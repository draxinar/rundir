#!/bin/bash
#
# check-scripts.sh - verify scripts.wombat/ and scripts/ are in lock-step.
#
# Three invariants are enforced:
#   1. Rebuild:    encoding scripts.wombat/*.m with scripts/*.m as
#                  variant reference reproduces scripts/*.m byte-for-byte.
#   2. Format:     scripts.wombat/*.m is already in canonical layout, i.e.
#                  formatting it (wombat -f) is a no-op. Unlike a decode
#                  round-trip this tolerates comments, which are stripped
#                  at compile time and the decoder cannot reproduce.
#   3. SDB:        ref-based encoding never appends to scripts/sdb.txt.
#
# Usage: ./ci/check-scripts.sh <wombat-dir>
#
#   <wombat-dir>  directory containing the compiled `wombat` binary and
#                 `convert.sh` (typically ../uotools/wombat).

set -e

if [ $# -ne 1 ]; then
	echo "usage: $0 <wombat-dir>" >&2
	exit 1
fi

WOMBAT_DIR="$1"
WOMBAT="$WOMBAT_DIR/wombat"
CONVERT="$WOMBAT_DIR/convert.sh"

if [ ! -x "$WOMBAT" ]; then
	echo "error: wombat binary not found or not executable: $WOMBAT" >&2
	exit 1
fi
if [ ! -x "$CONVERT" ]; then
	echo "error: convert.sh not found or not executable: $CONVERT" >&2
	exit 1
fi

RUNDIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS="$RUNDIR/scripts"
SOURCES="$RUNDIR/scripts.wombat"
SDB="$SCRIPTS/sdb.txt"

if [ ! -d "$SCRIPTS" ] || [ ! -f "$SDB" ]; then
	echo "error: $SCRIPTS or sdb.txt missing" >&2
	exit 1
fi
if [ ! -d "$SOURCES" ]; then
	echo "error: $SOURCES missing" >&2
	exit 1
fi

TMPDIR=$(mktemp -d "/tmp/check-scripts.XXXXXX")
trap 'rm -rf "$TMPDIR"' EXIT

mkdir -p "$TMPDIR/rebuilt" "$TMPDIR/formatted"

# Work on a copy of sdb.txt so the encoder cannot dirty the source tree
# if scripts.wombat/ references identifiers not yet in the DB.
WORK_SDB="$TMPDIR/sdb.txt"
cp "$SDB" "$WORK_SDB"

echo "=== check-scripts ==="
echo "  scripts:        $SCRIPTS"
echo "  scripts.wombat: $SOURCES"
echo "  sdb:            $SDB"
echo "  wombat:         $WOMBAT"
echo

sdb_before=$(sha1sum "$WORK_SDB" | cut -d' ' -f1)

# Rebuild: encode scripts.wombat -> tmp, using scripts/ as variant
# reference. Output must byte-match scripts/ file by file.
"$CONVERT" -c -s "$WORK_SDB" -r "$SCRIPTS" "$SOURCES" "$TMPDIR/rebuilt" >/dev/null

rebuild_total=0
rebuild_fail=0
for f in "$TMPDIR/rebuilt"/*.m; do
	[ -f "$f" ] || continue
	base="$(basename "$f")"
	rebuild_total=$((rebuild_total + 1))
	if ! cmp -s "$f" "$SCRIPTS/$base"; then
		echo "MISMATCH [rebuild]: $base"
		rebuild_fail=$((rebuild_fail + 1))
	fi
done

# SDB invariance: ref-mode encode of canonical sources must not grow
# the string DB (see uotools/wombat/main.c:87).
sdb_after=$(sha1sum "$WORK_SDB" | cut -d' ' -f1)
sdb_ok=1
if [ "$sdb_before" != "$sdb_after" ]; then
	echo "MISMATCH [sdb]: sdb.txt was modified by ref-based encode"
	echo "  before=$sdb_before"
	echo "  after =$sdb_after"
	sdb_ok=0
fi

# Format: formatting scripts.wombat -> tmp must reproduce scripts.wombat
# byte-for-byte, i.e. the checked-in source is already in canonical layout.
# This tolerates comments (wombat -f keeps them); a decode round-trip would
# not, since comments have no bytecode and the decoder never emits them.
# Format is read-only against the SDB; use the original path.
"$CONVERT" -f -s "$SDB" "$SOURCES" "$TMPDIR/formatted" >/dev/null

format_total=0
format_fail=0
first_fail=""
for f in "$TMPDIR/formatted"/*.m; do
	[ -f "$f" ] || continue
	base="$(basename "$f")"
	format_total=$((format_total + 1))
	if ! diff -q "$f" "$SOURCES/$base" >/dev/null 2>&1; then
		echo "MISMATCH [format]: $base"
		format_fail=$((format_fail + 1))
		if [ -z "$first_fail" ]; then
			first_fail="$base"
			diff -u "$SOURCES/$base" "$f" | head -20
		fi
	fi
done

echo
echo "=== Results ==="
echo "  rebuild:    $((rebuild_total - rebuild_fail))/$rebuild_total ok"
echo "  format:     $((format_total - format_fail))/$format_total ok"
if [ "$sdb_ok" -eq 1 ]; then
	echo "  sdb:        unchanged"
else
	echo "  sdb:        MODIFIED"
fi

[ "$rebuild_fail" -eq 0 ] && [ "$format_fail" -eq 0 ] && [ "$sdb_ok" -eq 1 ]

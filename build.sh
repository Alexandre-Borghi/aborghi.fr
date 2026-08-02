#!/usr/bin/env bash
# Build the whole aborghi.fr site into dist/.
# Requires: typst >= 0.15 (bundle + html export are behind feature flags).
set -euo pipefail
cd "$(dirname "$0")"
rm -rf dist
typst compile --features bundle,html --format bundle site.typ dist
echo "Built site → dist/"

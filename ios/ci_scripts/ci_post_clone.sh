#!/bin/sh
# Xcode Cloud runs this after cloning. The Xcode project is generated from
# project.yml rather than committed, so generate it before Xcode Cloud builds.
set -e

brew install xcodegen
cd "$(dirname "$0")/.."
xcodegen

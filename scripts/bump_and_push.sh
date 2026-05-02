#!/bin/bash

set -e

echo "📦 Reading pubspec.yaml..."

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

FILE="pubspec.yaml"

VERSION_LINE=$(grep "version:" "$FILE")

echo "Current: $VERSION_LINE"

VERSION=$(echo "$VERSION_LINE" | awk '{print $2}')

MAJOR=$(echo "$VERSION" | cut -d. -f1)
MINOR=$(echo "$VERSION" | cut -d. -f2)
PATCH_BUILD=$(echo "$VERSION" | cut -d. -f3)

PATCH=$(echo "$PATCH_BUILD" | cut -d+ -f1)
BUILD=$(echo "$PATCH_BUILD" | cut -d+ -f2)

BUILD=$((BUILD + 1))

NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD"

echo "🚀 New version: $NEW_VERSION"

# update pubspec
sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$FILE"

# git setup
git config user.email "ci@company.com"
git config user.name "ci-bot"

# ==============================
# 👇 أهم سطر في الحل كله
# ==============================
git add -A

git commit -m "chore: bump version to $NEW_VERSION & deploy" || echo "No changes to commit"

git push origin main

echo "✅ Project pushed successfully!"
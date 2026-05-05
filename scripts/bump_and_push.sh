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

# ==============================
# 🚀 INCREMENT LOGIC
# ==============================

BUILD=$((BUILD + 1))

if [ "$BUILD" -ge 50 ]; then
  BUILD=0
  MINOR=$((MINOR + 1))
fi

if [ "$MINOR" -ge 50 ]; then
  MINOR=0
  MAJOR=$((MAJOR + 1))
fi

PATCH=0

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
git add .


# ==============================
# 🧠 SMART COMMIT MESSAGE
# ==============================

generate_commit_message() {
  # لو فيه staged diff صغير نستخدمه
  DIFF=$(git diff --cached --quiet && echo "" || git diff --cached)

  # fallback 1: لو مفيش تغييرات واضحة
  if [ -z "$DIFF" ]; then
    echo "chore: update project files"
    return
  fi

  # fallback 2: intelligent heuristic بدون AI
  if git diff --cached --name-only | grep -q "pubspec.yaml"; then
    echo "chore: bump app version"
    return
  fi

  if git diff --cached --name-only | grep -q "lib/"; then
    echo "feat: update application logic"
    return
  fi

  if git diff --cached --name-only | grep -q "assets/"; then
    echo "chore: update assets"
    return
  fi

  if git diff --cached --name-only | grep -q "android\|ios"; then
    echo "chore: native platform updates"
    return
  fi

  # default fallback
  echo "chore: project update"
}

COMMIT_MESSAGE=$(generate_commit_message)

FINAL_COMMIT="$COMMIT_MESSAGE (v$NEW_VERSION)"

echo "📝 Commit: $FINAL_COMMIT"

git commit -m "$FINAL_COMMIT" || echo "No changes to commit"
#git commit -m "chore: bump version to $NEW_VERSION & deploy" || echo "No changes to commit"

git push origin main

echo "✅ Project pushed successfully!"
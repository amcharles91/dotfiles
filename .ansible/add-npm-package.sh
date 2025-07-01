#!/bin/bash
# Helper script to add npm packages to the list

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: $0 <package-name> [binary-name]"
    echo "Example: $0 @anthropic-ai/claude-desktop claude"
    echo "Example: $0 typescript tsc"
    exit 1
fi

PACKAGE_NAME="$1"
BINARY_NAME="${2:-$1}"  # Default to package name if binary not specified

# Remove @ prefix for simple binary name if not provided
if [ "$BINARY_NAME" = "$PACKAGE_NAME" ] && [[ "$PACKAGE_NAME" == @* ]]; then
    BINARY_NAME=$(echo "$PACKAGE_NAME" | sed 's/@.*\///')
fi

NPM_PACKAGES_FILE="$(dirname "$0")/npm-packages.yml"

# Check if package already exists
if grep -q "name: \"$PACKAGE_NAME\"" "$NPM_PACKAGES_FILE"; then
    echo "Package $PACKAGE_NAME already in the list"
    exit 0
fi

# Add the package
cat >> "$NPM_PACKAGES_FILE" << EOF
  
  - name: "$PACKAGE_NAME"
    binary: $BINARY_NAME
EOF

echo "✅ Added $PACKAGE_NAME to npm packages list"
echo "📝 Run 'chezmoi apply' to install it"
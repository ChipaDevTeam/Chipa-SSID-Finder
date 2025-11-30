#!/bin/bash

# Chipa SSID Finder - Deploy Website to GitHub Pages
# This script helps you deploy the /docs website to GitHub Pages

set -e

echo "🚀 Chipa SSID Finder - GitHub Pages Deployment"
echo "=============================================="
echo ""

# Check if we're in the right directory
if [ ! -d "docs" ]; then
    echo "❌ Error: docs/ directory not found"
    echo "Please run this script from the project root"
    exit 1
fi

echo "✅ Found docs/ directory"
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "❌ Error: Not a git repository"
    echo "Please initialize git first: git init"
    exit 1
fi

echo "✅ Git repository detected"
echo ""

# Show current status
echo "📊 Current Git Status:"
git status --short
echo ""

# Ask for confirmation
read -p "Do you want to commit and push the website? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

# Add files
echo "📦 Adding files to git..."
git add docs/

# Commit
echo ""
read -p "Enter commit message (or press Enter for default): " COMMIT_MSG
if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Add website for Google Play deployment"
fi

git commit -m "$COMMIT_MSG"
echo "✅ Files committed"
echo ""

# Push
echo "📤 Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "=============================================="
    echo "🎉 Deployment Complete!"
    echo "=============================================="
    echo ""
    echo "📋 Next Steps:"
    echo ""
    echo "1. Enable GitHub Pages:"
    echo "   → Go to: https://github.com/theshadow76/Chipa-SSID-Finder/settings/pages"
    echo "   → Source: main branch"
    echo "   → Folder: /docs"
    echo "   → Click Save"
    echo ""
    echo "2. Wait 2-5 minutes for deployment"
    echo ""
    echo "3. Your website will be live at:"
    echo "   https://theshadow76.github.io/Chipa-SSID-Finder/"
    echo ""
    echo "4. Use this Privacy Policy URL in Google Play Console:"
    echo "   https://theshadow76.github.io/Chipa-SSID-Finder/privacy-policy.html"
    echo ""
    echo "=============================================="
    echo ""
else
    echo "❌ Failed to push to GitHub"
    echo "Please check your git configuration and try again"
    exit 1
fi

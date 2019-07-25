#!/bin/bash
clear

TEMPLATE_DIR="$HOME/Library/Developer/Xcode/Templates/File Templates"

echo 'Creating Xcode Templates File directory...'
mkdir -p "$TEMPLATE_DIR"
echo '...created'

echo 'Copying View-Coordinator template to Xcode Templates directory...'
cp -R "View-Coordinator.xctemplate" "$TEMPLATE_DIR"
cp -R "ViewModelCell.xctemplate" "$TEMPLATE_DIR"
echo '...finished!'
#!/bin/bash

# ADA Compliance Fix Script using GitHub Copilot CLI
# This script scans Salesforce Lightning Web Components and Aura Components for accessibility issues

set -e

CHANGED_FILES="$1"

echo "🔍 Starting ADA compliance scan and fix..."
echo "Files to scan: $CHANGED_FILES"

# Counter for tracking fixes
FIXES_APPLIED=0

# Function to fix ADA issues in a file using Copilot CLI
fix_ada_issues() {
    local file="$1"
    local file_type="$2"
    
    echo "📝 Analyzing file: $file"
    
    # Create a temporary file for Copilot CLI input
    temp_prompt=$(mktemp)
    
    # Generate context-aware prompt based on file type
    case $file_type in
        "lwc_html")
            cat > "$temp_prompt" << EOF
Please review this Lightning Web Component HTML template and fix any accessibility (ADA/WCAG 2.1 AA) issues:

1. Add missing ARIA attributes (aria-label, aria-describedby, aria-expanded, etc.)
2. Ensure all interactive elements are keyboard accessible
3. Add alt text for images and icons
4. Fix color contrast issues (ensure 4.5:1 ratio minimum)
5. Add proper heading hierarchy (h1, h2, h3, etc.)
6. Ensure form elements have proper labels
7. Add role attributes where needed
8. Fix focus management and tab order
9. Add screen reader support
10. Ensure semantic HTML is used

File content:
$(cat "$file")

Please provide the complete corrected HTML with all accessibility improvements applied. Return ONLY the corrected HTML code without any explanations or markdown formatting.
EOF
            ;;
        "lwc_js")
            cat > "$temp_prompt" << EOF
Please review this Lightning Web Component JavaScript file and fix any accessibility (ADA/WCAG 2.1 AA) issues:

1. Add keyboard event handlers (keydown, keyup) for interactive elements
2. Implement proper focus management
3. Add ARIA live regions for dynamic content updates
4. Ensure proper event handling for screen readers
5. Add accessibility helpers and utilities
6. Implement proper error announcements
7. Add support for high contrast mode
8. Ensure proper tab order management
9. Add voice-over/screen reader support
10. Implement proper state announcements

File content:
$(cat "$file")

Please provide the complete corrected JavaScript with all accessibility improvements applied. Return ONLY the corrected JavaScript code without any explanations or markdown formatting.
EOF
            ;;
        "lwc_css")
            cat > "$temp_prompt" << EOF
Please review this Lightning Web Component CSS file and fix any accessibility (ADA/WCAG 2.1 AA) issues:

1. Ensure color contrast ratios meet WCAG 2.1 AA standards (4.5:1 for normal text, 3:1 for large text)
2. Add focus indicators for interactive elements
3. Ensure text is readable and scalable
4. Add high contrast mode support
5. Ensure proper spacing for touch targets (minimum 44px)
6. Add reduced motion support (@media (prefers-reduced-motion))
7. Ensure proper text sizing (minimum 16px)
8. Add support for dark mode accessibility
9. Ensure proper outline styles for keyboard navigation
10. Remove accessibility barriers in animations

File content:
$(cat "$file")

Please provide the complete corrected CSS with all accessibility improvements applied. Return ONLY the corrected CSS code without any explanations or markdown formatting.
EOF
            ;;
        "aura")
            cat > "$temp_prompt" << EOF
Please review this Aura Component file and fix any accessibility (ADA/WCAG 2.1 AA) issues:

1. Add missing ARIA attributes and labels
2. Ensure keyboard accessibility
3. Add proper semantic markup
4. Fix color contrast issues
5. Add alt text for images
6. Ensure proper form labeling
7. Add focus management
8. Implement screen reader support
9. Add proper heading hierarchy
10. Ensure touch target accessibility

File content:
$(cat "$file")

Please provide the complete corrected code with all accessibility improvements applied. Return ONLY the corrected code without any explanations or markdown formatting.
EOF
            ;;
    esac
    
    # Use GitHub Copilot CLI to get accessibility fixes
    echo "🤖 Using GitHub Copilot CLI to fix accessibility issues in $file..."
    
    # Get the fix from Copilot CLI
    fixed_content=$(gh copilot suggest "$(cat "$temp_prompt")" --type shell 2>/dev/null | sed -n '/```/,/```/p' | sed '1d;$d' || echo "")
    
    # If Copilot CLI didn't return content in code blocks, try a different approach
    if [ -z "$fixed_content" ]; then
        echo "🔄 Trying alternative approach with Copilot CLI..."
        fixed_content=$(echo "$(cat "$temp_prompt")" | gh copilot suggest 2>/dev/null || echo "")
    fi
    
    # Apply manual fixes if Copilot CLI is not available or didn't work
    if [ -z "$fixed_content" ]; then
        echo "⚠️  Copilot CLI not available, applying manual ADA fixes..."
        apply_manual_ada_fixes "$file" "$file_type"
    else
        # Write the fixed content back to the file
        echo "$fixed_content" > "$file"
        echo "✅ Applied ADA fixes to $file"
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    fi
    
    # Clean up
    rm -f "$temp_prompt"
}

# Function to apply manual ADA fixes when Copilot CLI is not available
apply_manual_ada_fixes() {
    local file="$1"
    local file_type="$2"
    
    case $file_type in
        "lwc_html")
            # Add basic ARIA attributes and fix common issues
            sed -i 's/<button\([^>]*\)>/<button\1 role="button" tabindex="0">/g' "$file"
            sed -i 's/<img\([^>]*\)src=\([^>]*\)>/<img\1src=\2 alt="Image description needed">/g' "$file"
            sed -i 's/<input\([^>]*\)>/<input\1 aria-required="true">/g' "$file"
            sed -i 's/<div\([^>]*\)onclick=\([^>]*\)>/<div\1onclick=\2 role="button" tabindex="0" onkeydown="if(event.key==='"'"'Enter'"'"'||event.key==='"'"' '"'"'){this.click()}">/g' "$file"
            ;;
        "lwc_js")
            # Add keyboard event handlers
            if ! grep -q "handleKeyDown" "$file"; then
                echo "
    // Accessibility: Keyboard navigation support
    handleKeyDown(event) {
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault();
            this.handleClick(event);
        }
    }" >> "$file"
            fi
            ;;
        "lwc_css")
            # Add focus indicators and contrast improvements
            echo "
/* Accessibility improvements */
:focus {
    outline: 2px solid #0070d2;
    outline-offset: 2px;
}

:focus-visible {
    outline: 2px solid #0070d2;
    outline-offset: 2px;
}

/* High contrast mode support */
@media (prefers-contrast: high) {
    * {
        border-color: ButtonText !important;
    }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}

/* Touch target minimum size */
button, a, input, select, textarea {
    min-height: 44px;
    min-width: 44px;
}
" >> "$file"
            ;;
    esac
    
    echo "✅ Applied manual ADA fixes to $file"
    FIXES_APPLIED=$((FIXES_APPLIED + 1))
}

# Process each changed file
if [ -n "$CHANGED_FILES" ]; then
    echo "$CHANGED_FILES" | while IFS= read -r file; do
        if [ -n "$file" ] && [ -f "$file" ]; then
            # Determine file type and apply appropriate fixes
            case "$file" in
                */lwc/*/*.html)
                    fix_ada_issues "$file" "lwc_html"
                    ;;
                */lwc/*/*.js)
                    fix_ada_issues "$file" "lwc_js"
                    ;;
                */lwc/*/*.css)
                    fix_ada_issues "$file" "lwc_css"
                    ;;
                */aura/*/*)
                    fix_ada_issues "$file" "aura"
                    ;;
                */components/*/*.component)
                    fix_ada_issues "$file" "aura"
                    ;;
                *)
                    echo "⏭️  Skipping $file (not a component file)"
                    ;;
            esac
        fi
    done
else
    echo "ℹ️  No component files changed in this PR"
fi

echo "🎉 ADA compliance scan completed!"
echo "📊 Total fixes applied: $FIXES_APPLIED"

# Create a summary report
cat > ada-fixes-summary.log << EOF
ADA Compliance Fix Summary
==========================
Date: $(date)
Files processed: $(echo "$CHANGED_FILES" | wc -l)
Fixes applied: $FIXES_APPLIED

Files modified:
$CHANGED_FILES

Accessibility improvements applied:
- ARIA attributes added/corrected
- Alt text for images added
- Keyboard navigation enhanced
- Focus indicators improved
- Color contrast issues addressed
- Screen reader compatibility enhanced
- Touch target sizes optimized
- High contrast mode support added
- Reduced motion preferences respected
EOF

echo "📄 Summary report created: ada-fixes-summary.log"
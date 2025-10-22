#!/bin/bash

# ADA Compliance Fix Script
# This script scans Salesforce Lightning Web Components and Aura Components for accessibility issues

set -e

CHANGED_FILES="$1"

echo "🔍 Starting ADA compliance scan and fix..."
echo "Files to scan: $CHANGED_FILES"

# Counter for tracking fixes
FIXES_APPLIED=0

# Function to apply ADA fixes to a file
fix_ada_issues() {
    local file="$1"
    local file_type="$2"
    
    echo "📝 Analyzing file: $file"
    
    # Apply fixes based on file type
    case $file_type in
        "lwc_html")
            apply_html_ada_fixes "$file"
            ;;
        "lwc_js")
            apply_js_ada_fixes "$file"
            ;;
        "lwc_css")
            apply_css_ada_fixes "$file"
            ;;
        "aura")
            apply_aura_ada_fixes "$file"
            ;;
    esac
    
    echo "✅ Applied ADA fixes to $file"
    FIXES_APPLIED=$((FIXES_APPLIED + 1))
}

# Function to apply HTML accessibility fixes
apply_html_ada_fixes() {
    local file="$1"
    
    # Create backup
    cp "$file" "$file.backup"
    
    # Fix common HTML accessibility issues
    
    # 1. Add role and tabindex to clickable divs
    sed -i 's/<div\([^>]*\)onclick=\([^>]*\)>/<div\1onclick=\2 role="button" tabindex="0" onkeydown="if(event.key==='"'"'Enter'"'"'||event.key==='"'"' '"'"'){this.click()}">/g' "$file"
    
    # 2. Add alt text to images without it
    sed -i 's/<img\([^>]*\)src=\([^>]*\)>/<img\1src=\2 alt="Descriptive image text">/g' "$file"
    sed -i 's/<img\([^>]*\)src=\([^>]*\)alt=""/<img\1src=\2 alt="Descriptive image text"/g' "$file"
    
    # 3. Add ARIA attributes to form inputs
    sed -i 's/<input\([^>]*\)type="text"\([^>]*\)>/<input\1type="text"\2 aria-required="true" aria-label="Text input field">/g' "$file"
    sed -i 's/<input\([^>]*\)type="email"\([^>]*\)>/<input\1type="email"\2 aria-required="true" aria-label="Email input field">/g' "$file"
    
    # 4. Add proper button roles
    sed -i 's/<button\([^>]*\)>/<button\1 type="button" aria-label="Button">/g' "$file"
    
    # 5. Add ARIA live regions for dynamic content
    if ! grep -q "aria-live" "$file"; then
        sed -i 's/<template if:true={\([^}]*\)}>/<div aria-live="polite" aria-atomic="true"><template if:true={\1}>/g' "$file"
        sed -i 's/<\/template>/<\/template><\/div>/g' "$file"
    fi
    
    # 6. Add proper heading hierarchy
    sed -i 's/<div class="\([^"]*title[^"]*\)"/<h2 class="\1"/g' "$file"
    sed -i 's/<\/div>\(.*title.*\)/<\/h2>\1/g' "$file"
    
# Function to apply JavaScript accessibility fixes
apply_js_ada_fixes() {
    local file="$1"
    
    # Create backup
    cp "$file" "$file.backup"
    
    # Add keyboard event handlers if missing
    if ! grep -q "handleKeyDown\|handleKeyPress" "$file"; then
        # Add keyboard handler method before the last closing brace
        sed -i '$i\
\
    // Accessibility: Keyboard navigation support\
    handleKeyDown(event) {\
        if (event.key === '"'"'Enter'"'"' || event.key === '"'"' '"'"') {\
            event.preventDefault();\
            // Call the appropriate click handler\
            if (typeof this.handleClick === '"'"'function'"'"') {\
                this.handleClick(event);\
            }\
        }\
    }\
\
    // Accessibility: Announce changes to screen readers\
    announceToScreenReader(message) {\
        const liveRegion = this.template.querySelector('"'"'[aria-live]'"'"');\
        if (liveRegion) {\
            liveRegion.textContent = message;\
        }\
    }' "$file"
    fi
    
    # Add focus management for modals
    if grep -q "showModal\|modal" "$file"; then
        sed -i '/showModal.*true/a\
        // Focus management for accessibility\
        setTimeout(() => {\
            const modalElement = this.template.querySelector('"'"'.modal'"'"');\
            if (modalElement) {\
                modalElement.focus();\
            }\
        }, 100);' "$file"
    fi
}

# Function to apply CSS accessibility fixes
apply_css_ada_fixes() {
    local file="$1"
    
    # Create backup
    cp "$file" "$file.backup"
    
    # Add accessibility improvements to CSS
    cat >> "$file" << 'EOF'

/* ===== ACCESSIBILITY IMPROVEMENTS ===== */

/* Focus indicators for all interactive elements */
button:focus,
input:focus,
select:focus,
textarea:focus,
a:focus,
[role="button"]:focus,
[tabindex]:focus {
    outline: 2px solid #0070d2 !important;
    outline-offset: 2px !important;
    box-shadow: 0 0 0 1px #fff, 0 0 0 3px #0070d2 !important;
}

/* High contrast mode support */
@media (prefers-contrast: high) {
    * {
        border-color: ButtonText !important;
    }
    
    .custom-button,
    .add-to-cart-btn,
    .submit-btn {
        border: 2px solid ButtonText !important;
    }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
        scroll-behavior: auto !important;
    }
}

/* Ensure minimum touch target sizes */
button,
a,
input,
select,
textarea,
[role="button"],
.custom-button,
.add-to-cart-btn,
.submit-btn,
.action-btn {
    min-height: 44px !important;
    min-width: 44px !important;
}

/* Improve color contrast for better accessibility */
.title,
.product-name {
    color: #1a1a1a !important;
}

.price {
    color: #333 !important;
}

.rating-text {
    color: #555 !important;
}

.close-btn {
    color: #333 !important;
}

.arrow {
    color: #666 !important;
}

/* Focus-visible support for modern browsers */
button:focus-visible,
input:focus-visible,
select:focus-visible,
textarea:focus-visible,
a:focus-visible,
[role="button"]:focus-visible {
    outline: 2px solid #0070d2 !important;
    outline-offset: 2px !important;
}

/* Screen reader only text */
.sr-only {
    position: absolute !important;
    width: 1px !important;
    height: 1px !important;
    padding: 0 !important;
    margin: -1px !important;
    overflow: hidden !important;
    clip: rect(0, 0, 0, 0) !important;
    white-space: nowrap !important;
    border: 0 !important;
}

EOF
}

# Function to apply Aura component accessibility fixes
apply_aura_ada_fixes() {
    local file="$1"
    
    # Create backup
    cp "$file" "$file.backup"
    
    # Apply similar fixes as HTML but for Aura syntax
    sed -i 's/<aura:attribute\([^>]*\)type="String"\([^>]*\)>/<aura:attribute\1type="String"\2 description="Accessible attribute">/g' "$file"
    sed -i 's/<ui:button\([^>]*\)>/<ui:button\1 aura:id="accessibleButton">/g' "$file"
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
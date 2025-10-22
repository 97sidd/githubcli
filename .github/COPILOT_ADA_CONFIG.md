# Copilot CLI Accessibility Prompts Configuration

This file contains standardized prompts for GitHub Copilot CLI to ensure consistent ADA compliance fixes across different file types in Salesforce projects.

## Lightning Web Components (LWC)

### HTML Templates
- Add ARIA attributes (aria-label, aria-describedby, aria-expanded, etc.)
- Ensure keyboard accessibility for interactive elements
- Add alt text for images and decorative icons
- Implement proper heading hierarchy
- Add form labels and descriptions
- Ensure proper focus management
- Add role attributes for custom components

### JavaScript Controllers
- Implement keyboard event handlers
- Add focus management logic
- Create ARIA live region updates
- Handle screen reader announcements
- Add error state management
- Implement proper event delegation
- Add accessibility utility functions

### CSS Stylesheets
- Ensure WCAG 2.1 AA color contrast ratios
- Add focus indicators for interactive elements
- Implement responsive design for accessibility
- Add high contrast mode support
- Include reduced motion preferences
- Ensure minimum touch target sizes (44px)
- Add proper text scaling support

## Aura Components

### Component Markup
- Add semantic HTML structure
- Implement ARIA attributes
- Ensure keyboard navigation
- Add proper form labeling
- Include focus management
- Add screen reader support

### Controller/Helper Files
- Add accessibility event handlers
- Implement keyboard navigation logic
- Add screen reader announcements
- Handle focus management
- Add error state handling

## Common Accessibility Patterns

### Form Elements
```html
<lightning-input
    label="Required Field"
    required
    aria-required="true"
    aria-describedby="field-help"
    message-when-value-missing="This field is required"
></lightning-input>
<div id="field-help" class="slds-form-element__help">Additional context for this field</div>
```

### Interactive Elements
```html
<div
    role="button"
    tabindex="0"
    aria-label="Custom button description"
    onclick={handleClick}
    onkeydown={handleKeyDown}
>
    Button Content
</div>
```

### Dynamic Content
```javascript
// Announce dynamic changes to screen readers
@api announceToScreenReader(message) {
    const liveRegion = this.template.querySelector('[aria-live="polite"]');
    if (liveRegion) {
        liveRegion.textContent = message;
    }
}
```

### Focus Management
```javascript
// Proper focus management
handleModalOpen() {
    this.template.querySelector('[data-id="modal-content"]').focus();
}

handleModalClose() {
    this.template.querySelector('[data-id="trigger-button"]').focus();
}
```

## WCAG 2.1 AA Compliance Checklist

- [ ] Color contrast ratio ≥ 4.5:1 for normal text
- [ ] Color contrast ratio ≥ 3:1 for large text
- [ ] All interactive elements keyboard accessible
- [ ] Images have descriptive alt text
- [ ] Form elements have proper labels
- [ ] Focus indicators are visible
- [ ] Heading hierarchy is logical
- [ ] Error messages are descriptive and associated
- [ ] Dynamic content changes are announced
- [ ] Touch targets are minimum 44px
- [ ] Content works without JavaScript
- [ ] Text can be resized up to 200% without loss of functionality
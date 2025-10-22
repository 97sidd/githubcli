# GitHub Copilot CLI ADA Compliance Setup

This repository is configured to automatically scan and fix accessibility (ADA) issues in Salesforce components when Pull Requests are created or updated.

## 🚀 How It Works

1. **Trigger**: The workflow automatically runs when:
   - A new PR is opened
   - An existing PR is updated
   - Changes are made to LWC, Aura, or Visualforce components

2. **Scan**: GitHub Copilot CLI analyzes the changed files for accessibility issues including:
   - Missing ARIA attributes
   - Improper keyboard navigation
   - Color contrast problems
   - Missing alt text for images
   - Form accessibility issues
   - Focus management problems

3. **Fix**: The system automatically applies fixes for common accessibility issues

4. **Commit**: Fixed files are automatically committed back to the PR branch

5. **Report**: A comment is added to the PR with details about the fixes applied

## 📁 Files Created

- `.github/workflows/ada-compliance-check.yml` - Main GitHub Actions workflow
- `.github/scripts/ada-compliance-fix.sh` - Script that performs the ADA fixes
- `.github/COPILOT_ADA_CONFIG.md` - Configuration and patterns for Copilot CLI

## 🔧 Configuration

### Prerequisites

**Local Machine**: No special installations required! The workflow runs entirely on GitHub's servers.

**GitHub Repository**: Just push your Salesforce project to GitHub.

### GitHub Secrets Required

The workflow uses the default `GITHUB_TOKEN` which is automatically provided by GitHub Actions. No additional secrets are required.

### Automatic Installations (on GitHub's servers)

The workflow automatically installs these tools during execution:
- Node.js and npm
- Salesforce CLI
- GitHub Copilot CLI

### Customization

You can customize the workflow by:

1. **Modifying file patterns**: Edit the `paths` section in the workflow file to include/exclude specific file types
2. **Adjusting fix patterns**: Modify the `ada-compliance-fix.sh` script to add custom accessibility patterns
3. **Changing commit messages**: Update the commit message template in the workflow

## 🎯 Supported File Types

- **Lightning Web Components (LWC)**
  - HTML templates (`.html`)
  - JavaScript controllers (`.js`)
  - CSS stylesheets (`.css`)

- **Aura Components**
  - Component markup (`.cmp`)
  - Controllers (`.js`)
  - Helpers (`.js`)
  - Stylesheets (`.css`)

- **Visualforce Components**
  - Component files (`.component`)
  - Pages (`.page`)

## ✅ Accessibility Standards

The automation follows WCAG 2.1 AA compliance standards and checks for:

- **Keyboard Navigation**: All interactive elements accessible via keyboard
- **Screen Reader Support**: Proper ARIA attributes and semantic markup
- **Color Contrast**: Minimum 4.5:1 ratio for normal text, 3:1 for large text
- **Form Accessibility**: Proper labels, error messages, and required field indicators
- **Focus Management**: Visible focus indicators and logical tab order
- **Alternative Text**: Descriptive alt text for images and icons
- **Touch Targets**: Minimum 44px size for interactive elements
- **Motion Sensitivity**: Reduced motion support for users with vestibular disorders

## 🔍 Manual Testing

While the automation fixes many common issues, manual testing is still recommended:

1. **Keyboard Navigation**: Tab through all interactive elements
2. **Screen Reader**: Test with NVDA, JAWS, or VoiceOver
3. **Color Contrast**: Use tools like WebAIM Contrast Checker
4. **Mobile Accessibility**: Test touch targets and gestures
5. **Zoom Testing**: Ensure functionality at 200% zoom

## 📊 Monitoring

The workflow creates:
- **PR Comments**: Summary of fixes applied
- **Artifacts**: Detailed reports uploaded to the workflow run
- **Logs**: Complete execution logs for troubleshooting

## 🛠️ Troubleshooting

### Workflow Not Running
- Check that the file paths match your component structure
- Ensure the workflow file is in `.github/workflows/`
- Verify branch protection rules aren't blocking the automation

### Fixes Not Applied
- Check the workflow logs for errors
- Ensure Copilot CLI is properly authenticated
- Verify file permissions for the script

### False Positives
- Review and adjust the patterns in the fix script
- Add file exclusions to the workflow if needed
- Customize the Copilot prompts for your specific use cases

## 🤝 Contributing

To improve the ADA compliance automation:

1. Fork the repository
2. Make changes to the workflow or scripts
3. Test with sample PR
4. Submit a PR with your improvements

## 📚 Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Salesforce Accessibility Guidelines](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/intro_accessibility.htm)
- [GitHub Copilot CLI Documentation](https://docs.github.com/en/copilot/github-copilot-in-the-cli)
- [Lightning Design System Accessibility](https://www.lightningdesignsystem.com/accessibility/overview/)
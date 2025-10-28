import { LightningElement, track } from 'lwc';

export default class UserProfile extends LightningElement {
    @track user = {
        name: 'John Doe',
        title: 'Software Engineer',
        email: 'john.doe@company.com',
        profilePicture: '/assets/images/default-avatar.jpg',
        projectCount: 12,
        tasksCompleted: 156,
        rating: 4
    };

    @track showSuccessMessage = false;
    @track errorMessage = '';
    @track isModalOpen = false;

    // ADA Issue: Missing keyboard event handlers for interactive elements
    handleEdit() {
        console.log('Edit clicked');
        // ADA Issue: No screen reader announcement
    }

    handleDelete() {
        console.log('Delete clicked');
        // ADA Issue: No confirmation dialog with proper accessibility
    }

    handleShare() {
        console.log('Share clicked');
        // ADA Issue: No feedback to user about share action
    }

    handleNameChange(event) {
        this.user.name = event.target.value;
        // ADA Issue: No validation feedback
    }

    handleDepartmentChange(event) {
        this.user.department = event.target.value;
        // ADA Issue: No announcement of selection change
    }

    // ADA Issue: Missing keyboard support for checkbox
    toggleNotifications() {
        console.log('Notifications toggled');
        // ADA Issue: No state announcement
    }

    handleSave() {
        // ADA Issue: No loading state indication
        this.showSuccessMessage = true;
        
        // ADA Issue: Message disappears without user control
        setTimeout(() => {
            this.showSuccessMessage = false;
        }, 3000);
        
        // ADA Issue: No focus management after save
    }

    // ADA Issue: Rating interaction without keyboard support
    handleRating(event) {
        const rating = event.currentTarget.dataset.rating;
        this.user.rating = parseInt(rating);
        // ADA Issue: No announcement of rating change
    }

    // ADA Issue: Modal opening without focus management
    openModal() {
        this.isModalOpen = true;
        // ADA Issue: Focus not moved to modal
        // ADA Issue: No escape key handler
        // ADA Issue: Background not properly hidden from screen readers
    }

    // ADA Issue: Modal closing without returning focus
    closeModal() {
        this.isModalOpen = false;
        // ADA Issue: Focus not returned to trigger element
    }

    // ADA Issue: No error handling with accessibility considerations
    handleError(message) {
        this.errorMessage = message;
        // ADA Issue: Error not announced to screen readers
        // ADA Issue: No focus management for errors
    }

    // ADA Issue: Missing lifecycle methods for accessibility setup
    connectedCallback() {
        // ADA Issue: No initial focus management
        // ADA Issue: No keyboard event listeners setup
    }

    // ADA Issue: No cleanup of accessibility features
    disconnectedCallback() {
        // ADA Issue: Event listeners not removed
    }
}
    // Accessibility: Keyboard navigation support
    handleKeyDown(event) {
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault();
            this.handleClick(event);
        }
    }

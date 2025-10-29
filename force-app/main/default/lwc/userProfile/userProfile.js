import { LightningElement, track } from 'lwc';

export default class UserProfile extends LightningElement {
    @track user = {
        name: 'John Doe',
        title: 'Software Engineer',
        email: 'john.doe@company.com',
        profilePicture: '/assets/images/default-avatar.jpg',
        imageAltText: 'Profile picture of John Doe',
        projectCount: 12,
        tasksCompleted: 156,
        rating: 4,
        department: '',
        notificationsEnabled: false
    };

    @track showSuccessMessage = false;
    @track errorMessage = '';
    @track isModalOpen = false;
    modalTriggerElement = null;

    connectedCallback() {
        this.setupKeyboardListeners();
    }

    disconnectedCallback() {
        this.removeKeyboardListeners();
    }

    renderedCallback() {
        if (this.isModalOpen) {
            this.focusModal();
        }
    }

    setupKeyboardListeners() {
        document.addEventListener('keydown', this.handleEscapeKey.bind(this));
    }

    removeKeyboardListeners() {
        document.removeEventListener('keydown', this.handleEscapeKey.bind(this));
    }

    handleEscapeKey(event) {
        if (event.key === 'Escape' && this.isModalOpen) {
            this.closeModal();
        }
    }

    handleKeyDown(event) {
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault();
            event.target.click();
        }
    }

    handleEdit() {
        console.log('Edit clicked');
        this.announceToScreenReader('Opening profile editor');
    }

    handleDelete() {
        console.log('Delete clicked');
        const confirmed = confirm('Are you sure you want to delete this profile? This action cannot be undone.');
        if (confirmed) {
            this.announceToScreenReader('Profile deletion confirmed');
        } else {
            this.announceToScreenReader('Profile deletion cancelled');
        }
    }

    handleShare() {
        console.log('Share clicked');
        this.announceToScreenReader('Profile share options opened');
    }

    handleNameChange(event) {
        this.user = { ...this.user, name: event.target.value };
        if (!event.target.value) {
            this.handleError('Name is required');
        } else {
            this.errorMessage = '';
        }
    }

    handleEmailChange(event) {
        this.user = { ...this.user, email: event.target.value };
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(event.target.value)) {
            this.handleError('Please enter a valid email address');
        } else {
            this.errorMessage = '';
        }
    }

    handleDepartmentChange(event) {
        this.user = { ...this.user, department: event.target.value };
        this.announceToScreenReader(`Department changed to ${event.target.value || 'none selected'}`);
    }

    toggleNotifications(event) {
        this.user = { ...this.user, notificationsEnabled: event.target.checked };
        const status = event.target.checked ? 'enabled' : 'disabled';
        this.announceToScreenReader(`Notifications ${status}`);
    }

    handleSave() {
        if (!this.user.name || !this.user.email) {
            this.handleError('Please fill in all required fields');
            return;
        }

        this.announceToScreenReader('Saving profile changes...');
        
        setTimeout(() => {
            this.showSuccessMessage = true;
            this.announceToScreenReader('Profile updated successfully');
            
            setTimeout(() => {
                this.showSuccessMessage = false;
            }, 5000);
        }, 500);
    }

    handleRating(event) {
        const rating = parseInt(event.currentTarget.dataset.rating);
        this.user = { ...this.user, rating };
        this.announceToScreenReader(`Rating set to ${rating} out of 5 stars`);
    }

    get isRatingSelected1() {
        return this.user.rating >= 1 ? 'true' : 'false';
    }

    get isRatingSelected2() {
        return this.user.rating >= 2 ? 'true' : 'false';
    }

    get isRatingSelected3() {
        return this.user.rating >= 3 ? 'true' : 'false';
    }

    get isRatingSelected4() {
        return this.user.rating >= 4 ? 'true' : 'false';
    }

    get isRatingSelected5() {
        return this.user.rating >= 5 ? 'true' : 'false';
    }

    openModal() {
        this.modalTriggerElement = document.activeElement;
        this.isModalOpen = true;
        this.announceToScreenReader('Profile details dialog opened');
    }

    closeModal() {
        this.isModalOpen = false;
        this.announceToScreenReader('Profile details dialog closed');
        
        if (this.modalTriggerElement) {
            setTimeout(() => {
                const triggerButton = this.template.querySelector('[data-id="modal-trigger"]');
                if (triggerButton) {
                    triggerButton.focus();
                }
            }, 100);
        }
    }

    handleOverlayClick(event) {
        if (event.target.classList.contains('modal-overlay')) {
            this.closeModal();
        }
    }

    focusModal() {
        setTimeout(() => {
            const modalContent = this.template.querySelector('[data-id="modal-content"]');
            if (modalContent) {
                const closeButton = modalContent.querySelector('.close-btn');
                if (closeButton) {
                    closeButton.focus();
                }
            }
        }, 100);
    }

    handleError(message) {
        this.errorMessage = message;
        this.announceToScreenReader(`Error: ${message}`);
        
        setTimeout(() => {
            const errorElement = this.template.querySelector('.error-msg');
            if (errorElement) {
                errorElement.focus();
            }
        }, 100);
    }

    announceToScreenReader(message) {
        const liveRegion = this.template.querySelector('[data-id="live-region"]');
        if (liveRegion) {
            liveRegion.textContent = '';
            setTimeout(() => {
                liveRegion.textContent = message;
            }, 100);
        }
    }
}
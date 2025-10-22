import { LightningElement, api, track } from 'lwc';

export default class ProductCard extends LightningElement {
    @api product = {
        id: '1',
        name: 'Sample Product',
        price: 99.99,
        rating: 4.5,
        image: '/resource/productImage',
        inStock: true,
        description: 'This is a sample product description.'
    };

    @track quantity = 1;
    @track isExpanded = false;
    @track showNotification = false;

    handleAddToCart() {
        // ADA Issue: No screen reader announcement for cart addition
        console.log('Added to cart');
        this.showNotification = true;
        
        // ADA Issue: Notification disappears automatically without user control
        setTimeout(() => {
            this.showNotification = false;
        }, 3000);
    }

    handleQuantityChange(event) {
        this.quantity = event.target.value;
    }

    toggleDetails() {
        // ADA Issue: State change not announced to screen readers
        this.isExpanded = !this.isExpanded;
    }

    handleImageClick() {
        // ADA Issue: Image click handler without keyboard equivalent
        console.log('Image clicked - should open gallery');
    }

    handleRatingClick(event) {
        // ADA Issue: Star rating clickable but not keyboard accessible
        const rating = event.target.dataset.rating;
        console.log('Rating clicked:', rating);
    }

    get stockStatus() {
        return this.product.inStock ? 'In Stock' : 'Out of Stock';
    }

    get formattedPrice() {
        return `$${this.product.price.toFixed(2)}`;
    }

    get stars() {
        // Generate array for star rating display
        const stars = [];
        for (let i = 1; i <= 5; i++) {
            stars.push({ id: i, value: i });
        }
        return stars;
    }

    handleWishlist() {
        console.log('Added to wishlist');
    }

    handleShare() {
        console.log('Share product');
    }

    handleCompare() {
        console.log('Add to compare');
    }
}
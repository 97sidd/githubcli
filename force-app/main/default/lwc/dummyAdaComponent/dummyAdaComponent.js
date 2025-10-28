import { LightningElement, track } from "lwc";

export default class DummyAdaComponent extends LightningElement {
  @track showModal = false;
  @track userName = "";
  @track email = "";
  @track errorMessage = "";

  handleClick() {
    // ADA Issue: Missing keyboard navigation support
    this.showModal = true;
  }

  handleSubmit() {
    if (!this.userName || !this.email) {
      // ADA Issue: Error not announced to screen readers
      this.errorMessage = "Please fill in all fields";
      return;
    }

    // ADA Issue: Success message not announced
    console.log("Form submitted successfully");
    this.showModal = false;
  }

  handleInputChange(event) {
    const field = event.target.name;
    if (field === "userName") {
      this.userName = event.target.value;
    } else if (field === "email") {
      this.email = event.target.value;
    }
  }

  closeModal() {
    this.showModal = false;
    // ADA Issue: Focus not returned to trigger element
  }
}

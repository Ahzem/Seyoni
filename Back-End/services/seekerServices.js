const SeekerModel = require("../models/seeker");

class SeekerServices {
  static async registerSeeker(firstName, lastName, phone, email, password) {
    // Create a new seeker
    try {
      const createSeeker = new SeekerModel({
        firstName,
        lastName,
        phone,
        email,
        password,
      });
      // Save the seeker
      return await createSeeker.save();
    } catch (error) {
      console.error(error);
    }
  }
}

module.exports = SeekerServices;

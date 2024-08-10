const Seeker = require("../models/seekerModel");

async function registerSeeker(data) {
  const { firstName, lastName, phone, email, password } = data;

  const newSeeker = new Seeker({
    firstName,
    lastName,
    phone,
    email,
    password,
  });

  try {
    await newSeeker.save();
    console.log("User created:", newSeeker);
    return newSeeker;
  } catch (error) {
    console.error("Error creating user:", error);
    throw error;
  }
}

module.exports = { registerSeeker };

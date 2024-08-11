const Seeker = require("../models/seekerModel");

async function signUpSeeker(data) {
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

async function signInSeeker(data) {
  const { email, password } = data;
  try {
    const seeker = await Seeker.findOne({ email });

    if (!seeker) {
      throw new Error("User not found");
    }

    const isPasswordValid = await seeker.comparePassword(password);
    if (!isPasswordValid) {
      throw new Error("Invalid password");
    }

    return seeker;
  } catch (error) {
    console.error("Error logging in user:", error);
    throw error;
  }
}

module.exports = { signUpSeeker, signInSeeker };

const mongoose = require("mongoose");
require("dotenv").config();
const bcrypt = require("bcryptjs");
const db = require("../config/db");

const { Schema } = mongoose;

const seekerSchema = new Schema(
  {
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    phone: { type: String, required: true, unique: true },
    email: { type: String, lowercase: true, required: true, unique: true },
    password: { type: String, required: true },
  },
  { timestamps: true }
);

// Hash the password before saving
seekerSchema.pre("save", async function (next) {
  if (!this.isModified("password")) {
    return next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// Compare entered password with hashed password
seekerSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

// Registering the model with the specific connection instance
const SeekerModel = db.model("Seeker", seekerSchema);

module.exports = SeekerModel;

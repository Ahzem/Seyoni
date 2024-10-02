const mongoose = require("mongoose");

const otpSchema = new mongoose.Schema({
  number: {
    type: String,
    required: true,
  },
  otp: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
    expires: 60, // OTP expires in 1 minutes
  },
});

module.exports = mongoose.model("Otp", otpSchema);

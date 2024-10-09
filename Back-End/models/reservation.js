const mongoose = require("mongoose");

const reservationSchema = new mongoose.Schema({
  name: String,
  profileImage: String,
  rating: Number,
  serviceType: String,
  location: String,
  time: String,
  date: String,
  description: String,
  images: [String], // Add this line
});

module.exports = mongoose.model("Reservation", reservationSchema);

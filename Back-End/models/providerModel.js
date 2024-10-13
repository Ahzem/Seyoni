const mongoose = require("mongoose");

const providerSchema = new mongoose.Schema({
  firstName: {
    type: String,
    required: true,
  },
  lastName: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  profession: {
    type: String,
    required: true,
  },
  subCategories: {
    type: [String],
    required: true,
  },
  profileImageUrl: {
    type: String,
    required: true,
  },
  nicFrontUrl: {
    type: String,
    required: true,
  },
  nicBackUrl: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,
    default: 0,
  },
  completedWorks: {
    type: Number,
    default: 0,
  },
  isAvailable: {
    type: Boolean,
    default: true,
  },
  isApproved: {
    type: Boolean,
    default: true,
  },
});

const Provider = mongoose.model("Provider", providerSchema);

module.exports = Provider;

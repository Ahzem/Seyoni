const mongoose = require("mongoose");

const providerSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,
    required: true,
  },
  completedWorks: {
    type: Number,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  imageUrl: {
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
  isAvailable: {
    type: Boolean,
    required: true,
  },
});

const Provider = mongoose.model("Provider", providerSchema);

module.exports = Provider;

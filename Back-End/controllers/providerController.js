const Provider = require("../models/providerModel");
const mongoose = require("mongoose");

exports.createProvider = async (req, res) => {
  try {
    const provider = new Provider(req.body);
    await provider.save();
    res.status(201).json(provider);
  } catch (error) {
    res.status(400).json({ message: "Error creating provider", error });
  }
};

exports.getAllProviders = async (req, res) => {
  try {
    const providers = await Provider.find();
    res.status(200).json(providers);
  } catch (error) {
    res.status(400).json({ message: "Error retrieving providers", error });
  }
};

exports.getProviderDetails = async (req, res) => {
  try {
    const providerId = mongoose.Types.ObjectId(req.params.id); // Convert string ID to ObjectId
    const provider = await Provider.findById(providerId);
    if (!provider) {
      return res.status(404).json({ message: "Provider not found" });
    }
    res.status(200).json(provider);
  } catch (error) {
    res
      .status(400)
      .json({ message: "Error retrieving provider details", error });
  }
};

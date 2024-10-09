// providerController.js
const Provider = require("../models/providerModel");

exports.createProvider = async (req, res) => {
  try {
    const provider = new Provider(req.body);
    await provider.save();
    res.status(201).json(provider);
  } catch (error) {
    res.status(400).json({ message: "Error creating provider", error });
  }
};

exports.getProviderDetails = async (req, res) => {
  try {
    const providerId = req.params.providerId;
    const provider = await Provider.findById(providerId);
    if (!provider) {
      return res.status(404).json({ message: "Provider not found" });
    }
    res.status(200).json(provider);
  } catch (error) {
    res.status(500).json({ message: "Error fetching provider details", error });
  }
};

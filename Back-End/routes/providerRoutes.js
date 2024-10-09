const express = require("express");
const router = express.Router();
const providerController = require("../controllers/providerController");

// POST route to create a provider
router.post("/providers", providerController.createProvider);

// GET route to retrieve provider details
router.get("/providers/:providerId", providerController.getProviderDetails);

module.exports = router;

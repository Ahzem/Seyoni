const express = require("express");
const router = express.Router();
const providerController = require("../controllers/providerController");

// POST route to create a provider
router.post("/providers", providerController.createProvider);

// GET route to retrieve all providers
router.get("/providers", providerController.getAllProviders);

// GET route to retrieve provider details by ID
router.get("/providers/:id", providerController.getProviderDetails);

module.exports = router;

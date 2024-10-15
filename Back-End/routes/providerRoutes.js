const express = require("express");
const router = express.Router();
const providerController = require("../controllers/providerController");

// POST route to create a provider
router.post("/providers", providerController.createProvider);

// GET route to retrieve all providers
router.get("/", providerController.getAllProviders);

// GET route to retrieve provider details by ID
router.get("/:id", providerController.getProviderDetails);

// POST route to register a provider
router.post("/register/step1", providerController.registerStep1);
router.post("/register/step2", providerController.registerStep2);
router.post("/register/step3", providerController.registerStep3);
router.post("/register/step41", providerController.registerStep41);
router.post("/register/step42", providerController.registerStep42);
router.post("/register/step5", providerController.registerStep5);

// POST route to sign in a provider
router.post("/signin", providerController.signInProvider);

// PATCH route to update provider status
router.post("/:id", providerController.updateProviderStatus);

module.exports = router;

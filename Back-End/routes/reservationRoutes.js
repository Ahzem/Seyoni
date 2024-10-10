const express = require("express");
const router = express.Router();
const reservationController = require("../controllers/reservationController");
const authMiddleware = require("../middleware/authMiddleware"); // Ensure this matches the actual file path casing

// POST route to create a reservation
router.post(
  "/reservations",
  authMiddleware,
  reservationController.uploadImages,
  reservationController.createReservation
);

// GET route to retrieve reservations
router.get(
  "/reservations",
  authMiddleware,
  reservationController.getReservations
);

module.exports = router;

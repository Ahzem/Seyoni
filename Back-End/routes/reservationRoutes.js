const express = require("express");
const router = express.Router();
const reservationController = require("../controllers/reservationController");

// POST route to create a reservation
router.post(
  "/reservations",
  reservationController.uploadImages,
  reservationController.createReservation
);

// GET route to retrieve reservations
router.get("/reservations", reservationController.getReservations);

module.exports = router;

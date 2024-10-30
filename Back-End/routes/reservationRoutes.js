const express = require("express");
const router = express.Router();
const reservationController = require("../controllers/reservationController");
const authMiddleware = require("../middleware/authMiddleware"); // Ensure this matches the actual file path casing

// POST route to create a reservation
router.post(
  "/createReservation",
  authMiddleware,
  reservationController.uploadImages,
  reservationController.createReservation
);

// GET route to retrieve reservations
router.get("/", authMiddleware, reservationController.getReservations);

// GET route to retrieve a specific reservation by ID
router.get(
  "/:reservationId",
  authMiddleware,
  reservationController.getReservationById
);

router.patch(
  "/:reservationId/accept",
  authMiddleware,
  reservationController.acceptReservation
);

router.patch(
  "/:reservationId/reject",
  authMiddleware,
  reservationController.rejectReservation
);

router.patch(
  "/:reservationId/finish",
  authMiddleware,
  reservationController.finishedReservation
);

module.exports = router;

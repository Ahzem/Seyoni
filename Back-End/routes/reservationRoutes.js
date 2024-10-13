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

module.exports = router;

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

router.get(
  "/:reservationId/payment",
  authMiddleware,
  reservationController.getPaymentDetails
);

router.patch(
  "/:reservationId/payment",
  authMiddleware,
  reservationController.updatePayment
);

// Add this in reservationRoutes.js
router.get("/active-otp/:seekerId", async (req, res) => {
  try {
    const seekerId = req.params.seekerId;
    const activeReservation = await Reservation.findOne({
      "seeker.id": seekerId,
      status: "active",
      otp: { $exists: true },
    });

    if (activeReservation && activeReservation.otp) {
      res.json({
        hasActiveOtp: true,
        otp: activeReservation.otp,
        reservationId: activeReservation._id,
        section: activeReservation.section || 0,
      });
    } else {
      res.json({ hasActiveOtp: false });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

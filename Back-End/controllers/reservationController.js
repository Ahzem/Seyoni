const Reservation = require("../models/reservation");
const Seeker = require("../models/seekerModel");
const multer = require("multer");
const path = require("path");
const { S3Client } = require("@aws-sdk/client-s3");
const { Upload } = require("@aws-sdk/lib-storage");
const multerS3 = require("multer-s3");

// Set up AWS S3 client
const s3 = new S3Client({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

// Set up multer for image uploads to S3
const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: process.env.AWS_S3_BUCKET_NAME,
    // acl: "public-read",
    metadata: function (req, file, cb) {
      cb(null, { fieldName: file.fieldname });
    },
    key: function (req, file, cb) {
      cb(null, Date.now().toString() + path.extname(file.originalname));
    },
  }),
});

exports.uploadImages = upload.array("images", 3);

exports.createReservation = async (req, res) => {
  try {
    const reservationData = req.body;
    const seekerId = req.user._id;
    const seeker = await Seeker.findById(seekerId);

    if (req.files) {
      reservationData.images = req.files.map((file) => file.location); // S3 URL
    }

    reservationData.seeker = {
      id: seeker._id,
      firstName: seeker.firstName,
      lastName: seeker.lastName,
      email: seeker.email,
      profileImageUrl: seeker.profileImageUrl || null,
    };
    reservationData.providerId = req.body.providerId; // Ensure providerId is set

    const reservation = new Reservation(reservationData);
    await reservation.save();
    res.status(201).send(reservation);
  } catch (error) {
    console.error("Error creating reservation:", error);
    res
      .status(400)
      .send({ error: "Failed to create reservation", details: error.message });
  }
};

exports.getReservations = async (req, res) => {
  try {
    console.log("Fetching reservations..."); // Add this line
    const seekerId = req.headers["seeker-id"];
    const providerId = req.headers["provider-id"];

    if (!seekerId && !providerId) {
      return res
        .status(400)
        .send({ error: "Seeker ID or Provider ID is required" });
    }

    let reservations;
    if (seekerId) {
      reservations = await Reservation.find({ "seeker.id": seekerId });
    } else if (providerId) {
      reservations = await Reservation.find({ providerId: providerId });
    }

    res.status(200).send(reservations);
  } catch (error) {
    console.error("Error fetching reservations:", error);
    res.status(400).send({ error: "Failed to fetch reservations" });
  }
};

exports.getReservationById = async (req, res) => {
  try {
    const { reservationId } = req.params;
    const reservation = await Reservation.findById(reservationId);

    if (!reservation) {
      return res.status(404).send({ error: "Reservation not found" });
    }

    res.status(200).send(reservation);
  } catch (error) {
    console.error("Error fetching reservation:", error);
    res.status(400).send({ error: "Failed to fetch reservation" });
  }
};

exports.acceptReservation = async (req, res) => {
  try {
    const { reservationId } = req.params;
    const reservation = await Reservation.findByIdAndUpdate(
      reservationId,
      { status: "accepted" },
      { new: true }
    );
    res.status(200).send(reservation);
  } catch (error) {
    console.error("Error accepting reservation:", error);
    res.status(400).send({ error: "Failed to accept reservation" });
  }
};

exports.rejectReservation = async (req, res) => {
  try {
    const { reservationId } = req.params;
    const reservation = await Reservation.findByIdAndUpdate(
      reservationId,
      { status: "rejected" },
      { new: true }
    );
    res.status(200).send(reservation);
  } catch (error) {
    console.error("Error rejecting reservation:", error);
    res.status(400).send({ error: "Failed to reject reservation" });
  }
};

// In reservationController.js
exports.finishedReservation = async (req, res) => {
  try {
    const { reservationId } = req.params;
    const providerId = req.headers["provider-id"];

    if (!providerId) {
      return res.status(401).json({
        error: "Provider ID is required",
      });
    }

    const updateData = {
      status: "finished",
      serviceTime: req.body.serviceTime,
      amount: req.body.amount,
      paymentMethod: "pending", // Set default value
      paymentStatus: "pending", // Set default value
      completedAt: new Date(),
    };

    const reservation = await Reservation.findOneAndUpdate(
      {
        _id: reservationId,
        providerId: providerId,
      },
      updateData,
      {
        new: true,
        runValidators: true,
      }
    );

    if (!reservation) {
      return res.status(404).json({
        error: "Reservation not found or unauthorized",
      });
    }

    res.status(200).json({
      status: "success",
      data: reservation,
    });
  } catch (error) {
    console.error("Error finishing reservation:", error);
    res.status(500).json({
      error: "Failed to finish reservation",
      details: error.message,
    });
  }
};

exports.getPaymentDetails = async (req, res) => {
  try {
    const { reservationId } = req.params;
    const reservation = await Reservation.findById(reservationId).select(
      "serviceTime amount paymentMethod paymentStatus completedAt"
    );

    if (!reservation) {
      return res.status(404).json({
        error: "Reservation not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: reservation,
    });
  } catch (error) {
    console.error("Error fetching payment details:", error);
    res.status(500).json({
      error: "Failed to fetch payment details",
      details: error.message,
    });
  }
};

exports.updatePayment = async (req, res) => {
  try {
    const { reservationId } = req.params;
    const { paymentMethod, paymentStatus, amount } = req.body;

    const reservation = await Reservation.findByIdAndUpdate(
      reservationId,
      {
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        amount: amount,
      },
      { new: true }
    );

    if (!reservation) {
      return res.status(404).json({
        error: "Reservation not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: reservation,
    });
  } catch (error) {
    console.error("Error updating payment:", error);
    res.status(500).json({
      error: "Failed to update payment",
      details: error.message,
    });
  }
};

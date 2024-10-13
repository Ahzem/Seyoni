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
    // console.log("Headers:", req.headers); // Log request headers
    // console.log("Body:", req.body); // Log request body

    const reservationData = req.body;
    // console.log("Incoming reservation data:", reservationData); // Log incoming data

    if (req.files) {
      reservationData.images = req.files.map((file) => file.location); // S3 URL
    }

    const seekerId = req.user._id; // Assuming you have middleware to set req.user
    const seeker = await Seeker.findById(seekerId);
    reservationData.seeker = {
      id: seeker._id,
      firstName: seeker.firstName,
      lastName: seeker.lastName,
      email: seeker.email,
    };
    reservationData.providerId = req.body.providerId; // Ensure providerId is set

    // console.log("Creating Reservation with Data:", reservationData); // Debug statement

    const reservation = new Reservation(reservationData);
    await reservation.save();
    res.status(201).send(reservation);
  } catch (error) {
    // console.error("Error creating reservation:", error);  Log error
    res
      .status(400)
      .send({ error: "Failed to create reservation", details: error.message });
  }
};
exports.getReservations = async (req, res) => {
  try {
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
      // console.log("Provider ID:", providerId);  Debug statement
      reservations = await Reservation.find({ providerId: providerId });
      // console.log("Fetched Reservations:", reservations);  Debug statement
    }

    res.status(200).send(reservations);
  } catch (error) {
    console.error("Error fetching reservations:", error);
    res.status(400).send({ error: "Failed to fetch reservations" });
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

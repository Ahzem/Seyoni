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
    const reservation = new Reservation(reservationData);
    await reservation.save();
    res.status(201).send(reservation);
  } catch (error) {
    console.error("Error creating reservation:", error);
    res.status(400).send(error);
  }
};

exports.getReservations = async (req, res) => {
  try {
    const reservations = await Reservation.find();
    res.status(200).send(reservations);
  } catch (error) {
    res.status(400).send(error);
  }
};

const express = require("express");
const {
  registerSeeker,
  authSeeker,
  getSeekerProfile,
} = require("../controllers/seekerController");
const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/signup", registerSeeker);
router.post("/signin", authSeeker);
router.get("/profile", authMiddleware, getSeekerProfile);

module.exports = router;

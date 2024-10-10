const Seeker = require("../models/seekerModel");

const authMiddleware = async (req, res, next) => {
  try {
    const seekerId = req.headers["seeker-id"] || req.query.seekerId; // Check both headers and query parameters
    if (!seekerId) {
      return res.status(401).send({ error: "Seeker ID is required" });
    }
    const seeker = await Seeker.findById(seekerId);
    if (!seeker) {
      return res.status(404).send({ error: "Seeker not found" });
    }
    req.user = seeker;
    next();
  } catch (error) {
    res.status(500).send({ error: "Internal Server Error" });
  }
};

module.exports = authMiddleware;

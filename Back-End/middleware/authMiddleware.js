const Seeker = require("../models/seekerModel");
const Provider = require("../models/providerModel");

const authMiddleware = async (req, res, next) => {
  try {
    const seekerId = req.headers["seeker-id"] || req.query.seekerId;
    const providerId = req.headers["provider-id"] || req.query.providerId;

    if (!seekerId && !providerId) {
      return res
        .status(401)
        .send({ error: "Seeker ID or Provider ID is required" });
    }

    let user;
    if (seekerId) {
      user = await Seeker.findById(seekerId);
      if (!user) {
        return res.status(404).send({ error: "Seeker not found" });
      }
    } else if (providerId) {
      user = await Provider.findById(providerId);
      if (!user) {
        return res.status(404).send({ error: "Provider not found" });
      }
    }

    req.user = user;
    next();
  } catch (error) {
    console.error("Auth Middleware Error:", error);
    res.status(500).send({ error: "Internal Server Error" });
  }
};

module.exports = authMiddleware;

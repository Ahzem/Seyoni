const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const seekerSchema = new mongoose.Schema(
  {
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    phone: { type: String, required: true },
    email: {
      type: String,
      required: true,
      unique: true,
      match: [/.+\@.+\..+/, "Please fill a valid email address"],
    },
    address: { type: String, default: "N/A" },
    profileImageUrl: { type: String, default: "N/A" },
    password: { type: String, required: true },
  },
  { timestamps: true }
);

// bcrypt the password before saving
seekerSchema.pre("save", async function (next) {
  if (!this.isModified("password")) {
    return next();
  }
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

// compare the password
seekerSchema.methods.comparePassword = async function (seekerPassword) {
  return await bcrypt.compare(seekerPassword, this.password);
};

const Seeker = mongoose.model("Seeker", seekerSchema);

module.exports = Seeker;

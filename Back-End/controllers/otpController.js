const {
  saveTempUser,
  generateOtp,
  verifyOtp,
} = require("../services/otpService");

exports.saveTempUser = async (req, res) => {
  try {
    const { phone, userData } = req.body;
    console.log("Saving temp user:", { phone, userData });

    if (!phone || !userData) {
      return res.status(400).json({
        error: "Phone and user data are required",
      });
    }

    await saveTempUser(phone, userData);
    console.log("Temp user saved successfully");

    res.status(200).json({
      message: "Temporary user data saved successfully",
    });
  } catch (error) {
    console.error("Error saving temporary user data:", error);
    res.status(500).json({
      error: "Failed to save temporary user data",
    });
  }
};

exports.generateOtp = async (req, res) => {
  try {
    const { phone } = req.body;
    if (!phone) {
      return res.status(400).json({ error: "Phone number is required" });
    }

    await generateOtp(phone);
    res.status(200).json({ message: "OTP sent successfully" });
  } catch (error) {
    console.error("SNS Error:", error);
    res.status(500).json({
      error: "Failed to send OTP",
      details: error.message,
    });
  }
};

exports.sendOtpToSeeker = async (req, res) => {
  const { seekerId, otp } = req.body;
  if (!seekerId || !otp) {
    return res.status(400).json({ error: "Seeker ID and OTP are required" });
  }
  // Logic to send OTP to the seeker (e.g., using WebSocket or any other method)
  // For simplicity, we assume the OTP is sent successfully
  res.status(200).json({ message: "OTP sent to seeker" });
};

exports.verifyOtp = async (req, res) => {
  try {
    const { phone, otp } = req.body;
    console.log("Raw verification attempt:", { phone, otp });

    if (!phone || !otp) {
      return res.status(400).json({
        error: "Phone number and OTP are required",
      });
    }

    // Format phone number
    let formattedPhone = phone.replace(/\s+/g, "");
    if (!formattedPhone.startsWith("+")) {
      if (formattedPhone.startsWith("94")) {
        formattedPhone = "+" + formattedPhone;
      } else {
        formattedPhone = "+94" + formattedPhone;
      }
    }

    console.log("Formatted phone:", formattedPhone);
    const isValid = verifyOtp(formattedPhone, otp);
    console.log("Verification result:", isValid);

    if (isValid) {
      res.status(200).json({ message: "OTP verified successfully" });
    } else {
      res.status(400).json({ error: "Invalid OTP" });
    }
  } catch (error) {
    console.error("OTP verification error:", error);
    res.status(500).json({ error: "Verification failed" });
  }
};

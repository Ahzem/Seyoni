const SeekerServices = require("../services/seekerServices");

exports.registerSeeker = async (req, res) => {
  try {
    const { firstName, lastName, phone, email, password } = req.body;

    const seeker = await UserServices.registerSeeker(
      firstName,
      lastName,
      phone,
      email,
      password
    );
    res.json({
      status: true,
      success: "Seeker registered successfully",
      data: seeker,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

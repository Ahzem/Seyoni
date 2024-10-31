const {
  generateOtp,
  verifyOtp,
  saveTempUser,
  getTempUser,
  deleteTempUser,
} = require("../services/otpService");
require("dotenv").config();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");
const multer = require("multer");
const mongoose = require("mongoose");
const Provider = require("../models/providerModel");

const s3 = new S3Client({ region: process.env.AWS_REGION });

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
});

const professionMap = {
  "House Cleaning": "Cleaner",
  "Plumbing Services": "Plumber",
  "Carpentry Services": "Carpenter",
  "Masonry Services": "Mason",
  "Electrical Services": "Electrician",
  "Mechanic Services": "Mechanic",
  "Gardening Services": "Gardener",
  "Appliance Repair": "Appliance Technician",
  "Pest Control": "Pest Control Technician",
  "Roofing Repair": "Roofer",
  "Gutter Repair": "Gutter Technician",
  "Door Installations": "Door Installer",
  "HVAC Services": "HVAC Technician",
  "Elder Care Services": "Elder Caregiver",
  "Baby Care Services": "Babysitter",
};

exports.createProvider = async (req, res) => {
  try {
    const provider = new Provider(req.body);
    await provider.save();
    res.status(201).json(provider);
  } catch (error) {
    res.status(400).json({ message: "Error creating provider", error });
  }
};

exports.getAllProviders = async (req, res) => {
  try {
    const providers = await Provider.find();
    res.status(200).json(providers);
  } catch (error) {
    console.error("Error retrieving providers:", error);
    res.status(400).json({ message: "Error retrieving providers", error });
  }
};

exports.getProviderDetails = async (req, res) => {
  try {
    const providerId = req.params.id;

    // Validate the providerId
    if (!mongoose.Types.ObjectId.isValid(providerId)) {
      return res.status(400).json({ message: "Invalid provider ID" });
    }

    const provider = await Provider.findById(providerId);
    if (!provider) {
      return res.status(404).json({ message: "Provider not found" });
    }
    res.status(200).json(provider);
  } catch (error) {
    console.error("Error retrieving provider details:", error);
    res
      .status(400)
      .json({ message: "Error retrieving provider details", error });
  }
};

exports.registerStep1 = async (req, res) => {
  const { email, phone } = req.body;
  try {
    const existingProvider = await Provider.findOne({
      $or: [{ email }, { phone }],
    });
    if (existingProvider) {
      return res.status(400).json({ error: "Provider already exists" });
    }

    const otp = await generateOtp(phone); // Ensure OTP is generated
    await saveTempUser(phone, { email, phone }); // Ensure temporary user data is saved
    res.status(200).json({ message: "OTP sent" }); // Do not send OTP in response in production
  } catch (error) {
    console.error("Error in registerStep1:", error);
    res.status(500).json({ error: "Server error" });
  }
};

exports.registerStep2 = async (req, res) => {
  const { phone, otp } = req.body;
  try {
    if (!verifyOtp(phone, otp)) {
      return res.status(400).json({ error: "Invalid OTP" });
    }
    res.status(200).json({ message: "OTP verified" });
  } catch (error) {
    res.status(500).json({ error: "Server error" });
  }
};

exports.registerStep3 = [
  upload.single("profileImage"),
  async (req, res) => {
    const { phone } = req.body;
    const tempUserData = getTempUser(phone);
    if (!tempUserData) {
      return res
        .status(400)
        .json({ error: "No user data found for this phone number" });
    }

    const file = req.file;
    tempUserData.profileImage = file;
    saveTempUser(phone, tempUserData);
    res.status(200).json({ message: "Profile image data collected" });
  },
];

exports.registerStep41 = [
  upload.single("nicFront"),
  async (req, res) => {
    const { phone } = req.body;
    const tempUserData = getTempUser(phone);
    if (!tempUserData) {
      return res
        .status(400)
        .json({ error: "No user data found for this phone number" });
    }

    const nicFrontFile = req.file;
    tempUserData.nicFrontFile = nicFrontFile;
    saveTempUser(phone, tempUserData);
    res.status(200).json({ message: "Front NIC image data collected" });
  },
];

exports.registerStep42 = [
  upload.single("nicBack"),
  async (req, res) => {
    const { phone } = req.body;
    const tempUserData = getTempUser(phone);
    if (!tempUserData) {
      return res
        .status(400)
        .json({ error: "No user data found for this phone number" });
    }

    const nicBackFile = req.file;
    tempUserData.nicBackFile = nicBackFile;
    saveTempUser(phone, tempUserData);
    res.status(200).json({ message: "Back NIC image data collected" });
  },
];

exports.registerStep5 = async (req, res) => {
  const {
    phone,
    firstName,
    lastName,
    email,
    location,
    category,
    subCategories,
    password,
  } = req.body;
  try {
    const tempUserData = getTempUser(phone);
    if (!tempUserData) {
      return res
        .status(400)
        .json({ error: "No user data found for this phone number" });
    }

    // Upload profile image to S3
    const profileImageFile = tempUserData.profileImage;
    const profileImageFileName = `profile-images/${Date.now()}_${
      profileImageFile.originalname
    }`;
    await s3.send(
      new PutObjectCommand({
        Bucket: process.env.AWS_S3_BUCKET_NAME,
        Key: profileImageFileName,
        Body: profileImageFile.buffer,
        ContentType: profileImageFile.mimetype,
      })
    );
    const profileImageUrl = `https://${process.env.AWS_S3_BUCKET_NAME}.s3.amazonaws.com/${profileImageFileName}`;

    // Upload NIC front image to S3
    const nicFrontFile = tempUserData.nicFrontFile;
    const nicFrontFileName = `nic-images/${Date.now()}_front_${
      nicFrontFile.originalname
    }`;
    await s3.send(
      new PutObjectCommand({
        Bucket: process.env.AWS_S3_BUCKET_NAME,
        Key: nicFrontFileName,
        Body: nicFrontFile.buffer,
        ContentType: nicFrontFile.mimetype,
      })
    );
    const nicFrontUrl = `https://${process.env.AWS_S3_BUCKET_NAME}.s3.amazonaws.com/${nicFrontFileName}`;

    // Upload NIC back image to S3
    const nicBackFile = tempUserData.nicBackFile;
    const nicBackFileName = `nic-images/${Date.now()}_back_${
      nicBackFile.originalname
    }`;
    await s3.send(
      new PutObjectCommand({
        Bucket: process.env.AWS_S3_BUCKET_NAME,
        Key: nicBackFileName,
        Body: nicBackFile.buffer,
        ContentType: nicBackFile.mimetype,
      })
    );
    const nicBackUrl = `https://${process.env.AWS_S3_BUCKET_NAME}.s3.amazonaws.com/${nicBackFileName}`;

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Determine profession based on category
    const profession = professionMap[category] || "Unknown";

    // Create the provider
    const provider = new Provider({
      firstName,
      lastName,
      email,
      phone,
      location,
      category,
      profession,
      subCategories,
      profileImageUrl,
      nicFrontUrl,
      nicBackUrl,
      password: hashedPassword,
    });

    await provider.save();
    deleteTempUser(phone);

    // Generate a token
    const token = jwt.sign({ id: provider._id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });
    const data = {
      providerId: provider._id,
      token: token,
    };
    // console.log("Provider registered successfullyyyy");
    res.status(200).json({ message: "Provider registered successfully", data });
  } catch (error) {
    console.error("Error in registerStep5:", error);
    res.status(500).json({ error: "Server error" });
  }
};

exports.signInProvider = async (req, res) => {
  const { email, password } = req.body;
  // console.log("Request body:", req.body); // Log the request body
  try {
    // Check if the provider exists
    const provider = await Provider.findOne({ email });
    if (!provider) {
      // console.log("Provider not found");
      return res.status(400).json({ error: "Invalid email or password" });
    }

    // Verify the password
    const isMatch = await bcrypt.compare(password, provider.password);
    if (!isMatch) {
      // console.log("Password does not match");
      return res.status(400).json({ error: "Invalid email or password" });
    }

    // Generate a token
    const token = jwt.sign({ id: provider._id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });

    // Return the token and providerId
    res.status(200).json({ token, providerId: provider._id });
  } catch (error) {
    console.error("Error in signInProvider:", error);
    res.status(500).json({ error: "Server error" });
  }
};

exports.updateProviderStatus = async (req, res) => {
  const { id } = req.params;
  const { isApproved } = req.body;

  try {
    const provider = await Provider.findByIdAndUpdate(
      id,
      { isApproved },
      { new: true }
    );

    if (!provider) {
      return res.status(404).json({ message: "Provider not found" });
    }

    res.status(200).json(provider);
  } catch (error) {
    res.status(400).json({ message: "Error updating provider status", error });
  }
};

// delete the provider details when click the reject button

// Future<void> _rejectProvider() async {
//   try {
//     final response = await http
//         .delete(Uri.parse('$updateProviderStatusUrl/${widget.providerId}'));
//     if (response.statusCode == 200) {
//       Navigator.pop(context, true);
//     } else {
//       throw Exception('Failed to reject provider ${response.statusCode}');
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Failed to reject provider: $e'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

exports.deleteProvider = async (req, res) => {
  const { id } = req.params;
  try {
    const provider = await Provider.findByIdAndDelete(id);
    if (!provider) {
      return res.status(404).json({ message: "Provider not found" });
    }
    res.status(200).json({ message: "Provider deleted successfully" });
  } catch (error) {
    res.status(400).json({ message: "Error deleting provider", error });
  }
};

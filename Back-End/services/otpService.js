const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");

const sns = new SNSClient({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

const otps = new Map();
const tempUsers = new Map();

function formatPhoneNumber(phone) {
  // Remove any spaces or special characters
  let cleaned = phone.replace(/\s+/g, "").replace(/^\+/, "");
  // Add +94 prefix if not present
  if (!cleaned.startsWith("94")) {
    cleaned = "94" + cleaned;
  }
  return "+" + cleaned;
}

async function generateAndSendOtp(phone) {
  try {
    // Format phone number consistently
    const formattedPhone = formatPhoneNumber(phone);
    console.log(
      `Phone number formatting: Original=${phone}, Formatted=${formattedPhone}`
    );

    // Generate OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    console.log(`Generated OTP=${otp} for phone=${formattedPhone}`);

    // Store OTP with formatted phone
    otps.set(formattedPhone, {
      otp,
      expiresAt: Date.now() + 300000,
    });
    console.log(`Stored OTP data:`, Array.from(otps.entries()));

    // Send SMS
    const params = {
      Message: `Your Seyoni verification code is: ${otp}. Valid for 5 minutes.`,
      PhoneNumber: formattedPhone,
      MessageAttributes: {
        "AWS.SNS.SMS.SenderID": {
          DataType: "String",
          StringValue: "SEYONI",
        },
        "AWS.SNS.SMS.SMSType": {
          DataType: "String",
          StringValue: "Transactional",
        },
      },
    };

    const command = new PublishCommand(params);
    const response = await sns.send(command);
    console.log(`SMS sent successfully, MessageId: ${response.MessageId}`);

    return otp;
  } catch (error) {
    console.error("SMS sending error:", error);
    throw error;
  }
}

function generateOtp(phone) {
  console.log(`Generating OTP for phone: ${phone}`); // Debug log
  return generateAndSendOtp(phone);
}

function verifyOtp(phone, otp) {
  const formattedPhone = formatPhoneNumber(phone);
  console.log(`OTP Verification attempt:`, {
    originalPhone: phone,
    formattedPhone: formattedPhone,
    receivedOtp: otp,
  });

  const otpData = otps.get(formattedPhone);
  console.log(`Stored OTP data for ${formattedPhone}:`, otpData);

  if (!otpData) {
    console.log(`No OTP found for ${formattedPhone}`);
    return false;
  }

  if (otpData.expiresAt < Date.now()) {
    console.log(`OTP expired for ${formattedPhone}`);
    otps.delete(formattedPhone);
    return false;
  }

  const isValid = otpData.otp === otp;
  console.log(`OTP validation result:`, {
    storedOtp: otpData.otp,
    receivedOtp: otp,
    isValid,
  });

  if (isValid) {
    otps.delete(formattedPhone);
  }

  return isValid;
}

function saveTempUser(phone, userData) {
  // Format phone number consistently
  const formattedPhone = formatPhoneNumber(phone);
  console.log(`Saving temp user data for ${formattedPhone}:`, userData);

  return new Promise((resolve, reject) => {
    try {
      tempUsers.set(formattedPhone, userData);
      console.log("Current temp users:", Array.from(tempUsers.entries()));
      resolve();
    } catch (error) {
      console.error("Error saving temp user:", error);
      reject(error);
    }
  });
}

function getTempUser(phone) {
  const formattedPhone = formatPhoneNumber(phone);
  console.log(`Getting temp user data for ${formattedPhone}`);
  const userData = tempUsers.get(formattedPhone);
  console.log("Found user data:", userData);
  return userData;
}

function deleteTempUser(phone) {
  tempUsers.delete(phone);
  console.log(`Deleted temporary user data for phone: ${phone}`);
}

module.exports = {
  generateOtp,
  verifyOtp,
  saveTempUser,
  getTempUser,
  deleteTempUser,
};

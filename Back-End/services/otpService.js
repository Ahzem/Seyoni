const otps = new Map();
const tempUsers = new Map();

function generateOtp(phone) {
  return new Promise((resolve, reject) => {
    try {
      const otp = Math.floor(100000 + Math.random() * 900000).toString(); // Generate a 6-digit OTP
      otps.set(phone, { otp, expiresAt: Date.now() + 300000 }); // OTP expires in 5 minutes
      console.log(`Generated OTP for ${phone}: ${otp}`);
      resolve(otp);
    } catch (error) {
      reject(error);
    }
  });
}

function verifyOtp(phone, otp) {
  console.log(`Verifying OTP for phone: ${phone}`);
  const otpData = otps.get(phone);
  console.log(`Stored OTP data: ${JSON.stringify(otpData)}`);
  if (!otpData) {
    console.log("No OTP found for this phone");
    return false;
  }
  if (otpData.expiresAt < Date.now()) {
    console.log("OTP has expired");
    otps.delete(phone);
    return false;
  }
  if (otpData.otp === otp) {
    console.log("OTP is valid");
    otps.delete(phone);
    return true;
  }
  console.log("OTP is invalid");
  return false;
}

function saveTempUser(phone, userData) {
  return new Promise((resolve, reject) => {
    try {
      tempUsers.set(phone, userData);
      resolve();
    } catch (error) {
      reject(error);
    }
  });
}

function getTempUser(phone) {
  return tempUsers.get(phone);
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

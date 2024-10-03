const otps = new Map();
const tempUsers = new Map();

function generateOtp(number) {
  const OTP = Math.floor(100000 + Math.random() * 900000).toString();
  otps.set(number, { otp: OTP, expiresAt: Date.now() + 60000 }); // OTP expires in 1 minute
  console.log(`Generated OTP: ${OTP} for number: ${number}`);
  console.log(`Current OTP store: ${JSON.stringify([...otps])}`);
  return OTP;
}

function verifyOtp(number, otp) {
  console.log(`Verifying OTP for number: ${number}`);
  const otpData = otps.get(number);
  console.log(`Stored OTP data: ${JSON.stringify(otpData)}`);
  if (!otpData) {
    console.log("No OTP found for this number");
    return false;
  }
  if (otpData.expiresAt < Date.now()) {
    console.log("OTP has expired");
    otps.delete(number);
    return false;
  }
  if (otpData.otp === otp) {
    console.log("OTP is valid");
    otps.delete(number);
    return true;
  }
  console.log("OTP is invalid");
  return false;
}

function saveTempUser(number, userData) {
  tempUsers.set(number, userData);
  console.log(`Saved temporary user data for number: ${number}`);
}

function getTempUser(number) {
  return tempUsers.get(number);
}

function deleteTempUser(number) {
  tempUsers.delete(number);
  console.log(`Deleted temporary user data for number: ${number}`);
}

module.exports = {
  generateOtp,
  verifyOtp,
  saveTempUser,
  getTempUser,
  deleteTempUser,
};

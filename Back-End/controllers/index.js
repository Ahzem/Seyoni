const signUpSeeker = require("./seeker/signUpSeeker");
const verifySignUpOtp = require("./seeker/verifySignUpOtp");
const resendOtp = require("./seeker/resendOtp");
const signInSeeker = require("./seeker/signInSeeker");
const signOutSeeker = require("./seeker/signOutSeeker");

module.exports = {
  signUpSeeker,
  verifySignUpOtp,
  resendOtp,
  signInSeeker,
  signOutSeeker,
};

const url = 'https://seyoni.onrender.com';
const wsUrl = 'wss://seyoni.onrender.com/ws';
// const wsUrl = 'ws://localhost:3000/ws';
// const url = 'http://localhost:3000';
const registerSeekersUrl = '$url/api/seeker/signup';
const loginSeekersUrl = '$url/api/seeker/signin';
const verifyOtpUrl = '$url/api/seeker/verifySignUpOtp';
const resendOtpUrl = '$url/api/seeker/resendSignUpOtp';
const signOutUrl = '$url/api/seeker/signout';
const checkSeekerExistsUrl = '$url/api/seeker/check';

const sendReservationsUrl = '$url/api/reservations/createReservation';
const getReservationsUrl = '$url/api/reservations';

const getProvidersUrl = '$url/api/provider';
const getSeekersUrl = '$url/api/seeker/all';

const registerProvidersUrl_1 = '$url/api/provider/register/step1';
const registerProvidersUrl_2 = '$url/api/provider/register/step2';
const registerProvidersUrl_3 = '$url/api/provider/register/step3';
const registerProvidersUrl_41 = '$url/api/provider/register/step41';
const registerProvidersUrl_42 = '$url/api/provider/register/step42';
const registerProvidersUrl_5 = '$url/api/provider/register/step5';

const loginProvidersUrl = '$url/api/provider/signin';

const fetchProvidersUrl = '$url/api/provider';
const updateProviderStatusUrl = '$url/api/provider';

const acceptReservationUrl = '$url/api/reservations';
const rejectReservationUrl = '$url/api/reservations';

const generateOtpUrl = '$url/api/otp/generateOtp';
const saveTempUserUrl = '$url/api/otp/saveTempUser';

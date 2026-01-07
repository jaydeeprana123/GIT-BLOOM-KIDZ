// live url
var urlBase =
    'https://api.bloomkidz.net/api'; // change ( 10-07-2024 ) ( Live url)

//Authentication APIs
const urlLogin = '/login';
const urlLogout = '/logout';

const urlNewsFeedCalenderList = '/parent/newsfeeds/calendar';
const urlNewsFeedList = '/parent/newsfeeds';
const urlAddCommentInNewsFeed = '/parent/newsfeeds';
const urlAddLikeInNewsFeedComment = '/parent/newsfeeds';

const urlChildInfoList = '/parent/children';
const urlActivityList = '/parent/children/activity';

const urlGetFamilyContacts = '/parent/contacts';
const urlAddFamily = "/parent/contacts";
const urlUpdateFamily = "/parent/contacts/update";
const urlDeleteContact = '/parent/contacts/delete';

///Documents
const urlGetDocumentList = '/parent/children/documents';

/// bookings
const urlGetBookingList = '/parent/children/extra-bookings';

const urlGetAbout = '/parent/children/about';

const urlGetExtraBookingList = '/parent/children/extra-bookings';
const urlAddExtraBooking = '/parent/children/extra-bookings';
const urlGetObservationList = '/parent/children/observations';
const urlLikeUnlikeObservation = '/parent/children/observations';
const urlAddCommentInObservation = '/parent/children/observations';

/// Price Band
const urlGetPriceBandList = '/parent/children/extra-bookings';

///Permissions
const urlGetChildPermissionsList = '/parent/children/permissions';
const urlConfirmChildPermission = '/parent/children/permissions/confirm';

const urlLeaveRequest = '/parent/children/leave';

/// Profile
const urlGetProfile = '/parent/profile';
const urlChangePassword = '/parent/change-password';
const urlSetPin = '/parent/profile/update-quick-pin';

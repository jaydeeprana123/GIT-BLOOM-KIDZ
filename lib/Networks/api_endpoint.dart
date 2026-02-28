// live url
var urlBase =
    'https://api.bloomkidz.net/api'; // change ( 10-07-2024 ) ( Live url)

//Authentication APIs
const urlLogin = '/login';
const urlLogout = '/logout';
const urlGetVersion = '/app-version';
const urlLoginWithPin = '/login-with-pin';

const urlNewsFeedCalenderList = '/parent/newsfeeds/calendar';
const urlNewsFeedList = '/parent/newsfeeds';
const urlAddLikeInNewsFeed = '/parent/newsfeeds';

const urlAddCommentInNewsFeed = '/parent/newsfeeds';
const urlAddLikeInNewsFeedComment = '/parent/newsfeeds';

const urlChildInfoList = '/parent/children';
const urlChildActivityList = '/parent/children/activity';

const urlGetFamilyContacts = '/parent/contacts';
const urlAddFamily = "/parent/contacts";
const urlUpdateFamily = "/parent/contacts/update";
const urlDeleteContact = '/parent/contacts/delete';

const urlLeaveRequest = '/parent/children/leave';

/// Safe guarding
const urlMedicationList = '/parent/children/medications';
const urlAddAcknowledgeMedication = '/parent/children/medications/acknowledge';

const urlAccidentList = '/parent/children/accidents';
const urlAddAcknowledgeAccident = '/parent/children/accidents/acknowledge';

///Documents
const urlGetDocumentList = '/parent/children/documents';

/// bookings
const urlGetBookingList = '/parent/children/extra-bookings';

const urlGetAbout = '/parent/children/about';

const urlGetExtraBookingList = '/parent/children/extra-bookings';
const urlAddExtraBooking = '/parent/children/extra-bookings';
const urlDeleteExtraBooking = '/parent/children/extra-bookings';


const urlGetGroupObservationList = '/parent/children/single-group-observations';

const urlGetObservationList = '/parent/children/observations';
const urlLikeUnlikeObservation = '/parent/children/observations';
const urlAddCommentInObservation = '/parent/children/observations';

const urlAddObservation = '/parent/children/observations';

/// Price Band
const urlGetPriceBandList = '/parent/children/extra-bookings';

///Permissions
const urlGetChildPermissionsList = '/parent/children/permissions';
const urlConfirmChildPermission = '/parent/children/permissions/confirm';

/// Profile
const urlGetProfile = '/parent/profile';
const urlChangePassword = '/parent/change-password';
const urlSetPin = '/parent/profile/update-quick-pin';
const urlViewPin = '/parent/profile/view-quick-pin';

const urlSetCollectionPin = '/parent/children/set-collection-pin';
const urlActivityList = '/parent/activities';

/// Chat
const urlPeopleList = '/parent/chat/people';
const urlSendMessage = '/parent/chat/send';
const urlGetGroupChat = '/parent/chat/messages';
const urlDeleteMessage = '/parent/chat/delete-message';
const urlAddGroupMember = '/parent/chat/add-members';
const urlConversations = '/parent/chat/conversations';

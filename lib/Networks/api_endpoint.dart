// live url
var urlBase =
    'http://api.bloomkidz.net/api'; // change ( 10-07-2024 ) ( Live url)

//Authentication APIs
const urlLogin = '/login';

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

///Permissions
const urlGetChildPermissionsList = '/parent/children/permissions';
const urlConfirmChildPermission = '/parent/children/permissions/confirm';

const urlLeaveRequest = '/parent/children/leave';

/// Profile
const urlGetProfile = '/parent/profile';
const urlChangePassword = '/parent/change-password';
const urlSetPin = '/parent/profile/update-quick-pin';

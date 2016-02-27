//
//  WebServiceConstants.h
//  I_Like_My_Waitress
//
//  Created by Rahul V. Mane on 8/26/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#pragma mark - General Error Constants

#define WS_DOMAIN_WEB_SERVER_ERROR @"WebServerErrorDomain"
#define WS_DOMAIN_JSON_ERROR @"JSONErrorDomain"

#define WS_RANDOM_CUSTOM_ERROR_CODE_BAD_RESPONSE 7654
#define WS_SUCCESS_CODE 1000

#pragma mark - API call's path

#define WS_API_LOGIN @"token?"
#define WS_API_REGISTER @"api/Account/Register"
#define WS_API_FORGOT_PASSWORD @"/api/Account/ForgotPassword"
#define WS_API_UPDATE_PROFILE @"api/Account/UpdateUser"
#define WS_API_UPDATE_DEVICE_TOKEN  @"user/updateDeviceToken"

#define WS_API_GET_TOP_BROADCAST @"user/getTopBroadcast"
#define WS_API_GET_BROADCAST_LIST @"user/getBroadcastList"
#define WS_API_SEARCH_BROADCAST @"user/searchBroadcast"

#define WS_API_GET_OLD_QUERIES @"user/getQueries"
#define WS_API_SEND_QUERY @"user/sendQuery"

#define WS_API_GET_USER_LIST @"user/getUserList"
#define WS_API_SEARCH_USER @"user/searchUser"
#define WS_API_FOLLOW_USER @"user/followUser"
#define WS_API_GET_USER_DETAILS @"user/getUserDetails"

#define WS_API_GET_USERS_BROADCASTS @"broadcast/getMyBroadcasts"

#define WS_API_CREATE_SCHEDULE_BRD @"broadcast/createBroadcastSchedule"
#define WS_API_EDIT_SCHEDULED_BRD @"broadcast/editBroadcastSchedule"

#define WS_API_SEND_BROADCAST_MESSAGE @"user/sendMessageWhileBroadcasting"
#define WS_API_GET_BROADCAST_MESSAGES @"user/getMessagesWhileBroadcasting"
#define WS_API_CREATE_LIVE_BROADCAST @"user/createLiveBroadcast"
#define WS_API_JOIN_LIVE_BROADCAST @"user/joinLiveBroadcast"
#define WS_API_END_LIVE_BROADCAST @"user/endLiveBroadcast"

#pragma mark - Keys used in parameter

// RESPONSE KEYS

#define WS_KEY_NAME  @"name"
#define WS_KEY_USERNAME  @"Username"

#define WS_KEY_GRANTTYPE  @"grant_type"

#define WS_KEY_EMAIL @"Email"
#define WS_KEY_PASSWORD @"Password"
#define WS_KEY_CONFIRM_PASSWORD @"ConfirmPassword"
#define WS_KEY_DEVICE_TOKEN @"deviceToken"
#define WS_KEY_PAGE_NO @"pageNumber"
#define WS_KEY_SESSION @"sessionToken"
#define WS_KEY_USER_ID @"userId"
#define WS_KEY_FOLLOWING_ID @"followingId"
#define WS_KEY_USER_DETAIL_ID @"userDetailId"
#define WS_KEY_SEARCH_TEXT @"serachText"
#define WS_KEY_QUERY @"query"
#define WS_KEY_FOLLOW_ACTION @"follow"
#define WS_KEY_BROADCAST_ID @"broadcastId"
#define WS_KEY_BROADCAST_TITLE @"broadcastTitle"
#define WS_KEY_BROADCAST_DATE_TIME @"broadcastDateTime"
#define WS_KEY_BROADCAST_TIME_ZONE @"broadcastTimeZone"
#define WS_KEY_ROOM_ID @"roomId"

#define WS_KEY_STATUS @"messageCode"
#define WS_KEY_MESSAGE @"message"
#define WS_KEY_DATA @"data"

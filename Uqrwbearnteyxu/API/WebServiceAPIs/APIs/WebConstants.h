//
//  WebConstants.h
//  UploadImageDemo
//
//  Created by Developer on 10/01/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#ifndef WebConstants_h
#define WebConstants_h


#define baseURL @"http://5.189.161.31"
//#define baseURL @"http://uxwebapi.twigsoftwares.com"


#define loginURL [NSString stringWithFormat:@"%@/%@",baseURL,@"token?"]
#define registerURL [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Account/Register"]
#define forgotPasswordURL [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Account/ForgotPassword"]
#define makeProfileURL [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Account/UpdateUser"]

#define getFriendList [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Profile/UserFriends?"]
#define searchFriendList [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Relationships/GetPeopleRelationships?"]

#define addFriendRequest [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Relationships"]



#define radarURL [NSString stringWithFormat:@"%@/%@",baseURL,@"/api/Radar/UserRadar"]

#define sportListURL [NSString stringWithFormat:@"%@/%@",baseURL,@"/api/Sports"]
#define checkEmailURL [NSString stringWithFormat:@"%@/%@",baseURL,@"/api/Account/CheckAccount?"]
#define checkUserNameUrl [NSString stringWithFormat:@"%@/%@",baseURL,@"/api/Account/CheckUsername?"]

#define sportListSendURL [NSString stringWithFormat:@"%@/%@",baseURL,@"/api/UserSports"]

#define facebookBearToken [NSString stringWithFormat:@"%@/%@",baseURL,@"/api/UserSports"]

#endif /* WebConstants_h */

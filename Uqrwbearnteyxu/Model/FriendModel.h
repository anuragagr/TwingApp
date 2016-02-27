//
//  FriendModel.h
//  Uqrwbearnteyxu
//
//  Created by Developer on 11/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
@property (strong, nonatomic) NSString *strBithdate;
@property (strong, nonatomic) NSString *strEmail;
@property (strong, nonatomic) NSString *strFirstName;
@property (strong, nonatomic) NSString *strFriendsCount;
@property (strong, nonatomic) NSString *strGender;
@property (strong, nonatomic) NSString *strUserID;
@property (strong, nonatomic) NSString *strLastName;
@property (strong, nonatomic) NSString *strMeetUpCount;
@property (strong, nonatomic) NSString *strMutualFriends;
@property (strong, nonatomic) NSString *strMutualSports;
@property (strong, nonatomic) NSString *strPhoneNumber;
@property (strong, nonatomic) NSString *strProfilePicURL;
@property (strong, nonatomic) NSString *strResidence;
@property (strong, nonatomic) NSString *strThumbImgPath;
@property (strong, nonatomic) NSString *strUserName;
@property (strong, nonatomic) NSString *strClientUserName;
@property (strong, nonatomic) NSMutableArray *arrayOfSports;
@property (strong, nonatomic) NSMutableArray *arrayOfFriends;

@property (strong, nonatomic) NSString *strRelationshipStatus;
@property (strong, nonatomic) NSString *strUserStatus;
@property (strong, nonatomic) NSString *strDistance;


@property (readwrite, nonatomic) BOOL isRequestFriend;


@end

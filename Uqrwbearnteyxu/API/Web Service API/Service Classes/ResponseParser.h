//
//  OnLookerParser.h
//  OnLooker
//
//  Created by Rahul Mane on 09/11/15.
//  Copyright © 2015 Perennial Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@class Response;

@interface ResponseParser : NSObject

// User Web Service Client

- (Response *)userWebClientSignInParser:(NSDictionary *)data;
- (Response *)userWebClientSignUpParser:(NSDictionary *)json;


- (Response *)userWebClientUpdateUserProfileParser:(NSDictionary *)data;

// Broadcast Web Service Client

- (Response *)broadcastWebClientGetTopBroadcastParser:(NSDictionary *)data;

- (Response *)broadcastWebClientGetBroadcastListParser:(NSDictionary *)data;

// Support Web Service Client

- (Response *)supportWebClientGetOldQueriesParser:(NSDictionary *)data;

// Friends Web Service Client

- (Response *)friendsWebClientGetUserListParser:(NSDictionary *)data;

- (Response *)friendsWebClientGetUserDetailParser:(NSDictionary *)data;

- (Response *)friendsWebClientGetUsersBroadcastParser:(NSDictionary *)data;

// Live Broadcast Web Service Client

- (Response *)liveBroadcastWebClientCreateBroadcastParser:(NSDictionary *)data;

- (Response *)liveBroadcastWebClientCreateLiveBroadcastParser:(NSDictionary *)data;

- (Response *)liveBroadcastWebClientJoinLiveBroadcastParser:(NSDictionary *)data;

// OTHER
- (Response *)sucessResponseParser:(NSDictionary *)data;


- (Response *)successForgotPassword:(NSDictionary *)data;


@end

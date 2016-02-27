//
//  OnLookerParser.m
//  OnLooker
//
//  Created by Rahul Mane on 09/11/15.
//  Copyright © 2015 Perennial Systems. All rights reserved.
//

#import "ResponseParser.h"
#import "Response.h"
#import "UserModel.h"

#define kSuccessResponseCode 0

@interface ResponseParser ()

@property (strong, nonatomic) Response *result;

@end

@implementation ResponseParser

- (id)init
{
    if (self = [super init])
    {
        self.result = [[Response alloc] init];
        self.result.errorCode = kSuccessResponseCode;
    }
    return self;
}

- (Response *)userWebClientSignUpParser:(NSDictionary *)json
{
    NSDictionary *data = json[@"Data"];
    
    
    return self.result;
}



- (Response *)userWebClientSignInParser:(NSDictionary *)json
{

    UserModel *userModel = [[UserModel alloc] init];
    userModel.strUserId = [json valueForKey:@"UserId"];
    userModel.strAuthToken = [json valueForKey:@"access_token"];
    userModel.strUserName = [json valueForKey:@"UserName"];
    
    self.result.responseObject = userModel;
    return self.result;
}

- (Response *)userWebClientUpdateUserProfileParser:(NSDictionary *)json
{
    NSDictionary *data = json[@"data"];

    NSString *pictureURL = data[@"profilePictureUrl"];
    
   // self.result.responseObject = pictureURL;
    return self.result;
}

- (Response *)broadcastWebClientGetTopBroadcastParser:(NSDictionary *)json
{
    NSDictionary *data = json[@"data"];
    
    NSMutableArray *featuredArray = [NSMutableArray array];
    NSMutableArray *topTenArray = [NSMutableArray array];
    
    for (NSDictionary *dict in data[@"featured"])
    {
//        BroadcastModel *model = [[BroadcastModel alloc] initWithData:dict];
//        [featuredArray addObject:model];
    }

    for (NSDictionary *dict in data[@"topten"])
    {
//        BroadcastModel *model = [[BroadcastModel alloc] initWithData:dict];
//        [topTenArray addObject:model];
    }

    NSDictionary *topBroadcast = @{ @"featured" : featuredArray, @"topten" : topTenArray};
    //self.result.responseObject = topBroadcast;
    
    return self.result;
}

- (Response *)successForgotPassword:(NSDictionary *)data{
    NSDictionary *dict = data[@"Data"];
    
    self.result.responseObject = dict;
    
    return self.result;
}
@end

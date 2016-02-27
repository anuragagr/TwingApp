//
//  UserWebServiceClient.h
//  WonUp
//
//  Created by Rahul Mane on 01/09/15.
//  Copyright (c) 2015 Perennial Systems. All rights reserved.
//

#import "BaseService.h"

@class UserModel;

@interface UserWebServiceClient : BaseService

- (void)signInWithEmailId:(NSString *)emailId password:(NSString *)password deviceToken:(NSString *)deviceToken target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure;

- (void)forgotPasswordForEmailId:(NSString *)emailId target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure;

- (void)signUpUserWithName:(NSString *)name emailId:(NSString *)emailId password:(NSString *)password deviceToken:(NSString *)deviceToken target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure;

- (void)updateDeviceTokenForUserId:(NSString *)userId sessionId:(NSString *)sessionId deviceToken:(NSString *)deviceToken target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure;

- (void)updateUser:(UserModel *)userModel target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure;

@end

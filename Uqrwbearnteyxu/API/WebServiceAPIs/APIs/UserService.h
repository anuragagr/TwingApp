//
//  UserService.h
//  WCI-Web
//
//  Created by Rahul N. Mane on 11/04/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"
#import "ASIFormDataRequest.h"
#import "UserModel.h"

@interface UserService : NSObject

@property(nonatomic,readwrite)int tag;
@property(nonatomic,strong)id<WebServiceDelegate> delegate;
@property (strong, nonatomic) ASIFormDataRequest *requestform;
@property (strong, nonatomic) ASIHTTPRequest *request;


//shared instance
+ (UserService *)sharedInstance;

-(void)registerWithUserName:(NSString *)userName andDateOfBirth:(NSString *)dateOfBirth andGender:(NSString *)gender andEmail:(NSString *)email andPassword:(NSString *)password andConfirmPassowrd:(NSString *)confirmPassowrd andUploadImage:(UIImage *)uploadImage andFirstName:(NSString *)firstName andLastName:(NSString *)lastName andResidence:(NSString *)residence andClientUserName:(NSString *)clientUserName andStatus:(NSString *)status ;
-(void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password token:(NSString *)deviceToken;
-(void)forgotPasswordWithEmailID:(NSString *)email;

-(void)makeProfileWithUserModel:(UserModel *)userModel;
-(void)SportListdata;
-(void)CheckEmailId:(NSString *)email;
-(void)checkUserName:(NSString *)username;
-(void)sportListSendData:(NSString *)userId andSportId:(NSString *)sportId andCreatedDate:(NSString *)createdDate andUpdatedDate:(NSString *)updatedDate;
    
@end

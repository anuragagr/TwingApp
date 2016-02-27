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


//shared instance
+ (UserService *)sharedInstance;

-(void)registerWithUserName:(NSString *)userName andPassword:(NSString *)password;
-(void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password token:(NSString *)deviceToken;
-(void)forgotPasswordWithEmailID:(NSString *)email;

-(void)makeProfileWithUserModel:(UserModel *)userModel;


    
@end

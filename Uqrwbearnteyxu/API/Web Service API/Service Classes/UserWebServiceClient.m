//
//  UserWebServiceClient.m
//  WonUp
//
//  Created by Rahul Mane on 01/09/15.
//  Copyright (c) 2015 Perennial Systems. All rights reserved.
//

#import "UserWebServiceClient.h"
#import "WebServiceChannel.h"
#import "WebServiceConstants.h"
#import "ResponseParser.h"
#import "UserModel.h"

NS_ENUM(NSInteger, USER_WEB_SERVICE_TAG)
{
    USER_WEB_SERVICE_TAG_SIGN_IN,
    USER_WEB_SERVICE_TAG_FORGOT_PASSWORD,
    USER_WEB_SERVICE_TAG_SIGN_UP,
    USER_WEB_SERVICE_TAG_UPDATE_DEVICE_TOKEN,
    USER_WEB_SERVICE_TAG_USER_UPDATE
};

@implementation UserWebServiceClient

- (id)init
{
    self = [super init];
    if (self) {
        channel = [[WebServiceChannel alloc] init];
    }
    return self;
}

- (void)signInWithEmailId:(NSString *)emailId password:(NSString *)password deviceToken:(NSString *)deviceToken target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure
{
    
    NSString *grantType= @"password";
    NSString *grantKey = @"grant_type";
    
    [self setCallbakToListener:target onSuccess:success onFailure:failure];
    
    NSDictionary *parameters = @{ WS_KEY_USERNAME : emailId.length?emailId:@"",
                                  WS_KEY_PASSWORD : password.length?password:@"",
                                  grantKey : grantType
                                 };
    [channel requestWithTag:USER_WEB_SERVICE_TAG_SIGN_IN postData:parameters toPath:WS_API_LOGIN target:self onSuccess:@selector(request:didSignInFinishWithResponse:) onFailure:@selector(request:didFailWithError:)];
}

- (void)signUpUserWithName:(NSString *)name emailId:(NSString *)emailId password:(NSString *)password deviceToken:(NSString *)deviceToken target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure
{
    [self setCallbakToListener:target onSuccess:success onFailure:failure];
    
    NSDictionary *parameters = @{ WS_KEY_EMAIL : emailId.length?emailId:@"",
                                  WS_KEY_PASSWORD : password.length?password:@"",
                                  WS_KEY_CONFIRM_PASSWORD : password.length?password:@"",
                                  };
    [channel requestWithTag:USER_WEB_SERVICE_TAG_SIGN_UP postData:parameters toPath:WS_API_REGISTER target:self onSuccess:@selector(request:didFinishWithResponse:) onFailure:@selector(request:didFailWithError:)];
}

- (void)forgotPasswordForEmailId:(NSString *)emailId target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure
{
    [self setCallbakToListener:target onSuccess:success onFailure:failure];
    
    NSDictionary *parameters = @{ WS_KEY_EMAIL : emailId.length?emailId:@"" };

    [channel requestWithTag:USER_WEB_SERVICE_TAG_FORGOT_PASSWORD postData:parameters toPath:WS_API_FORGOT_PASSWORD target:self onSuccess:@selector(request:didFinishWithResponse:) onFailure:@selector(request:didFailWithError:)];
}

- (void)updateUser:(UserModel *)userModel target:(id)target onSuccess:(SEL)success onFailure:(SEL)failure{
    [self setCallbakToListener:target onSuccess:success onFailure:failure];

    NSDictionary *parameters = @{
                                 @"Email" : userModel.strEmailID.length?userModel.strEmailID:@"",
                                 @"FirstName" : @"",
                                 @"LastName" : @"",
                                 @"Birthdate" : userModel.strBirthdate.length?userModel.strBirthdate:@"",
                                 @"Gender" : @"true",
                                 @"UserName" : userModel.strUserName.length?userModel.strUserName:@"",
                                 @"Residence" : userModel.strRecidence.length?userModel.strRecidence:@""
                                 };

    //[channel requestWithTag:USER_WEB_SERVICE_TAG_USER_UPDATE postData:parameters toPath:WS_API_FORGOT_PASSWORD target:self onSuccess:@selector(request:didFinishWithResponse:) onFailure:@selector(request:didFailWithError:)];

    NSData *imageData = UIImageJPEGRepresentation(userModel.imgProfile, 1);
    
    [channel requestWithTag:USER_WEB_SERVICE_TAG_USER_UPDATE postData:parameters toPath:WS_API_UPDATE_PROFILE file:imageData target:self onSuccess:@selector(request:didFinishWithResponse:) onFailure:@selector(request:didFailWithError:)];
    
}
#pragma mark - Web service delegates
- (void)request:(id)asynchroniousRequest didSignInFinishWithResponse:(NSData *)responseData{
    NSError *error = nil;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"json %@ %@",json,error);
    if(!error)
    {
        NSString *strError = [json valueForKey:@"error"];
        
        if(strError.length){
            NSMutableDictionary *dicionary = [[NSMutableDictionary alloc]init];
            [dicionary setValue:strError forKey:NSLocalizedDescriptionKey];
           NSError *errorInLogin = [NSError errorWithDomain:WS_DOMAIN_JSON_ERROR code:WS_RANDOM_CUSTOM_ERROR_CODE_BAD_RESPONSE userInfo:dicionary];
            //[errorInLogin setValue:strError forKey:NSLocalizedDescriptionKey];
            
            [self failureCallback:errorInLogin];

        }
        else{
            ResponseParser *parser = [[ResponseParser alloc] init];
            id parsedData = [parser userWebClientSignInParser:json];
        
            ((void (*) (id, SEL, id)) [listener methodForSelector:callbackForSuccess])(listener, callbackForSuccess, parsedData);
        }
    }
}
- (void)request:(id)asynchroniousRequest didFinishWithResponse:(NSData *)responseData
{
    NSError *error = nil;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"json %@ %@",json,error);
    if(!error)
    {
        if([json[@"Status"] integerValue] == 1){
        
            ResponseParser *parser = [[ResponseParser alloc] init];
            id parsedData = nil;
            
            switch ([asynchroniousRequest tag])
            {
                case USER_WEB_SERVICE_TAG_SIGN_IN:
                case USER_WEB_SERVICE_TAG_SIGN_UP:
                {
                    parsedData = [parser userWebClientSignInParser:json];
                }
                    break;

                case USER_WEB_SERVICE_TAG_FORGOT_PASSWORD:{
                    parsedData = [parser successForgotPassword:json];
                    break;
                }
                case USER_WEB_SERVICE_TAG_UPDATE_DEVICE_TOKEN:
                {
                    parsedData = [parser sucessResponseParser:json];
                }
                    break;
                    
                case USER_WEB_SERVICE_TAG_USER_UPDATE:
                {
                    parsedData = [parser userWebClientUpdateUserProfileParser:json];
                }
                    break;
            
            }
            ((void (*) (id, SEL, id)) [listener methodForSelector:callbackForSuccess])(listener, callbackForSuccess, parsedData);

        }
        else{
            error = [NSError errorWithDomain:WS_DOMAIN_JSON_ERROR code:WS_RANDOM_CUSTOM_ERROR_CODE_BAD_RESPONSE userInfo:nil];
            [self failureCallback:error];
        }
    }
    else
    {
        
#if DEBUG
        
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Error : %@", string);
        
#endif

        error = [NSError errorWithDomain:WS_DOMAIN_JSON_ERROR code:WS_RANDOM_CUSTOM_ERROR_CODE_BAD_RESPONSE userInfo:nil];
        [self failureCallback:error];
    }
}

- (void)request:(id)asynchroniousRequest didFailWithError:(NSError *)error
{
    NSLog(@"Error : %@ \n Tag %d", error, (int)[asynchroniousRequest tag]);
    [self failureCallback:error];
}

@end

//
//  UserService.m
//  WCI-Web
//
//  Created by Rahul N. Mane on 11/04/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import "UserService.h"
#import "Parser.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import "WebConstants.h"


#define kTimeout 15









@implementation UserService

+ (UserService *)sharedInstance{
    // 1
    static UserService *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserService alloc] init];
    });
    return _sharedInstance;

}

-(void)registerWithUserName:(NSString *)userName andPassword:(NSString *)password{
    NSURL *url=[NSURL URLWithString:registerURL];
    self.requestform = [ASIFormDataRequest requestWithURL:url];
    self.requestform.tag=0;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    [self.requestform setPostValue:userName forKey:@"Email"];
    [self.requestform setPostValue:password forKey:@"Password"];
    [self.requestform setPostValue:password forKey:@"ConfirmPassword"];

    
    [self.requestform setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.requestform setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.requestform setShouldContinueWhenAppEntersBackground:YES];
    [self.requestform setDelegate:self];
    [self.requestform setTimeOutSeconds:30];
    [self.requestform startAsynchronous];
}

-(void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password token:(NSString *)deviceToken{
    
    NSURL *url=[NSURL URLWithString:loginURL];
    self.requestform = [ASIFormDataRequest requestWithURL:url];
    self.requestform.tag=1;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    [self.requestform setPostValue:userName forKey:@"Username"];
    [self.requestform setPostValue:password forKey:@"Password"];
    [self.requestform setPostValue:@"password" forKey:@"grant_type"];
    [self.requestform setPostValue:deviceToken forKey:@"DeviceToken"];
    [self.requestform setPostValue:@"iOS" forKey:@"DeviceType"];
    [self.requestform setPostValue:@"18.15" forKey:@"Latitude"];
    [self.requestform setPostValue:@"73.98" forKey:@"Longitude"];

    [self.requestform setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.requestform setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.requestform setShouldContinueWhenAppEntersBackground:YES];
    [self.requestform setDelegate:self];
    [self.requestform setTimeOutSeconds:30];
    [self.requestform startAsynchronous];

}

-(void)forgotPasswordWithEmailID:(NSString *)email{
    NSURL *url=[NSURL URLWithString:forgotPasswordURL];
    self.requestform = [ASIFormDataRequest requestWithURL:url];
    self.requestform.tag=2;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    [self.requestform setPostValue:email forKey:@"Email"];
    
    [self.requestform setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.requestform setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.requestform setShouldContinueWhenAppEntersBackground:YES];
    [self.requestform setDelegate:self];
    [self.requestform setTimeOutSeconds:30];
    [self.requestform startAsynchronous];
}

-(void)makeProfileWithUserModel:(UserModel *)userModel{
    
    NSURL *url=[NSURL URLWithString:makeProfileURL];
    NSData *imageData1=UIImageJPEGRepresentation(userModel.imgProfile, 1.0);
    

    self.requestform = [ASIFormDataRequest requestWithURL:url];
    self.requestform.tag=3;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    
    
    [self.requestform setPostValue:userModel.strEmailID forKey:@"Email"];
    [self.requestform setPostValue:@"" forKey:@"FirstName"];
    [self.requestform setPostValue:@"" forKey:@"LastName"];
    [self.requestform setPostValue:userModel.strBirthdate forKey:@"Birthdate"];
    [self.requestform setPostValue:userModel.strGender forKey:@"Gender"];
    [self.requestform setPostValue:@"" forKey:@"Residence"];
    //[self.requestform setPostValue:userModel.strUserName forKey:@"UserName"];
    [self.requestform setPostValue:userModel.strUserName forKey:@"ClientUserName"];

    [self.requestform  setData:imageData1 withFileName:@"file.jpg" andContentType:@"application/octet-stream" forKey:@"UploadedImage"];
    
    
    [self.requestform setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.requestform setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.requestform setShouldContinueWhenAppEntersBackground:YES];
    [self.requestform setDelegate:self];
    [self.requestform setTimeOutSeconds:300];
    [self.requestform startAsynchronous];
}






-(void)cancelWebService{
    [self.requestform cancel];
}

#pragma mark - Reponse delegate

-(void)requestFinishedWithError:(ASIHTTPRequest *)theRequest
{
    NSError *error = [theRequest error];
    if(error.code == 1){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"There is no active internet connection. Please check your connection and try again." forKey:NSLocalizedDescriptionKey];
        NSError *errorNoNetwork = [NSError errorWithDomain:@"Error" code:122 userInfo:details];
        error = errorNoNetwork;
        
    }
    [self.delegate request:self didFailWithError:error];
}

-(void)requestFinishedSuccessfully:(ASIHTTPRequest *)theRequest
{
    NSData *reponseData = [theRequest responseData];
    if (theRequest.tag==0){
        // Image upload status
        NSError *error;

        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseRegisterData:reponseData andError:&error];
        
        if(error){
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
        
    }
    else if (theRequest.tag==1){
        // Image upload status
        NSError *error;
        
        
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseLoginData:reponseData andError:&error];
        if(error){
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }

    }
    else if (theRequest.tag==2){
        NSError *error;
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseForgotPasswordData:reponseData andError:&error];
        if(error){
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
        
    }
    else if (theRequest.tag==3){
        NSError *error;
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseMakeProfile:reponseData andError:&error];
        if(error){
            
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
    }
}



@end

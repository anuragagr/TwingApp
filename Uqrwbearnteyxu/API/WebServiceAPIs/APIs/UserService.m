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

-(void)registerWithUserName:(NSString *)userName andDateOfBirth:(NSString *)dateOfBirth andGender:(NSString *)gender andEmail:(NSString *)email andPassword:(NSString *)password andConfirmPassowrd:(NSString *)confirmPassowrd andUploadImage:(UIImage *)uploadImage andFirstName:(NSString *)firstName andLastName:(NSString *)lastName andResidence:(NSString *)residence andClientUserName:(NSString *)clientUserName andStatus:(NSString *)status{
    NSURL *url=[NSURL URLWithString:registerURL];
    NSData *imageData1=UIImageJPEGRepresentation(uploadImage, 1.0);
    self.requestform = [ASIFormDataRequest requestWithURL:url];
    self.requestform.tag=0;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
   
    [self.requestform setPostValue:email forKey:@"Email"];
    [self.requestform setPostValue:password forKey:@"Password"];
    [self.requestform setPostValue:confirmPassowrd forKey:@"ConfirmPassword"];
    [self.requestform setPostValue:firstName forKey:@"FirstName"];
    [self.requestform setPostValue:lastName forKey:@"LastName"];
    [self.requestform setPostValue:dateOfBirth forKey:@"Birthdate"];
    [self.requestform setPostValue:gender forKey:@"Gender"];
    [self.requestform setPostValue:residence forKey:@"Residence"];
    [self.requestform setPostValue:userName forKey:@"UserName"];
    [self.requestform setPostValue:clientUserName forKey:@"ClientUserName"];
    [self.requestform setPostValue:status forKey:@"UserStatus"];
    
    [self.requestform  setData:imageData1 withFileName:@"file.jpg" andContentType:@"application/octet-stream" forKey:@"UploadedImage"];

    
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


-(void)SportListdata {
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",sportListURL]];
    
    self.request = [ASIHTTPRequest requestWithURL:url];
    
    self.request.tag=5;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
   // [self.request setRequestMethod:@"POST"];
    [self.request setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.request setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.request setShouldContinueWhenAppEntersBackground:YES];
    [self.request setDelegate:self];
    [self.request setTimeOutSeconds:30];
    [self.request startAsynchronous];
}

-(void)CheckEmailId:(NSString *)email
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@Email=%@",checkEmailURL,email]];
    
    self.request = [ASIHTTPRequest requestWithURL:url];
    
    self.request.tag=4;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    [self.request setRequestMethod:@"POST"];
    [self.request setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.request setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.request setShouldContinueWhenAppEntersBackground:YES];
    [self.request setDelegate:self];
    [self.request setTimeOutSeconds:30];
    [self.request startAsynchronous];
}

-(void)checkUserName:(NSString *)username;
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@ClientUserName=%@",checkUserNameUrl,username]];
    
    self.request = [ASIHTTPRequest requestWithURL:url];
    
    self.request.tag=6;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    [self.request setRequestMethod:@"POST"];
    [self.request setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.request setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.request setShouldContinueWhenAppEntersBackground:YES];
    [self.request setDelegate:self];
    [self.request setTimeOutSeconds:30];
    [self.request startAsynchronous];
}
-(void)sportListSendData:(NSString *)userId andSportId:(NSString *)sportId andCreatedDate:(NSString *)createdDate andUpdatedDate:(NSString *)updatedDate;
{
    NSURL *url=[NSURL URLWithString:sportListSendURL];
    self.requestform = [ASIFormDataRequest requestWithURL:url];
    self.requestform.tag=7;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    [self.requestform setPostValue:userId forKey:@"UserID"];
    [self.requestform setPostValue:sportId forKey:@"SportId"];
    [self.requestform setPostValue:createdDate forKey:@"CreatedDate"];
    [self.requestform setPostValue:updatedDate forKey:@"UpdatedDate"];
    
    [self.requestform setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.requestform setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.requestform setShouldContinueWhenAppEntersBackground:YES];
    [self.requestform setDelegate:self];
    [self.requestform setTimeOutSeconds:30];
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
    else if (theRequest.tag==4){
        NSError *error;
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseCheckEmail:reponseData andError:&error];
        if(error){
            
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
    }
    else if (theRequest.tag==5){
        NSError *error;
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseSportListData:reponseData andError:&error];
        if(error){
            
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
    }
    else if (theRequest.tag==6){
        NSError *error;
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseCheckUserName:reponseData andError:&error];
        if(error){
            
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
    }
    else if (theRequest.tag==7){
        NSError *error;
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseCheckUserName:reponseData andError:&error];
        if(error){
            
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
    }
}



@end

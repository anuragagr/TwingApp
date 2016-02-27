//
//  RadarServices.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 23/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "RadarServices.h"
#import "WebConstants.h"
#import "Parser.h"


@implementation RadarServices

+ (RadarServices *)sharedInstance{
    // 1
    static RadarServices *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[RadarServices alloc] init];
    });
    return _sharedInstance;
    
}

-(void)getFriendsNearby:(NSString *)userID andLat:(NSString *)lattitude andLong:(NSString *)longitude withLimit:(NSString *)limit{
    
    NSURL *url=[NSURL URLWithString:radarURL];
    self.requestform = [ASIFormDataRequest requestWithURL:url];
    self.requestform.tag=1;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    [self.requestform setPostValue:userID forKey:@"UserId"];
    [self.requestform setPostValue:lattitude forKey:@"lat"];
        [self.requestform setPostValue:longitude forKey:@"log"];
        [self.requestform setPostValue:limit forKey:@"limit"];
    
    [self.requestform setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.requestform setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.requestform setShouldContinueWhenAppEntersBackground:YES];
    [self.requestform setDelegate:self];
    [self.requestform setTimeOutSeconds:30];
    [self.requestform startAsynchronous];
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
    if (theRequest.tag==1){
        // Image upload status
        NSError *error;
        
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseRadarListData:reponseData andError:&error];
        
        if(error){
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
        
    }
}

@end

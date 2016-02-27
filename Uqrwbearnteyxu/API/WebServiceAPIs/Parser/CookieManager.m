//
//  CookieManager.m
//  WCI
//
//  Created by Rahul N. Mane on 19/04/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import "CookieManager.h"

@implementation CookieManager


#pragma mark - Cookiees

-(void)setUserId:(NSString *)strUserId{
    [[NSUserDefaults standardUserDefaults] setValue:strUserId forKey:@"UserId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)getUserId{
    NSString *value=[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"];
    
    return value;
}

-(void)setDeviceToken:(NSString *)strToken{
    [[NSUserDefaults standardUserDefaults] setValue:strToken forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)getDeviceToken{
    NSString *value=[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"];
    
    return value;
}

-(void)setPendingRequestCount:(NSString *)strRequestCount{
    [[NSUserDefaults standardUserDefaults] setValue:strRequestCount forKey:@"PendingRequestCount"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)getPendingRequestCount{
    NSString *value=[[NSUserDefaults standardUserDefaults] valueForKey:@"PendingRequestCount"];
    
    return value;
}


-(void)setShuffleisON:(BOOL )isShuffle{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",isShuffle] forKey:@"isShuffle"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(BOOL)getShuffleisON{
    NSString *value=[[NSUserDefaults standardUserDefaults] valueForKey:@"isShuffle"];
    BOOL isShuffle=NO;
    isShuffle=[value intValue];
    return isShuffle;
}

-(void)setRepeatisON:(BOOL )isRepeat{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",isRepeat] forKey:@"isRepeat"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(BOOL)getRepeatisON{
    NSString *value=[[NSUserDefaults standardUserDefaults] valueForKey:@"isRepeat"];
    BOOL isShuffle=NO;
    isShuffle=[value intValue];
    return isShuffle;
}
-(void)setUserLocation:(NSMutableDictionary *)addressData{
    [[NSUserDefaults standardUserDefaults] setObject:addressData forKey:@"userLocation"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
-(NSMutableDictionary *)getUserLocation{
    NSMutableDictionary *retrievedDictionary = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userLocation"]mutableCopy];
    return retrievedDictionary;
}



-(void)setCookees:(NSString *)strSessionID{
    [[NSUserDefaults standardUserDefaults] setValue:strSessionID forKey:@"sessionID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSHTTPCookie *)getCookie{
    
    NSString *value=[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionID"];
    NSDictionary *properties = [[NSMutableDictionary alloc] init] ;
    [properties setValue:@"PHPSESSID" forKey:NSHTTPCookieName];
    [properties setValue:value forKey:NSHTTPCookieValue];
    [properties setValue:@" " forKey:NSHTTPCookieDomain];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    
    return cookie;
}
-(void)clearCookie{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end

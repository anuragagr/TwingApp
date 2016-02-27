//
//  RadarServices.h
//  Uqrwbearnteyxu
//
//  Created by Developer on 23/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"
#import "ASIFormDataRequest.h"

@interface RadarServices : NSObject
@property(nonatomic,readwrite)int tag;
@property(nonatomic,strong)id<WebServiceDelegate> delegate;
@property (strong, nonatomic) ASIFormDataRequest *requestform;


//shared instance
+ (RadarServices *)sharedInstance;

-(void)getFriendsNearby:(NSString *)userID andLat:(NSString *)lattitude andLong:(NSString *)longitude withLimit:(NSString *)limit;

@end

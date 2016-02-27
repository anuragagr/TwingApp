//
//  FriendsService.h
//  UploadImageDemo
//
//  Created by Developer on 10/01/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"
#import "ASIFormDataRequest.h"

@interface FriendsService : NSObject
@property(nonatomic,readwrite)int tag;
@property(nonatomic,strong)id<WebServiceDelegate> delegate;
@property (strong, nonatomic) ASIFormDataRequest *requestform;
@property (strong, nonatomic) ASIHTTPRequest *request;


//shared instance
+ (FriendsService *)sharedInstance;

-(void)getFriendListOnUserId:(NSString *)userID andPageNo:(int)pageNo andSearchText:(NSString *)searchtext;
-(void)getAllUserList:(NSString *)userID andPageNo:(int)pageNo forSearchedText:(NSString *)text;


-(void)sendFriendRequestFromUserId:(NSString *)userID andTo:(NSString *)frUserID;
-(void)acceptFriendRequestFromUserId:(NSString *)userID andTo:(NSString *)frUserID;
-(void)rejectFriendRequestFromUserId:(NSString *)userID andTo:(NSString *)frUserID;
-(void)deleteFriendRequestFromUserId:(NSString *)userID andTo:(NSString *)frUserID;

@end

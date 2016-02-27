//
//  Parser.h
//  WCI-Web
//
//  Created by Rahul N. Mane on 10/04/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

-(NSMutableArray *)parseRegisterData:(NSData *)responseData andError:(NSError **)error;
-(NSMutableArray *)parseLoginData:(NSData *)responseData andError:(NSError **)error;
-(NSMutableArray *)parseForgotPasswordData:(NSData *)responseData andError:(NSError **)error;
-(NSMutableArray *)parseMakeProfile:(NSData *)responseData andError:(NSError **)error;


-(NSMutableArray *)parseFriendListData:(NSData *)responseData andError:(NSError **)error;
-(NSMutableArray *)parseSearchFriendListData:(NSData *)responseData andError:(NSError **)error;
-(NSMutableArray *)parseSendFriendRequestData:(NSData *)responseData andError:(NSError **)error;


-(NSMutableArray *)parseRadarListData:(NSData *)responseData andError:(NSError **)error;

@end

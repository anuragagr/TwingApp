//
//  WebServiceChannel.h
//  I Like My Waitress
//
//  Created by Rahul Mane on 23/03/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AsynchroniousRequest;

@interface WebServiceChannel : NSObject
{
    id target;
    SEL onSuccess;
    SEL onFailure;
}

@property (readwrite, nonatomic) NSInteger tag;

@property (strong, nonatomic) AsynchroniousRequest *request;

- (void)requestWithTag:(NSInteger)tag postData:(NSDictionary *)params toPath:(NSString *)path target:(id)target onSuccess:(SEL)requestSuccessful onFailure:(SEL)requestFailure;

- (void)requestWithTag:(NSInteger)tag postData:(NSDictionary *)params toPath:(NSString *)path  file:(NSData *)fileData target:(id)target onSuccess:(SEL)requestSuccessful onFailure:(SEL)requestFailure;

- (void)requestWithTag:(NSInteger)tag toPath:(NSString *)path params:(NSString *)params target:(id)requestTarget onSuccess:(SEL)requestSuccessful onFailure:(SEL)requestFailure;

@end

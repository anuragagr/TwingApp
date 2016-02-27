//
//  WebServiceChannel.m
//  I Like My Waitress
//
//  Created by Rahul Mane on 23/03/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import "WebServiceChannel.h"
#import "AsynchroniousRequest.h"
#import "WebServiceConstants.h"

//static NSString *SERVICE_BASE_URL = @"http://uxwebapi.twigsoftwares.com/";
static NSString *SERVICE_BASE_URL = @"http://5.189.161.31/";


@implementation WebServiceChannel

- (AsynchroniousRequest *)getServiceWithTag:(NSInteger)tag
{
    AsynchroniousRequest *service = [[AsynchroniousRequest alloc] init];
    return service;
}

- (void)requestWithTag:(NSInteger)tag postData:(NSDictionary *)params toPath:(NSString *)path target:(id)requestTarget onSuccess:(SEL)requestSuccessful onFailure:(SEL)requestFailure
{
    target = requestTarget;
    onSuccess = requestSuccessful;
    onFailure = requestFailure;
    self.tag = tag;
    
    self.request = [self getServiceWithTag:tag];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVICE_BASE_URL, path];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.request requestURL:url withPOSTParameters:params successBlock:^(NSData *data) {
        [self requestSuccessCallback:data];
    } failureBlock:^(NSError *error) {
        [self requestFailureCallback:error];
    }];
}

- (void)requestWithTag:(NSInteger)tag toPath:(NSString *)path params:(NSString *)params target:(id)requestTarget onSuccess:(SEL)requestSuccessful onFailure:(SEL)requestFailure
{
    target = requestTarget;
    onSuccess = requestSuccessful;
    onFailure = requestFailure;
    self.tag = tag;

    self.request = [self getServiceWithTag:tag];
        
    params = [params stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    params = [params stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@", SERVICE_BASE_URL, path, params];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (url)
    {
        [self.request requestURL:url successBlock:^(NSData *data) {
            [self requestSuccessCallback:data];
        } failureBlock:^(NSError *error) {
            [self requestFailureCallback:error];
        }];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:@"Local" code:1563 userInfo:@{NSLocalizedDescriptionKey : @"Something went wrong, please try again, still problem persists then re-open the app."}];
        
        [self requestFailureCallback:error];
    }
}

- (void)requestFailureCallback:(NSError *)error
{
    ((void (*) (id, SEL, id, id)) [target methodForSelector:onFailure])(target, onFailure, self, error);
}

-(void)requestSuccessCallback:(NSData *)responseData
{
    ((void (*) (id, SEL, id, id)) [target methodForSelector:onSuccess])(target, onSuccess, self, responseData);
}

- (void)requestWithTag:(NSInteger)tag postData:(NSDictionary *)params toPath:(NSString *)path file:(NSData *)fileData target:(id)requestTarget onSuccess:(SEL)requestSuccessful onFailure:(SEL)requestFailure
{
    target = requestTarget;
    onSuccess = requestSuccessful;
    onFailure = requestFailure;
    self.tag = tag;
    
    self.request = [self getServiceWithTag:tag];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVICE_BASE_URL, path];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.request requestURL:url withPOSTParameters:params file:fileData successBlock:^(NSData *data) {
        [self requestSuccessCallback:data];
    } failureBlock:^(NSError *error) {
        [self requestFailureCallback:error];
    }];
}

@end

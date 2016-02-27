//
//  AsynchroniousRequest.m
//  I_Like_My_Waitress
//
//  Created by Rahul V. Mane on 8/25/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "AsynchroniousRequest.h"
#import "JSON.h"
#import <UIKit/UIKit.h>

static const NSTimeInterval kTimeout = 60;

@implementation AsynchroniousRequest

- (void)requestURL:(NSURL *)url withPOSTParameters:(NSDictionary *)params successBlock: (SuccessBlock)successBlock failureBlock: (FailureBlock) failureBlock
{
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONReadingAllowFragments error:nil];
    
        NSString *strPost=@"";
    
    for (int k=0; k<params.allKeys.count; k++) {
        NSString *key=[params.allKeys objectAtIndex:k];
        NSString *value = [params valueForKey:key];
        
        strPost = [strPost stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
        if(k==(params.allKeys.count-1)){

        }
        else{
                        strPost = [strPost stringByAppendingString:@"&"];
        }
    }

    self.request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.request setTimeoutInterval:kTimeout];
    [self.request setHTTPMethod:@"POST"];
  //  [self.request setHTTPBody:paramsData];
   // NSString *str = @"email=rahul@gmai.com&Password=Tushar%23123&ConfirmPassword=Rahul#123";
    [self.request setHTTPBody:[strPost dataUsingEncoding:NSUTF8StringEncoding]];


    [self.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSLog(@"*** Request URL : %@", [url absoluteString]);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [NSURLConnection sendAsynchronousRequest:self.request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

         if (data && successBlock)
         {
             successBlock(data);
         }
         else if(failureBlock)
         {
             failureBlock(connectionError);
         }
         else
         {
             NSLog(@"Error occurred %@",connectionError);
         }
     }];
}

/*
- (void)requestURL:(NSURL *)url withPOSTParameters:(NSDictionary *)params file:(NSData *)imageData successBlock: (SuccessBlock)successBlock failureBlock: (FailureBlock) failureBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:kTimeout];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *strPost;
    for (int k=0; k<params.allKeys.count; k++) {
        NSString *key=[params.allKeys objectAtIndex:k];
        NSString *value = [params valueForKey:key];
        
        strPost = [strPost stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
        if(k==(params.allKeys.count-1)){
            
        }
        else{
            strPost = [strPost stringByAppendingString:@"&"];
        }
    }
    
    for (NSString*key in [params allKeys])
    {
        NSDictionary *value = [params objectForKey:key];
        
        SBJsonWriter *writer = [SBJsonWriter new];
        NSString *inputJsonString = [writer stringWithObject:value];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"data"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", inputJsonString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"UploadedImage"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSLog(@"*** Request URL : %@", [url absoluteString]);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (data && successBlock)
        {
            successBlock(data);
        }
        else if(failureBlock)
        {
            failureBlock(error);
        }
        else
        {
            NSLog(@"Error occurred %@",error);
        }
    }];
}
*/
- (void)requestURL:(NSURL *)url successBlock: (SuccessBlock)successBlock failureBlock: (FailureBlock) failureBlock
{
    self.request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.request setTimeoutInterval:kTimeout];
    [self.request setHTTPMethod:@"POST"];
    [self.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"*** Request URL : %@", [url absoluteString]);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         if (data && successBlock)
         {
             successBlock(data);
         }
         else if(failureBlock)
         {
             failureBlock(connectionError);
         }
         else
         {
             NSLog(@"Error occurred %@",connectionError);
         }
     }];
}

- (void)requestURL:(NSURL *)url withPOSTParameters:(NSDictionary *)params file:(NSData *)imageData successBlock: (SuccessBlock)successBlock failureBlock: (FailureBlock) failureBlock{
        
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONReadingAllowFragments error:nil];
    
    NSString *strPost=@"";
    
    for (int k=0; k<params.allKeys.count; k++) {
        NSString *key=[params.allKeys objectAtIndex:k];
        NSString *value = [params valueForKey:key];
        
        strPost = [strPost stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
        if(k==(params.allKeys.count-1)){
            
        }
        else{
            strPost = [strPost stringByAppendingString:@"&"];
        }
    }
    
    self.request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.request setTimeoutInterval:kTimeout];
    [self.request setHTTPMethod:@"POST"];
    //  [self.request setHTTPBody:paramsData];
    // NSString *str = @"email=rahul@gmai.com&Password=Tushar%23123&ConfirmPassword=Rahul#123";
    NSString *boundary = @"unique-consistent-string";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [self.request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    NSMutableData *body = [NSMutableData data];
    body = [[strPost dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    if (!imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"UploadedImage"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [self.request setHTTPBody:[strPost dataUsingEncoding:NSUTF8StringEncoding]];
    
    
   // [self.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"*** Request URL : %@", [url absoluteString]);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         if (data && successBlock)
         {
             successBlock(data);
         }
         else if(failureBlock)
         {
             failureBlock(connectionError);
         }
         else
         {
             NSLog(@"Error occurred %@",connectionError);
         }
     }];

}


@end

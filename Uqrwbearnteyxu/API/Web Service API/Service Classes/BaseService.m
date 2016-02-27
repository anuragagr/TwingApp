//
//  BaseSevice.m
//  I Like My Waitress
//
//  Created by Rahul Mane on 23/03/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import "BaseService.h"
#import "Strings.h"
#import "Response.h"
#import "WebServiceConstants.h"

@interface BaseService()

@end

@implementation BaseService

-(void)failureCallback:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *message = error.localizedDescription;
        NSLog(@"Error : %@",message);
                
        if(callbackForFailure == nil)
        {
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"OnLookerProject" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorMessage show];
        }
        else
        {
            Response *result = [[Response alloc] init];
            result.errorCode = error.code;
            result.message = error.localizedDescription;
            
            [listener performSelectorOnMainThread:callbackForFailure withObject:result waitUntilDone:NO];
        }
    });
}

- (void)setCallbakToListener:(id)target onSuccess:(SEL)onSuccess onFailure:(SEL)onFailure
{
    listener = target;
    callbackForSuccess = onSuccess;
    callbackForFailure = onFailure;
}

@end

//
//  BaseSevice.h
//  I Like My Waitress
//
//  Created by Rahul Mane on 23/03/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WebServiceChannel;

@interface BaseService : NSObject
{
    id listener;
    SEL callbackForFailure;
    SEL callbackForSuccess;
    
    WebServiceChannel *channel;
}

- (void)failureCallback:(NSError *)error;
- (void)setCallbakToListener:(id)target onSuccess:(SEL)onSuccess onFailure:(SEL)onFailure;

@end

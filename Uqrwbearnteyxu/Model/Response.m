//
//  Result.m
//  I Like My Waitress
//
//  Created by Rahul Mane on 30/03/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import "Response.h"

@implementation Response

- (BOOL)isServerSideError
{
    if (self.errorCode == 2546 || self.errorCode == 1563 || self.errorCode == 8569 || self.errorCode == 7654) {
        return YES;
    }
    return NO;
}

@end

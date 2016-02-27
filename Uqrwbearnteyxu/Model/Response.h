//
//  Result.h
//  I Like My Waitress
//
//  Created by Rahul Mane on 30/03/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (strong, nonatomic) NSString *message;
@property (readwrite, nonatomic) NSInteger errorCode;
@property (strong, nonatomic) id responseObject;

- (BOOL)isServerSideError;

@end

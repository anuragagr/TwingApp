//
//  AsynchroniousRequest.h
//  I_Like_My_Waitress
//
//  Created by Rahul V. Mane on 8/25/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsynchroniousRequest : NSObject

typedef void (^ SuccessBlock)(NSData *);
typedef void (^ FailureBlock)(NSError *);

@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSMutableURLRequest *multipartRequest;

- (void)requestURL:(NSURL *)url withPOSTParameters:(NSDictionary *)params successBlock: (SuccessBlock)successBlock failureBlock: (FailureBlock) failureBlock;

- (void)requestURL:(NSURL *)url withPOSTParameters:(NSDictionary *)params file:(NSData *)file successBlock: (SuccessBlock)successBlock failureBlock: (FailureBlock) failureBlock;

- (void)requestURL:(NSURL *)url successBlock: (SuccessBlock)successBlock failureBlock: (FailureBlock) failureBlock;

@end


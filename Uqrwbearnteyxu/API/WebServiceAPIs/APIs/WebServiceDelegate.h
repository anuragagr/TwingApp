//
//  WebServiceDelegate.h
//  WCI-Web
//
//  Created by Rahul N. Mane on 10/04/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate <NSObject>

- (void)request:(id)serviceRequest didFailWithError:(NSError *)error;
- (void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData;


@end

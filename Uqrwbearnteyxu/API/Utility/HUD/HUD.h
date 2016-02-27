//
//  HUD.h
//  WCI
//
//  Created by Rahul N. Mane on 22/04/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUD : NSObject<MBProgressHUDDelegate>

+ (HUD *)sharedInstance;

-(void)showHUD:(UIView *)parentView;

-(void)hideHUD:(UIView *)view;


@end

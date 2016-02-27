//
//  HUD.m
//  WCI
//
//  Created by Rahul N. Mane on 22/04/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import "HUD.h"

@implementation HUD
{
    MBProgressHUD *hudToShow;
    UIView *hudParentView;
}


+ (HUD *)sharedInstance
{
    // 1
    static HUD *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[HUD alloc] init];
    });
    return _sharedInstance;
}


-(void)showHUD:(UIView *)parentView{
    //if(hudParentView){
       // NSLog(@"One");
        [self hideHUD:parentView];
    //}
    hudParentView=parentView;
    hudToShow = [[MBProgressHUD alloc] initWithView:hudParentView];
	// Set determinate bar mode
	hudToShow.mode = 	MBProgressHUDModeIndeterminate;
	//hudToShow.delegate = self;
    hudToShow.animationType=MBProgressHUDAnimationZoomOut;
    [hudParentView addSubview:hudToShow];
    [hudToShow show:YES];
}

-(void)hideHUD:(UIView *)view{

    //NSLog(@"Two ");
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    //hudParentView=nil;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hudToShow removeFromSuperview];
 	hudToShow = nil;
}


@end

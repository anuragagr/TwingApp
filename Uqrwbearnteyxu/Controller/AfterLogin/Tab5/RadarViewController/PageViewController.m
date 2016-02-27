//
//  PageViewController.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 24/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "PageViewController.h"

@implementation PageViewController

-(void)viewDidLayoutSubviews {
    UIView* v = self.view;
    NSArray* subviews = v.subviews;
    // Confirm that the view has the exact expected structure.
    // If you add any custom subviews, you will want to remove this check.
    if( [subviews count] == 2 ) {
        UIScrollView* sv = nil;
        UIPageControl* pc = nil;
        for( UIView* t in subviews ) {
            if( [t isKindOfClass:[UIScrollView class]] ) {
                sv = (UIScrollView*)t;
            } else if( [t isKindOfClass:[UIPageControl class]] ) {
                pc = (UIPageControl*)t;
            }
        }
        if( sv != nil && pc != nil ) {
            // expand scroll view to fit entire view
           // sv.frame = v.bounds;
            // put page control in front
           // [v bringSubviewToFront:pc];
            
            pc.frame = CGRectMake(pc.frame.origin.x, 0, pc.frame.size.width, pc.frame.size.height);
            sv.frame= CGRectMake(sv.frame.origin.x, pc.frame.size.height, sv.frame.size.width, sv.frame.size.height);
            
        }
    }
    [super viewDidLayoutSubviews];
}

@end

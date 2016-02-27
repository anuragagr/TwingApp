//
//  VIewUtility.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "VIewUtility.h"

@implementation VIewUtility


+(void)addHexagoneShapeMaskFor:(UIView *)viewObj{
    CGRect rect = viewObj.frame;
    
    CAShapeLayer *hexagonMask = [CAShapeLayer layer];
   // hexagonMask.lineWidth = 5;
    hexagonMask.strokeColor = [UIColor redColor].CGColor;
    
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];


    CGFloat sideWidth = 2 * ( 0.5 * rect.size.width / 2 );
    CGFloat lcolumn = ( rect.size.width - sideWidth ) / 2;
    CGFloat rcolumn = rect.size.width - lcolumn;
    CGFloat height = 0.866025 * rect.size.height;
    CGFloat y = (rect.size.height - height) / 2;
    CGFloat by = rect.size.height - y;
    CGFloat midy = rect.size.height / 2;
    CGFloat rightmost = rect.size.width;
    [hexagonPath moveToPoint:CGPointMake(lcolumn, y)];
    [hexagonPath addLineToPoint:CGPointMake(rcolumn, y)];
    [hexagonPath addLineToPoint:CGPointMake(rightmost, midy)];
    [hexagonPath addLineToPoint:CGPointMake(rcolumn, by)];
    [hexagonPath addLineToPoint:CGPointMake(lcolumn, by)];
    [hexagonPath addLineToPoint:CGPointMake(0, midy)];
    [hexagonPath addLineToPoint:CGPointMake(lcolumn, y)];
    

    
    hexagonMask.path = hexagonPath.CGPath;
    viewObj.layer.mask = hexagonMask;

    
}

@end

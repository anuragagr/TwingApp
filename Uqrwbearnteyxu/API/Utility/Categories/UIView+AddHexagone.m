//
//  UIView+AddHexagone.m
//  CustomDatePicker
//
//  Created by Rahul Mane on 13/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import "UIView+AddHexagone.h"

@implementation UIView (AddHexagone)


-(void)addHexaShape{
    CGRect rect = CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.height-4);
    
    CAShapeLayer *hexagonMask = [CAShapeLayer layer];
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

    hexagonMask.backgroundColor = [UIColor redColor].CGColor;
    
    hexagonPath.lineWidth = 5;
    [[UIColor blackColor]setStroke];
    [hexagonPath stroke];

    hexagonMask.path = hexagonPath.CGPath;
    self.layer.mask = hexagonMask;

}

-(UIBezierPath *)hexagonePath{
    CGRect rect = CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.height-4);

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
    
    return hexagonPath;
}
@end

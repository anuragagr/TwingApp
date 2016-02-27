//
//  RadarView.h
//  CustomDatePicker
//
//  Created by Rahul Mane on 20/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RadarViewDelegate <NSObject>

-(void)radarView:(id)radarView didSelectAnnotation:(int)selectedIndex;

@end

@interface RadarView : UIView

@property(nonatomic,strong)id<RadarViewDelegate> delegate;

@property(nonatomic,strong)    NSMutableArray *arrayOfViews;
@property(nonatomic,strong)  NSMutableArray *arrayOfLineViews;



-(id)initWithFrame:(CGRect)frame;
-(void)selectLineAtIndex:(int)index;

-(void)addRadarAnnotation:(NSMutableArray *)anotationArray;
-(void)selectAnnotationIndex:(int)index;


@end

//
//  AADatePicker.h
//  CustomDatePicker
//
//  Created by Amit Attias on 3/26/14.
//  Copyright (c) 2014 I'm IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AADatePickerDelegate <NSObject>

@optional

-(void)dateChanged:(id)sender;

@end

@interface AADatePicker : UIControl

@property (nonatomic, strong, readwrite) NSDate *minimumDate;
@property (nonatomic, strong, readwrite) NSDate *maximumDate;
@property (nonatomic, strong, readwrite) NSDate *date;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end

//
//  CustomDatePicker.h
//  CustomDatePicker
//
//  Created by Rahul Mane on 12/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerDelegate <NSObject>

-(void)customDatePicker:(id)datePicker withSelectedDate:(NSDate *)date;


@end

@interface CustomDatePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,weak)id<CustomDatePickerDelegate> delegate;
@property (nonatomic,weak)IBOutlet UIPickerView *pickerViewDate;

-(void)reloadPickerViewWithSelectedDate:(NSString *)date;
@end

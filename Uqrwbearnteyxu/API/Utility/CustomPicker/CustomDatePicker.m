//
//  CustomDatePicker.m
//  CustomDatePicker
//
//  Created by Rahul Mane on 12/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import "CustomDatePicker.h"

#define startYearOffset 95

@implementation CustomDatePicker{
    NSMutableArray *arrayOfMonths,*arrayOfYears,*arrayOfDates;
    NSDate *selectedDate;
    int startYear;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setUp];
        
    }
    return self;
}
-(id)init{
    self = [super init];
    if(self){
        [self setUp];
    }
    return self;
}

-(void)awakeFromNib{
    [self setUp];
}
-(void)setUp{
    
    self.pickerViewDate.delegate=self;
    self.pickerViewDate.dataSource = self;
    
    
    [self fillMonthData];
    [self fillYearData];
    [self fillDayData:selectedDate];
    [self.pickerViewDate selectRow:startYear inComponent:2 animated:NO];

    

  


}

-(void)fillDayData:(NSDate *)aDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDate];
    NSUInteger numberOfDaysInMonth = range.length;
    arrayOfDates = [[NSMutableArray alloc]init];
    
    for (int k=0; k<numberOfDaysInMonth; k++) {
        [arrayOfDates addObject:[NSString stringWithFormat:@"%d",k+1]];
    }
    
    [self.pickerViewDate reloadComponent:0];

}


-(void)fillMonthData{
    arrayOfMonths = [[NSMutableArray alloc]init];
    
    [arrayOfMonths addObject:@"1"];
    [arrayOfMonths addObject:@"2"];
    [arrayOfMonths addObject:@"3"];
    [arrayOfMonths addObject:@"4"];
    [arrayOfMonths addObject:@"5"];
    [arrayOfMonths addObject:@"6"];
    [arrayOfMonths addObject:@"7"];
    [arrayOfMonths addObject:@"8"];
    [arrayOfMonths addObject:@"9"];
    [arrayOfMonths addObject:@"10"];
    [arrayOfMonths addObject:@"11"];
    [arrayOfMonths addObject:@"12"];
}

-(void)fillYearData{
    arrayOfYears = [[NSMutableArray alloc]init];
    selectedDate = [self getPreviousYearDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"YYYY";
    NSString *startDateYear = [formatter stringFromDate:selectedDate];
    
    int year = [startDateYear intValue];
    
    for (int k=0; k<startYearOffset; k++) {
        if(year == 1991){
            startYear = k;
        }
        
        [arrayOfYears addObject:[NSString stringWithFormat:@"%d",year]];
        year++;
    }

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return arrayOfDates.count;
    }
    else if (component ==1){
        return arrayOfMonths.count;
    }
    else if(component == 2){
        return arrayOfYears.count;
    }
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        NSString *strDate = [NSString stringWithFormat:@"%ld",row+1];
        return strDate;
    }
    else if (component ==1){
        return arrayOfMonths[row];
    }
    else if(component == 2){
        return arrayOfYears[row];
    }
    return 0;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *strText ;
    if(component == 0){
        NSString *strDate = [NSString stringWithFormat:@"%ld",row+1];
        strText = strDate;
    }
    else if (component ==1){
        strText = arrayOfMonths[row];
    }
    else if(component == 2){
        strText =  arrayOfYears[row];
    }
    
    UILabel *label = (id)view;
    
    if (!label)
    {
        
        label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = strText;
        
    }
    
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    UILabel *labelSelected = (UILabel*)[pickerView viewForRow:row forComponent:component];
//    [labelSelected setTextColor:[UIColor redColor]];
//
//    UILabel *labelSelected2 = (UILabel*)[pickerView viewForRow:[pickerView selectedRowInComponent:0] forComponent:component];
//    [labelSelected2 setTextColor:[UIColor redColor]];

    
    NSLog(@"%ld %ld",(long)row,(long)component);
    int selectedD =(int)[pickerView selectedRowInComponent:0];
    int selectedM =(int)[pickerView selectedRowInComponent:1];
    int selectedY =(int)[pickerView selectedRowInComponent:2];
    
    NSString *selectedDat = arrayOfDates[selectedD];
    NSString *selectedMonth = arrayOfMonths[selectedM];
    NSString *selectedYear = arrayOfYears[selectedY];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *strDateToSend = [NSString stringWithFormat:@"%@/%@/%@",selectedDat,selectedMonth,selectedYear];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(customDatePicker:withSelectedDate:)]){
        [self.delegate customDatePicker:self withSelectedDate:[formatter dateFromString:strDateToSend]];
    }
  
    
    if(component == 1){
        NSString *strDate = [NSString stringWithFormat:@"%@/%@/%@",@"1",selectedMonth,selectedYear];
        
       // NSLog(@"selected date %@",strDate);
       
        NSDate *adate = [formatter dateFromString:strDate];
        [self fillDayData:adate];
        

    }
    else if (component == 2){
        NSString *strDate = [NSString stringWithFormat:@"%@/%@/%@",@"1",selectedMonth,selectedYear];
        
        
        NSDate *adate = [formatter dateFromString:strDate];
        [self fillDayData:adate];
        
       
    }
    
}


-(NSDate *)getPreviousYearDate:(NSDate *)sinceDate{
    NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
    //[offsetComponents1 setDay:-7]; // you can change this as per your requirement, this will decrease -1 date
    //[offsetComponents1 setMonth:-1];
    [offsetComponents1 setYear:-startYearOffset];
    
    NSDate *previousDate = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:sinceDate options:0];
    return previousDate;
}

@end


//
//  RadarFriendDetailViewController.m
//  CustomDatePicker
//
//  Created by Developer on 23/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import "RadarFriendDetailViewController.h"
#import "VIewUtility.h"
#import "PPImageScrollingCellView.h"
#import "WebConstants.h"

@interface RadarFriendDetailViewController()
@property (nonatomic,weak)IBOutlet UIImageView *imgViewProfile;
@property (nonatomic,weak)IBOutlet UILabel *lblProfileName;
@property (nonatomic,weak)IBOutlet UILabel *lblStatus;
@property (nonatomic,weak)IBOutlet UILabel *lblDistance;

@property (nonatomic,weak)IBOutlet PPImageScrollingCellView *sportsView;


@end


@implementation RadarFriendDetailViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUp];
    self.view.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82/255.0 blue:89/255.0 alpha:0.8];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


-(void)setUp{
    [self setUpProfile];
    
    NSMutableArray *arrayOfSportsFriend;
    if(self.friendModel){
        arrayOfSportsFriend = self.friendModel.arrayOfSports;
    }
    
    NSMutableDictionary *category = [[NSMutableDictionary alloc]init];
    NSString *strCat = [NSString stringWithFormat:@"Your sports (%lu)",(unsigned long)arrayOfSportsFriend.count];
    [category setValue:strCat forKey:@"category"];
    
    NSMutableArray *arryOfImages = [[NSMutableArray alloc]init];
    for (int k=0; k<arrayOfSportsFriend.count; k++) {
        NSDictionary *propSports = [arrayOfSportsFriend objectAtIndex:k];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:@"Name" forKey:@"name"];
        NSString *url = [NSString stringWithFormat:@"%@/%@",baseURL,[propSports valueForKey:@"SportIconThumb"]];
        [dict setValue:url forKey:@"URL"];
        [arryOfImages addObject:dict];
    }
    [category setValue:arryOfImages forKey:@"images"];
    
    NSArray *array = @[category];
    /* NSArray *array = @[
     @{ @"category": @"Your sports (25)",
     @"images":
     @[
     @{ @"name":@"icon29.png", @"URL":@"http://www.imge.com/wp-content/uploads/2011/07/jordanIMGE-340x300.jpg"},
     @{ @"name":@"icon29.png", @"title":@"A-1"},
     @{ @"name":@"", @"title":@"A-2"},
     @{ @"name":@"", @"title":@"A-3"},
     @{ @"name":@"", @"title":@"A-4"},
     @{ @"name":@"", @"title":@"A-5"}
     
     ]
     }
     ];
     
     */
    
    [self setImageData:[array objectAtIndex:0]];
    
}

-(void)setUpProfile{
    [VIewUtility addHexagoneShapeMaskFor:self.imgViewProfile];
    //self.imgViewProfile.image = [UIImage imageNamed:@"icon29.png"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    
    NSDate *birthDate = [formatter dateFromString:self.friendModel.strBithdate];
    NSInteger age = [self ageFromBirthday:birthDate];

    
    NSString *profile = [NSString stringWithFormat:@"%@ (%ld)",self.friendModel.strClientUserName,(long)age];
    
    self.lblProfileName.text = profile;
    self.lblStatus.text = [NSString stringWithFormat:@"%@", self.friendModel.strDistance];
    self.lblDistance.text = @"";
    self.imgViewProfile.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"URL %@",self.friendModel.strThumbImgPath);
    if(self.friendModel.strThumbImgPath.length){
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        //  You may want to cache this explicitly instead of reloading every time.
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.friendModel.strThumbImgPath]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Capture the indexPath variable, not the cell variable, and use that
            self.imgViewProfile.image = image;
        });
    });
    }
    
}

- (void)setImageData:(NSDictionary*)collectionImageData
{
    self.sportsView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82/255.0 blue:89/255.0 alpha:0.8];
    
    [self.sportsView setImageData:[collectionImageData objectForKey:@"images"]];
}


- (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}




@end

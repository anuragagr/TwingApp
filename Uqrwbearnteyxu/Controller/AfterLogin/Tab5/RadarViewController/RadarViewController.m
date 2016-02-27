//
//  RadarViewController.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 14/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "RadarViewController.h"
#import "VIewUtility.h"
#import "UserModel.h"
#import "CommansUtility.h"
#import "RadarView.h"
#import "RadarDetailViewController.h"

#import "RadarServices.h"
#import "MBProgressHUD.h"
#import "FriendModel.h"
#import "GBSliderBubbleView.h"



#define smallPadding 2
#define largePadding 10

@interface RadarViewController()<RadarViewDelegate,WebServiceDelegate,GBSliderBubbleViewDelegate>
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet GBSliderBubbleView *gbSliderView;


@end

@implementation RadarViewController{
    RadarDetailViewController *radarDetailVC;
    
    NSMutableArray *arrayOfLineViews,*arrayOfViews;
    NSCache *imageCache;
    UserModel *userModel;
    
    UIImageView *profileImageView;
    UIImage *imgProfile;
    int _xPosForRadar;
    int _yPosForRadar;
    RadarView *radarView;

    RadarServices *radarService;
    
    NSMutableArray *arrayOfFriends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageCache = [[NSCache alloc]init];
    userModel = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        //  You may want to cache this explicitly instead of reloading every time.
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userModel.strProfileURLThumb]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Capture the indexPath variable, not the cell variable, and use that
            profileImageView.image = image;
        });
    });
    
    
 
    [self addOuterLayers];
    [self addRadar];

    
    [self.sliderView addTarget:self action:@selector(sliderViewValueChanged:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    [self setUpSlider];
}

-(void)setUpSlider{
    self.gbSliderView.tintColor = [UIColor colorWithRed:148/255 green:249.0/255 blue:253.255 alpha:1];
    self.gbSliderView.thumbImage = [UIImage imageNamed:@"slidercircle.png"];
    self.gbSliderView.delegate = self;
    self.gbSliderView.isBubbleHideAnimation = NO;
   // self.gbSliderView.maxValue = 25;
    self.gbSliderView.maxValue = radarView.arrayOfLineViews.count;
    self.gbSliderView.minValue = 0;
    self.gbSliderView.defaultValue = 0;
    self.gbSliderView.sliderTrackHeight = 2;
    
    
    
    [self.gbSliderView renderSliderBubbleView];
    
}


-(void)addOuterLayers{
    int xPos = -64;
    int yPos = 0;
    int width = self.view.frame.size.width+128;
    int height = self.view.frame.size.width+128;
    
    int numberOfViews = (width / largePadding)/2;
    
    UIView *mainContainer = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    //mainContainer.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:mainContainer];

    int xPosForInner = 0;
    int yPosForInner = 0;
    int widthForInner = self.view.frame.size.width+140;
    int heightForInner = self.view.frame.size.width+140;

    
    for (int k=0; k<(numberOfViews-2); k++) {
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(xPosForInner, yPosForInner, width, height)];
        mainView.backgroundColor = [UIColor grayColor];
        [VIewUtility addHexagoneShapeMaskFor:mainView];
        [mainContainer addSubview:mainView];
        
        
        if(k == (numberOfViews)){
            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(xPosForInner+smallPadding, yPosForInner+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            lineView.image =imgProfile;
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            profileImageView = lineView;
            [mainContainer addSubview:lineView];
            
        }
        else{
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPosForInner+smallPadding, yPosForInner+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            [mainContainer addSubview:lineView];
            
        }
        
        
        
        xPosForInner = xPosForInner + largePadding;
        yPosForInner = yPosForInner + largePadding;
        width = width - (2*largePadding);
        height = height - (2*largePadding);
        
        xPos = xPos + largePadding;
        yPos = yPos + largePadding;

        NSLog(@"XPOS %d",xPos);
        
        if(xPos>0){
            _xPosForRadar = xPos;
            _yPosForRadar = yPos;
            break;
        }
    }

}


-(void)addRadar{
    
    int xPos = _xPosForRadar;
    int yPos = _yPosForRadar;
    int width = self.view.frame.size.width- (_xPosForRadar *2);
    int height = self.view.frame.size.width - (_xPosForRadar *2);
    
    
    radarView = [[RadarView alloc]initWithFrame:CGRectMake(_xPosForRadar, _yPosForRadar, width+2, height+2)];
    radarView.delegate=self;
    
    [self.view addSubview:radarView];
   
//    self.sliderView.thumbTintColor = [UIColor colorWithRed:151.0/255.0 green:254/255.0 blue:255.0/255.0 alpha:1];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"slidercircle.png"] forState:UIControlStateNormal];
    self.sliderView.tintColor = [UIColor colorWithRed:148/255 green:249.0/255 blue:253.255 alpha:1];
    
    self.sliderView.maximumValue = radarView.arrayOfLineViews.count;
    self.sliderView.minimumValue = 0;
    
    return;
    
    int numberOfViews = (width / largePadding)/2;
    
    arrayOfViews = [[NSMutableArray alloc]init];
    arrayOfLineViews = [[NSMutableArray alloc]init];
    
    self.sliderView.maximumValue = numberOfViews-2;
    self.sliderView.minimumValue = 0;
    
    for (int k=0; k<(numberOfViews-2); k++) {
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        mainView.backgroundColor = [UIColor grayColor];
        [VIewUtility addHexagoneShapeMaskFor:mainView];
        [self.view addSubview:mainView];
        
        
        if(k == (numberOfViews)){
            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos+smallPadding, yPos+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            lineView.image =imgProfile;
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            profileImageView = lineView;
            [self.view addSubview:lineView];
            [arrayOfViews addObject:lineView];

        }
        else{
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPos+smallPadding, yPos+smallPadding, width-(2*smallPadding), height-(2*smallPadding))];
            lineView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82.0/255.0 blue:89.0/255.0 alpha:1];
            [VIewUtility addHexagoneShapeMaskFor:lineView];
            
            [self.view addSubview:lineView];
            [arrayOfViews addObject:lineView];
            
    
        }



        xPos = xPos + largePadding;
        yPos = yPos + largePadding;
        width = width - (2*largePadding);
        height = height - (2*largePadding);
        
        [arrayOfLineViews addObject:mainView];

    }
}

#pragma mark - Web service

-(void)webAPIForFriendsForSliderValue:(int)value{

    
    radarService = [[RadarServices alloc]init];
    [radarService getFriendsNearby:userModel.strUserId andLat:@"18.15" andLong:@"73.98" withLimit:[NSString stringWithFormat:@"%d",value]];
    
    radarService.delegate=self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - Slider values event
#pragma mark 

-(void)sliderViewValueChanged:(id)sender{
    
    int value = ceil(self.sliderView.value);
    int percentage = ((float)value/(float)radarView.arrayOfLineViews.count) * 100;
    NSLog(@"Percentage %d %d %lu",percentage,value,(unsigned long)radarView.arrayOfLineViews.count);

    
    value = (int)radarView.arrayOfLineViews.count- value;
    [radarView selectLineAtIndex:value];

    

    [self webAPIForFriendsForSliderValue:percentage];
    return;
    
    /*
    int value = ceil(self.sliderView.value);
    value =(int) arrayOfLineViews.count - value;
    
    for (int k=0; k<arrayOfLineViews.count; k++) {
        UIView *view = [arrayOfLineViews objectAtIndex:k];
        if(k==value){
            view.backgroundColor = [UIColor colorWithRed:148/255 green:249.0/255 blue:253.255 alpha:1];
            
            UIView *mainView = [arrayOfViews objectAtIndex:k];
            mainView.backgroundColor =[UIColor redColor];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(mainView.frame.size.width/2, 0, 20, 20)];
            btn.backgroundColor = [UIColor yellowColor];
            
            [mainView addSubview:btn];
            
        }
        else{
            view.backgroundColor = [UIColor grayColor];
        }
    }*/
    
}


#pragma mark - Radar

-(void)radarView:(id)radarView didSelectAnnotation:(int)selectedIndex{
    
    [self setUpFriendsDetailContainer:selectedIndex];
}

-(void)setUpFriendsDetailContainer:(int)selectedIndex{
    UIView *resultView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 210)];
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainAppStoryboard" bundle:[NSBundle mainBundle]];
    radarDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"RadarDetailViewController"];

    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [radarDetailVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    radarDetailVC.delegate=self;
    
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arrayOfFriends];
    [array exchangeObjectAtIndex:0 withObjectAtIndex:selectedIndex];
    
    radarDetailVC.arrayOfFriends = array;
    radarDetailVC.selectedFriendIndex = selectedIndex;
    
    //radarDetailVC.view.backgroundColor = [UIColor clearColor];
    //radarDetailVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:radarDetailVC animated:YES completion:nil];
    
//    [self.tabBarController presentViewController:radarDetailVC animated:YES completion:nil];
    
    //return radarDetail.view;
}


#pragma mark - Web service response
#pragma mark

- (void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    arrayOfFriends = [[NSMutableArray alloc]init];
    if(responseData.count>0){
        arrayOfFriends = responseData;
        
        [radarView addRadarAnnotation:responseData];
        
        NSLog(@"Friends %@",responseData);
    }
    
}


#pragma mark - Radar details

-(void)radarDetailVC:(id)sender andSelectedIndex:(id)friendModel{
    FriendModel *frModel = (FriendModel *)friendModel;
    int selectedIndex;
    for (int k=0; k<arrayOfFriends.count; k++) {
        FriendModel *fModel = [arrayOfFriends objectAtIndex:k];
        if([frModel.strUserID isEqualToString:fModel.strUserID]){
            selectedIndex = k;
            break;
        }
    }
    
    [radarView selectAnnotationIndex:selectedIndex];
}


#pragma mark - GB Slider

-(void)getSliderDidEndChangeValue:(NSInteger)value{
    int percentage = ((float)value/(float)radarView.arrayOfLineViews.count) * 100;
    
    
    value = (int)radarView.arrayOfLineViews.count- value;
    value = value-1;
    if(value<0){
        value=0;
    }
    [radarView selectLineAtIndex:(int)value];
    
    [self webAPIForFriendsForSliderValue:percentage];
}

-(void)getSliderDidChangeValue:(NSInteger)value{
    int percentage = ((float)value/(float)radarView.arrayOfLineViews.count) * 100;

    int t = 25 * ((float)percentage / 100);
    NSLog(@"Percentage %d %d",t,percentage);

    self.gbSliderView.valueLabel.text =[NSString stringWithFormat: @"%d km",t];
    
}


@end

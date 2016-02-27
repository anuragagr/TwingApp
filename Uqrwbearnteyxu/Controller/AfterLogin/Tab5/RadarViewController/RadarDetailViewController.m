//
//  RadarDetailViewController.m
//  CustomDatePicker
//
//  Created by Developer on 23/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import "RadarDetailViewController.h"
#import "RadarFriendDetailViewController.h"
#import "PageViewController.h"

@interface RadarDetailViewController()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong, nonatomic) PageViewController *pageViewController;
@property (nonatomic,strong)    UIPageControl *pageControl;

@end

@implementation RadarDetailViewController{
    NSMutableArray *arrayOfViewControllers;
    UITapGestureRecognizer *tapGuesture;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];;

   // self.pageViewController.dataSource = self;
    [self setUp];


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

#pragma mark - Make Up view with Pageview Controller,data source required for pageview controller etc
#pragma mark -
/**
 @author         Rahul N. Mane
 @function       setUp
 @discussion     This function will make UI for this view by using PagingViewController.
 @param          nil
 @result         Set up view with PagingViewController.
 */
-(void)setUp{
    [self setUpViewControllers];
    [self setPageViewControllers];
    [self addTapGuesture];
    
    // [self getUserLocation];
}

-(void)addTapGuesture{
    tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuestureClicked:)];
    [self.view addGestureRecognizer:tapGuesture];
}

-(void)tapGuestureClicked:(UITapGestureRecognizer *)tap{
    [self.view removeGestureRecognizer:tap];
    tapGuesture = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 @author         Rahul N. Mane
 @function       setUpViewControllers
 @discussion     This function sets data source for pageviewcontroller.Both are navigation controller one will be used for eventlist and other will be used for entertainer list.
 @param          nil
 @result         Sets data source for pageview cotnroller.
 */
-(void)setUpViewControllers{
    arrayOfViewControllers=[[NSMutableArray alloc]init];
    
    for (int k=0;k<self.arrayOfFriends.count; k++) {
      //  RadarFriendDetailViewController *radarFriendDetail= [self.storyboard instantiateViewControllerWithIdentifier:@"RadarFriendDetailViewController"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"MainAppStoryboard" bundle:[NSBundle mainBundle]];
        RadarFriendDetailViewController *radarFriendDetail = [storyboard instantiateViewControllerWithIdentifier:@"RadarFriendDetailViewController"];
        radarFriendDetail.view.frame = CGRectMake(0, 0, 320, 150);
        
        
        radarFriendDetail.view.tag = k;
        radarFriendDetail.view.backgroundColor = [UIColor grayColor];
        
        [arrayOfViewControllers addObject:radarFriendDetail];
    }
    
}


-(void)setPageViewControllers{
    self.pageViewController = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:CGRectMake(0, self.view.bounds.size.height-200-44, self.view.frame.size.width, 200)];
    
    RadarFriendDetailViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [[self view] addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
    self.pageViewController.view.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82/255.0 blue:89/255.0 alpha:0.8];

    

}


- (RadarFriendDetailViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"MainAppStoryboard" bundle:[NSBundle mainBundle]];
    RadarFriendDetailViewController *radarFriendDetail = [storyboard instantiateViewControllerWithIdentifier:@"RadarFriendDetailViewController"];
    radarFriendDetail.friendModel = [self.arrayOfFriends objectAtIndex:index];
    radarFriendDetail.index = index;
    
   
    return radarFriendDetail;
    
}

-(void)setUpPagingViewController{
    // Create page view controller
  //  UIStoryboard *sptry = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                              //  @"Main" bundle:[NSBundle mainBundle]];
    //self.pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];

    
    self.pageViewController = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:[[self view] bounds]];
    

    
//    self.pageViewController = [[PageViewController alloc]init];
    self.pageViewController.view.backgroundColor = [UIColor redColor];
    

    self.pageViewController.dataSource = self;
    self.pageViewController.delegate=self;
    
    // self.pageViewController.definesPresentationContext = YES;
    
    
    UIViewController *startingViewController = [self viewControllerAtIndex:self.selectedFriendIndex];
    // startingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 40, self.view.frame.size.width, 200);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.dataSource = nil;
        self.pageViewController.dataSource = self;

    
}
/*
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([arrayOfViewControllers count] == 0)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    UIViewController *pageContentViewController =[arrayOfViewControllers objectAtIndex:index];
    
    return pageContentViewController;
}
*/


#pragma mark - PageViewController data source delegate.
#pragma mark -

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RadarFriendDetailViewController *)viewController index];
    
    if(self.delegate){
        
        [self.delegate radarDetailVC:self andSelectedIndex:[self.arrayOfFriends objectAtIndex:index]];
    }
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RadarFriendDetailViewController *)viewController index];
    
    if(self.delegate){
        
        [self.delegate radarDetailVC:self andSelectedIndex:[self.arrayOfFriends objectAtIndex:index]];
    }
    
    
    index++;
    
    
    if (index == self.arrayOfFriends.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return self.arrayOfFriends.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


@end

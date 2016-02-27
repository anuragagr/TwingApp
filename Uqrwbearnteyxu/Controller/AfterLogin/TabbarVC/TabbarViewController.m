//
//  TabbarViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 05/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "TabbarViewController.h"
#import "DCPathButton.h"
#import "RightMenuViewController.h"
#import "ProfileViewController.h"
#import "CommansUtility.h"
#import "AskForLoginViewController.h"
#import "SearchFriendViewController.h"

@interface TabbarViewController ()<DCPathButtonDelegate,UITabBarControllerDelegate,RightMenuViewControllerDelegate>

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;

    RightMenuViewController *rightMenu =  (RightMenuViewController *)   [SlideNavigationController sharedInstance].rightMenu ;
    
    rightMenu.delegate = self;
    
    //self.delegate=self;
    /*
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard"
                                                             bundle: nil];
    
    RightMenuViewController *rightMenu = (RightMenuViewController*)[mainStoryboard
                                                                    instantiateViewControllerWithIdentifier: @"RightMenuViewController"];
    
    rightMenu.delegate = self;
    
    [SlideNavigationController sharedInstance].rightMenu = rightMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;

    */
    
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:0] setBadgeValue:@"12"];
    
    self.tabBar.tintColor= [UIColor colorWithRed:148/255 green:249.0/255 blue:253.255 alpha:1];

    
   // self.tabBar.ima= [UIColor colorWithRed:148/255 green:249.0/255 blue:253.255 alpha:1];

    
    //[self.tabBar setBarTintColor:[UIColor yellowColor]];

    [self configureDCPathButton];
    // Do any additional setup after loading the view.
   
    
    UIImage *selectedImage0 = [UIImage imageNamed:@"tab2.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"tab2.png"];
    
    //UITabBarItem *item0 = [self.tabBar.items objectAtIndex:0];
    
    //[item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    
   /* [item0 setImage:[[UIImage imageNamed:@"tab2.png"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];*/
    
    /*
    UITabBar *tabBar = self.tabBar;
    
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    
    [item0 setFinishedSelectedImage:[UIImage imageNamed:@"tab1.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab1.png"]];
    [item0 setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    
    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"tab2.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab2.png"]];
    
    [item1 setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"tab3.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab3.png"]];
    [item2 setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [item3 setFinishedSelectedImage:[UIImage imageNamed:@"tab4.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab4.png"]];
    [item3 setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    */
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}

-(void)rightMenuVC:(id)sender didSelectMenu:(enum menus)selectedMenu{
    if(selectedMenu == menuLogOut){
        
        [self alertOKCancelAction];
        
    }
    else if (selectedMenu == menuProfile){
        UINavigationController *nav = self.selectedViewController;
        
        UIViewController *controller = [nav topViewController];
        if([controller isKindOfClass:[ProfileViewController class]]){
            return;
        }
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard"
                                                                 bundle: nil];
        
        UIViewController *vc ;
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
        
        [nav pushViewController:vc animated:YES];
    }
    else if (selectedMenu == menuSearchFriend){
        UINavigationController *nav = self.selectedViewController;
        
        UIViewController *controller = [nav topViewController];
        if([controller isKindOfClass:[SearchFriendViewController class]]){
            return;
        }
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard"
                                                                 bundle: nil];
        UIViewController *vc ;
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SearchFriendViewController"];
        [nav pushViewController:vc animated:YES];
    }
}

- (void)alertOKCancelAction {
    // open a alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log out" message:@"Are you sure want to log out ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if(alert.tag == 1)
    {
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        }
        else
        {
            [[CommansUtility sharedInstance]saveUserObject:nil key:@"loggedInUser"];
            
            UIViewController  *rootController =(AskForLoginViewController*)[[                    [[UIApplication sharedApplication]delegate] window] rootViewController];
            if([rootController isKindOfClass:[AskForLoginViewController class]]){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                AskForLoginViewController *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AskForLoginViewController"];
                
                [[SlideNavigationController sharedInstance] setViewControllers:[NSArray arrayWithObjects:tabBarVC, nil]];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)configureDCPathButton
{
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"tab3.png"]
                                                         highlightedImage:[UIImage imageNamed:@"tab3.png"]];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"tab-sub1.png"]
                                                           highlightedImage:[UIImage imageNamed:@"tab-sub1.png"]
                                                            backgroundImage:[UIImage imageNamed:@"tab-sub1.png"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"tab-sub1.png"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"tab-sub2.png"]
                                                           highlightedImage:[UIImage imageNamed:@"tab-sub2.png"]
                                                            backgroundImage:[UIImage imageNamed:@"tab-sub2.png"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"tab-sub2.png"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"tab-sub3.png"]
                                                           highlightedImage:[UIImage imageNamed:@"tab-sub3.png"]
                                                            backgroundImage:[UIImage imageNamed:@"tab-sub3.png"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"tab-sub3.png"]];
    
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1,
                                 itemButton_2,
                                 itemButton_3,
                                 ]];
    
    // Change the bloom radius, default is 105.0f
    //
    dcPathButton.bloomRadius = 70;
    
    // Change the DCButton's center
    //
    //dcPathButton.frame = CGRectMake(0, 0, 60, 60);

    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 30.5f);
    
    // Setting the DCButton appearance
    //
    dcPathButton.allowSounds = YES;
    dcPathButton.allowCenterButtonRotation = NO;
    
    dcPathButton.bottomViewColor = [UIColor grayColor];
    
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTop;
    
    [self.view addSubview:dcPathButton];
    
}

#pragma mark - Tabbar Delegates

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
{
    if (tabBarController.selectedIndex == 2) {
            return NO;
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //unselected icon tint color
    [[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor:[UIColor redColor]];
    
    //selected tint color
    [[UITabBar appearance] setTintColor:[UIColor greenColor]];
}


#pragma mark - DCPathButton Delegate

- (void)willPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton will present");
    
}

- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@"You tap %@ at index : %lu", dcPathButton, (unsigned long)itemButtonIndex);
}

- (void)didPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton did present");
    
}

- (void)willDismissDCPathButtonItems:(DCPathButton *)dcPathButton{
    
}
- (void)didDismissDCPathButtonItems:(DCPathButton *)dcPathButton{
    
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}


@end

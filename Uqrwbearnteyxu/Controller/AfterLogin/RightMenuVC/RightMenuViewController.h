//
//  RightMenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationContorllerAnimator.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

enum menus{
    menuProfile,
    menuSport,
    menuSetting,
    menuLogOut,
    menuHelp,
    menuSearchFriend
};
@protocol RightMenuViewControllerDelegate <NSObject>

-(void)rightMenuVC:(id)sender didSelectMenu:(enum menus)selectedMenu;


@end
@interface RightMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<RightMenuViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

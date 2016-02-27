//
//  RadarDetailViewController.h
//  CustomDatePicker
//
//  Created by Developer on 23/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadarDetailVCDelegate <NSObject>

-(void)radarDetailVC:(id)sender andSelectedIndex:(id)friendModel;

@end

@interface RadarDetailViewController : UIViewController

@property(nonatomic,weak)id<RadarDetailVCDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *arrayOfFriendsOriginal;

@property(nonatomic,strong)NSMutableArray *arrayOfFriends;
@property(nonatomic,readwrite)int selectedFriendIndex;


@end

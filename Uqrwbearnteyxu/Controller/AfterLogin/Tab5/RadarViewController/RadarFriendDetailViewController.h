//
//  RadarFriendDetailViewController.h
//  CustomDatePicker
//
//  Created by Developer on 23/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface RadarFriendDetailViewController : UIViewController

@property(nonatomic,strong)FriendModel *friendModel;

@property(nonatomic,readwrite)NSInteger index;

@end

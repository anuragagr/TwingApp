//
//  ProfileViewController.h
//  Uqrwbearnteyxu
//
//  Created by Developer on 03/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface ProfileViewController : UIViewController

@property(nonatomic,strong)FriendModel *friendModel;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint *topConstarintTable;


@end

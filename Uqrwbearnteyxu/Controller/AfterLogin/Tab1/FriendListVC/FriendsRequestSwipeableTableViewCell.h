//
//  FriendsRequestSwipeableTableViewCell.h
//  Uqrwbearnteyxu
//
//  Created by Developer on 05/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FriendsRequestSwipeableTableViewCellDelegate <NSObject>

@end

@interface FriendsRequestSwipeableTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblFriendName;
@property (weak, nonatomic) IBOutlet UILabel *lblMutualFriend;
@property (weak, nonatomic) IBOutlet UILabel *lblMutualSports;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewFriendsProfile;

@property (weak, nonatomic) IBOutlet UIButton *btnAcceptRequest;
@property (weak, nonatomic) IBOutlet UIButton *btnRejectRequest;

@end

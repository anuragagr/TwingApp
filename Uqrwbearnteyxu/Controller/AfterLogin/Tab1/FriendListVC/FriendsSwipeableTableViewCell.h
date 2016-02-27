//
//  FriendsSwipeableTableViewCell.h
//  Uqrwbearnteyxu
//
//  Created by Developer on 05/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendsSwipeableTableViewCellDelegate <NSObject>
- (void)btnFriendsForIndexPath:(NSIndexPath *)indexPath;
- (void)btnChatForIndexPath:(NSIndexPath *)indexPath;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end

@interface FriendsSwipeableTableViewCell : UITableViewCell

@property (nonatomic, weak) id <FriendsSwipeableTableViewCellDelegate> delegate;
- (void)openCell;
-(void)closeCell;

-(void)makeItSwipable:(BOOL)makeItSwipable;

@property (weak, nonatomic) IBOutlet UILabel *lblFriendName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewFriendsProfile;

@end

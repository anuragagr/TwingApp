//
//  MakeProfileViewController.h
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDatePicker.h"

@interface MakeProfileViewController : UIViewController
@property(nonatomic,strong)IBOutlet CustomDatePicker *customDatePicker;
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) NSString *strPassword;
@property (strong, nonatomic) NSString *strConfirmPassowrd;
@property (strong, nonatomic) NSString *strTxtUserName;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewProfile;
@property  (strong, nonatomic) NSData *imageFacebookData;
@property (strong, nonatomic)NSString *strFacebookDateOfBirth;
@property (strong, nonatomic)NSString *strFacebookMaleAndFemale;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end

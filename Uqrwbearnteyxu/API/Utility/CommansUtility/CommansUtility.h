//
//  CommansUtility.h
//  Uqrwbearnteyxu
//
//  Created by Developer on 09/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface CommansUtility : NSObject
+ (CommansUtility *)sharedInstance;
- (void)saveUserObject:(UserModel *)object key:(NSString *)key;
- (UserModel *)loadUserObjectWithKey:(NSString *)key;

@end

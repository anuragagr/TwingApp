//
//  CommansUtility.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 09/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "CommansUtility.h"

@implementation CommansUtility

+ (CommansUtility *)sharedInstance
{
    // 1
    static CommansUtility *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[CommansUtility alloc] init];
    });
    return _sharedInstance;
}

- (void)saveUserObject:(UserModel *)object key:(NSString *)key{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (UserModel *)loadUserObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    UserModel *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end

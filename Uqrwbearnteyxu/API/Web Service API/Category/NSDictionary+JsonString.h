//
//  NSDictionary+JsonString.h
//  IceBerg
//
//  Created by Rahul Mane on 07/07/15.
//  Copyright (c) 2015 Perennial Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonString)

- (NSString *)jsonStringWithPrettyPrint:(BOOL) prettyPrint;

- (id)getObjectForKey:(NSString *)key;

- (NSString *)getStringForKey:(NSString *)key;
- (NSNumber *)getNumberForKey:(NSString *)key;
- (BOOL)getBoolForKey:(NSString *)key;
- (int)getIntForKey:(NSString *)key;
- (NSInteger)getIntegerForKey:(NSString *)key;

- (void)setIntValue:(int)value forKey:(NSString *)key;
- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)key;
- (void)setBoolValue:(BOOL)value forKey:(NSString *)key;

@end

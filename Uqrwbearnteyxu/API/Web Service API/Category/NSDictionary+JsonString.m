//
//  NSDictionary+JsonString.m
//  IceBerg
//
//  Created by Rahul Mane on 07/07/15.
//  Copyright (c) 2015 Perennial Systems. All rights reserved.
//

#import "NSDictionary+JsonString.h"

@implementation NSDictionary (JsonString)

- (NSString *)jsonStringWithPrettyPrint:(BOOL)prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0) error:&error];
    
    if (!jsonData)
    {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (id)getObjectForKey:(NSString *)key
{
    id value = self[key];
    
    if ((value == [NSNull null]) || ([value isKindOfClass:[NSString class]] && [value isEqualToString:@""]))
        return nil;
    else
        return value;
}

- (NSString *)getStringForKey:(NSString *)key
{
    id value = self[key];
    
    if ((value == [NSNull null]) || (value == nil))
        return @"";
    else
        return value;
}

- (NSNumber *)getNumberForKey:(NSString *)key
{
    NSString *value = [self getStringForKey:key];
    
    NSNumber *number = nil;
    if ([value isKindOfClass:[NSString class]])
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        number = [formatter numberFromString:value];
    }
    else
    {
        number = @([value intValue]);
    }
    
    return number;
}

- (BOOL)getBoolForKey:(NSString *)key
{
    id value = self[key];
    return [value boolValue];
}

- (int)getIntForKey:(NSString *)key
{
    id value = self[key];
    return [value intValue];
}

- (NSInteger)getIntegerForKey:(NSString *)key
{
    id value = self[key];
    return [value integerValue];
}

- (void)setIntValue:(int)value forKey:(NSString *)key
{
    NSNumber *number = [NSNumber numberWithInt:value];
    [self setValue:number forKey:key];
}

- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)key
{
    NSNumber *number = [NSNumber numberWithInteger:value];
    [self setValue:number forKey:key];
}

- (void)setBoolValue:(BOOL)value forKey:(NSString *)key
{
    NSNumber *number = [NSNumber numberWithBool:value];
    [self setValue:number forKey:key];
}

@end

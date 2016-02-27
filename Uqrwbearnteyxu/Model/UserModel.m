//
//  UserModel.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 12/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.strUserId forKey:@"userid"];
    [encoder encodeObject:self.strUserName forKey:@"username"];
    [encoder encodeObject:self.strAuthToken forKey:@"authtoken"];
    [encoder encodeObject:self.strEmailID forKey:@"emailID"];
    [encoder encodeObject:self.strClientUserName forKey:@"clientUserName"];
    [encoder encodeObject:self.strProfileURLThumb forKey:@"thumbURL"];
    [encoder encodeObject:self.strProfileURL forKey:@"profileURL"];
    [encoder encodeObject:self.strBirthdate forKey:@"birthdate"];
    [encoder encodeObject:self.arrayOfFriends forKey:@"arrayOfFriends"];
    [encoder encodeObject:self.arrayOfSports forKey:@"arrayOfSports"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.strUserId = [decoder decodeObjectForKey:@"userid"];
        self.strUserName = [decoder decodeObjectForKey:@"username"];
        self.strAuthToken = [decoder decodeObjectForKey:@"authtoken"];
        self.strEmailID = [decoder decodeObjectForKey:@"emailID"];
        self.strClientUserName = [decoder decodeObjectForKey:@"clientUserName"];
        self.strProfileURL = [decoder decodeObjectForKey:@"profileURL"];
        self.strProfileURLThumb = [decoder decodeObjectForKey:@"thumbURL"];
        self.strBirthdate = [decoder decodeObjectForKey:@"birthdate"];
        self.arrayOfSports = [decoder decodeObjectForKey:@"arrayOfSports"];
        self.arrayOfFriends = [decoder decodeObjectForKey:@"arrayOfFriends"];
    }
    return self;
}

@end

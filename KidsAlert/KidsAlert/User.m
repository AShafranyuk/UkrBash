//
//  User.m
//  KidsAlert
//
//  Created by Admin on 08.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "User.h"

@implementation User

+ (id)sharedManager {
    static User *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _userEmail = nil;
        _userId = 0;
        _kidId = nil;
        _deviceToken = nil;
        _userPhone = nil;
        _badge = @"0";
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end

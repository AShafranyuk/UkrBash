//
//  User.h
//  KidsAlert
//
//  Created by Admin on 08.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, retain) NSString *userEmail;
@property (nonatomic) NSInteger* userId;
@property (strong, nonatomic) NSString *kidId;
@property (strong, nonatomic) NSString * deviceToken;
@property (strong, nonatomic) NSString * userPhone;
@property (strong, nonatomic) NSString * badge;

@property (nonatomic) BOOL * settingEmail;

+ (id)sharedManager;



@end



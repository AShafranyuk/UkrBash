//
//  BirthViewController.h
//  KidsAlert
//
//  Created by Admin on 02.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BirthViewController : UIViewController
@property (strong, nonatomic) NSString * date;
@property (strong) NSManagedObject *devices;

@end

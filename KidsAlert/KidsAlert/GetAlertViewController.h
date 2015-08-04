//
//  GetAlertViewController.h
//  KidsAlert
//
//  Created by Admin on 22.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface GetAlertViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *kidName;
@property (weak, nonatomic) IBOutlet UILabel *kidGender;
@property (weak, nonatomic) IBOutlet UILabel *kidAge;
@property (weak, nonatomic) IBOutlet UILabel *kidHair;
@property (weak, nonatomic) IBOutlet UILabel *kidEye;
@property (weak, nonatomic) IBOutlet UILabel *kidHight;
@property (weak, nonatomic) IBOutlet UILabel *kidWeight;
@property (weak, nonatomic) IBOutlet UILabel *kidSpecial;
@property (weak, nonatomic) IBOutlet UILabel *kidLastSeen;
@property (weak, nonatomic) IBOutlet UILabel *kidClothes;
@property (weak, nonatomic) IBOutlet UILabel *kidPhone;

@property (strong) NSManagedObject *device1;
@property (strong, nonatomic) UIImageView *imageHolder;


@end

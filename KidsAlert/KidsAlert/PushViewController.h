//
//  PushViewController.h
//  KidsAlert
//
//  Created by Admin on 24.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface PushViewController : UITableViewController
@property (strong) NSManagedObject *device2;

@property (weak, nonatomic) IBOutlet UIImageView *kidImage;
@property (weak, nonatomic) IBOutlet UILabel *kidName;
@property (weak, nonatomic) IBOutlet UILabel *kidGender;
@property (weak, nonatomic) IBOutlet UILabel *kidAge;
@property (weak, nonatomic) IBOutlet UILabel *kidHair;
@property (weak, nonatomic) IBOutlet UILabel *kidEye;
@property (weak, nonatomic) IBOutlet UILabel *kidHeight;
@property (weak, nonatomic) IBOutlet UILabel *kidWeight;
@property (weak, nonatomic) IBOutlet UILabel *kidSpecial;
@property (weak, nonatomic) IBOutlet UILabel *kidLastSeen;
@property (weak, nonatomic) IBOutlet UILabel *kidClothes;
@property (weak, nonatomic) IBOutlet UILabel *kidPhone;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellSpecial;
@property (weak, nonatomic) IBOutlet UITextView *kidSpecialTView;


@property (strong, nonatomic) UIImageView *imageHolder;

@property (nonatomic) BOOL find;

@property (weak, nonatomic) IBOutlet UIButton *iFind;
@property (nonatomic) NSInteger index;


@property (weak, nonatomic) IBOutlet UIView *wait;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UIImageView *phoneIm;
@end

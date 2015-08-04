//
//  TableViewCell.h
//  KidsAlert
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *kidsName;
@property (weak, nonatomic) IBOutlet UIImageView *kidsImage;
@property (weak, nonatomic) IBOutlet UILabel *kidsAge;
@property (weak, nonatomic) IBOutlet UILabel *kidsGender;
@property (weak, nonatomic) IBOutlet UILabel *kidsHair;
@property (weak, nonatomic) IBOutlet UILabel *kidsEye;
@property (weak, nonatomic) IBOutlet UILabel *kidsHeight;
@property (weak, nonatomic) IBOutlet UILabel *kidsSpecial;
@property (weak, nonatomic) IBOutlet UIButton *deleteRow;
@property (weak, nonatomic) IBOutlet UIButton *updateRow;

@end

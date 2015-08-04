//
//  KidsTableTableViewController.h
//  KidsAlert
//
//  Created by Admin on 27.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddKidsViewController.h"

@interface KidsTableTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *nav;
@property NSInteger count;
@property NSIndexPath * path;
@property NSInteger row;
@property id sen;




@end

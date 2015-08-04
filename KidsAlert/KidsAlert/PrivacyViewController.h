//
//  PrivacyViewController.h
//  KidsAlert
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyViewController : UITableViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *text;

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell;

@end

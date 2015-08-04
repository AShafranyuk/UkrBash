//
//  PrivacyViewController.m
//  KidsAlert
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if(indexPath.row ==  1 ){
        return [UIScreen mainScreen].bounds.size.height-60;}
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

@end

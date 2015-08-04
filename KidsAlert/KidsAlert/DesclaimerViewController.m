//
//  DesclaimerViewController.m
//  KidsAlert
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "DesclaimerViewController.h"

@interface DesclaimerViewController ()

@end

@implementation DesclaimerViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end

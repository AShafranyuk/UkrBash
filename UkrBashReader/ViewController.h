//
//  ViewController.h
//  UkrBashReader
//
//  Created by Admin on 29.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
@interface ViewController : UITableViewController <NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end


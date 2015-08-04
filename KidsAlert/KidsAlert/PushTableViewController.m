//
//  PushTableViewController.m
//  KidsAlert
//
//  Created by Admin on 24.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PushTableViewController.h"
#import "User.h"



@interface PushTableViewController ()
@property (strong) NSMutableArray *devices;
@property (strong) NSMutableArray *devicesAll;
@end

@implementation PushTableViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *navBar = [UIImage imageNamed:@"tin.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor]};
    User * user = [User sharedManager];
    user.badge = @"0";
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Alert"];
    self.devicesAll = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Alert1"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return self.devices.count;
            break;
        case 1:
            return self.devicesAll.count;
            break;
    }
    return self.devices.count;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    UIView *headerView1;
    
    switch(section){
        case 0:
        {
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 12)];
            UILabel * header = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, tableView.bounds.size.width, 15)];
            if(self.devices.count >0)
            {
                [headerView setBackgroundColor:[UIColor colorWithRed:219.0/255.0
                                                               green:221.0/255.0
                                                                blue:220.0/255.0
                                                               alpha:1.0]];
                [header setTextColor:[UIColor lightGrayColor]];
                [header setText:@"  Mijn Alerts"];
            } else
            {
                [headerView setBackgroundColor:[UIColor colorWithRed:219.0/255.0
                                                               green:221.0/255.0
                                                                blue:220.0/255.0
                                                               alpha:1.0]];
            }
            [headerView addSubview:header];
            return headerView;
            break;
        }
        case 1:
        {
            headerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 12)];
            UILabel * header1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, tableView.bounds.size.width, 12)];
            if(self.devicesAll.count >0)
            {
                [headerView1 setBackgroundColor:[UIColor colorWithRed:219.0/255.0
                                                                green:221.0/255.0
                                                                 blue:220.0/255.0
                                                                alpha:1.0]];
                [header1 setTextColor:[UIColor lightGrayColor]];
                [header1 setText:@"  Inkomend Alert"];

            } else
            {
                [headerView1 setBackgroundColor:[UIColor clearColor]];
            }
            [headerView1 addSubview:header1];
            return headerView1;
            break;
        }
    }
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return @"Mijn Alerts";
            break;
        case 1:
            return @"Alle Alerts";
            break;
    }
return @"tt";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell2";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSLog(@"%@", self.devices);
     NSLog(@"%@", self.devicesAll);
    // Configure the cell...
    NSManagedObject *device;
    switch([indexPath section])
    {
        case 0:
            device = [self.devices objectAtIndex:indexPath.row];
            break;
        case 1:
            device = [self.devicesAll objectAtIndex:indexPath.row];
            break;
    }
    
    
   
    cell.kidsName.text =[device valueForKey:@"name"];
    cell.kidsAge.text =[device valueForKey:@"age"];
    cell.kidsGender.text = [device valueForKey:@"gender"];
    cell.kidsHair.text = [device valueForKey:@"hair_color"];
    cell.kidsEye.text = [device valueForKey:@"eye_color"];
    cell.kidsHeight.text = [device valueForKey:@"height"];
    cell.kidsSpecial.text = [device valueForKey:@"special_features"];
    UIImage *image;
    NSString * photo;
    switch([indexPath section])
    {
        case 0:
            image = [UIImage imageWithData:[device valueForKey:@"photo"]];
            cell.kidsImage.image = image;
            break;
        case 1:
            photo = [@"http://37.48.84.185/images/" stringByAppendingString:[device valueForKey:@"photo"]];
            NSURL * url = [NSURL URLWithString:photo];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *iconImage = [[UIImage alloc] initWithData:data];
            cell.kidsImage.image = iconImage;
           break;
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        switch([indexPath section])
        {
            case 0:
                [context deleteObject:[self.devices objectAtIndex:indexPath.row]];
                break;
            case 1:
                [context deleteObject:[self.devicesAll objectAtIndex:indexPath.row]];
                break;
        }
        
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        switch([indexPath section])
        {
            case 0:
                [self.devices removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 1:
                [self.devicesAll removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger section = [[self.tableView indexPathForSelectedRow ]section];
    NSString *inStr = [NSString stringWithFormat:@"%ld", (long)section];
    
    if ([[segue identifier] isEqualToString:@"alert" ] && [inStr isEqual:@"0" ])
    {
        NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        PushViewController *destViewController = segue.destinationViewController;
        destViewController.device2 = selectedDevice;
        destViewController.find = YES;
        destViewController.index = [[self.tableView indexPathForSelectedRow] row];
    } else if ([[segue identifier] isEqualToString:@"alert" ] && [inStr isEqual:@"1" ])
    {
        NSManagedObject *selectedDevice = [self.devicesAll objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        PushViewController *destViewController = segue.destinationViewController;
        destViewController.device2 = selectedDevice;
        destViewController.find = NO;
    }
}


@end

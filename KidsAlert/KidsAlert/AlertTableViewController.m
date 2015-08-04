//
//  AlertTableViewController.m
//  KidsAlert
//
//  Created by Admin on 16.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AlertTableViewController.h"
#import "TableViewCell.h"

@interface AlertTableViewController ()
@property (strong) NSMutableArray *devices;
@end

@implementation AlertTableViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"STUUR ALERT";
    UIImage *navBar = [UIImage imageNamed:@"tin.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *log = [defaults valueForKey:@"UserId"];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Kids"];
    
    NSArray * devices1 = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSInteger c = devices1.count;
    for(int i = c-1; i>= 0; i--)
    {
        NSManagedObject *device = [devices1 objectAtIndex:i];
        
        if([[device valueForKey:@"user"] isEqualToString:log ])
        {
            self.count = self.count + 1;
        }
        else {
            [self.devices removeObjectAtIndex:i];
            NSLog(@"%@", self.devices );
        }
        
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell1";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    NSManagedObject *device = [self.devices objectAtIndex:indexPath.row];

    cell.kidsName.text =[device valueForKey:@"name"];
    cell.kidsAge.text =[device valueForKey:@"age"];
    cell.kidsGender.text = [device valueForKey:@"gender"];
    cell.kidsHair.text = [device valueForKey:@"hair"];
    cell.kidsEye.text = [device valueForKey:@"eye"];
    cell.kidsHeight.text = [device valueForKey:@"growth"];
    cell.kidsSpecial.text = [device valueForKey:@"special"];
    UIImage *image = [UIImage imageWithData:[device valueForKey:@"photo"]];
    cell.kidsImage.image = image;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"UpdateDevice2"])
    {
        NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        AddKidsViewController *destViewController = segue.destinationViewController;
        destViewController.device = selectedDevice;
    }
}


@end

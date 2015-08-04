//
//  KidsTableTableViewController.m
//  KidsAlert
//
//  Created by Admin on 27.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "KidsTableTableViewController.h"
#import "TableViewCell.h"

@interface KidsTableTableViewController ()
@property (strong) NSMutableArray *devices;
@end

@implementation KidsTableTableViewController


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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.title = @"LIJST KINDEREN";
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
    static NSString *CellIdentifier = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSLog(@"%@", self.devices);
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
        cell.kidsImage.image  = image;
    cell.deleteRow.tag = indexPath.row;
    [cell.deleteRow addTarget:self action:@selector(funkAlert1:) forControlEvents:UIControlEventTouchDown];
    
    cell.updateRow.tag = indexPath.row;
    [cell.updateRow addTarget:self action:@selector(updateRow:) forControlEvents:UIControlEventTouchDown];

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
        // Delete object from database
        [context deleteObject:[self.devices objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.devices removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *device = [self.devices objectAtIndex:indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[device valueForKey:@"name"]message:nil delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Verwijderen", @"Update", nil];
    _row = indexPath.row;
    _path = indexPath;
    [alert show];
    alert.tag = 1;

}
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    //-----EMAIL-------
    if(alert.tag == 1)
    {
        if(buttonIndex == 2)
        {
            NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
            // AddKidsViewController *destViewController = segue.destinationViewController;
            //  destViewController.device = selectedDevice;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AddKidsViewController *privacy = (AddKidsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"add"];
            privacy.device = selectedDevice;
            // present
            [self presentViewController:privacy animated:YES completion:nil];
            NSLog(@"cancel");
        }
        else if(buttonIndex == 1) {
            
            [self funkAlert];
            
        }
        
    }
    if(alert.tag == 2){
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        } else {
            NSManagedObjectContext *context = [self managedObjectContext];
            [context deleteObject:[self.devices objectAtIndex:_row]];
            
            NSError *error = nil;
            if (![context save:&error])
            {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            
            // Remove device from table view
            [self.devices removeObjectAtIndex:_row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_path] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }
    if(alert.tag == 3){
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        } else {
            [self deleteRow:self.sen];

        }
    }
}
-(void) funkAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verwijderen"message:@"Weet je zeker dat je deze informatie wil wissen?" delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Aanpassen", nil];
    
    [alert show];
    alert.tag = 2;
    
}

-(void) funkAlert1: (id) sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verwijderen"message:@"Weet je zeker dat je deze informatie wil wissen?" delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Aanpassen", nil];
    
    [alert show];
    self.sen = sender;
    alert.tag = 3;
    
}
-(void) deleteRow: (id) sender {
     UIButton *clicked = (UIButton *) sender;
     NSLog(@"%d",clicked.tag);
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:[self.devices objectAtIndex:clicked.tag]];
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    
    // Remove device from table view
    [self.devices removeObjectAtIndex:clicked.tag];
    [self.tableView reloadData];
   // [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
    
    
}

-(void) updateRow: (id) sender {
    NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    // AddKidsViewController *destViewController = segue.destinationViewController;
    //  destViewController.device = selectedDevice;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddKidsViewController *privacy = (AddKidsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"add"];
    privacy.device = selectedDevice;
    // present
    [self presentViewController:privacy animated:YES completion:nil];
    NSLog(@"cancel");
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   /* if ([[segue identifier] isEqualToString:@"Update"]) {
        NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        AddKidsViewController *destViewController = segue.destinationViewController;
        destViewController.device = selectedDevice;
    }*/
}

@end

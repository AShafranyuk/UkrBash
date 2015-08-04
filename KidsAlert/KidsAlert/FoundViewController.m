//
//  FoundViewController.m
//  KidsAlert
//
//  Created by Admin on 22.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "FoundViewController.h"
#import "User.h"
#import <CoreData/CoreData.h>

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end
@interface FoundViewController ()

@property (strong) NSMutableArray *devices;

@end

@implementation FoundViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Alert"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    User *newUser = [User sharedManager];
    
    NSLog(@"%@",self.devices);
    for(int i = 0; i< self.devices.count; i++)
    {
        NSManagedObject *device = [self.devices objectAtIndex:i];

        if([[device valueForKey:@"id"] isEqualToString:newUser.kidId ])
        {
            NSString * photo = [@"http://37.48.84.185/images/" stringByAppendingString:[device valueForKey:@"photo"]];
            NSURL * url = [NSURL URLWithString:photo];
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue currentQueue]
                                   completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
                                       
                                       // No error handling - check `error` if you want to
                                       UIImage * img = [UIImage imageWithData:data];
                                       [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
                                       
                                   }];
            NSString * found = [[device valueForKey:@"name"] stringByAppendingString:@" is gevonden!"];
            self.kidName.text = found;
            
            
            
           
            
                // Delete object from database
            [managedObjectContext deleteObject:[self.devices objectAtIndex:i]];
            [self.devices removeObjectAtIndex:i];

        }
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

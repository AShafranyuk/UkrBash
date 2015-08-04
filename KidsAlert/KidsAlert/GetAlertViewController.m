//
//  GetAlertViewController.m
//  KidsAlert
//
//  Created by Admin on 22.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "GetAlertViewController.h"
#import "User.h"

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end

@interface GetAlertViewController ()
@property (strong) NSMutableArray *devices;
@end

@implementation GetAlertViewController
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self sendId];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
    [self.imageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTaped:)];
    singleTap1.numberOfTapsRequired = 1;
    singleTap1.numberOfTouchesRequired = 1;
    [self.kidPhone addGestureRecognizer:singleTap1];
    [self.kidPhone setUserInteractionEnabled:YES];
    
    
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
            NSString * photo = [@"http://37.48.84.185/" stringByAppendingString:[device valueForKey:@"photo"]];
            NSURL * url = [NSURL URLWithString:photo];
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue currentQueue]
                                   completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
                                       
                                       // No error handling - check `error` if you want to
                                       UIImage * img = [UIImage imageWithData:data];
                                       [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
                                       
                                   }];
            
            self.kidName.text = [device valueForKey:@"name"];
            
            self.kidGender.text =  [device valueForKey:@"gender"];
            self.kidAge.text =  [device valueForKey:@"age"];
            self.kidHair.text =  [device valueForKey:@"hair_color"];
            self.kidEye.text = [device valueForKey:@"eye_color"];
            self.kidLastSeen.text = [device valueForKey:@"last_seen"];
            self.kidHight.text = [device valueForKey:@"height"];
            self.kidWeight.text = [device valueForKey:@"weight"];
            self.kidClothes.text = [device valueForKey:@"clothing"];
            self.kidSpecial.text = [device valueForKey:@"special_features"];
            self.kidPhone.text = [device valueForKey:@"telephone"];
            
            
            
            // Delete object from database
            
            
        }
    }




}
-(void) viewDidAppear{
      }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"fff1");
    _imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    
    _imageHolder.image = self.imageView.image;
    // optional:
    // [imageHolder sizeToFit];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.imageHolder action:@selector(imageTaped1:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    [self.view setUserInteractionEnabled:YES];
    
    
    [self.view addSubview:_imageHolder];
    
    
}

- (void)imageTaped1:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"fff2");
    [_imageHolder removeFromSuperview];
}


- (void)labelTaped:(UIGestureRecognizer *)gestureRecognizer {
    NSString * alertm = [@"Phone on this number: " stringByAppendingString:self.kidPhone.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:alertm delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Telefoongesprek", nil];
    alert.tag = 1;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if(alert.tag == 1)
    {
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        }
        else
        {
            NSLog(@"ok");
            NSString * tel = [@"tel:" stringByAppendingString:self.kidPhone.text];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
    }
}

@end

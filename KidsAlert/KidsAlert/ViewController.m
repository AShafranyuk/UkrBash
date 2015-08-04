//
//  ViewController.m
//  KidsAlert
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "SettingsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MenuAlertViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define URL            @"http://37.48.84.185"

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end

@interface ViewController () <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;}

@end

@implementation ViewController
- (NSManagedObjectContext *)managedObjectContext {
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
    
    
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // Will get here on both iOS 7 & 8 even though camera permissions weren't required
            // until iOS 8. So for iOS 7 permission will always be granted.
            if (granted) {
                // Permission has been granted. Use dispatch_async for any UI updating
                // code because this block may be executed in a thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            } else {
                // Permission has been denied.
            }
        }];
    }

    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    

    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSLog(@"%i",[group numberOfAssets]);
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access, code: %i",error.code);
        }else{
            NSLog(@"Other error code: %i",error.code);
        }
    }];
    
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray * users = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if( users.count > 0 )
    {
        NSManagedObject *device = [users objectAtIndex:users.count - 1];
        self.userID = [device valueForKey:@"id"];
    }

    //-----make round button----
    _button.layer.cornerRadius = 2.5f;
    _button1.layer.cornerRadius = 2.5f;
    _button3.layer.cornerRadius = 2.5f;
    if([UIScreen mainScreen].bounds.size.width>400){
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        _button1.titleLabel.font = [UIFont systemFontOfSize:15];
        _but.font = [UIFont systemFontOfSize:15];

    }
    
    //-----location------
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
   // if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self->locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self->locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]))
        {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"])
            {
                [self->locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"])
            {
                [self->locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
   // }
    [self->locationManager startUpdatingLocation];
    

    
    /*----------view----------------*/
    UIImageView *imgview;
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/5)];
    } else {
        imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/4 + 70)];
    }
    [imgview setImage:[UIImage imageNamed:@"kids_image.png"]];
    imgview.tag = 2;
    [self.view addSubview:imgview];
    
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
    UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        [button4 setFrame:CGRectMake(0, 65 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width, 45)];
    } else {
        [button4 setFrame:CGRectMake(0, 65 + [UIScreen mainScreen].bounds.size.height/4 + 70, [UIScreen mainScreen].bounds.size.width, 45)];
    }
    button4.backgroundColor = [UIColor colorWithRed:58.0/255.0
                                             green:164.0/255.0
                                              blue:212.0/255.0
                                             alpha:1.0];
    [button4 setTitle:@"WELKOM BIJ KIDSALERT" forState:UIControlStateNormal];
    if([UIScreen mainScreen].bounds.size.width<400)
    {
        button4.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    else {
        button4.titleLabel.font = [UIFont systemFontOfSize:25];
    }
    button4.tag = 1;
    [self.view addSubview:button4];
    
    CGRect textViewFrame;
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        textViewFrame = CGRectMake(20, 145 + [UIScreen mainScreen].bounds.size.height/5 , [UIScreen mainScreen].bounds.size.width-40, 230);
    } else {
        textViewFrame = CGRectMake(15, 125 + [UIScreen mainScreen].bounds.size.height/4 + 70 , [UIScreen mainScreen].bounds.size.width-30, 250);
    }
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    textView.text = @"Je kind uit het oog verloren?\nJe zoekt en kunt ze niet direct vinden?\nGeen paniek\nWaar je ook bent, thuis, op vakantie, in de dierentuin of in een pretpark\nStuur direct een Alert via de app en iedereen in de directe omgeving zoekt met je mee!\n";
    if([UIScreen mainScreen].bounds.size.width<400)
    {
        [textView setFont:[UIFont systemFontOfSize:16]];
    } else {
        [textView setFont:[UIFont systemFontOfSize:19]];
    }
    textView.returnKeyType = UIReturnKeyDone;
    textView.editable = NO;
    [textView setTextAlignment:NSTextAlignmentCenter];
    textView.backgroundColor = [UIColor colorWithRed:239.0/255.0
                                               green:239.0/255.0
                                                blue:244.0/255.0
                                               alpha:1.0];
    textView.tag = 3;
    [self.view addSubview:textView];
    [_button1 addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchDown];
  
}
//----you can not open settings without registration-----
-(void) setting {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Om gebruik te maken van de instellingen dient u eerst te registreren of ingelogd te zijn!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
}
//-----dismiss Alert-----
-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
//------Rotation-----
-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 2 || subView.tag == 1 || subView.tag == 3)
        {
            [subView removeFromSuperview];
        }
    }
    [self viewDidLoad];
    NSLog(@"!!!!!!!");
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
  //  UIAlertView *errorAlert = [[UIAlertView alloc]
  //                             initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
   // [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    CLLocation *oldLocations = oldLocation;
    User *newUser = [User sharedManager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *log = [defaults valueForKey:@"UserId"];
    //NSString * token = [defaults objectForKey:@"DeviceToken"];
    NSString * push = [defaults objectForKey:@"push"];
    NSString * whatsApp = [defaults objectForKey:@"whatsApp"];
    NSString * email = [defaults objectForKey:@"email"];
    float a =currentLocation.coordinate.longitude - oldLocations.coordinate.longitude;
    float b =currentLocation.coordinate.latitude - oldLocations.coordinate.latitude;
    NSLog(@" %f     %f",fabs(a), fabs(b));
   // if (currentLocation != nil &&  log != nil){
     if ((fabs(a)>0.0001 || fabs(b)>0.0001 )) {
    NSLog(@"%@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
    NSLog(@"%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    
    NSDictionary *o1 = [[NSMutableDictionary alloc] init];
    [o1 setValue: log forKey:@"user_id"];
    [o1 setValue:[NSNumber numberWithFloat:currentLocation.coordinate.longitude] forKey:@"loc_lng"];
    [o1 setValue:[NSNumber numberWithFloat:currentLocation.coordinate.latitude] forKey:@"loc_lat"];
    if(newUser.userEmail != nil)
        [o1 setValue:newUser.userEmail forKey:@"email"];
    if(newUser.userPhone != nil)
    {
        [o1 setValue:newUser.userPhone forKey:@"telephone"];
    }
   // [o1 setValue: token forKey:@"push_code"];
    if(push != nil)
    {
        if([push isEqualToString:@"YES"])
        {
            [o1 setValue: @"1" forKey:@"app_alert"];
        } else
        {
            [o1 setValue: @"0" forKey:@"app_alert"];
        }
    }
    if(whatsApp != nil)
    {
        if([whatsApp isEqualToString:@"YES"])
        {
            [o1 setValue: @"1" forKey:@"whats_app_alert"];
        } else
        {
            [o1 setValue: @"0" forKey:@"whats_app_alert"];
        }
    }
    if(email != nil)
    {
        if([email isEqualToString:@"YES"])
        {
            [o1 setValue: @"1" forKey:@"email_alert"];
        } else
        {
            [o1 setValue: @"0" forKey:@"email_alert"];
        }
    }
        
    NSString * url = [URL stringByAppendingString:@"/update"];
    NSURL *myWebserverURL = [NSURL URLWithString:url];
        
    // Create the request
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:myWebserverURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        
    // Set the HTTP method.
    [theRequest setHTTPMethod:@"POST"];
        
    // Set useful headers
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1 options:NSJSONWritingPrettyPrinted error:nil];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    // NSData *theData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody: jsonData];
        
    // Use the private method setAllowsAnyHTTPSCertificate:forHost:
    // to not validate the HTTPS certificate.
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:URL];
        
    // Create the NSURLConnection and init the request.
    NSURLConnection *st = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"%@", st);
    //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"start1"];
    [defaults setObject:@"" forKey:@"userEmail"];
    [defaults setObject:@"" forKey:@"userPhone"];
    [defaults synchronize];
        
    [defaults setObject:@"" forKey:@"userEmail11"];
    [defaults setObject:@""forKey:@"userPhone11"];
    [defaults setObject:@"" forKey:@"userEmail22"];
    [defaults setObject:@""forKey:@"userPhone22"];
     }}

-(void) viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *log = [defaults valueForKey:@"UserId"];
    if(![log isEqual:@"nil"] && log != nil)
    {
        MenuAlertViewController *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuAlert"];
        [self presentViewController:monitorMenuViewController animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response recieved");
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data
{
    NSLog(@"Data recieved");
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);

}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Authentication challenge");
    
    // load cert
    NSString *path = [[NSBundle mainBundle] pathForResource:@"amber" ofType:@"p12"]; 
    NSData *p12data = [NSData dataWithContentsOfFile:path];
    CFDataRef inP12data = (__bridge CFDataRef)p12data;
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    OSStatus status = extractIdentityAndTrust2(inP12data, &myIdentity, &myTrust);
    NSLog(@"%d", (int)status);
    SecCertificateRef myCertificate;
    SecIdentityCopyCertificate(myIdentity, &myCertificate);
    const void *certs[] = { myCertificate };
    CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
    
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
    
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection*) connection didFailWithError:(NSError *)error
{
    //  NSLog([NSString stringWithFormat:@"Did recieve error: %@", [error localizedDescription]]);
    //  NSLog([NSString stringWithFormat:@"%@", [error userInfo]]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

OSStatus extractIdentityAndTrust2(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
{
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("111111");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12data, options, &items);
    
    if (securityError == 0)
    {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }
    
    if (options)
    {
        CFRelease(options);
    }
    
    return securityError;
}


@end

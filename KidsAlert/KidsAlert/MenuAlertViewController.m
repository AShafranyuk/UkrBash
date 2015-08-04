//
//  MenuAlertViewController.m
//  KidsAlert
//
//  Created by Admin on 07.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MenuAlertViewController.h"
#import "LoginMenuViewController.h"
#import "ViewController.h"
#import "User.h"
#import "AddKidsViewController.h"

#define URL            @"http://37.48.84.185"

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
@interface MenuAlertViewController ()

@end

@implementation MenuAlertViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray * users = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if( users.count > 0 ) {
        NSManagedObject *device = [users objectAtIndex:users.count - 1];
        
        self.userID = [device valueForKey:@"id"];
        
    }
    // Do any additional setup after loading the view.
    _btn.layer.cornerRadius = 2.5f;
    _btn1.layer.cornerRadius = 2.5f;
    _btn2.layer.cornerRadius = 2.5f;
    
    if([UIScreen mainScreen].bounds.size.width>400){
        _btn.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        
    }

    
    
   [self.btn2 addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
 
    
    
    /*----------------view--------------------*/
    
    UIImageView *imgview;
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        imgview = [[UIImageView alloc]
                   initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/5)];
    } else {
        imgview = [[UIImageView alloc]
                   initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/4 + 70)];
    }
    [imgview setImage:[UIImage imageNamed:@"kids_image.png"]];
    imgview.tag = 1;
    [self.view addSubview:imgview];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        [button setFrame:CGRectMake(0, 65 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width, 45)];
    } else {
        [button setFrame:CGRectMake(0, 65 + [UIScreen mainScreen].bounds.size.height/4 + 70, [UIScreen mainScreen].bounds.size.width, 45)];
    }
    button.backgroundColor = [UIColor colorWithRed:58.0/255.0
                                             green:164.0/255.0
                                              blue:212.0/255.0
                                             alpha:1.0];
    [button setTitle:@"WELKOM BIJ KIDSALERT" forState:UIControlStateNormal];
    if([UIScreen mainScreen].bounds.size.width<400){
        button.titleLabel.font = [UIFont systemFontOfSize:18];}
    else { button.titleLabel.font = [UIFont systemFontOfSize:25];}
    button.tag = 2;
    [self.view addSubview:button];
    
    
    
    
    
    
    UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
    [buttonAdd setFrame:CGRectMake(30, 140 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-60, 35)];
    } else {
        [buttonAdd setFrame:CGRectMake(30, 140 + [UIScreen mainScreen].bounds.size.height/4+70, [UIScreen mainScreen].bounds.size.width-60, 35)];
    }
    buttonAdd.backgroundColor = [UIColor whiteColor];
    [buttonAdd setTitle:@"GEGEVENS KIND" forState:UIControlStateNormal];
        buttonAdd.titleLabel.font = [UIFont systemFontOfSize:20];
    [buttonAdd setTitleColor:[UIColor colorWithRed:70.0/255.0
                                             green:155.0/255.0
                                              blue:194.0/255.0
                                             alpha:1.0] forState:UIControlStateNormal];
    [buttonAdd addTarget:self
                  action:@selector(add)
        forControlEvents:UIControlEventTouchDown];
    buttonAdd.tag = 3;
    [self.view addSubview:buttonAdd];
    
    
    UIButton *buttonAddList = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
         [buttonAddList setFrame:CGRectMake(30, 185 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-60, 35)];
    } else {
         [buttonAddList setFrame:CGRectMake(30, 185 + [UIScreen mainScreen].bounds.size.height/4+70, [UIScreen mainScreen].bounds.size.width-60, 35)];
    }
    
    buttonAddList.backgroundColor = [UIColor whiteColor];
    [buttonAddList setTitle:@"LIJST KINDEREN" forState:UIControlStateNormal];
    buttonAddList.titleLabel.font = [UIFont systemFontOfSize:20];
    [buttonAddList setTitleColor:[UIColor colorWithRed:70.0/255.0
                                             green:155.0/255.0
                                              blue:194.0/255.0
                                             alpha:1.0] forState:UIControlStateNormal];
    [buttonAddList addTarget:self
                  action:@selector(addList)
        forControlEvents:UIControlEventTouchDown];
    buttonAddList.tag = 4;
    [self.view addSubview:buttonAddList];
    
    UIButton *buttonSend = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        [buttonSend setFrame:CGRectMake(30, 230 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-60, 35)];
    } else {
        [buttonSend setFrame:CGRectMake(30, 230 + [UIScreen mainScreen].bounds.size.height/4+70, [UIScreen mainScreen].bounds.size.width-60, 35)];
    }
    
    buttonSend.backgroundColor = [UIColor whiteColor];
    [buttonSend setTitle:@"STUUR ALERT" forState:UIControlStateNormal];
    buttonSend.titleLabel.font = [UIFont systemFontOfSize:20];
    [buttonSend setTitleColor:[UIColor colorWithRed:70.0/255.0
                                                 green:155.0/255.0
                                                  blue:194.0/255.0
                                                 alpha:1.0] forState:UIControlStateNormal];
    [buttonSend addTarget:self
                      action:@selector(send)
            forControlEvents:UIControlEventTouchDown];
    buttonSend.tag = 5;
    [self.view addSubview:buttonSend];
    
    
    
    UIButton * buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        [buttonView setFrame:CGRectMake(30, 275 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-60, 35)];
    } else {
        [buttonView setFrame:CGRectMake(30, 275 + [UIScreen mainScreen].bounds.size.height/4 + 70, [UIScreen mainScreen].bounds.size.width-60, 35)];
    }
    
    buttonView.backgroundColor = [UIColor whiteColor];
    [buttonView setTitle:@"AFMELDEN ALERT" forState:UIControlStateNormal];
    buttonView.titleLabel.font = [UIFont systemFontOfSize:20];
    [buttonView setTitleColor:[UIColor colorWithRed:70.0/255.0
                                                 green:155.0/255.0
                                                  blue:194.0/255.0
                                                 alpha:1.0] forState:UIControlStateNormal];
    [buttonView addTarget:self
                      action:@selector(view1)
            forControlEvents:UIControlEventTouchDown];
    buttonView.tag = 6;
    [self.view addSubview:buttonView];
    
    User * user = [User sharedManager];
    if([user.badge isEqualToString:@"1"])
    {
        
        UILabel *lbl_card_count = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100,9, 17, 17)];
        lbl_card_count.textColor = [UIColor whiteColor];
        lbl_card_count.textAlignment = NSTextAlignmentCenter;
        lbl_card_count.text = [NSString stringWithFormat:@"%@", user.badge];
        lbl_card_count.layer.borderWidth = 1;
        lbl_card_count.layer.cornerRadius = 6;
        lbl_card_count.layer.masksToBounds = YES;
        lbl_card_count.layer.borderColor =[[UIColor clearColor] CGColor];
        lbl_card_count.layer.shadowColor = [[UIColor clearColor] CGColor];
        lbl_card_count.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lbl_card_count.layer.shadowOpacity = 0.0;
        lbl_card_count.backgroundColor = [UIColor redColor]; //colorWithRed:247.0/255.0 green:45.0/255.0 blue:143.0/255.0 alpha:1.0];
        lbl_card_count.font = [UIFont fontWithName:@"ArialMT" size:11];
        [buttonView addSubview:lbl_card_count];
    }


}


-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 2 || subView.tag == 1 || subView.tag == 3 ||subView.tag == 4 || subView.tag == 5 || subView.tag == 6)
        {
            [subView removeFromSuperview];
        }
    }
    [self viewDidLoad];
    NSLog(@"!!!!!!!");
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) login {

    
    
        [self logOut];
    
}

- (void)logOut {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSString * token = [defaults objectForKey:@"DeviceToken"];
    NSString *log = [defaults objectForKey:@"UserId"];
    NSDictionary *o1 = [[NSMutableDictionary alloc] init];
    [o1 setValue:log  forKey:@"user_id"];//[NSNumber numberWithInteger:log]  forKey:@"user_id"];
    [o1 setValue:token forKey:@"push_code"];
    NSURL *myWebserverURL = [NSURL URLWithString:@"http://37.48.84.185/logout"];
    
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
   //x [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"http://tratala.esy.es"];
    
    // Create the NSURLConnection and init the request.
    NSURLConnection *st = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"%@", st);
    
   
    
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
    
    NSError *jsonError;
    NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if( [[json objectForKey:@"status"] isEqualToString:@"Logout"])
    {
        ViewController *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Privacy"];
        [self presentViewController:monitorMenuViewController animated:YES completion:nil];
        [defaults setObject:@"nil" forKey:@"UserId"];
        [defaults synchronize];
    } else {
        ViewController *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Privacy"];
        [self presentViewController:monitorMenuViewController animated:YES completion:nil];
        [defaults setObject:@"nil" forKey:@"UserId"];
        [defaults synchronize];
    }

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    User * user = [User sharedManager];
    user.badge = @"0";
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
    OSStatus status = extractIdentityAndTrust8(inP12data, &myIdentity, &myTrust);
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

OSStatus extractIdentityAndTrust8(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
{
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("111111");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}



-(void) add{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddKidsViewController *privacy = (AddKidsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"add"];
    [self presentViewController:privacy animated:YES completion:nil];

}

-(void) addList {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *privacy = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"addList"];
    [self presentViewController:privacy animated:YES completion:nil];
}

-(void) send{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *privacy = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"send"];
    [self presentViewController:privacy animated:YES completion:nil];
}

-(void) view1{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *privacy = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"view"];
    [self presentViewController:privacy animated:YES completion:nil];
}


@end

//
//  PushViewController.m
//  KidsAlert
//
//  Created by Admin on 24.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PushViewController.h"
#import "MenuAlertViewController.h"


#define URL            @"http://37.48.84.185"

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end
@interface PushViewController ()

@end

@implementation PushViewController
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.find == NO)
    {
        [self.iFind setEnabled:NO];
        self.iFind.backgroundColor = [UIColor clearColor];
    }
    
    if (self.device2)
    {
        UIImage* image;
        if ([[self.device2 valueForKey:@"photo"] isKindOfClass:[NSString class]] )
        {
            NSString * url1 = [URL stringByAppendingString:@"/images/"];
            NSString * photo = [url1 stringByAppendingString:[self.device2 valueForKey:@"photo"]];
            NSURL * url = [NSURL URLWithString:photo];
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [[UIImage alloc] initWithData:data];
        } else
        {
            image = [UIImage imageWithData:[self.device2 valueForKey:@"photo"]];
        }
        NSString * phone;
        if([[self.device2 valueForKey:@"telephone"] hasPrefix:@"++"]){
            phone = [[self.device2 valueForKey:@"telephone"] substringFromIndex:1];
        } else if([[self.device2 valueForKey:@"telephone"] hasPrefix:@"+"]){
            phone = [self.device2 valueForKey:@"telephone"];
        }else {
            phone =[@"+" stringByAppendingString:[self.device2 valueForKey:@"telephone"]];
        }

        self.kidImage.image = image;
        [self.kidName setText:[self.device2 valueForKey:@"name"]];
        [self.kidGender setText:[self.device2 valueForKey:@"gender"]];
        [self.kidAge setText:[self.device2 valueForKey:@"age"]];
        [self.kidHair setText:[self.device2 valueForKey:@"hair_color"]];
        [self.kidEye setText:[self.device2 valueForKey:@"eye_color"]];
        [self.kidHeight setText:[self.device2 valueForKey:@"height"]];
        [self.kidWeight setText:[self.device2 valueForKey:@"weight"]];
        [self.kidSpecial setText:[self.device2 valueForKey:@"special_features"]];
        [self.kidSpecialTView setText:[self.device2 valueForKey:@"special_features"]];
        [self.kidLastSeen setText:[self.device2 valueForKey:@"last_seen"]];
        [self.kidClothes setText:[self.device2 valueForKey:@"clothing"]];
        [self.kidPhone setText:phone];
        [self.kidSpecial sizeToFit];
    }
    _activityView = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Do any additional setup after loading the view.
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.kidImage addGestureRecognizer:singleTap];
    [self.kidImage setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTaped:)];
    singleTap1.numberOfTapsRequired = 1;
    singleTap1.numberOfTouchesRequired = 1;
    [self.kidPhone addGestureRecognizer:singleTap1];
    [self.kidPhone setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTaped:)];
    singleTap2.numberOfTapsRequired = 1;
    singleTap2.numberOfTouchesRequired = 1;
    [self.phoneIm addGestureRecognizer:singleTap2];
    [self.phoneIm setUserInteractionEnabled:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - make image bigger
- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"fff1");
    _imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    _imageHolder.image = self.kidImage.image;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped1:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    [self.view setUserInteractionEnabled:YES];
    [self.view addSubview:_imageHolder];
    
}

- (void)phoneTaped:(UIGestureRecognizer *)gestureRecognizer
{
    if (  UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        NSString * alertm = [@"Bel dit nummer a.u.b. :" stringByAppendingString:self.kidPhone.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:alertm delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Telefoongesprek", nil];

        alert.tag = 1;
        [alert show];
    }
}

#pragma mark - remove image
- (void)imageTaped1:(UIGestureRecognizer *)gestureRecognizer {
     NSLog(@"fff2");
    [_imageHolder removeFromSuperview];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageHolder;
}

- (void)labelTaped:(UIGestureRecognizer *)gestureRecognizer
{
    if (  UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        NSString * alertm = [@"Bel dit nummer a.u.b. :" stringByAppendingString:self.kidPhone.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:alertm delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Telefoongesprek", nil];

        alert.tag = 1;
        [alert show];
    }
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
    if(alert.tag == 2)
    {
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        }
        else
        {
            NSLog(@"ok");
             NSManagedObjectContext *context = [self managedObjectContext];
            [context deleteObject:self.device2];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MenuAlertViewController *privacy = (MenuAlertViewController*)[storyboard instantiateViewControllerWithIdentifier:@"menuAlert"];
            // present
            [self presentViewController:privacy animated:YES completion:nil];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert is verwijderd!"
                                                            message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            
            [alert show];
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        }
    }
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)find:(id)sender
{
    [self.iFind setEnabled:NO];
    self.iFind.userInteractionEnabled = NO;

    
    NSDictionary *o1 = [[NSMutableDictionary alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *log = [defaults objectForKey:@"UserId"];
    [o1 setValue:log forKey:@"user"];
    [o1 setValue:[self.device2 valueForKey:@"id"] forKey:@"alert_id"];

    NSString * url = [URL stringByAppendingString:@"/found"];
    
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
   // [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:URL];
    
    // Create the NSURLConnection and init the request.
    NSURLConnection *s = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"%@", s);
    
    
    [_activityView startAnimating];
    [self.wait addSubview:_activityView];
}


- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response recieved");
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data
{
    NSLog(@"Data recieved");
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"DATA%@", responseString);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"start1"];
    [defaults synchronize];
    
    NSError *jsonError;
    NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    if([[json objectForKey:@"status"] isEqualToString:@"ok"] )
    {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Verwijderen alert?" delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Verwijderen", nil];
        alert.tag = 2;
        [alert show];
        [_activityView stopAnimating];
    }
    
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
    OSStatus status = extractIdentityAndTrust12(inP12data, &myIdentity, &myTrust);
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

OSStatus extractIdentityAndTrust12(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
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

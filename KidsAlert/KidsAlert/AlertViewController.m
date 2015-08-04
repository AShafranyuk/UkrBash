//
//  AlertViewController.m
//  KidsAlert
//
//  Created by Admin on 16.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AlertViewController.h"
#import "HSDatePickerViewController.h"
#import "User.h"
#import <CoreGraphics/CoreGraphics.h>
#import "MenuAlertViewController.h"


#define URL            @"http://37.48.84.185"


//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end

@interface AlertViewController ()<HSDatePickerViewControllerDelegate>

@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation AlertViewController

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
    
    _kidName.delegate = self;
    _kidAge.delegate= self;
    _kidGender.delegate = self;
    _kidHair.delegate = self;
    _kidEye.delegate = self;
    _kidGrowth.delegate = self;
    _kidWeigth.delegate = self;
    _kidSpecial.delegate = (id)self;
    _kidPhone.delegate = self;
    _kidClothes.delegate = self;
    _radius = @"5000";
    _activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"t"] hasPrefix:@"++"]){
        self.kidPhone.text = [[defaults objectForKey:@"t"] substringFromIndex:1];
    } else {
        self.kidPhone.text = [defaults objectForKey:@"t"];
    }
    if (self.device)
    {
        [self.kidName setText:[self.device valueForKey:@"name"]];
        [self.kidGender setText:[self.device valueForKey:@"gender"]];
        [self.kidAge setText:[self.device valueForKey:@"age"]];
        [self.kidHair setText:[self.device valueForKey:@"hair"]];
        [self.kidEye setText:[self.device valueForKey:@"eye"]];
        [self.kidGrowth setText:[self.device valueForKey:@"growth"]];
        [self.kidWeigth setText:[self.device valueForKey:@"weight"]];
         self.kidSpecial.text  = [self.device valueForKey:@"special"];
        UIImage *image = [UIImage imageWithData:[self.device valueForKey:@"photo"]];
        self.image.image = image;
    }
    
 //-------padding--------
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidName.leftView = paddingView;
    _kidName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidAge.leftView = paddingView1;
    _kidAge.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidGender.leftView = paddingView2;
    _kidGender.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidHair.leftView = paddingView3;
    _kidHair.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidEye.leftView = paddingView4;
    _kidEye.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidGrowth.leftView = paddingView5;
    _kidGrowth.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidWeigth.leftView = paddingView6;
    _kidWeigth.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidPhone.leftView = paddingView7;
    _kidPhone.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidLAstSeen.leftView = paddingView8;
    _kidLAstSeen.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _kidClothes.leftView = paddingView9;
    _kidClothes.leftViewMode = UITextFieldViewModeAlways;
//------------
    
    _kidClothes.delegate = self;
    _kidLastSeen = [[NSString alloc] init];
    
     if(_kidSpecial.text.length == 0 || [_kidSpecial.text  isEqual: @"Bijzonderheden"])
     {
         _kidSpecial.text = @"Bijzonderheden";
         _kidSpecial.textColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:197/255.0f alpha:1.0f];
         _kidSpecial.delegate = (id)self;
     }
    
    
    
//--------DropDown List ---------
    entries2 = [[NSArray alloc] initWithObjects:@"Blauw",@"Groen", @"Bruin", @"Grijs",nil];
    selectionStates2 = [[NSMutableDictionary alloc] init];
    UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 10)];
    img2.image=[UIImage imageNamed:@"add.jpg"];
    [self.kidEyebtn addSubview:img2];
    [self.kidEyebtn addTarget:self action:@selector(getData2) forControlEvents:UIControlEventTouchUpInside];
    
    
    entries1 = [[NSArray alloc] initWithObjects:@"Zwart", @"Blond", @"Rood", @"Bruin",nil];
    selectionStates1 = [[NSMutableDictionary alloc] init];
    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 10)];
    img1.image=[UIImage imageNamed:@"add.jpg"];
    [self.kidHairbtn addSubview:img1];
    [self.kidHairbtn addTarget:self action:@selector(getData1) forControlEvents:UIControlEventTouchUpInside];
    
    
    entries3 = [[NSArray alloc] initWithObjects:@"Meisje", @"Jongen",nil];
    selectionStates3 = [[NSMutableDictionary alloc] init];
    UIImageView *img3=[[UIImageView alloc]initWithFrame:CGRectMake( 20, 10, 15, 10)];
    img3.image=[UIImage imageNamed:@"add.jpg"];
    NSLog(@"%f", self.kidGender.frame.size.width);
    [self.kidGenderbtn addSubview:img3];
    [self.kidGenderbtn addTarget:self action:@selector(getData3) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - text view placeholder
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ( [_kidSpecial.textColor isEqual:[UIColor colorWithRed:191/255.0f green:191/255.0f blue:197/255.0f alpha:1.0f]])
    {
        _kidSpecial.text = @"";
        _kidSpecial.textColor = [UIColor colorWithRed:85/255.0f green:85/255.0f blue:85/255.0f alpha:1.0f];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(_kidSpecial.text.length == 0 ||  [_kidSpecial.text  isEqual: @"Bijzonderheden"])
    {
        _kidSpecial.textColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:197/255.0f alpha:1.0f];
        _kidSpecial.text = @"Bijzonderheden";
       [_kidSpecial resignFirstResponder];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Date Picker
- (IBAction)showDatePicker:(id)sender
{
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    if (self.selectedDate)
    {
        hsdpvc.date = self.selectedDate;
    }
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm";
    self.kidLAstSeen.text = [dateFormater stringFromDate:date];
    self.kidLastSeen = [dateFormater stringFromDate:date];
    self.selectedDate = date;
}

//optional
- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker did dismiss with %lu", (unsigned long)method);
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker will dismiss with %lu", (unsigned long)method);
}

#pragma mark - random image name
-(NSString *) randomString {
    NSString *letters = @"123456789qwertyuiopasdfghjklzxcvbnm";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 6];
    for (int i=0; i<6; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

#pragma mark - Send Image
-(void) sendImage {
    NSData *imageData = UIImagePNGRepresentation(_image.image);
    // encodedImage = UIImagePNGRepresentation(imgRef);
    NSString * url = [URL stringByAppendingString:@"/upload"];
    NSURL *myWebserverURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myWebserverURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    _kidPhotoName = [[self randomString] stringByAppendingString:@".png"];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", _kidPhotoName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    
   // [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:URL];
    
    // Create the NSURLConnection and init the request.
    NSURLConnection *st = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"%@", st);
    [_activityView startAnimating];
    [self.waitView setEnabled:NO];
    self.waitView.userInteractionEnabled = NO;
}

#pragma mark - Send Alert
- (IBAction)sendAlert:(id)sender
{
    if ([self.kidLAstSeen.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'laatst gezien' en probeer het opnieuw!"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    else if ([self.kidClothes.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'kleding' en probeer het opnieuw!"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    else if (self.kidPhone.text.length != 12)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vul het juiste telefoonnummer in!"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    else if([self.kidName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'voornaam' en probeer het opnieuw"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    else if([self.kidGender.text isEqualToString:@""] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vul het geslacht in a.u.b.!"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    else if([self.kidAge.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'leeftijd' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidHair.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'haarkleur' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidEye.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"  Controleer 'oogkleur' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidGrowth.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Controleer 'lengte' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidWeigth.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Controleer 'gewicht' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }else
    {
        [self sendImage];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *log = [defaults valueForKey:@"UserId"];
        
        NSDictionary *o1 = [[NSMutableDictionary alloc] init];
        
        NSString * phone;
        if ([self.kidPhone.text hasPrefix:@"+31"] && [self.kidPhone.text length] > 11)
        {
            phone = [self.kidPhone.text substringFromIndex:3];
        }
        
        [o1 setValue:log  forKey:@"user_id"];
        [o1 setValue:self.kidName.text forKey:@"name"];
        [o1 setValue:self.kidGender.text forKey:@"gender"];
        [o1 setValue:self.kidAge.text forKey:@"age"];
        [o1 setValue:self.kidHair.text forKey:@"hair_color"];
        [o1 setValue:self.kidEye.text forKey:@"eye_color"];
        [o1 setValue:self.kidGrowth.text forKey:@"height"];
        [o1 setValue:self.kidWeigth.text forKey:@"weight"];
        [o1 setValue:self.kidClothes.text forKey:@"clothing"];
        [o1 setValue:self.kidSpecial.text forKey:@"special_features"];
        [o1 setValue:self.radius forKey:@"search_radius"];
        [o1 setValue:self.kidLastSeen forKey:@"last_seen"];
        [o1 setValue:self.kidPhotoName forKey:@"photo"];
        [o1 setValue:phone forKey:@"telephone"];
        
        
        NSString * url = [URL stringByAppendingString:@"/alert"];
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
        NSURLConnection *st = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        NSLog(@"%@", st);
        
        // _activityView.center=self.waitView1.center;
        
        [_activityView startAnimating];
        [self.waitView1 addSubview:_activityView];
        // self.waitView.userInteractionEnabled = YES;
        self.waitView.titleLabel.text = @"";
    }
}



- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response recieved");
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data
{
    NSLog(@"Data recieved");
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"DATA   %@", responseString);
    NSError *jsonError;
    NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];

    NSLog(@"DATA   %@", json);
    

    
    
    if ([json objectForKey:@"error"])
    {
        NSString *data1 = [json objectForKey:@"error"];
        NSLog(@"DATA   %@", data1);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:data1
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if([json objectForKey:@"alert_id"])
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Alert1" inManagedObjectContext:context];
        
        NSString * phone;
        if ([self.kidPhone.text hasPrefix:@"+"] && [self.kidPhone.text length] > 1)
        {
            phone = [self.kidPhone.text substringFromIndex:1];
        }
        
        [newDevice setValue:self.kidName.text forKey:@"name"];
        [newDevice setValue:self.kidGender.text forKey:@"gender"];
        [newDevice setValue:self.kidAge.text forKey:@"age"];
        NSData *imageData = UIImagePNGRepresentation(_image.image);
        [newDevice setValue:imageData forKey:@"photo"];
         [newDevice setValue:[json objectForKey:@"alert_id"] forKey:@"id"];
        // [newDevice setValue:[json objectForKey:@"user_id"] forKey:@"user_id"];
        [newDevice setValue:self.kidHair.text forKey:@"hair_color"];
        [newDevice setValue:self.kidEye.text forKey:@"eye_color"];
        [newDevice setValue:self.kidGrowth.text forKey:@"height"];
        [newDevice setValue:self.kidWeigth.text forKey:@"weight"];
        [newDevice setValue:self.kidClothes.text forKey:@"clothing"];
        [newDevice setValue:self.kidSpecial.text forKey:@"special_features"];
        [newDevice setValue:self.kidRadius.text forKey:@"search_radius"];
        [newDevice setValue:self.kidLAstSeen.text forKey:@"last_seen"];
        [newDevice setValue:phone forKey:@"telephone"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuAlertViewController *privacy = (MenuAlertViewController*)[storyboard instantiateViewControllerWithIdentifier:@"menuAlert"];
        // present
        [self presentViewController:privacy animated:YES completion:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Het alert is verzonden!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        [_activityView stopAnimating];
    }
    
    
    [self.waitView setEnabled:YES];
    self.waitView.userInteractionEnabled = YES;

}

-(void)dismissAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Authentication challenge");
 
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"amber" ofType:@"p12"];

    NSData *p12data = [NSData dataWithContentsOfFile:filePath];
    CFDataRef inP12data = (__bridge CFDataRef)p12data;
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    CFStringRef password = CFSTR("111111");
    OSStatus status = extractIdentityAndTrust3(inP12data, &myIdentity, &myTrust, password);
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

OSStatus extractIdentityAndTrust3(CFDataRef inPKCS12Data,
                                  SecIdentityRef *outIdentity,
                                  SecTrustRef *outTrust,
                                  CFStringRef keyPassword)
{
    OSStatus securityError = errSecSuccess;
    
    
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { keyPassword };
    CFDictionaryRef optionsDictionary = NULL;
    
    /* Create a dictionary containing the passphrase if one
     was specified.  Otherwise, create an empty dictionary. */
    optionsDictionary = CFDictionaryCreate(
                                           NULL, keys,
                                           values, (keyPassword ? 1 : 0),
                                           NULL, NULL);  // 1
    
    CFArrayRef items = NULL;
    securityError = SecPKCS12Import(inPKCS12Data,
                                    optionsDictionary,
                                    &items);                    // 2
    
    
    //
    if (securityError == 0) {                                   // 3
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             kSecImportItemIdentity);
        CFRetain(tempIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        
        CFRetain(tempTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }
    
    if (optionsDictionary)                                      // 4
        CFRelease(optionsDictionary);
    
    if (items)
        CFRelease(items);
    
    return securityError;
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

#pragma mark - radius slider
- (IBAction)RadiusSlider:(id)sender {
     self.kidRadius.text = [NSString stringWithFormat:@"%.1F", self.kidRadiusSlider.value];
    CGFloat strFloat = (CGFloat)[ self.kidRadius.text floatValue];
    strFloat = strFloat * 1000;
    self.radius = [NSString stringWithFormat:@"%f", strFloat];
    _kidRadiusSlider.minimumValue = 1;
    _kidRadiusSlider.maximumValue = 10;
    
}

#pragma mark - check textField
- (IBAction)nameVal:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isLetter != 1 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidName.text=newString;
        }
    }
}

- (IBAction)ageVal:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isDigit == 0 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidAge.text=newString;
        }
    }
}

- (IBAction)heigthVal:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isDigit == 0 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidGrowth.text=newString;
        }
    }
}

- (IBAction)weightVal:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isDigit == 0 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidWeigth.text=newString;
        }
    }
}


//---------picker-----

#pragma mark - Delegate
-(NSString*)returnChoosedPickerString:(NSString *)selectedEntriesArr
{
    NSLog(@"selectedArray=%@",selectedEntriesArr);
    // NSString *dataStr = [selectedEntriesArr componentsJoinedByString:@"\n"];
    if(multiPickerView.tag == 0) {
        self.kidAge.text = selectedEntriesArr;
    } else if(multiPickerView.tag == 1) {
        self.kidHair.text = selectedEntriesArr;
    } else if(multiPickerView.tag == 2) {
        self.kidEye.text = selectedEntriesArr;
    } else if(multiPickerView.tag == 3) {
        self.kidGender.text = selectedEntriesArr;
    }
    return selectedEntriesArr;
}

#pragma mark - dropDown list method GetData
-(void)getData1
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    if ([UIScreen mainScreen].bounds.size.width < 600)
    {
        multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height +70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } else
    {
        multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height -190-20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    multiPickerView.entriesArray = entries1;
    multiPickerView.entriesSelectedArray = entriesSelected1;
    multiPickerView.multiPickerDelegate = self;
    multiPickerView.tag = 1;
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];
    [self.view endEditing:YES];
}

-(void)getData2
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    if ([UIScreen mainScreen].bounds.size.width < 600)
    {
        multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height +70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } else {
        multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height -190-20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    multiPickerView.entriesArray = entries2;
    multiPickerView.entriesSelectedArray = entriesSelected2;
    multiPickerView.multiPickerDelegate = self;
    multiPickerView.tag = 2;
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];
    [self.view endEditing:YES];
}

-(void)getData3
{
    [self.view endEditing:YES];
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    if ([UIScreen mainScreen].bounds.size.width < 600)
    {
        multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height +70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } else
    {
        multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height -190-20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    multiPickerView.entriesArray = entries3;
    multiPickerView.entriesSelectedArray = entriesSelected3;
    multiPickerView.multiPickerDelegate = self;
    multiPickerView.tag = 3;
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];
    [self.view endEditing:YES];
}


- (IBAction)startGender:(id)sender
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (IBAction)startHair:(id)sender
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (IBAction)startEye:(id)sender
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (IBAction)hairVer:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isLetter != 1 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidHair.text=newString;
        }
    }
}

- (IBAction)eyeVer:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isLetter != 1 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidEye.text=newString;
        }
    }
}

- (IBAction)telVer:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        if (sender.text.length > 13 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidPhone.text=newString;
        }
    }
}

@end




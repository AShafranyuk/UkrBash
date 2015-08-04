//
//  RegistrationViewController.m
//  KidsAlert
//
//  Created by Admin on 23.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "RegistrationViewController.h"
#import "M13Checkbox.h"
#import "ViewController.h"
#import "User.h"

#define URL            @"http://37.48.84.185"


//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end
@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
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
    // Do any additional setup after loading the view.
    
    _btn3.layer.cornerRadius = 2.5f;
    _btn1.layer.cornerRadius = 2.5f;
    _btn2.layer.cornerRadius = 2.5f;
    
    if([UIScreen mainScreen].bounds.size.width>400){
        _btn3.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        _but.font = [UIFont systemFontOfSize:15];
    }
    
    _leftAlignment = [[M13Checkbox alloc] init];//initWithTitle:@"Ik accepteer onze"];
    [_leftAlignment setCheckAlignment:M13CheckboxAlignmentLeft];
    _leftAlignment.titleLabel.textColor = [UIColor grayColor];
    _leftAlignment.frame = CGRectMake(-2, 1, 307, 40);
   _leftAlignment.checkState = NO;
    [self.privacy addSubview:_leftAlignment];
    
    
    _allDefaults = [[M13Checkbox alloc] init];
    _allDefaults.frame = CGRectMake(10, 10, 20, 20);
    _allDefaults.strokeColor = [UIColor clearColor];
    _allDefaults.checkState = NO;
    [_allDefaults addTarget:self action:@selector(checkChangedValue:) forControlEvents:UIControlEventValueChanged];
    _rightPsw.backgroundColor = [UIColor clearColor];
    [self.rightPsw addSubview:_allDefaults];
    
    _allDefaults1 = [[M13Checkbox alloc] init];
    _allDefaults1.frame = CGRectMake(10, 10, 20, 20);
    _allDefaults1.strokeColor = [UIColor clearColor];
    _allDefaults1.checkState = NO;
    [_allDefaults1 addTarget:self action:@selector(checkChangedValue:) forControlEvents:UIControlEventValueChanged];
    _rightPsw1.backgroundColor = [UIColor clearColor];
    [self.rightPsw1 addSubview:_allDefaults1];


    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 40)];
    _userPhone.leftView = paddingView;
    _userPhone.leftViewMode = UITextFieldViewModeAlways;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void)checkChangedValue:(id)sender
{
    NSLog(@"Changed Value");
}


-(void) PostRequest: (NSString*)username password:(NSString*) password telephone:(NSString*) telephone
{
    
    [self.regBtn setEnabled:NO];
    self.regBtn.userInteractionEnabled = NO;
    
    
    NSDictionary *o1 = [[NSMutableDictionary alloc] init];
    [o1 setValue:username forKey:@"email"];
    [o1 setValue:password forKey:@"password"];
    [o1 setValue:telephone forKey:@"telephone"];
    
    
    NSString * url = [URL stringByAppendingString:@"/reg"];
    
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
-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

#pragma mark - Confirm Password
- (IBAction)confirmPassword:(UITextField *)sender
{
    NSString * password = _userPassword.text;
    NSString * check = sender.text;
    if([check isEqualToString:password]&& ![password isEqualToString:@""])
    {
        _allDefaults.checkState = YES;
        _allDefaults1.checkState = YES;
    } else {
        _allDefaults.checkState = NO;
        _allDefaults1.checkState = NO;
    }

}

- (IBAction)confirmPssw:(UITextField *)sender {
    NSString * password = _userPAsswordConfirm.text;
    NSString * check = sender.text;
    if([check isEqualToString:password] && ![password isEqualToString:@""])
    {
        _allDefaults.checkState = YES;
        _allDefaults1.checkState = YES;
    } else {
        _allDefaults.checkState = NO;
        _allDefaults1.checkState = NO;
    }

}

#pragma mark - userRegister
- (IBAction)userRegister:(id)sender {
    NSString *username = _userEmail.text;
    NSString *password = _userPassword.text;
    NSString *passwordConf = _userPAsswordConfirm.text;
    NSString *telephone = _userPhone.text; //[ @"31" stringByAppendingString:_userPhone.text];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username  forKey:@"userEmail"];
    [defaults setObject:telephone forKey:@"userPhone"];
    [defaults setObject:password forKey:@"userPssw"];
    [defaults synchronize];
    
    
    if (![password isEqualToString:@""] &&[self IsValidEmail:username Strict:YES]&& self.userPassword.text.length >=6 && [password isEqualToString:passwordConf] && _leftAlignment.checkState == YES && self.userPhone.text.length == 9 && ![self.userEmail.text isEqualToString:@""])
    {
        [self PostRequest:username password:password telephone:telephone];
    } else if (([password isEqualToString:@""] || ![password isEqualToString:passwordConf] || self.userPassword.text.length <6)  && _leftAlignment.checkState == NO && self.userPhone.text.length != 9&&![self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw e-mail, telefoonnummer, wachtwoord, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([password isEqualToString:@""] && ![self.userEmail.text isEqualToString:@""]  && [self IsValidEmail:username Strict:YES] && _leftAlignment.checkState == NO && self.userPhone.text.length != 9 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw telefoonnummer, wachtwoord, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (([password isEqualToString:@""] || ![password isEqualToString:passwordConf]|| self.userPassword.text.length <6)  && _leftAlignment.checkState == NO && self.userPhone.text.length == 9&&![self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw e-mail, wachtwoord, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![password isEqualToString:@""] && [password isEqualToString:passwordConf] && self.userPassword.text.length >=6   && _leftAlignment.checkState == NO && self.userPhone.text.length == 9&&![self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw e-mail, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (([password isEqualToString:@""] || ![password isEqualToString:passwordConf] || self.userPassword.text.length <6)  && _leftAlignment.checkState == NO && self.userPhone.text.length == 9&&[self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw wachtwoord, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![password isEqualToString:@""] && [password isEqualToString:passwordConf] && self.userPassword.text.length >=6 && _leftAlignment.checkState == NO && self.userPhone.text.length == 9&&[self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![password isEqualToString:@""] && [password isEqualToString:passwordConf] && self.userPassword.text.length >=6  && _leftAlignment.checkState == NO && self.userPhone.text.length != 9&&[self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw telefoonnummer, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![password isEqualToString:@""] && [password isEqualToString:passwordConf] && self.userPassword.text.length >=6  && _leftAlignment.checkState == NO && self.userPhone.text.length == 9&&![self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw e-mail, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![password isEqualToString:@""] && [password isEqualToString:passwordConf] && self.userPassword.text.length >=6  && _leftAlignment.checkState == YES && self.userPhone.text.length == 9&&![self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw e-mail en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![password isEqualToString:@""] && [password isEqualToString:passwordConf] && self.userPassword.text.length >=6  && _leftAlignment.checkState == YES && self.userPhone.text.length != 9&&[self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Het telefoonnummer is te kort of te lang. Probeer het nogmaals!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![password isEqualToString:@""] && [password isEqualToString:passwordConf] && self.userPassword.text.length >=6  && _leftAlignment.checkState == NO && self.userPhone.text.length != 9&&[self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw telefoonnummer, wachtwoord, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (([password isEqualToString:@""] || ![password isEqualToString:passwordConf] || self.userPassword.text.length <6)  && _leftAlignment.checkState == YES && self.userPhone.text.length == 9&&![self IsValidEmail:username Strict:YES] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw e-mail, wachtwoord en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    else if (![password isEqualToString:passwordConf] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Het wachtwoord komt niet overeen!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.userPassword.text.length <6 ||[password isEqualToString:@""] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Het ingevoerde wachtwoord is te kort. Het wachtwoord dient minimaal uit 6 tekens bestaan!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Controleer uw e-mail, telefoonnummer, wachtwoord, ga akkoord met de Gebruikersovereenkomst, Privacy Policy en Disclaimer en probeer het opnieuw!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
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
    
    NSLog(@"DATA%@", responseString);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"start1"];
    [defaults synchronize];
    
    NSError *jsonError;
    NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [newDevice setValue:[json objectForKey:@"email"] forKey:@"email"];
    [newDevice setValue:[json objectForKey:@"telephone"] forKey:@"telephone"];
    [newDevice setValue:[json objectForKey:@"user_id"] forKey:@"id"];
    
    User *newUser = [User sharedManager];
    newUser.userEmail = [json objectForKey:@"email"];
    if (newUser.userEmail != nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *privacy = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"Privacy"];
        [privacy setUserId:newUser.userId];
        
        // present
        [self presentViewController:privacy animated:YES completion:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[json objectForKey:@"user_id"]forKey:@"UserId"];
        [defaults setObject:[json objectForKey:@"email"]forKey:@"e"];
        [defaults setObject:[@"+" stringByAppendingString:[json objectForKey:@"telephone"]]forKey:@"t"];
        [defaults synchronize];
        [self updatePush];
    }else if ([[json objectForKey:@"status"] isEqualToString:@"Updated"]){}
        else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[json objectForKey:@"error"]//@"Incorrect gebruikersnaam of wachtwoord!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [_activityView stopAnimating];
        [self.regBtn setEnabled:YES];
        self.regBtn.userInteractionEnabled = YES;
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
    OSStatus status = extractIdentityAndTrust(inP12data, &myIdentity, &myTrust);
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

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
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


-(NSInteger*) getID
{
    return _userId;
}

#pragma mark - Check Telephone
- (IBAction)VerTel:(UITextField *)sender {
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
            self.userPhone.text=newString;
        }
    }

    if (sender.text.length > 9 )
    {
        
        NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
        NSLog(@"%@", newString );
        self.userPhone.text=newString;
    }

}

- (IBAction)VerTelEnd:(UITextField *)sender {
   /* if (sender.text.length < 9 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Het telefoonnummer is te kort."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }*/
}





- (void)updatePush
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *log = [defaults valueForKey:@"UserId"];
    NSString * token = [defaults objectForKey:@"DeviceToken"];
    NSDictionary *o1 = [[NSMutableDictionary alloc] init];
    [o1 setValue: log forKey:@"user_id"];
    [o1 setValue: token forKey:@"push_code"];
    
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
        
    // Create the NSURLConnection and init the request.
    NSURLConnection *st = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"%@", st);
}

@end

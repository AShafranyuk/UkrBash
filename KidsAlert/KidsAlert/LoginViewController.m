//
//  LoginViewController.m
//  KidsAlert
//
//  Created by Admin on 26.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuAlertViewController.h"
#import "RegistrationViewController.h"
#import "User.h"


#define URL            @"http://37.48.84.185"

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end



@interface LoginViewController ()

@end



@implementation LoginViewController
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
    _btn3.layer.cornerRadius = 2.5f;
    _btn1.layer.cornerRadius = 2.5f;
    _btn2.layer.cornerRadius = 2.5f;
    
    
    if([UIScreen mainScreen].bounds.size.width>400)
    {
        _btn3.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        _but.font = [UIFont systemFontOfSize:15];
    }
    
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
       // Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}



- (IBAction)login:(id)sender {
    if([_userPassword.text isEqualToString:@""] || [_userEmail.text isEqualToString:@""] ||![self IsValidEmail:_userEmail.text Strict:YES] ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer uw e-mailadres en wachtwoord en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    } else {
        NSString * username = _userEmail.text;
        NSString * password = _userPassword.text;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:username forKey:@"userEmail"];
        [defaults setObject:password forKey:@"userPssw"];
        [defaults synchronize];
        
        NSDictionary *o1 = [[NSMutableDictionary alloc] init];
        [o1 setValue:username forKey:@"email"];
        [o1 setValue:password forKey:@"password"];
        
        NSString * url = [URL stringByAppendingString:@"/login"];
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
        NSURLConnection *s = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        NSLog(@"%@", s);
        
        [_activityView startAnimating];
        [self.wait addSubview:_activityView];
        
        [self sendAlertId];
        
        
        /*
         NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
         
         NSLog(@"Response: %@", result);
         if([result isEqualToString:@"\"Error Login\""]){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
         message:@"Please Enter Valid Email Address !"
         delegate:nil
         cancelButtonTitle:@"Ok!"
         otherButtonTitles:nil, nil];
         [alert show];
         
         }*/
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
    NSError *jsonError;
    NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    if (![json isKindOfClass:[NSMutableArray class]])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES" forKey:@"start1"];
        [defaults synchronize];
    
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
            MenuAlertViewController *privacy = (MenuAlertViewController*)[storyboard instantiateViewControllerWithIdentifier:@"menuAlert"];
    
    // present
            [self presentViewController:privacy animated:YES completion:nil];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[json objectForKey:@"user_id"]forKey:@"UserId"];
            [defaults setObject:[json objectForKey:@"email"]forKey:@"e"];
            [defaults setObject:[@"+" stringByAppendingString:[json objectForKey:@"telephone"]]forKey:@"t"];
            [defaults synchronize];
            [self updatePush];
        } else if ([[json objectForKey:@"status"] isEqualToString:@"ok"])
        {
        }
        else if (![[json objectForKey:@"error"] isEqualToString:@"Het wachtwoord is aangepast!"] && ![[json objectForKey:@"status"] isEqualToString:@"Updated"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[json objectForKey:@"error"]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
            [alert show];
            _userPassword.text = @"";
            [_activityView stopAnimating];
        }
        if([[json objectForKey:@"error"] isEqualToString:@"Het wachtwoord is aangepast!"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Een nieuw wachtwoord is verstuurd naar uw registratie e-mail."message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
            [alert show];
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        }
    } else if ([json isKindOfClass:[NSMutableArray class]])
    {
        NSArray * json1 = [NSJSONSerialization JSONObjectWithData:objectData
                                                          options:NSJSONReadingMutableContainers
                                                            error:&jsonError];
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Alert"];
        NSMutableArray * devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSLog(@"%@",devices);
        for(int j = 0; j< json1.count; j++)
        {
            for(int i = 0; i< devices.count; i++)
            {
                NSManagedObject *device = [devices objectAtIndex:i];
            
                if([[device valueForKey:@"id"] isEqual:json1[j]])
                {
                    // Delete object from database
                    [managedObjectContext deleteObject:[devices objectAtIndex:i]];
                    [devices removeObjectAtIndex:i];
                
                }
            }
        }
    }
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
    OSStatus status = extractIdentityAndTrust1(inP12data, &myIdentity, &myTrust, password);
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

OSStatus extractIdentityAndTrust1(CFDataRef inPKCS12Data,
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

-(NSInteger*) getID
{
    return _userLogId;
}


- (IBAction)forgotPsswd:(id)sender {
    [self.view endEditing:YES];
    UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"Wachtwoord vergeten?" message:@"Vul het registratie e-mail adres in:" delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Aanpassen", nil];
    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
    alertViewChangeName.tag = 1;
    [alertViewChangeName show];
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
            
            NSString * email =  [[alert textFieldAtIndex:0] text];
            
            NSLog(@"%@", email);
            if([email isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer uw e-mailadres en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                
                [alert show];
                [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
                
            }else {
                
                NSDictionary *o1 = [[NSMutableDictionary alloc] init];
                [o1 setValue:email forKey:@"email"];
                
                NSString * url = [URL stringByAppendingString:@"/lost"];
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
                //  [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:URL];
                
                // Create the NSURLConnection and init the request.
                NSURLConnection *s = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                NSLog(@"%@", s);
                
            }
            
        }
    }

}
-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
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
    
    // Use the private method setAllowsAnyHTTPSCertificate:forHost:
    // to not validate the HTTPS certificate.
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:URL];
    
    // Create the NSURLConnection and init the request.
    NSURLConnection *st = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"%@", st);
    //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
}




- (NSMutableArray *) checkAlert {
    NSMutableArray * alertId =[[NSMutableArray alloc] init];;
    
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Alert"];
    NSArray * devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"%@",devices);
    for(int i = 0; i< devices.count; i++)
    {
        NSManagedObject *device = [devices objectAtIndex:i];
        
            [alertId addObject:[device valueForKey:@"id"]];
            
        
    }
    NSLog(@"%@",alertId);

    return alertId;
}

- (void)sendAlertId {

    NSArray * alerts = [self checkAlert];
    if([alerts count] != 0){
    
        NSDictionary *o1 = [[NSMutableDictionary alloc] init];

        [o1 setValue:alerts forKey:@"alerts"];

        
        NSString * url = [URL stringByAppendingString:@"/check"];
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

        NSURLConnection *s = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        NSLog(@"%@", s);
    }
}

@end

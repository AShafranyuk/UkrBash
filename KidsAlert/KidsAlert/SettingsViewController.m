//
//  SettingsViewController.m
//  KidsAlert
//
//  Created by Admin on 06.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "SettingsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBookUI/AddressBookUI.h>
#import "User.h"
#import <AVFoundation/AVAudioSession.h>
#import "MenuAlertViewController.h"


#define URL            @"http://37.48.84.185"

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end

@interface SettingsViewController ()

@property (strong) NSMutableArray *devices;

@end

@import AVFoundation;

@implementation SettingsViewController

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
    

    self.changePsswdView.hidden = YES;
    
    _allDefaults = [[M13Checkbox alloc] init];
    _allDefaults.frame = CGRectMake(10, 10, 20, 20);
    _allDefaults.strokeColor = [UIColor clearColor];
    _allDefaults.checkState = NO;
    [self.check addSubview:_allDefaults];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userEmail.text = [defaults objectForKey:@"e"];
    if([[defaults objectForKey:@"t"] hasPrefix:@"++"]){
        self.userPhone.text = [[defaults objectForKey:@"t"] substringFromIndex:1];
    } else {
        self.userPhone.text = [defaults objectForKey:@"t"];
    }


    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"title" style:UIBarButtonItemStylePlain target:nil action:nil];
    // Do any additional setup after loading the view.
    //map
    
    [self.useLocation addTarget:self action:@selector(checkMapAcces:) forControlEvents:UIControlEventTouchUpInside];
    _img=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,5, 20, 20)];
    _img.image=[UIImage imageNamed:@"ok.jpg"];
    _img1=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-45, 5, 20, 20)];
    _img1.image=[UIImage imageNamed:@"no.jpg"];
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.useLocation addSubview:_img];
    } else{
        [self.useLocation addSubview:_img1];
    }
    
    //photo
    [self.usePhoto addTarget:self action:@selector(checkPhotoAcces:) forControlEvents:UIControlEventTouchUpInside];
    _img2=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,5, 20, 20)];
    _img2.image=[UIImage imageNamed:@"ok.jpg"];
    _img3=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 5, 20, 20)];
    _img3.image=[UIImage imageNamed:@"no.jpg"];
     if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)
    {
        [self.usePhoto addSubview:_img2];
    } else{
        [self.usePhoto addSubview:_img3];
    }
    
    //contacts
    [self.useContacts addTarget:self action:@selector(checkContactsAcces:) forControlEvents:UIControlEventTouchUpInside];
    _img6=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,5, 20, 20)];
    _img6.image=[UIImage imageNamed:@"ok.jpg"];
    _img7=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 5, 20, 20)];
    _img7.image=[UIImage imageNamed:@"no.jpg"];
    NSString *contacts = [defaults objectForKey:@"contacts"];
    if([contacts isEqualToString:@"YES"])
    {
        [self.useContacts addSubview:_img6];
    } else{
        [self.useContacts addSubview:_img7];
    }
    
    
    
    //email  !!!
   [self.useEmail addTarget:self action:@selector(checkEmailAcces:) forControlEvents:UIControlEventTouchUpInside];
    _img4=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,5, 20, 20)];
    _img4.image=[UIImage imageNamed:@"ok.jpg"];
    _img5=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 5, 20, 20)];
    _img5.image=[UIImage imageNamed:@"no.jpg"];
    NSString *email = [defaults objectForKey:@"email"];
    if([email isEqualToString:@"YES"])
    {
        [self.useEmail addSubview:_img4];
        [defaults setObject:@"YES" forKey:@"email"];
        [defaults synchronize];
    } else{
        [self.useEmail addSubview:_img5];
        [defaults setObject:@"NO" forKey:@"email"];
        [defaults synchronize];
    }
    
    //push
    NSString *push = [defaults objectForKey:@"push"];
    
    [self.usePush addTarget:self action:@selector(checkPushAcces:) forControlEvents:UIControlEventTouchUpInside];
    _img8=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,5, 20, 20)];
    _img8.image=[UIImage imageNamed:@"ok.jpg"];
    _img9=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 5, 20, 20)];
    _img9.image=[UIImage imageNamed:@"no.jpg"];
    
    if([push isEqualToString:@"NO"])
    {
        [self.usePush addSubview:_img9];
        [defaults setObject:@"NO" forKey:@"push"];
        [defaults synchronize];
    } else{
        [self.usePush addSubview:_img8];
        [defaults setObject:@"YES" forKey:@"push"];
        [defaults synchronize];
    }


    
    //remainder  !!!

  //  NSString *remainder = [defaults objectForKey:@"remainder"];
    [self.useRemainder addTarget:self action:@selector(checkRemainderAcces:) forControlEvents:UIControlEventTouchUpInside];
    _img10=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,5, 20, 20)];
    _img10.image=[UIImage imageNamed:@"ok.jpg"];
    _img11=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 5, 20, 20)];
    _img11.image=[UIImage imageNamed:@"no.jpg"];
    
    if ([SKPaymentQueue canMakePayments])//Проверяем, включена ли возможность совершать покупки
    {
        [self.useRemainder addSubview:_img10];
    } else{
        [self.useRemainder addSubview:_img11];
    }

    
    //whatsApp !!!!

    NSString *whatsApp = [defaults objectForKey:@"whatsApp"];
    [self.useWhatsApp addTarget:self action:@selector(checkWhatsAppAcces:) forControlEvents:UIControlEventTouchUpInside];
    _img12=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,5, 20, 20)];
    _img12.image=[UIImage imageNamed:@"ok.jpg"];
    _img13=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 5, 20, 20)];
    _img13.image=[UIImage imageNamed:@"no.jpg"];
    
    if([whatsApp isEqualToString:@"YES"])
    {
        [self.useWhatsApp addSubview:_img12];
        [defaults setObject:@"YES" forKey:@"whatsApp"];
        [defaults synchronize];

    } else{
        [self.useWhatsApp addSubview:_img13];
        [defaults setObject:@"NO" forKey:@"whatsApp"];
        [defaults synchronize];

    }
    
    //camera
    [self.useCamera addTarget:self action:@selector(checkCameraAcces:) forControlEvents:UIControlEventTouchUpInside];
    _img14=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,5, 20, 20)];
    _img14.image=[UIImage imageNamed:@"ok.jpg"];
    _img15=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 5, 20, 20)];
    _img15.image=[UIImage imageNamed:@"no.jpg"];

    enum AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
         [self.useCamera addSubview:_img14];
    } else{
        [self.useCamera
         addSubview:_img15];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark = MAP
- (void)checkMapAcces:(id)sender
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuAlertViewController *privacy = (MenuAlertViewController*)[storyboard instantiateViewControllerWithIdentifier:@"menuAlert"];
    // present
    [self presentViewController:privacy animated:YES completion:nil];
}

#pragma mark - PHOTO
- (void)checkPhotoAcces:(id)sender
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)
    {
        [self.usePhoto addSubview:_img2];
    } else{
        [self.usePhoto addSubview:_img3];
    }
}

#pragma mark - CONTACTS
- (void)checkContactsAcces:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *contacts = [defaults objectForKey:@"contacts"];
    if([contacts isEqualToString:@"NO"])
    {
        [self.img7 removeFromSuperview];
        [self.useContacts addSubview:_img6];
        [defaults setObject:@"YES" forKey:@"contacts"];
        [defaults synchronize];
        [self.device setValue:@"YES" forKey:@"contacts"];
        
    } else
    {
        [self.img6 removeFromSuperview];
        [defaults setObject:@"NO" forKey:@"contacts"];
        [defaults synchronize];
        [self.useContacts addSubview:_img7];
        [self.device setValue:@"NO" forKey:@"contacts"];
    }
}

#pragma mark - Email
- (void)checkEmailAcces:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"email"];
    if([email isEqualToString:@"NO"])
    {
        [self.img5 removeFromSuperview];
        [self.useEmail addSubview:_img4];
        [defaults setObject:@"YES" forKey:@"email"];
        [defaults synchronize];
        
    } else
    {
         [self.img4 removeFromSuperview];
        [defaults setObject:@"NO" forKey:@"email"];
        [defaults synchronize];
        [self.useEmail addSubview:_img5];
    }
    
}

#pragma mark - Push
- (void)checkPushAcces:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *push = [defaults objectForKey:@"push"];
    if([push isEqualToString:@"NO"])
    {
        [self.img9 removeFromSuperview];
        [self.usePush addSubview:_img8];
        [defaults setObject:@"YES" forKey:@"push"];
        [defaults synchronize];
        
    } else
    {
        [self.img8 removeFromSuperview];
        [defaults setObject:@"NO" forKey:@"push"];
        [defaults synchronize];
        [self.usePush addSubview:_img9];
    }

}

#pragma mark - Remainder
- (void)checkRemainderAcces:(id)sender
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([SKPaymentQueue canMakePayments])//Проверяем, включена ли возможность совершать покупки
    {
        [self.img11 removeFromSuperview];
        [self.useRemainder addSubview:_img10];
        [defaults setObject:@"YES" forKey:@"remainder"];
        [defaults synchronize];
        
    } else
    {
        [self.img10 removeFromSuperview];
        [defaults setObject:@"NO" forKey:@"remainder"];
        [defaults synchronize];
        [self.useRemainder addSubview:_img11];
    }
}

#pragma mark - Whats App
- (void)checkWhatsAppAcces:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *whatsApp = [defaults objectForKey:@"whatsApp"];
    if([whatsApp isEqualToString:@"NO"])
    {
        [self.img13 removeFromSuperview];
        [self.useWhatsApp addSubview:_img12];
        [defaults setObject:@"YES" forKey:@"whatsApp"];
        [defaults synchronize];
        
    } else
    {
        [self.img12 removeFromSuperview];
        [defaults setObject:@"NO" forKey:@"whatsApp"];
        [defaults synchronize];
        [self.useWhatsApp addSubview:_img13];
    }
}

#pragma mark - Camera
- (void)checkCameraAcces:(id)sender
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
    enum AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized)
    {
        [self.useCamera addSubview:_img14];
    } else{
        [self.useCamera addSubview:_img15];
    }
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self PostRequest];
}

#pragma mark - Change Email
- (IBAction)changeEmail:(id)sender
{
    UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"Instellingen" message:@"Let op! Het aanpassen van je e-mail kan problemen geven met inloggen." delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Aanpassen", nil];
    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
    alertViewChangeName.tag = 1;
    [alertViewChangeName show];
    [self PostRequest];
}

#pragma mark - Change Phone
- (IBAction)changePhone:(id)sender {
    UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"Instellingen" message:@"Wat is je nieuwe telefoonnummer?" delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Aanpassen", nil];
    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField * alertTextField1 = [alertViewChangeName textFieldAtIndex:0];
    alertTextField1.placeholder = @"+31 XXX XX XX XX";
    alertViewChangeName.tag = 2;
    [alertViewChangeName show];
    [self PostRequest];
}

#pragma mark - is Valid Email ?
-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

#pragma mark - ALERT
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //-----EMAIL-------
    if(alert.tag == 1)
    {
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        }
        else
        {
            NSLog(@"ok");
            if ([self IsValidEmail:[[alert textFieldAtIndex:0] text] Strict:YES])
            {
                [self EmailChange:[[alert textFieldAtIndex:0] text] ];
                self.emailChange =  [[alert textFieldAtIndex:0] text];
                [self performSelector:@selector(aTime:) withObject:[[alert textFieldAtIndex:0] text] afterDelay:3];
                
            } else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vul het juiste e-mailadres in!"
                                                                message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                
                [alert show];
                [self performSelector:@selector(dismissAlertView111:) withObject:alert afterDelay:2];
            }
        }
    }
    //------PHONE--------
    else if(alert.tag == 2)
    {
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        }
        else
        {
            NSString * tel;
            if([[[alert textFieldAtIndex:0] text] hasPrefix:@"+31"]){
                tel = [[[alert textFieldAtIndex:0] text] substringFromIndex:3];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer uw telefoonnummer en probeer het opnieuw!"                                                                message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                
                [alert show];
                [self performSelector:@selector(dismissAlertView11:) withObject:alert afterDelay:2];
            }
            if([[alert textFieldAtIndex:0] text].length==12 && [[[[alert textFieldAtIndex:0] text] substringToIndex:1] isEqualToString:@"+"] && tel.length == 9)
            {
                
                NSLog(@"ok");
                self.userPhone.text =  [[alert textFieldAtIndex:0] text];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.userEmail.text forKey:@"e"];
                [defaults setObject: [[alert textFieldAtIndex:0] text]forKey:@"t"];
                [defaults synchronize];
                
                User *user = [User sharedManager];
                user.userPhone = tel;//[[alert textFieldAtIndex:0] text];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Het telefoonnummer is aangepast!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                
                
                [alert show];
                [self performSelector:@selector(dismissAlertView1:) withObject:alert afterDelay:2];
            } else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer uw telefoonnummer en probeer het opnieuw!"                                                                message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                
                [alert show];
                [self performSelector:@selector(dismissAlertView11:) withObject:alert afterDelay:2];
                
            }
        }
    }
}


-(void)dismissAlertView11:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"Instellingen" message:@"Wat is je nieuwe telefoonnummer?" delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Aanpassen", nil];
    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
    alertViewChangeName.tag = 2;
    [alertViewChangeName show];
    [self PostRequest];
}
-(void)dismissAlertView111:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"Instellingen" message:@"Let op! Het aanpassen van je e-mail kan problemen geven met inloggen." delegate:self cancelButtonTitle:@"Annuleren" otherButtonTitles:@"Aanpassen", nil];
    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
    alertViewChangeName.tag = 1;
    [alertViewChangeName show];
    [self PostRequest];
}
-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)dismissAlertView1:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - Change Email
-(void) EmailChange: (NSString *) email {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *log = [defaults valueForKey:@"UserId"];

    NSDictionary *o1 = [[NSMutableDictionary alloc] init];
    [o1 setValue: log forKey:@"user_id"];
    [o1 setValue:email forKey:@"email"];
    
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
    // [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:URL];
    
    // Create the NSURLConnection and init the request.
    NSURLConnection *s = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"%@", s);
}


#pragma mark - POST request
-(void) PostRequest{
    User *newUser = [User sharedManager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *log = [defaults valueForKey:@"UserId"];
    NSString * push = [defaults objectForKey:@"push"];
    NSString * whatsApp = [defaults objectForKey:@"whatsApp"];
    NSString * email = [defaults objectForKey:@"email"];
    NSDictionary *o1 = [[NSMutableDictionary alloc] init];
    [o1 setValue: log forKey:@"user_id"];
    
    if(newUser.userPhone != nil)
    {[o1 setValue:newUser.userPhone forKey:@"telephone"];}
    
    if(push != nil){
        if([push isEqualToString:@"YES"]){
            [o1 setValue: @"1" forKey:@"app_alert"];
        } else {
            [o1 setValue: @"0" forKey:@"app_alert"];
            
        }
    }
    if(whatsApp != nil){
        if([whatsApp isEqualToString:@"YES"]){
            [o1 setValue: @"1" forKey:@"whats_app_alert"];
        } else {
            [o1 setValue: @"0" forKey:@"whats_app_alert"];
            
        }
    }
    if(email != nil){
        if([email isEqualToString:@"YES"]){
            [o1 setValue: @"1" forKey:@"email_alert"];
        } else {
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
   // [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:URL];
    
    // Create the NSURLConnection and init the request.
    NSURLConnection *s = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"%@", s);
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
    
    if([json objectForKey:@"error"])
    {
        self.Error = @"Error";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[json objectForKey:@"error"] //@"Incorrect gebruikersnaam of wachtwoord!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil, nil];
        [alert show];
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
    OSStatus status = extractIdentityAndTrust20(inP12data, &myIdentity, &myTrust);
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

OSStatus extractIdentityAndTrust20(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
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


- (IBAction)changePsswd:(id)sender {
    self.changePsswdView.hidden = NO;
}
- (IBAction)backPssw:(id)sender {
    self.changePsswdView.hidden = YES;
    [self.view endEditing:YES];
}

- (IBAction)change:(id)sender
{
    if(self.allDefaults.checkState == YES && self.Pssw.text.length > 5 && ![self.oldPssw.text isEqualToString:@""] && [self.Pssw.text isEqualToString:self.confirmPssw.text] && self.oldPssw.text.length > 5)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *log = [defaults valueForKey:@"UserId"];
        
        NSDictionary *o1 = [[NSMutableDictionary alloc] init];
        [o1 setValue: log forKey:@"user_id"];
        [o1 setValue:self.oldPssw.text forKey:@"old"];
        [o1 setValue:self.Pssw.text forKey:@"new"];
        
        NSString * url = [URL stringByAppendingString:@"/change"];
        
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
        
        
        self.changePsswdView.hidden = YES;
        [self.view endEditing:YES];
    }else if([self.oldPssw.text isEqualToString:@""] && [self.Pssw.text isEqualToString:@""] && [self.confirmPssw.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer uw wachtwoord en probeer het opnieuw!"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }else if (self.Pssw.text.length < 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Het ingevoerde wachtwoord is te kort. Het wachtwoord dient minimaal uit 6 tekens bestaan!"//Controleer uw wachtwoord en probeer het opnieuw!"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    } else if (![self.Pssw.text isEqualToString:self.confirmPssw.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Het wachtwoord komt niet overeen!"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer uw wachtwoord en probeer het opnieuw!"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    

}

- (IBAction)confirmPssw:(UITextField *)sender {
    if([self.Pssw.text isEqualToString:sender.text])
    {
        _allDefaults.checkState = YES;
    } else {
        _allDefaults.checkState = NO;
    }
}


-(void)aTime: (NSString *) email
{
    if([self.Error isEqualToString:@"Error"]) {
        
    } else
    {
        self.userEmail.text = email;
        NSLog(@"....Update Function Called....");
        User *user = [User sharedManager];
        user.userEmail = self.emailChange;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject: email forKey:@"e"];
        [defaults synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Let op! Het aanpassen van je e-mail kan problemen geven met inloggen!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
}
@end

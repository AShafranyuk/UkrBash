//
//  LoginViewController.h
//  KidsAlert
//
//  Created by Admin on 26.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface LoginViewController : UIViewController


@property (weak, nonatomic) NSMutableData *responseData;

@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
//@property (strong, nonatomic) ViewController *displayViewController;

@property (assign, nonatomic) NSInteger * userLogId;

- (IBAction)login:(id)sender;


- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust);
-(NSInteger*) getID;


@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIView *wait;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UILabel *but;



- (IBAction)forgotPsswd:(id)sender;

@end

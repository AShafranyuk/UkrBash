//
//  RegistrationViewController.h
//  KidsAlert
//
//  Created by Admin on 23.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import "M13Checkbox.h"
#import <CoreData/CoreData.h>

@interface RegistrationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userEmail;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UITextField *userPAsswordConfirm;
@property(strong, nonatomic)  M13Checkbox *leftAlignment;
@property ( strong, nonatomic)  M13Checkbox *allDefaults;
@property ( strong, nonatomic)  M13Checkbox *allDefaults1;

@property (weak, nonatomic) IBOutlet UITextField *userPhone;

@property(nonatomic) NSInteger *userId;

- (IBAction)confirmPassword:(UITextField *)sender;
- (IBAction)confirmPssw:(UITextField *)sender;

- (IBAction)userRegister:(id)sender;




- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust);


-(NSInteger*) getID;
@property (weak, nonatomic) IBOutlet UIView *rightPsw;
@property (weak, nonatomic) IBOutlet UIView *rightPsw1;

@property (weak, nonatomic) IBOutlet UIView *privacy;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;


@property (weak, nonatomic) IBOutlet UIView *wait;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UILabel *but;

- (IBAction)VerTel:(UITextField *)sender;
- (IBAction)VerTelEnd:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UIButton *regBtn;


@end

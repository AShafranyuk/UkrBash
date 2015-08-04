//
//  ViewController.h
//  KidsAlert
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <CoreData/CoreData.h>


@interface ViewController : UIViewController
@property(strong,nonatomic) NSString * lg;

@property (weak, nonatomic) IBOutlet UILabel *but;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UILabel *login;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust);

@property(nonatomic) NSInteger* userId;

@property (nonatomic) LoginViewController *log;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *button4;

@property(strong, nonatomic) NSString * userID;

@end


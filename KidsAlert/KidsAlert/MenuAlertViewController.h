//
//  MenuAlertViewController.h
//  KidsAlert
//
//  Created by Admin on 07.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MenuAlertViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *loginLbl;
@property (weak, nonatomic) IBOutlet UIButton *badgeBtn;



- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;

OSStatus extractIdentityAndTrust8(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust);

@property (strong, nonatomic) NSString * userID;
@end

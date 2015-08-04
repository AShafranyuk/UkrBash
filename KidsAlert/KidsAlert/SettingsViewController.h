//
//  SettingsViewController.h
//  KidsAlert
//
//  Created by Admin on 06.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13Checkbox.h"
#import <CoreData/CoreData.h>
#import <StoreKit/StoreKit.h>

@interface SettingsViewController : UIViewController
@property (nonatomic) UIImageView *imgView;

@property (strong) NSManagedObject *device;

@property (weak, nonatomic) IBOutlet UIButton *useLocation;
@property ( strong, nonatomic)  M13Checkbox *checkLocation;
@property (retain, nonatomic) NSString * location;
@property (retain, nonatomic) UIImageView *img;
@property (retain, nonatomic) UIImageView *img1;


@property (weak, nonatomic) IBOutlet UIButton *usePhoto;
@property ( strong, nonatomic)  M13Checkbox *checkPhoto;
@property (retain, nonatomic) NSString * photo;
@property (retain, nonatomic) UIImageView *img2;
@property (retain, nonatomic) UIImageView *img3;

@property (weak, nonatomic) IBOutlet UIButton *useContacts;
@property ( strong, nonatomic)  M13Checkbox *checkContacts;
@property (retain, nonatomic) NSString * contacts;
@property (retain, nonatomic) UIImageView *img6;
@property (retain, nonatomic) UIImageView *img7;

@property (weak, nonatomic) IBOutlet UIButton *useEmail;
@property ( strong, nonatomic)  M13Checkbox *checkEmail;
@property (retain, nonatomic) NSString * email;
@property (retain, nonatomic) UIImageView *img4;
@property (retain, nonatomic) UIImageView *img5;

@property (weak, nonatomic) IBOutlet UIButton *usePush;
@property ( strong, nonatomic)  M13Checkbox *checkPush;
@property (retain, nonatomic) NSString * push;
@property (retain, nonatomic) UIImageView *img8;
@property (retain, nonatomic) UIImageView *img9;

@property (weak, nonatomic) IBOutlet UIButton *useRemainder;
@property ( strong, nonatomic)  M13Checkbox *checkRemainder;
@property (retain, nonatomic) NSString * remainder;
@property (retain, nonatomic) UIImageView *img10;
@property (retain, nonatomic) UIImageView *img11;

@property (weak, nonatomic) IBOutlet UIButton *useWhatsApp;
@property ( strong, nonatomic)  M13Checkbox *checkWhatsApp;
@property (retain, nonatomic) NSString * whatsApp;
@property (retain, nonatomic) UIImageView *img12;
@property (retain, nonatomic) UIImageView *img13;

@property (weak, nonatomic) IBOutlet UIButton *useCamera;
@property (retain, nonatomic) UIImageView *img14;
@property (retain, nonatomic) UIImageView *img15;


- (IBAction)changeEmail:(id)sender;

- (IBAction)changePhone:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;

//change password
@property ( strong, nonatomic)  M13Checkbox *allDefaults;
@property (weak, nonatomic) IBOutlet UIView *changePsswdView;
- (IBAction)changePsswd:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPssw;
@property (weak, nonatomic) IBOutlet UITextField *Pssw;
@property (weak, nonatomic) IBOutlet UITextField *confirmPssw;

- (IBAction)backPssw:(id)sender;
- (IBAction)change:(id)sender;

- (IBAction)confirmPssw:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIView *check;

@property(strong, nonatomic) NSString * userID;


@property (strong, nonatomic) NSString * emailChange;
@property (strong, nonatomic) NSString * Error;
@end

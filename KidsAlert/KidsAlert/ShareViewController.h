//
//  ShareViewController.h
//  KidsAlert
//
//  Created by Admin on 30.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPPSignInButton;
@interface ShareViewController : UIViewController
- (IBAction)shareInst:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
 @property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
- (IBAction)shareFB:(id)sender;
- (IBAction)shareTwitter:(id)sender;

- (IBAction)shareMail:(id)sender;
//- (IBAction)shareLinked:(id)sender;

- (IBAction)sharePin:(id)sender;

- (IBAction)IN:(id)sender;


@end

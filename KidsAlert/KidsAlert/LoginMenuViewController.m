//
//  LoginMenuViewController.m
//  KidsAlert
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "LoginMenuViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"




@interface LoginMenuViewController ()

@end

@implementation LoginMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //---round button----
    _button.layer.cornerRadius = 2.5f;
    _button1.layer.cornerRadius = 2.5f;
    _button2.layer.cornerRadius = 2.5f;
    
    
    if([UIScreen mainScreen].bounds.size.width>400){
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        _button2.titleLabel.font = [UIFont systemFontOfSize:15];
        _but.font = [UIFont systemFontOfSize:15];
    }
   
    
    UIImageView *imgview;
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/5)];
    } else {
        imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/4 + 70)];
    }
    [imgview setImage:[UIImage imageNamed:@"kids_image.png"]];
    imgview.tag = 1 ;
    [self.view addSubview:imgview];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        [button setFrame:CGRectMake(0, 65 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width, 45)];
    } else {
        [button setFrame:CGRectMake(0, 65 + [UIScreen mainScreen].bounds.size.height/4 + 70, [UIScreen mainScreen].bounds.size.width, 45)];
    }
    button.backgroundColor = [UIColor colorWithRed:58.0/255.0
                                             green:164.0/255.0
                                              blue:212.0/255.0
                                             alpha:1.0];
    [button setTitle:@"WELKOM BIJ KIDSALERT" forState:UIControlStateNormal];
    if([UIScreen mainScreen].bounds.size.width<400)
    {
        button.titleLabel.font = [UIFont systemFontOfSize:18];
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:25];
    }
    button.tag = 2;
    [self.view addSubview:button];
    
    //----login button---
    UIButton *buttonLog = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        [buttonLog setFrame:CGRectMake(30, 140 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-60, 40)];
    } else
    {
        [buttonLog setFrame:CGRectMake(30, 140 + [UIScreen mainScreen].bounds.size.height/4 + 70, [UIScreen mainScreen].bounds.size.width-60, 40)];
    }
    buttonLog.backgroundColor = [UIColor whiteColor];
    [buttonLog setTitle:@"LOGIN" forState:UIControlStateNormal];
    if([UIScreen mainScreen].bounds.size.width<400)
    {
        buttonLog.titleLabel.font = [UIFont systemFontOfSize:18];
    } else
    {
        buttonLog.titleLabel.font = [UIFont systemFontOfSize:22];
    }
    [buttonLog setTitleColor:[UIColor colorWithRed:70.0/255.0
                                             green:155.0/255.0
                                              blue:194.0/255.0
                                             alpha:1.0] forState:UIControlStateNormal];
    [buttonLog addTarget:self action:@selector(log) forControlEvents:UIControlEventTouchDown];
    buttonLog.tag = 3;
    [self.view addSubview:buttonLog];
    
    //-----button registration-----
    UIButton *buttonReg = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.width < 1000)
    {
        [buttonReg setFrame:CGRectMake(30, 190 + [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-60, 40)];
    } else
    {
        [buttonReg setFrame:CGRectMake(30, 190 + [UIScreen mainScreen].bounds.size.height/4 + 70, [UIScreen mainScreen].bounds.size.width-60, 40)];
    }
    buttonReg.backgroundColor = [UIColor whiteColor];
    [buttonReg setTitle:@"REGISTREREN" forState:UIControlStateNormal];
    if([UIScreen mainScreen].bounds.size.width<400)
    {
        buttonReg.titleLabel.font = [UIFont systemFontOfSize:18];
    } else
    {
        buttonReg.titleLabel.font = [UIFont systemFontOfSize:22];
    }
    [buttonReg setTitleColor:[UIColor colorWithRed:70.0/255.0
                                             green:155.0/255.0
                                              blue:194.0/255.0
                                             alpha:1.0] forState:UIControlStateNormal];
    [buttonReg addTarget:self action:@selector(reg) forControlEvents:UIControlEventTouchDown];
    buttonReg. tag = 4;
    [self.view addSubview:buttonReg];
}

//----rotation----
-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration
{
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 2 || subView.tag == 1 || subView.tag == 3 || subView.tag == 4)
        {
            [subView removeFromSuperview];
        }
    }
    [self viewDidLoad];
    NSLog(@"!!!!!!!");
}

-(void) log {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *privacy = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"login"];
     [self presentViewController:privacy animated:YES completion:nil];
}

-(void) reg {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistrationViewController *privacy = (RegistrationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"reg"];
    [self presentViewController:privacy animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

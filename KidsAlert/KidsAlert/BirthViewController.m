//
//  BirthViewController.m
//  KidsAlert
//
//  Created by Admin on 02.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "BirthViewController.h"
#import "AddKidsViewController.h"

@interface BirthViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BirthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickerAction:(id)sender
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];

    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [dateFormatter1 setDateFormat:@"yyyy"];
    [dateFormatter2 setDateFormat:@"MM"];
    [dateFormatter3 setDateFormat:@"dd"];
    
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    NSInteger formatedDate1 = [[dateFormatter1 stringFromDate:self.datePicker.date]integerValue];
    NSInteger formatedDate2 = [[dateFormatter2 stringFromDate:self.datePicker.date]integerValue];
    NSInteger formatedDate3 = [[dateFormatter3 stringFromDate:self.datePicker.date]integerValue];
    
    self.date =formatedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"MM";
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"dd";


    NSInteger string = [[formatter stringFromDate:[NSDate date]]integerValue] ;
    NSInteger string1 = [[formatter1 stringFromDate:[NSDate date]]integerValue] ;
    NSInteger string2 = [[formatter2 stringFromDate:[NSDate date]]integerValue] ;

    NSLog(@"%d", string-formatedDate1);
    NSInteger age = string-formatedDate1;
    
    if((formatedDate2 - string1)>0) {
        age = age - 1;
    } else if ((string1 - formatedDate2) == 0) {
        if ((string2 - formatedDate3) < 0) {
            age = age - 1;
        }
        
    }
   
    
    
    NSString *inStr = [NSString stringWithFormat:@"%ld", (long)age];
    
    AddKidsViewController *add = [[AddKidsViewController alloc] init];
    add.kidAge.text = inStr;
    self.date = inStr;
    
    [self.devices setValue:inStr forKey:@"age"];
}
- (IBAction)back:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddKidsViewController *privacy = (AddKidsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"add"];
    
    privacy.device = self.devices;
   // privacy.kidsAge1= self.date;
    // present
    [self presentViewController:privacy animated:YES completion:nil];
    
}



@end

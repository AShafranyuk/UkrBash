//
//  AddKidsViewController.h
//  KidsAlert
//
//  Created by Admin on 27.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ALPickerView.h"
#import "CYCustomMultiSelectPickerView.h"


@interface AddKidsViewController : UITableViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate,CYCustomMultiSelectPickerViewDelegate >


{

    
NSArray *entries1;
NSString *entriesSelected1;
NSMutableDictionary *selectionStates1;
    
NSArray *entries2;
NSString *entriesSelected2;
NSMutableDictionary *selectionStates2;
    
NSArray *entries3;
NSString *entriesSelected3;
NSMutableDictionary *selectionStates3;

CYCustomMultiSelectPickerView *multiPickerView;
}
@property (weak, nonatomic) IBOutlet UIButton *btnShow1;
@property (weak, nonatomic) IBOutlet UIButton *btnShow;
@property (weak, nonatomic) IBOutlet UIButton *btnShow2;
@property (weak, nonatomic) IBOutlet UIButton *btnShow3;


@property (weak, nonatomic) IBOutlet UITextField *kidName;
@property (weak, nonatomic) IBOutlet UITextField *kidGender;
@property (weak, nonatomic) IBOutlet UITextField *kidAge;
@property (weak, nonatomic) IBOutlet UITextField *kidHair;
@property (weak, nonatomic) IBOutlet UITextField *kidEye;
@property (weak, nonatomic) IBOutlet UITextField *kidGrowth;
@property (weak, nonatomic) IBOutlet UITextView *kidSpecial;
@property (weak, nonatomic) NSString * kidLastSeen;
@property (strong) NSManagedObject *device;
@property (weak, nonatomic) IBOutlet UITextField *kidWeight;
@property (strong, nonatomic) NSString *kidsAge1;


- (IBAction)save:(id)sender;




@property  NSInteger * count;




@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)takePhoto:(UIButton *)sender;



- (IBAction)nameVer:(UITextField*)sender;
- (IBAction)heigthLer:(UITextField *)sender;
- (IBAction)weightVer:(UITextField *)sender;
- (IBAction)AgeVer:(UITextField *)sender;
- (IBAction)hairVer:(UITextField *)sender;
- (IBAction)eyeVer:(UITextField *)sender;
- (IBAction)ageVer:(UITextField *)sender;


- (IBAction)startEdEye:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addKidBtn;
- (IBAction)back:(id)sender;

@end

//
//  AlertViewController.h
//  KidsAlert
//
//  Created by Admin on 16.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ALPickerView.h"
#import "CYCustomMultiSelectPickerView.h"

@interface AlertViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CYCustomMultiSelectPickerViewDelegate >


{
    
    
    NSArray *entries;
    NSMutableArray *entriesSelected;
    NSMutableDictionary *selectionStates;
    
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

@property (weak, nonatomic) IBOutlet UITextField *kidName;
@property (weak, nonatomic) IBOutlet UITextField *kidGender;
@property (weak, nonatomic) IBOutlet UITextField *kidAge;
@property (weak, nonatomic) IBOutlet UITextField *kidHair;
@property (weak, nonatomic) IBOutlet UITextField *kidEye;
@property (weak, nonatomic) IBOutlet UITextField *kidGrowth;
@property (weak, nonatomic) IBOutlet UITextView *kidSpecial;
@property (weak, nonatomic) IBOutlet UITextField *kidWeigth;
@property(strong, nonatomic) NSString *kidLastSeen;
@property(strong, nonatomic) NSString *radius;
@property (weak, nonatomic) IBOutlet UITextField *kidClothes;
@property (weak, nonatomic) IBOutlet UISlider *kidRadiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *kidRadius;
@property (weak, nonatomic) IBOutlet UITextField *kidPhone;
@property(strong, nonatomic) NSString *kidPhotoName;
@property (weak, nonatomic) IBOutlet UITextField *kidLAstSeen;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (strong) NSManagedObject *device;

- (IBAction)sendAlert:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *waitView;

@property (weak, nonatomic) IBOutlet UIView *waitView1;

@property (strong, nonatomic) UIActivityIndicatorView *activityView;

- (IBAction)nameVal:(UITextField *)sender;
- (IBAction)ageVal:(UITextField *)sender;
- (IBAction)heigthVal:(UITextField *)sender;
- (IBAction)weightVal:(UITextField *)sender;

@property (strong, nonatomic) NSString * userID;

@property (weak, nonatomic) IBOutlet UIButton *kidGenderbtn;
@property (weak, nonatomic) IBOutlet UIButton *kidHairbtn;
@property (weak, nonatomic) IBOutlet UIButton *kidEyebtn;

- (IBAction)startGender:(id)sender;
- (IBAction)startHair:(id)sender;
- (IBAction)startEye:(id)sender;
- (IBAction)hairVer:(UITextField *)sender;
- (IBAction)eyeVer:(UITextField *)sender;
- (IBAction)telVer:(UITextField *)sender;

@end

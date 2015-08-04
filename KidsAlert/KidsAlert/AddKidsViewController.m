//
//  AddKidsViewController.m
//  KidsAlert
//
//  Created by Admin on 27.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AddKidsViewController.h"
#import "BirthViewController.h"
#import "MenuAlertViewController.h"



@interface AddKidsViewController ()
@property (nonatomic, strong) NSDate *selectedDate;


@end

@implementation AddKidsViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.device) {
         NSLog(@"%@", self.device);
        [self.kidName setText:[self.device valueForKey:@"name"]];
        [self.kidGender setText:[self.device valueForKey:@"gender"]];
        [self.kidAge setText:[self.device valueForKey:@"age"]];
        [self.kidHair setText:[self.device valueForKey:@"hair"]];
        [self.kidEye setText:[self.device valueForKey:@"eye"]];
        [self.kidGrowth setText:[self.device valueForKey:@"growth"]];
        [self.kidWeight setText:[self.device valueForKey:@"weight"]];
        self.kidSpecial.text  = [self.device valueForKey:@"special"];
        UIImage *image = [UIImage imageWithData:[self.device valueForKey:@"photo"]];
        self.imageView.image = image;
       
        [self.addKidBtn setTitle:@"WIJZIGINGEN OPSLAAN" forState:UIControlStateNormal];
    } else
    {
        [self.addKidBtn setTitle:@"KIND TOEVOEGEN" forState:UIControlStateNormal];
    }
    
    _kidName.delegate = (id)self;
    _kidAge.delegate= (id)self;
    _kidGender.delegate = (id)self;
    _kidHair.delegate = (id)self;
    _kidEye.delegate = (id)self;
    _kidGrowth.delegate = (id)self;
    _kidWeight.delegate = (id)self;
    _kidSpecial.delegate = (id)self;
  
    //-----padding---------
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
    _kidName.leftView = paddingView;
    _kidName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
    _kidAge.leftView = paddingView1;
    _kidAge.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
    _kidGender.leftView = paddingView2;
    _kidGender.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
    _kidHair.leftView = paddingView3;
    _kidHair.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
    _kidEye.leftView = paddingView4;
    _kidEye.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
    _kidGrowth.leftView = paddingView5;
    _kidGrowth.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
    _kidWeight.leftView = paddingView6;
    _kidWeight.leftViewMode = UITextFieldViewModeAlways;
    //-----------

    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
            
         //   UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
        //                                                          message:@"Device has no camera"
         //                                                        delegate:nil
          //                                              cancelButtonTitle:@"OK"
          //                                              otherButtonTitles: nil];
            
          //  [myAlertView show];
    }
    
       
    //-------dropdown list ------------
    entries2 = [[NSArray alloc] initWithObjects:@"Blauw",@"Groen", @"Bruin", @"Grijs",nil];
    selectionStates2 = [[NSMutableDictionary alloc] init];
    UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 10)];
    img2.image=[UIImage imageNamed:@"add.jpg"];
    [self.btnShow2 addSubview:img2];
    [self.btnShow2 addTarget:self action:@selector(getData2) forControlEvents:UIControlEventTouchUpInside];
    
    
    entries1 = [[NSArray alloc] initWithObjects:@"Zwart", @"Blond", @"Rood", @"Bruin",nil];
    selectionStates1 = [[NSMutableDictionary alloc] init];
    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 10)];
    img1.image=[UIImage imageNamed:@"add.jpg"];
    [self.btnShow1 addSubview:img1];
    [self.btnShow1 addTarget:self action:@selector(getData1) forControlEvents:UIControlEventTouchUpInside];
    
    
    entries3 = [[NSArray alloc] initWithObjects:@"Meisje", @"Jongen",nil];
    selectionStates3 = [[NSMutableDictionary alloc] init];
    UIImageView *img3;
    if (  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        img3=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 10)];
    } else {
        img3=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 10)];
    }

    img3.image=[UIImage imageNamed:@"add.jpg"];
    [self.btnShow3 addSubview:img3];
    [self.btnShow3 addTarget:self action:@selector(getData3) forControlEvents:UIControlEventTouchUpInside];
    //-------------------
    
    if(_kidSpecial.text.length == 0 || [_kidSpecial.text  isEqual: @"Bijzonderheden"]){
    _kidSpecial.text = @"Bijzonderheden";
    _kidSpecial.textColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:197/255.0f alpha:1.0f];
    _kidSpecial.delegate = (id)self;
    }
}

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    
}
#pragma mark - text view placeholder
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ( [_kidSpecial.textColor isEqual:[UIColor colorWithRed:191/255.0f green:191/255.0f blue:197/255.0f alpha:1.0f]])
    {
        _kidSpecial.text = @"";
        _kidSpecial.textColor = [UIColor colorWithRed:85/255.0f green:85/255.0f blue:85/255.0f alpha:1.0f];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(_kidSpecial.text.length == 0 ||  [_kidSpecial.text  isEqual: @"Bijzonderheden"])
    {
        _kidSpecial.textColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:197/255.0f alpha:1.0f];
        _kidSpecial.text = @"Bijzonderheden";
        [_kidSpecial resignFirstResponder];
    }
}





- (IBAction)save:(id)sender
{
    // if([self.kidName.text isEqualToString:@""] || [self.kidGender.text isEqualToString:@""] || [self.kidAge.text isEqualToString:@""] || [self.kidHair.text isEqualToString:@""] || [self.kidEye.text isEqualToString:@""] ||[self.kidGrowth.text isEqualToString:@""] ||[self.kidWeight.text isEqualToString:@""])
    //{
    int growth = [self.kidGrowth.text intValue];
    int weight = [self.kidWeight.text intValue];
    if([self.kidName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'voornaam' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidGender.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vul het geslacht in a.u.b.!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidAge.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'leeftijd' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidHair.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'haarkleur' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidEye.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Controleer 'oogkleur' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if([self.kidGrowth.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Controleer 'lengte' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if (growth<50 || growth>200)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vul de juiste lengte in (50–200 cm)!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    else if([self.kidWeight.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Controleer 'gewicht' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
        
    }
    else if (weight<10 || weight>150)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vul het juiste gewicht in (10–150 kg)!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    else if (self.imageView.image == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Controleer 'foto' en probeer het opnieuw!"message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    // }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *log = [defaults valueForKey:@"UserId"];
        NSManagedObjectContext *context = [self managedObjectContext];
        if (self.device)
        {
            // Update existing device
            [self.device setValue:log   forKey:@"user"];
            [self.device setValue:self.kidName.text forKey:@"name"];
            [self.device setValue:self.kidGender.text forKey:@"gender"];
            [self.device setValue:self.kidAge.text forKey:@"age"];
            [self.device setValue:self.kidHair.text forKey:@"hair"];
            [self.device setValue:self.kidEye.text forKey:@"eye"];
            [self.device setValue:self.kidGrowth.text forKey:@"growth"];
            [self.device setValue:self.kidSpecial.text forKey:@"special"];
            [self.device setValue:self.kidWeight.text forKey:@"weight"];
            NSData *imageData = UIImagePNGRepresentation(_imageView.image);
            [self.device setValue:imageData forKey:@"photo"];
        } else
        {
            // Create a new device
            NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Kids" inManagedObjectContext:context];
            [newDevice setValue:log   forKey:@"user"];
            [newDevice setValue:self.kidName.text forKey:@"name"];
            [newDevice setValue:self.kidGender.text forKey:@"gender"];
            [newDevice setValue:self.kidAge.text forKey:@"age"];
            [newDevice setValue:self.kidHair.text forKey:@"hair"];
            [newDevice setValue:self.kidEye.text forKey:@"eye"];
            [newDevice setValue:self.kidGrowth.text forKey:@"growth"];
            [newDevice setValue:self.kidSpecial.text forKey:@"special"];
            [newDevice setValue:self.kidWeight.text forKey:@"weight"];
            NSData *imageData = UIImagePNGRepresentation(_imageView.image);
            [newDevice setValue:imageData forKey:@"photo"];
            //[newDevice setValue:self.imageView. forKey:@"photo"];
        }
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error])
        {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *privacy = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"send"];
        [self presentViewController:privacy animated:YES completion:nil];
    }
}

#pragma mark - Select photo and take photo
- (IBAction)selectPhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)takePhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Check text field
- (IBAction)nameVer:(UITextField*)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isLetter != 1 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidName.text=newString;
        }
    }
}

- (IBAction)heigthLer:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (sender.text.length > 3 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidGrowth.text=newString;
        }
    }
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isDigit == 0 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidGrowth.text=newString;
        }
    }
}

- (IBAction)weightVer:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (sender.text.length > 3 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidWeight.text=newString;
        }
    }
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isDigit == 0 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidWeight.text=newString;
        }
    }
}

- (IBAction)AgeVer:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isDigit == 0 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidAge.text=newString;
        }
    }
}

- (IBAction)hairVer:(UITextField *)sender
{
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isLetter != 1 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidHair.text=newString;
        }
    }
}

- (IBAction)eyeVer:(UITextField *)sender
{
    
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (isLetter != 1 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidEye.text=newString;
        }
    }
}

- (IBAction)ageVer:(UITextField *)sender {
    if([sender.text isEqualToString:@""])
    {
        
    } else
    {
        NSLog(@"%@", sender.text );
        unichar ch = [sender.text characterAtIndex:[sender.text length]-1];
        BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: ch];
        BOOL isDigit  = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: ch];
        NSLog(@"'%C' is a letter: %d or a digit %d", ch, isLetter, isDigit);
        if (sender.text.length > 2 )
        {
            NSString *newString = [sender.text substringToIndex:[sender.text length]-1];
            NSLog(@"%@", newString );
            self.kidAge.text=newString;
        }
    }
}

- (IBAction)startEdEye:(id)sender
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
}
- (IBAction)startEdHair:(id)sender
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (IBAction)startEdGender:(id)sender
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - delegate image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Delegate
-(NSString*)returnChoosedPickerString:(NSString *)selectedEntriesArr
{
    NSLog(@"selectedArray=%@",selectedEntriesArr);
   // NSString *dataStr = [selectedEntriesArr componentsJoinedByString:@"\n"];
    if(multiPickerView.tag == 0) {
        self.kidAge.text = selectedEntriesArr;
    } else if(multiPickerView.tag == 1) {
        self.kidHair.text = selectedEntriesArr;
    } else if(multiPickerView.tag == 2) {
        self.kidEye.text = selectedEntriesArr;
    } else if(multiPickerView.tag == 3) {
        self.kidGender.text = selectedEntriesArr;
    }
    return selectedEntriesArr;
}

#pragma mark - dropDown list getData
-(void)getData1
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 190-20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    multiPickerView.entriesArray = entries1;
    multiPickerView.entriesSelectedArray = entriesSelected1;
    multiPickerView.multiPickerDelegate = self;
    multiPickerView.tag = 1;
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];
    [self.view endEditing:YES];
}


-(void)getData2
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 190-20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    multiPickerView.entriesArray = entries2;
    multiPickerView.entriesSelectedArray = entriesSelected2;
    multiPickerView.multiPickerDelegate = self;
    multiPickerView.tag = 2;
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];
    [self.view endEditing:YES];
}


-(void)getData3
{
    [self.view endEditing:YES];
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 190-20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    multiPickerView.entriesArray = entries3;
    multiPickerView.entriesSelectedArray = entriesSelected3;
    multiPickerView.multiPickerDelegate = self;
    multiPickerView.tag = 3;
    [self.view addSubview:multiPickerView];
    [multiPickerView pickerShow];
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    return headerView;
}
-(void)dismissAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end

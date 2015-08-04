//
//  ShareViewController.m
//  KidsAlert
//
//  Created by Admin on 30.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ShareViewController.h"
#import <objc/runtime.h>
#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ShareViewController ()
{
}


@end
////static NSString * const kClientId = @"332198467231-iilrveo2sh5dm4cnegmadoaotjnmv5t6.apps.googleusercontent.com";
@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void) handleBack:(id)sender
{
    // pop to root view controller
  //  [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - share via instagram
- (IBAction)shareInst:(id)sender
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        UIImage *image = [UIImage imageNamed:@"share.jpg"];
        CGFloat cropVal = (image.size.height > image.size.width ? image.size.width : image.size.height);
        
        cropVal *= [_imageView.image scale];
        
        CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
        CGImageRelease(imageRef);
        
        NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
        if (![imageData writeToFile:writePath atomically:YES])
        {
            // failure
            NSLog(@"image save failed to path %@", writePath);
            return;
        } else
        {
            // success.
        }
        // send it to instagram.
        NSURL *fileURL = [NSURL fileURLWithPath:writePath];
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        self.documentController.delegate = (id)self;
        [self.documentController setUTI:@"com.instagram.exclusivegram"];
        [self.documentController setAnnotation:@{@"InstagramCaption" : @"de KidsAlertApp! Kind zoek, verstuur direct je Alert en iedereen zoekt mee. Download nu! Samen staan we samen sterk."}];
        [self.documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 320, 480) inView:self.view animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Instagram werkt niet correct, installeer Instagram."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - share via facebook
- (IBAction)shareFB:(id)sender
{
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    if (isInstalled)
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:@" Ik heb een heel handige en nieuwe app, de KidsAlert App  gedownload. Kind uit het oog verloren? Thuis, in de dierentuin, pretpark, waar dan ook. Verstuur direct een Alert en iedereen zoekt mee. Door en voor iedereen!\nVoor ouders met jonge kinderen, voor opa’s en oma’s, ooms en tantes, buren, kortom voor iedereen! \nDownload nu, dan staan we samen sterk! Dank je wel.\nDelen is fijn."];
        [controller addURL:[NSURL URLWithString:@"http://www.kidsalert.info"]];
        [controller addImage:[UIImage imageNamed:@"children.jpg"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Facebook werkt niet correct, installeer Facebook."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([MFMailComposeViewController canSendMail])
    {
        NSLog(@"YES");
    } else
    {
         NSLog(@"NO");
    }
}

#pragma mark - share via twitter
- (IBAction)shareTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"de KidsAlertApp! Kind zoek, verstuur direct je Alert en iedereen zoekt mee. Download nu! Staan staan we samen sterk."];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Twitter werkt niet correct, installeer Twitter."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - share via email
- (IBAction)shareMail:(id)sender
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = (id)self;
    [controller setSubject:@" Nieuw: de Kids Alert App"];
    [controller setMessageBody:@" Ik heb een heel handige en nieuwe app, de KidsAlert App  gedownload. Kind uit het oog verloren, thuis, in de dierentuin, pretpark, waar dan ook? Verstuur direct een Alert en iedereen zoekt mee. Door en voor iedereen!\n Voor ouders met jonge kinderen, voor opa’s en oma’s, ooms en tantes, buren, kortom voor iedereen!\nDownload nu, dan staan we samen sterk! Dank je wel." isHTML:NO];
    if (controller) [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)sharePin:(id)sender {
   
}

#pragma mark - share via linkedIn
- (IBAction)IN:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~/shares"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        NSString * message = @" Ik wil je graag attenderen op een handige en nieuwe app, de KidsAlertApp, nu verkrijgbaar in de stores. Kind uit het oog verloren, thuis, in de dierentuin, pretpark, waar dan ook? Verstuur direct een Alert en iedereen zoekt mee. Door en voor iedereen!\nVoor ouders met jonge kinderen, voor opa’s en oma’s, ooms en tantes, buren, kortom voor iedereen!\nDownload nu, dan staan we samen sterk! Dank je wel.\n Delen is fijn.";
        UIImage * image = [UIImage imageNamed:@"children.jpg"];
        NSArray * shareItems = @[message, image];
    
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        avc.popoverPresentationController.sourceView = self.view;
        [self presentViewController:avc animated:YES completion:nil];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"LinkedIn werkt niet correct, installeer LinkedIn."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end

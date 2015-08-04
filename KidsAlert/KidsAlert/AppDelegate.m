//
//  AppDelegate.m
//  KidsAlert
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import <Pushwoosh/PushNotificationManager.h>
#import "GetAlertViewController.h"
#import "User.h"
#import "FoundViewController.h"
#import "PushViewController.h"
#import "MenuAlertViewController.h"

#define URL1            @"http://37.48.84.185"

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
//@end

@interface AppDelegate ()

@end
@import CoreLocation;
@import SystemConfiguration;
@import AVFoundation;
@import ImageIO;
@implementation AppDelegate


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

/*- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
      //  if ([trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}*/


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //-----------PUSHWOOSH PART-----------
    // set custom delegate for push handling, in our case - view controller
    PushNotificationManager * pushManager = [PushNotificationManager pushManager];
    pushManager.delegate = (id)self;
    
    // handling push on app start
    [[PushNotificationManager pushManager] handlePushReceived:launchOptions];
    
    // make sure we count app open in Pushwoosh stats
    [[PushNotificationManager pushManager] sendAppOpen];
    
    // register for push notifications!
    [[PushNotificationManager pushManager] registerForPushNotifications];
      // Override point for customization after application launch
    
    return YES;
}

// system push notification registration success callback, delegate to pushManager
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[PushNotificationManager pushManager] handlePushRegistration:deviceToken];
    User *user = [User sharedManager];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken1 = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken1 = [deviceToken1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    user.deviceToken = deviceToken1;
    [defaults setObject:deviceToken1 forKey:@"DeviceToken"];
    NSLog(@"DEVICETOKEN %@", deviceToken1);
}

// system push notification registration error callback, delegate to pushManager
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[PushNotificationManager pushManager] handlePushRegistrationFailure:error];
}

// system push notifications callback, delegate to pushManager
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"!!!!!!%@",userInfo);
    [[PushNotificationManager pushManager] handlePushReceived:userInfo];
    User *newUser = [User sharedManager];
    
    NSString *pushDict = [userInfo objectForKey:@"u"];
    
    NSError *jsonError;
    NSData *objectData = [pushDict dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    NSLog (@"CHILD    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",[json objectForKey:@"alert_id"] );
    newUser.kidId = [json objectForKey:@"alert_id"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * log = [defaults objectForKey:@"UserId"];
    
    if([[json objectForKey:@"alert_type"] isEqualToString:@"found"] && ![log isEqual:@"nil"] && [defaults objectForKey:@"UserId"] != nil)
    {
        if (application.applicationState == UIApplicationStateActive)
        {
            UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            while (topRootViewController.presentedViewController)
            {
                topRootViewController = topRootViewController.presentedViewController;
            }
            topRootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            UIViewController *vc = self.window.rootViewController;
            FoundViewController *pvc = [vc.storyboard instantiateViewControllerWithIdentifier:@"found"];
            [topRootViewController presentViewController:pvc animated:YES completion:nil];
        } else {
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Alert"];
            self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            User *newUser = [User sharedManager];
            
            NSLog(@"%@",self.devices);
            for(int i = 0; i< self.devices.count; i++)
            {
                NSManagedObject *device = [self.devices objectAtIndex:i];
                
                if([[device valueForKey:@"id"] isEqualToString:newUser.kidId ])
                {
                    // Delete object from database
                    [managedObjectContext deleteObject:[self.devices objectAtIndex:i]];
                    [self.devices removeObjectAtIndex:i];
                }
            }
        }
    } else if([[json objectForKey:@"alert_type"] isEqualToString:@"create"] && ![log isEqual:@"nil"] && [defaults objectForKey:@"UserId"] != nil)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        newUser.badge = @"1";

        [self sendId];
        
        if ( application.applicationState == UIApplicationStateActive )
        {
        } else {
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Alert"];
            self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            User *newUser = [User sharedManager];
            
            NSLog(@"%@",self.devices);
            for(int i = 0; i< self.devices.count; i++)
            {
                NSManagedObject *device = [self.devices objectAtIndex:i];
                
                if([[device valueForKey:@"id"] isEqualToString:newUser.kidId ])
                {
                    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                    while (topRootViewController.presentedViewController)
                    {
                        topRootViewController = topRootViewController.presentedViewController;
                    }
                    topRootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
                    UIViewController *vc = self.window.rootViewController;
                    PushViewController *pvc = [vc.storyboard instantiateViewControllerWithIdentifier:@"push"];
                    pvc.device2 = device;
                    [topRootViewController presentViewController:pvc animated:YES completion:nil];

                }
            }
        }
    } else {
      /*  UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }
        topRootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        UIViewController *vc = self.window.rootViewController;
        MenuAlertViewController *pvc = [vc.storyboard instantiateViewControllerWithIdentifier:@"menuAlert"];
        [topRootViewController presentViewController:pvc animated:YES completion:nil];

        */
    }
}




#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "webbook.KidsAlert" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KidsAlert" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KidsAlert.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)sendId {
    User *newUser = [User sharedManager];
    NSDictionary *o1 = [[NSMutableDictionary alloc] init];
    [o1 setValue:newUser.kidId forKey:@"alert_id"];
    
    NSString * url = [URL1 stringByAppendingString:@"/get"];
    
    NSURL *myWebserverURL = [NSURL URLWithString:url];
    
    // Create the request
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:myWebserverURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    // Set the HTTP method.
    [theRequest setHTTPMethod:@"POST"];
    
    // Set useful headers
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1 options:NSJSONWritingPrettyPrinted error:nil];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    // NSData *theData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody: jsonData];
    
    
    
    // Use the private method setAllowsAnyHTTPSCertificate:forHost:
    // to not validate the HTTPS certificate.
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:URL1];
    
    // Create the NSURLConnection and init the request.
    NSURLConnection *s = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"%@", s);
   
}





- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response recieved");
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data
{
    NSLog(@"Data recieved");
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"DATA   %@", responseString);
    
    NSError *jsonError;
    NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if(![defaults objectForKey:[json objectForKey:@"id"]]) {
    // Create a new device
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Alert" inManagedObjectContext:context];
    [newDevice setValue:[json objectForKey:@"name"] forKey:@"name"];
    [newDevice setValue:[json objectForKey:@"gender"] forKey:@"gender"];
    [newDevice setValue:[json objectForKey:@"age"] forKey:@"age"];
    [newDevice setValue:[json objectForKey:@"photo"] forKey:@"photo"];
    [newDevice setValue:[json objectForKey:@"id"] forKey:@"id"];
    [newDevice setValue:[json objectForKey:@"user_id"] forKey:@"user_id"];
    [newDevice setValue:[json objectForKey:@"hair_color"] forKey:@"hair_color"];
    [newDevice setValue:[json objectForKey:@"eye_color"] forKey:@"eye_color"];
    [newDevice setValue:[json objectForKey:@"height"] forKey:@"height"];
    [newDevice setValue:[json objectForKey:@"weight"] forKey:@"weight"];
    [newDevice setValue:[json objectForKey:@"clothing"] forKey:@"clothing"];
    [newDevice setValue:[json objectForKey:@"special_features"] forKey:@"special_features"];
    [newDevice setValue:[json objectForKey:@"search_radius"] forKey:@"search_radius"];
    [newDevice setValue:[json objectForKey:@"last_seen"] forKey:@"last_seen"];
    [newDevice setValue:[json objectForKey:@"telephone"] forKey:@"telephone"];
    
    [defaults setObject:[json objectForKey:@"id"]forKey:[json objectForKey:@"id"]];
    [defaults synchronize];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Authentication challenge");
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"amber" ofType:@"p12"];
    
    NSData *p12data = [NSData dataWithContentsOfFile:filePath];
    CFDataRef inP12data = (__bridge CFDataRef)p12data;
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    CFStringRef password = CFSTR("111111");
    OSStatus status = extractIdentityAndTrust7(inP12data, &myIdentity, &myTrust, password);
    NSLog(@"%d", (int)status);
    SecCertificateRef myCertificate;
    SecIdentityCopyCertificate(myIdentity, &myCertificate);
    const void *certs[] = { myCertificate };
    CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
    
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
    
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection*) connection didFailWithError:(NSError *)error
{
    //  NSLog([NSString stringWithFormat:@"Did recieve error: %@", [error localizedDescription]]);
    //  NSLog([NSString stringWithFormat:@"%@", [error userInfo]]);
}


OSStatus extractIdentityAndTrust7(CFDataRef inPKCS12Data,
                                  SecIdentityRef *outIdentity,
                                  SecTrustRef *outTrust,
                                  CFStringRef keyPassword)
{
    OSStatus securityError = errSecSuccess;
    
    
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { keyPassword };
    CFDictionaryRef optionsDictionary = NULL;
    
    /* Create a dictionary containing the passphrase if one
     was specified.  Otherwise, create an empty dictionary. */
    optionsDictionary = CFDictionaryCreate(
                                           NULL, keys,
                                           values, (keyPassword ? 1 : 0),
                                           NULL, NULL);  // 1
    
    CFArrayRef items = NULL;
    securityError = SecPKCS12Import(inPKCS12Data,
                                    optionsDictionary,
                                    &items);                    // 2
    
    
    //
    if (securityError == 0) {                                   // 3
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             kSecImportItemIdentity);
        CFRetain(tempIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        
        CFRetain(tempTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }
    
    if (optionsDictionary)                                      // 4
        CFRelease(optionsDictionary);
    
    if (items)
        CFRelease(items);
    
    return securityError;
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}
@end

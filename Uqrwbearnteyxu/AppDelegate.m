//
//  AppDelegate.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 05/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "AppDelegate.h"
#import "RightMenuViewController.h"
#import "SlideNavigationController.h"
#import "UserModel.h"
#import "CommansUtility.h"
#import "TabbarViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard"
                                                             bundle: nil];

    RightMenuViewController *rightMenu = (RightMenuViewController*)[mainStoryboard
                                                                    instantiateViewControllerWithIdentifier: @"RightMenuViewController"];
    
    [SlideNavigationController sharedInstance].rightMenu = rightMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    

    UserModel *uModel = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];
    if(uModel && uModel.strClientUserName.length){
        NSLog(@"User was logged in");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard" bundle:nil];
        
        //SlideNavigationController *sViewController = [storyboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
        
        TabbarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"TabbarViewController"];

        [[SlideNavigationController sharedInstance] setViewControllers:[NSArray arrayWithObjects:tabBarVC, nil]];
        
        [UIApplication sharedApplication].keyWindow.rootViewController =     [SlideNavigationController sharedInstance];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        
        
        
    }
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
   
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
  //  NSLog(@"My token is: %@", deviceToken);
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];

    NSLog(@"TOKEN %@",token);
  //  [[[UIAlertView alloc]initWithTitle:@"TOKEN" message:token delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"apnsToken"]; //save token to resend it if request fails
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"apnsTokenSentSuccessfully"]; // set flag for request status
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}



@end

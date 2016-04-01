//
//  AskForLoginViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "AskForLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserService.h"
#import "MakeProfileViewController.h"
@interface AskForLoginViewController ()<WebServiceDelegate>
{
    NSString *accessToken;
}
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegistration;
@property (strong,nonatomic) IBOutlet  UIButton *btnFacebook;
@property (nonatomic, strong)UserService *userWebAPI;
@property (nonatomic, strong)NSString *strEmail;
@property (nonatomic, strong)NSData *currentFacebookImageData;
@end

@implementation AskForLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [[self.btnRegistration layer] setBorderWidth:2.0f];
    [[self.btnRegistration layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[self.btnRegistration layer] setCornerRadius:3.0f];
    [[self.btnLogin layer] setCornerRadius:3.0f];
    [[self.btnFacebook layer] setCornerRadius:3.0f];
    //FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
   // loginButton.center = self.view.center;
    //[self.btnFacebook addSubview:loginButton];
    // Do any additional setup after loading the view.
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
    }
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - SetUp
#pragma mark 

-(void)setUp{
    [self setUpButtons];
}

-(void)setUpButtons{
    [self addRightBorder:self.btnLogin];

}

-(void)addRightBorder:(UIView *)view{
    CALayer *layer=[[CALayer alloc]init];
    layer.frame=CGRectMake(view.frame.size.width, 5, 1, view.frame.size.height-10);
    layer.backgroundColor=[UIColor whiteColor].CGColor;
    
    [view.layer addSublayer:layer];
}

- (IBAction)btnFbLoginClicked:(id)sender {
   [[[UIAlertView alloc]initWithTitle:@"Coming soon" message:@"Facebook login functionality will be available in later release !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             NSLog(@"%@",result);
             if ([FBSDKAccessToken currentAccessToken]!=nil) {
                 // TODO:Token is already available.
                  accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                 [self ShowUserData];
             }

         }
     }];
    
}
-(void)ShowUserData
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture, id, name, gender, first_name, last_name, locale, email"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
             NSLog(@"fetched user:%@  and Email : %@", result,result[@"picture"]);
             NSString *pictureURL = [NSString stringWithFormat:@"%@",result[@"picture"][@"data"][@"url"]];
             
             NSLog(@"email is %@", [result objectForKey:@"email"]);
             self.strEmail=[NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
             self.currentFacebookImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
             //_imageView.image = [UIImage imageWithData:data];
           //  [self webAPIToFacebookLogin];
             //[self performSegueWithIdentifier:@"segueMakeProfile" sender:self];
             
         }
     }];
}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if ([[segue identifier] isEqualToString:@"segueMakeProfile"])
//        {
//            // Get reference to the destination view controller
//            MakeProfileViewController *makeProfileVC = [segue destinationViewController];
//            // Pass any objects to the view controller here, like...
//            makeProfileVC.strTxtUserName=self.strEmail;
//            makeProfileVC.strPassword=@"12345";
//            makeProfileVC.strConfirmPassowrd=@"12345";
//            makeProfileVC.imageFacebookData=self.currentFacebookImageData;
//            
//            
//        }
//    });
//    // Make sure your segue name in storyboard is the same as this line
//    
//}


#pragma mark - Call web service


//-(void)webAPIToFacebookLogin{
//    
//    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"];
//    
//    if(deviceToken.length==0){
//        deviceToken= @"abc";
//    }
//    self.userWebAPI = [[UserService alloc]init];
//    self.userWebAPI.delegate=self;
//    [self.userWebAPI loginWithUserName:self.strEmail andPassword:@"12345" token:deviceToken];
//    
//   
//}
//
//-(void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
//        if(responseData.count>0){
//            
//        }
//    
//}
//
//-(void)request:(id)serviceRequest didFailWithError:(NSError *)error{
//    [self webAPIToFacebookLogin];
//    
//}

//-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id)user{
//    NSLog(@"%@", user);
//    self.profilePicture.profileID = user.id;
//    self.lblUsername.text = user.name;
//    self.lblEmail.text = [user objectForKey:@"email"];
//}

-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"UrbanEx" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}


@end

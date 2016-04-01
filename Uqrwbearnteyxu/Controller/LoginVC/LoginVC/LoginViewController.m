//
//  LoginViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "LoginViewController.h"
//#import "VIewUtility.h"
//#import "TextFieldValidator.h"
#import "HUD.h"
#import "UserService.h"

#import "Constants.h"
#import "CommansUtility.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MakeProfileViewController.h"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"


@interface LoginViewController ()<UIAlertViewDelegate,WebServiceDelegate>
{
    IBOutlet UIImageView *userViewImage;
    IBOutlet UIImageView *passwordViewImage;
    IBOutlet UIButton *btnCanelUserText;
    IBOutlet UIButton *btnCancelPassowrdText;
    IBOutlet UIButton *btnForgetPawword;
    IBOutlet UIButton *btnFacebook;
    IBOutlet UIButton *btnLogin;
    UIView *backgrView;
}
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) UserService *userWebAPI;
@property (nonatomic, strong)NSString *strEmail;
@property (nonatomic, strong)NSData *currentFacebookImageData;

@end

@implementation LoginViewController{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
   //[self setUp];
    
    //self.txtEmail.text = @"tusharit25@gmail.com";
   // self.txtPassword.text = @"Tushar#123";
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    
    btnCanelUserText.hidden=YES;
    btnCancelPassowrdText.hidden=YES;
    btnForgetPawword.hidden=NO;
    // Do any additional setup after loading the view.
    [[btnLogin layer] setCornerRadius:3.0f];
    [[btnFacebook layer] setCornerRadius:3.0f];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)dismissKeyboard {
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         backgrView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 250);
                         
                     }
                     completion:^(BOOL finished){
                         [backgrView removeFromSuperview];
                         self.view.userInteractionEnabled=YES;
                         self.view.alpha=1.0;
                     }];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField==self.txtEmail) {
        if ([self.txtEmail.text length]>0) {
            BOOL validEmail =  [self NSStringIsValidEmail:self.txtEmail.text];
            if (validEmail) {
                userViewImage.image=[UIImage imageNamed:@"accepted.png"];
                

            }
            else {
                userViewImage.image=[UIImage imageNamed:@"denied.png"];
            }
            
             btnCanelUserText.hidden=NO;
        }
        else {
            userViewImage.image=[UIImage imageNamed:@"nuetral.png"];
            btnCanelUserText.hidden=YES;
        }
    }
    
    if (textField==self.txtPassword) {
        if ([self.txtPassword.text length]>0) {
    
            btnCancelPassowrdText.hidden=NO;
            btnForgetPawword.hidden=YES;
            
        }
        else {
            btnCancelPassowrdText.hidden=YES;
            btnForgetPawword.hidden=NO;

        }
    }
    [self IsValidLogin];


}
-(IBAction)clearTextFieldButtonClicked:(UIButton *)sender
{
    if (sender==btnCanelUserText) {
        self.txtEmail.text=@"";
        userViewImage.image=[UIImage imageNamed:@"nuetral.png"];
        btnCanelUserText.hidden=YES;
    }
    if (sender==btnCancelPassowrdText) {
        self.txtPassword.text=@"";
        btnCancelPassowrdText.hidden=YES;
        btnForgetPawword.hidden=NO;
    }
    [self IsValidLogin];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
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

//-(void)setUp{
//    //[self setUpButtons];
//    [self setUptextFields];
//}

//-(void)setUpButtons{
//    [VIewUtility addHexagoneShapeMaskFor:self.btnGo];
//    [VIewUtility addHexagoneShapeMaskFor:self.viewBtnContainer];
//
//}

//-(void)setUptextFields{
//    [self setupAlerts];
//
//    NSAttributedString *strEmail = [[NSAttributedString alloc] initWithString:@"email" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
//    self.txtEmail.attributedPlaceholder = strEmail;
//    NSAttributedString *strPassword = [[NSAttributedString alloc] initWithString:@"password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
//    self.txtPassword.attributedPlaceholder = strPassword;
//
//    self.txtEmail.returnKeyType = UIReturnKeyNext;
//    self.txtPassword.returnKeyType = UIReturnKeySend;
//    
//    //[self addBottomBorder:self.txtEmail];
//    //[self addBottomBorder:self.txtPassword];
//
//  //  [self leftPanelView:self.txtPassword withImage:[UIImage imageNamed:@"password.png"]];
//   // [self leftPanelView:self.txtEmail withImage:[UIImage imageNamed:@"person-icon.png"]];
//}
//-(void)addBottomBorder:(UIView *)view{
//    CALayer *layer=[[CALayer alloc]init];
//    layer.frame=CGRectMake(0, view.frame.size.height-1, view.frame.size.width,1);
//    layer.backgroundColor=[UIColor whiteColor].CGColor;
//    
//    [view.layer addSublayer:layer];
//}

//-(void)leftPanelView:(UITextField *)txt withImage:(UIImage *)image{
//    UIView *panel =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//    UIImageView *imageview=[[UIImageView alloc]initWithFrame:panel.bounds];
//    imageview.image=image;
//    imageview.contentMode = UIViewContentModeScaleAspectFit;
//    [panel addSubview:imageview];
//    
//    txt.leftView = panel;
//    txt.leftViewMode =UITextFieldViewModeAlways;
//    
//}
//-(void)setupAlerts{
//    [self.txtEmail addRegx:REGEX_EMAIL withMsg:@"Please enter a valid email address"];
//
//    self.txtEmail.isMandatory = YES;
//    self.txtPassword.isMandatory = YES;
//    self.txtEmail.validateOnCharacterChanged=YES;
//    self.txtEmail.validateOnResign=YES;
//}

//-(void)addTapGuesture{
//    if(tapGuesture){
//        [self.view removeGestureRecognizer:tapGuesture];
//    }
//    

//}

-(BOOL)IsValidLogin
{
    BOOL loginValid;
    if ([self.txtEmail.text length]>0 && [self.txtPassword.text length]>0) {
        BOOL validEmail =  [self NSStringIsValidEmail:self.txtEmail.text];
        if (validEmail && [self.txtPassword.text length]>4) {
             btnLogin.backgroundColor=[UIColor clearColor];
            btnLogin.backgroundColor=[UIColor colorWithRed:221/225.0 green:160/255.0 blue:60/255.0 alpha:1.0];
            loginValid=YES;
        }
        else
        {
            btnLogin.backgroundColor=[UIColor clearColor];
            btnLogin.backgroundColor=[UIColor colorWithRed:247/225.0 green:168/255.0 blue:52/255.0 alpha:1.0];
            loginValid=NO;
            
        }

    }
    else
    {
        btnLogin.backgroundColor=[UIColor clearColor];
        btnLogin.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        loginValid=NO;
        
    }
    
    return loginValid;
}

#pragma mark Button Delegates

//- (IBAction)btnForgotPasswordClicked:(id)sender {
//    [self showAlertForForgotPassword];
//}

- (IBAction)btnLoginClicked:(id)sender {
 
    BOOL isValidLogin =[self IsValidLogin];
    if (isValidLogin) {
        [self.txtEmail resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        [self webAPIToLogin];
    }
    else
    {
//        userViewImage.image=[UIImage imageNamed:@"nuetral.png"];
//        btnCanelUserText.hidden=YES;
//        self.txtPassword.text=@"";
//        btnCancelPassowrdText.hidden=YES;
//        btnForgetPawword.hidden=NO;
//        [self.txtEmail resignFirstResponder];
//        [self.txtPassword resignFirstResponder];
//        self.btnLogin.backgroundColor=[UIColor colorWithRed:170/225.0 green:170/255.0 blue:170/255.0 alpha:1.0];
       
       
        
        
    }
    
    
}
-(void)ForgetAndUSerNameScreen
{
    
    [self.txtPassword resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    self.view.userInteractionEnabled=NO;
    self.view.alpha=0.65;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    backgrView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width,200)];
    backgrView.backgroundColor = [UIColor colorWithRed:239/255.0 green:241/255.0 blue:238/255.0 alpha:0.85];
    backgrView.alpha = 1.0;
    UIImageView *imageError=[[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-25, 20, 50, 50)];
    imageError.image=[UIImage imageNamed:@"alertIcon@2x.png"];
    [backgrView addSubview:imageError];
    UILabel *labErrorMessage=[[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-100, 62, 200, 35)];
    labErrorMessage.text=@"incorrect password";
    labErrorMessage.backgroundColor=[UIColor clearColor];
    labErrorMessage.font=[UIFont fontWithName:@"SFUIText-Italic" size:14.0];
    labErrorMessage.textAlignment=NSTextAlignmentCenter;
    [backgrView addSubview:labErrorMessage];
    UIButton *btnOkay=[UIButton buttonWithType:UIButtonTypeCustom];
    btnOkay.frame=CGRectMake(20,labErrorMessage.frame.size.height+labErrorMessage.frame.origin.y+5,[[UIScreen mainScreen] bounds].size.width-40, 35);
    btnOkay.titleLabel.font=[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0];
    [btnOkay setTitle:@"okay" forState:UIControlStateNormal];
    [btnOkay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnOkay.backgroundColor=[UIColor whiteColor];
    [[btnOkay layer] setBorderWidth:1.0f];
    [[btnOkay layer] setBorderColor:[UIColor blackColor].CGColor];
    [[btnOkay layer] setCornerRadius:3.0f];
    [btnOkay addTarget:self action:@selector(okaybuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backgrView addSubview:btnOkay];
    
    UIButton *btnForget=[UIButton buttonWithType:UIButtonTypeCustom];
    btnForget.frame=CGRectMake(20,btnOkay.frame.size.height+btnOkay.frame.origin.y+8, [[UIScreen mainScreen] bounds].size.width-40, 35);
    [btnForget setTitle:@"forgot password" forState:UIControlStateNormal];
     btnForget.titleLabel.font=[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0];
    [btnForget setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnForget.backgroundColor=[UIColor whiteColor];
    [[btnForget layer] setBorderWidth:1.0f];
    [[btnForget layer] setBorderColor:[UIColor blackColor].CGColor];
    [[btnForget layer] setCornerRadius:3.0f];
    [btnForget addTarget:self action:@selector(ForgotbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backgrView addSubview:btnForget];
    
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         backgrView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-200, [[UIScreen mainScreen] bounds].size.width, 200);
                     }
                     completion:^(BOOL finished){
                     }];
    [[appDelegate window] addSubview:backgrView];
}
-(void)okaybuttonClicked
{
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         backgrView.alpha = 1.0;
                         backgrView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 200);
                         
                         
                     }
                     completion:^(BOOL finished){
                         [backgrView removeFromSuperview];
                         self.view.userInteractionEnabled=YES;
                         self.view.alpha=1.0;
                     }];
    
}
-(void)ForgotbuttonClicked
{
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         backgrView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 200);
                         
                     }
                     completion:^(BOOL finished){
                         [backgrView removeFromSuperview];
                         [self performSegueWithIdentifier:@"segueForgotPassword" sender:self];
                         self.view.userInteractionEnabled=YES;
                          self.view.alpha=1.0;
                     }];
    
    
}
- (IBAction)btnCancelClicked:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Forgot password

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        //[self keyboardWillBeHidden:nil];
        
        //[self btnGoClicked:nil];
        
    }
    return NO;
}



#pragma mark - Call web service


-(void)webAPIToLogin{

    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"];
    
    if(deviceToken.length==0){
        deviceToken= @"abc";
    }
    self.userWebAPI = [[UserService alloc]init];
    self.userWebAPI.delegate=self;
    self.userWebAPI.tag=0;
    [self.userWebAPI loginWithUserName:self.txtEmail.text andPassword:self.txtPassword.text token:deviceToken];
    
    [[HUD sharedInstance]showHUD:self.view];
}

-(void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    [[HUD sharedInstance]hideHUD:self.view];
    UserService *service = (UserService *)serviceRequest;
    
    if(service.tag == 0){
        if(responseData.count>0){
            UserModel *model = (UserModel *)[responseData objectAtIndex:0];
            
            [[CommansUtility sharedInstance]saveUserObject:model key:@"loggedInUser"];
            
            if(model.strClientUserName.length>0){
                [self performSegueWithIdentifier:@"segueTabBarFromLogin" sender:self];
            }
            else{
               [self performSegueWithIdentifier:@"segueTabBarFromLogin" sender:self];
            }
            self.txtEmail.text=@"";
            userViewImage.image=[UIImage imageNamed:@"nuetral.png"];
            btnCanelUserText.hidden=YES;
            self.txtPassword.text=@"";
            btnCancelPassowrdText.hidden=YES;
            btnForgetPawword.hidden=NO;
            [self.txtEmail resignFirstResponder];
             [self.txtPassword resignFirstResponder];
            btnLogin.backgroundColor=[UIColor clearColor];
             btnLogin.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        }
    }
}

-(void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    UserService *service = (UserService *)serviceRequest;
    
    if(service.tag == 0){
        [[HUD sharedInstance]hideHUD:self.view];
      //  [self showErrorMessage:error.localizedDescription];
        [self ForgetAndUSerNameScreen];
        self.txtEmail.text=@"";
        userViewImage.image=[UIImage imageNamed:@"nuetral.png"];
        btnCanelUserText.hidden=YES;
        self.txtPassword.text=@"";
        btnCancelPassowrdText.hidden=YES;
        btnForgetPawword.hidden=NO;
        [self.txtEmail resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        btnLogin.backgroundColor=[UIColor clearColor];
        btnLogin.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    }
   

}


- (IBAction)btnFBLoginClicked:(id)sender {
//    [[[UIAlertView alloc]initWithTitle:@"Coming soon" message:@"Facebook login functionality will be available in later release !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
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
            // [self webAPIToFacebookLogin];
             [self performSegueWithIdentifier:@"segueMakeProfile" sender:self];
             
         }
     }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[segue identifier] isEqualToString:@"segueMakeProfile"])
        {
            // Get reference to the destination view controller
            MakeProfileViewController *makeProfileVC = [segue destinationViewController];
            // Pass any objects to the view controller here, like...
            makeProfileVC.strTxtUserName=self.strEmail;
            makeProfileVC.strPassword=@"12345";
            makeProfileVC.strConfirmPassowrd=@"12345";
            makeProfileVC.imageFacebookData=self.currentFacebookImageData;
            
            
        }
    });
    // Make sure your segue name in storyboard is the same as this line
    
}
//-(void)webAPIToFacebookLogin{
//    
//    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"];
//    
//    if(deviceToken.length==0){
//        deviceToken= @"abc";
//    }
//    self.userWebAPI = [[UserService alloc]init];
//    self.userWebAPI.delegate=self;
//    self.userWebAPI.tag=1;
//    [self.userWebAPI loginWithUserName:self.strEmail andPassword:@"12345" token:deviceToken];
//    
//    
//}


-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"ERROR" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}


@end

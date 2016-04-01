//
//  RegisterViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserService.h"
#import "HUD.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "MakeProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//#import "CameraSessionView.h"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
//#define REGEX_PASSWORD @"^(?=.*?[0-9].*?[0-9])(?=.*[!@#$%])[0-9a-zA-Z!@#$%0-9]{6,}"
#define REGEX_PASSWORD @"^.*(?=.{6,})(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*${6,}"
//#define REGEX_PASSWORD @"^[a-zA-Z0-9]*$"

@interface RegisterViewController ()<UITextFieldDelegate,WebServiceDelegate>
{
    IBOutlet UIButton *btnCancelUserText;
    IBOutlet UIButton *btnCancelPasswordText;
    IBOutlet UIButton *btnCancelRePasswordText;
    IBOutlet UIButton *btnRegister;
    IBOutlet UIButton *btnFacebook;
    IBOutlet UIImageView *emailImageView;
    IBOutlet UIImageView *passwordImageView;
    IBOutlet UIImageView *rePasswordImageView;
}

@property (strong, nonatomic) IBOutlet UITextField *txtEmailID;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (strong, nonatomic) UserService *userWebAPI;
@property (nonatomic, strong)NSString *strEmail;
@property (nonatomic, strong)NSString *strDateOfBirth;
@property (nonatomic, strong)NSString *strMaleAndFemale;
@property (nonatomic, strong)NSData *currentFacebookImageData;
@property (nonatomic)BOOL isFaceBookData;
@end

@implementation RegisterViewController{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setUp];
    //self.txtEmailID.text = @"rahul52@gmail.com";
    //self.txtPassword.text = @"Rahul@123";
      //  self.txtConfirmPassword.text = @"Rahul@123";
    
    // Do any additional setup after loading the view.
    btnCancelUserText.hidden=YES;
    btnCancelPasswordText.hidden=YES;
    btnCancelRePasswordText.hidden=YES;
    [[btnRegister layer] setCornerRadius:3.0f];
    [[btnFacebook layer] setCornerRadius:3.0f];
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)dismissKeyboard {
    [self.txtEmailID resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
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


#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
   // [self animateTextField:textField up:NO];
    //activeTextfield = nil;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField==self.txtEmailID) {
        if ([self.txtEmailID.text length]>0) {
            BOOL validEmail =  [self NSStringIsValidEmail:self.txtEmailID.text];
            if (validEmail) {
               emailImageView.image=[UIImage imageNamed:@"emaiGreen.png"];
                
                
                
            }
            else {
               emailImageView.image=[UIImage imageNamed:@"email.png"];
                
            }
            
            btnCancelUserText.hidden=NO;
        }
        else {
            emailImageView.image=[UIImage imageNamed:@"email.png"];
            btnCancelUserText.hidden=YES;
            
        }
    }
    
    if (textField==self.txtPassword) {
        if ([self.txtPassword.text length]>0) {
            if ([self.txtPassword.text length]>=5) {
                passwordImageView.image=[UIImage imageNamed:@"passwordGreen.png"];
            }
            else
            {
                passwordImageView.image=[UIImage imageNamed:@"password.png"];
            }
            
            btnCancelPasswordText.hidden=NO;
            
            
        }
        else {
            passwordImageView.image=[UIImage imageNamed:@"password.png"];
            btnCancelPasswordText.hidden=YES;
            
        }
    }
    if (textField==self.txtConfirmPassword) {
        if ([self.txtConfirmPassword.text length]>0) {
            if ([self.txtConfirmPassword.text isEqualToString:self.txtPassword.text]) {
                rePasswordImageView.image=[UIImage imageNamed:@"passwordGreen.png"];
            }
            else
            {
                rePasswordImageView.image=[UIImage imageNamed:@"password.png"];
            }
            
            btnCancelRePasswordText.hidden=NO;
            
            
        }
        else {
            rePasswordImageView.image=[UIImage imageNamed:@"password.png"];
            btnCancelRePasswordText.hidden=YES;
            
        }
    }
    [self IsValidLogin];
    
    
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField==self.txtPassword) {
//        NSString *currentString = [self.txtPassword.text stringByReplacingCharactersInRange:range withString:string];
//        int length = [currentString length];
//        if (length < 5) {
//            return NO;
//        }
//        return YES;
//    }
//    if (textField==self.txtConfirmPassword) {
//        NSString *currentString = [self.txtConfirmPassword.text stringByReplacingCharactersInRange:range withString:string];
//        int length = [currentString length];
//        if (length < 5) {
//            return NO;
//        }
//        return YES;
//    }
//    
//    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
//                                                                   withString:string];
//    return resultText.length  10;
//    return YES;
//    
//}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)IsValidLogin
{
    BOOL loginValid;
    if ([self.txtEmailID.text length]>0 && [self.txtPassword.text length]>0 && [self.txtConfirmPassword.text length]>0 && [self.txtPassword.text length]>=5) {
        BOOL validEmail =  [self NSStringIsValidEmail:self.txtEmailID.text];
        if (validEmail && [self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
            btnRegister.backgroundColor=[UIColor colorWithRed:247/225.0 green:178/255.0 blue:52/255.0 alpha:1.0];
            loginValid=YES;
        }
        else
        {
//            btnRegister.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
//            loginValid=NO;
            
        }
        
    }
    else
    {
        btnRegister.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        loginValid=NO;
        
    }
//    if ([passwordField.text isEqualToString:passwordConfirmField.text])
//    {
//        //they are equal to each other
//    }
//    else
//    {
//        //they are not equal to each other
//    }
    
    return loginValid;
}

-(IBAction)clearTextFieldButtonClicked:(UIButton *)sender
{
    if (sender==btnCancelUserText) {
        self.txtEmailID.text=@"";
        btnCancelUserText.hidden=YES;
        emailImageView.image=[UIImage imageNamed:@"email.png"];
    }
    if (sender==btnCancelPasswordText) {
        self.txtPassword.text=@"";
        btnCancelPasswordText.hidden=YES;
        passwordImageView.image=[UIImage imageNamed:@"password.png"];
        
    }
    if (sender==btnCancelRePasswordText) {
        self.txtConfirmPassword.text=@"";
        btnCancelRePasswordText.hidden=YES;
        rePasswordImageView.image=[UIImage imageNamed:@"password.png"];
        
    }
    [self IsValidLogin];
}

#pragma mark - Helpers
-(void)clearAllFieldsAndShowKeyBoard
{
    self.txtEmailID.text=@"";
    btnCancelUserText.hidden=YES;
    emailImageView.image=[UIImage imageNamed:@"email.png"];
    self.txtPassword.text=@"";
    btnCancelPasswordText.hidden=YES;
    passwordImageView.image=[UIImage imageNamed:@"password.png"];
    self.txtConfirmPassword.text=@"";
    btnCancelRePasswordText.hidden=YES;
    rePasswordImageView.image=[UIImage imageNamed:@"password.png"];
    [self.txtEmailID becomeFirstResponder];
}
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
       // [self animateTextField:textField up:NO];
        [self btnGoClicked:nil];

    }
    return NO;
}



#pragma mark - Button Delegates

- (IBAction)btnGoClicked:(id)sender {
    
 //   [self dismissViewControllerAnimated:YES completion:nil];
 //   return;
    
    
//    if([self.txtEmailID validate] && [self.txtPassword validate] && [self.txtConfirmPassword validate]){
//        [[HUD sharedInstance]showHUD:self.view];
//        [self webAPIToRegister];
//    }
    [self dismissKeyboard];
    BOOL isValidRegister=[self IsValidLogin];
    if (isValidRegister) {
        //self.isFaceBookData=NO;
        [[HUD sharedInstance]showHUD:self.view];
        [self webAPIToRegister];

    }

}

- (IBAction)btnCancelClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnFacebookClicked:(id)sender {
   // [[[UIAlertView alloc]initWithTitle:@"Coming soon" message:@"Facebook login functionality will be available in later release !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends", @"user_birthday"]
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
    //self.isFaceBookData=YES;
    //@{@"fields": @"picture,id,name, gender, first_name, last_name, locale, email, user_birthday"}
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture,id,name, gender, first_name, last_name, locale, email, birthday, bio"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
             NSLog(@"fetched user:%@  and Email : %@", result,result[@"picture"]);
             NSString *pictureURL = [NSString stringWithFormat:@"%@",result[@"picture"][@"data"][@"url"]];
             
             NSLog(@"email is %@", [result objectForKey:@"email"]);
             self.strEmail=[NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
             self.currentFacebookImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
             //_imageView.image = [UIImage imageWithData:data];
             self.txtEmailID.text=self.strEmail;
             self.strDateOfBirth=[NSString stringWithFormat:@"%@",[result objectForKey:@"birthday"]];
             self.strMaleAndFemale=[NSString stringWithFormat:@"%@",[result objectForKey:@"gender"]];
              self.isFaceBookData=YES;
             //[self webAPIToFacebookLogin];
            // [self performSegueWithIdentifier:@"segueMakeProfile" sender:self];
             
         }
     }];
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

#pragma mark - Call web service

-(void)webAPIToRegister{
    self.userWebAPI = [[UserService alloc]init];
    self.userWebAPI.delegate = self;
    self.userWebAPI.tag=0;
    [self.userWebAPI CheckEmailId:self.txtEmailID.text];
    
    //[service signInWithEmailId:@"abc@brandscape-online.com" password:@"Tushar#123" deviceToken:nil target:self onSuccess:nil onFailure:nil];
    
}

-(void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    UserService *service = (UserService *)serviceRequest;
    
    if(service.tag == 0){
    [[HUD sharedInstance]hideHUD:self.view];
    if(error.code == 1001){
        [self showErrorMessage:@"The entered Email is already taken. Please choose a different Email address."];
    }
    else{
        [self showErrorMessage:error.localizedDescription];
    }
    [self clearAllFieldsAndShowKeyBoard];
    }
    
}

-(void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    
   // [self showErrorMessage:@"User registered successfully"];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
   /// [[[UIAlertView alloc]initWithTitle:@"CONGRATULATIONS" message:@"User registered successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
  //  UIStoryboardSegue *segue=[UIStoryboardSegue se];
//    MakeProfileViewController *makeProfileVC = [[MakeProfileViewController alloc] init];
//    
//    // Pass any objects to the view controller here, like...
//    makeProfileVC.strTxtUserName=self.txtEmailID.text;
//    makeProfileVC.strPassword=self.txtPassword.text;
//    makeProfileVC.strConfirmPassowrd=self.txtConfirmPassword.text;

/*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    MakeProfileViewController *makeProfileVC = [[MakeProfileViewController alloc] init];
    
        // Pass any objects to the view controller here, like...
        makeProfileVC.strTxtUserName=self.txtEmailID.text;
        makeProfileVC.strPassword=self.txtPassword.text;
        makeProfileVC.strConfirmPassowrd=self.txtConfirmPassword.text;

});*/
      //[self prepareForSegue:@"segueMakeProfile" sender:self];
    UserService *service = (UserService *)serviceRequest;
    if(service.tag == 0){
        [[HUD sharedInstance]hideHUD:self.view];
    [self performSegueWithIdentifier:@"segueMakeProfile" sender:self];
    
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[segue identifier] isEqualToString:@"segueMakeProfile"])
        {
            // Get reference to the destination view controller
            MakeProfileViewController *makeProfileVC = [segue destinationViewController];
            // Pass any objects to the view controller here, like...
            
                makeProfileVC.strTxtUserName=self.txtEmailID.text;
                makeProfileVC.strPassword=self.txtPassword.text;
                makeProfileVC.strConfirmPassowrd=self.txtConfirmPassword.text;
            if (self.isFaceBookData) {
                makeProfileVC.imageFacebookData=self.currentFacebookImageData;
                makeProfileVC.strFacebookDateOfBirth=self.strDateOfBirth;
                makeProfileVC.strFacebookMaleAndFemale=self.strMaleAndFemale;
            }
            
           
            
        }

    });
    // Make sure your segue name in storyboard is the same as this line
    
}


-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"ERROR" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}


@end

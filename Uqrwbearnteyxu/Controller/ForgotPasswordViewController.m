//
//  ForgotPasswordViewController.m
//  Uqrwbearnteyxu
//
//  Created by Mac on 03/03/16.
//  Copyright © 2016 Anurag Agrawal All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "HUD.h"
#import "UserService.h"
#import <QuartzCore/QuartzCore.h>
@interface ForgotPasswordViewController ()<UITextFieldDelegate,WebServiceDelegate>
{
    IBOutlet UIButton *btnCanelUserText;
    
}
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) UserService *userWebAPI;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    btnCanelUserText.hidden=YES;
    [[self.btnSend layer] setCornerRadius:3.0f];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];


    // Do any additional setup after loading the view.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)dismissKeyboard {
    [self.txtEmail resignFirstResponder];
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

#pragma mark - back button functionality
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField==self.txtEmail) {
        if ([self.txtEmail.text length]>0) {
            BOOL validEmail =  [self NSStringIsValidEmail:self.txtEmail.text];
            if (validEmail) {
                
                btnCanelUserText.hidden=NO;
                self.btnSend.backgroundColor=[UIColor colorWithRed:247/225.0 green:178/255.0 blue:52/255.0 alpha:1.0];
            }
            else
            {
                btnCanelUserText.hidden=NO;
                self.btnSend.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
            }
    
            
            
        }
        else {
            btnCanelUserText.hidden=YES;
             self.btnSend.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        }
        
    }
}

#pragma mark -- helper method

//-(BOOL)IsValidSend
//{
//    BOOL loginValid;
//    if ([self.txtEmail.text length]>0) {
//        BOOL validEmail =  [self NSStringIsValidEmail:self.txtEmail.text];
//        if (validEmail) {
//            self.btnSend.backgroundColor=[UIColor colorWithRed:221/225.0 green:160/255.0 blue:60/255.0 alpha:1.0];
//            loginValid=YES;
//        }
//        
//    }
//    else
//    {
//        self.btnSend.backgroundColor=[UIColor colorWithRed:170/225.0 green:170/255.0 blue:170/255.0 alpha:1.0];
//        loginValid=NO;
//        
//    }
//    
//    return loginValid;
//}

#pragma mark - email validation method

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - clear text field x button method
-(IBAction)clearTextFieldButtonClicked:(UIButton *)sender
{
    if (sender==btnCanelUserText) {
        btnCanelUserText.hidden=YES;
        BOOL validEmail =  [self NSStringIsValidEmail:self.txtEmail.text];
        self.txtEmail.text=@"";
        if (validEmail) {
            self.btnSend.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        }
        
    }
    
}

#pragma mark - send button clicked method

- (IBAction)btnSendClicked:(id)sender {
    [self.txtEmail resignFirstResponder];
    
    BOOL isValidEmail =[self NSStringIsValidEmail:self.txtEmail.text];
    if (isValidEmail) {
        self.btnSend.backgroundColor=[UIColor colorWithRed:247/225.0 green:178/255.0 blue:52/255.0 alpha:1.0];
        [self webAPIForgotPassword:self.txtEmail.text];
    }
    else
    {
//        NSString *strTitle=nil;
//        if ([self.txtEmail.text length]>0) {
//            strTitle=@"Please Enter the valid email";
//        }
//        else
//        {
//            strTitle=@"Email can not be blank";
//        }
//        UIAlertController* alert = [UIAlertController
//                                    alertControllerWithTitle:strTitle    //  Must be "nil", otherwise a blank title area will appear above our two buttons
//                                    message:nil
//                                    preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        UIAlertAction* button0 = [UIAlertAction
//                                  actionWithTitle:@"Okay"
//                                  style:UIAlertActionStyleCancel
//                                  handler:^(UIAlertAction * action)
//                                  {
//                                      //  UIAlertController will automatically dismiss the view
//                                  }];
//        
////        UIAlertAction* button1 = [UIAlertAction
////                                  actionWithTitle:@"Okay"
////                                  style:UIAlertActionStyleDefault
////                                  handler:^(UIAlertAction * action)
////                                  {
////                                      //  The user tapped on "Take a photo"
//////                                      UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//////                                      imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//////                                      imagePickerController.delegate = self;
//////                                      [self presentViewController:imagePickerController animated:YES completion:^{}];
////                                  }];
//        
////        UIAlertAction* button2 = [UIAlertAction
////                                  actionWithTitle:@"Choose Existing"
////                                  style:UIAlertActionStyleDefault
////                                  handler:^(UIAlertAction * action)
////                                  {
////                                      //  The user tapped on "Choose existing"
//////                                      UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//////                                      imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//////                                      imagePickerController.delegate = self;
//////                                      [self presentViewController:imagePickerController animated:YES completion:^{}];
////                                  }];
//        
//       [alert addAction:button0];
//        //[alert addAction:button1];
//        //[alert addAction:button2];
//        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
}
#pragma mark - Call web service

-(void)webAPIForgotPassword:(NSString *)strEmail{
    self.userWebAPI = [[UserService alloc]init];
    self.userWebAPI.tag = 1;
    self.userWebAPI.delegate = self;
    [self.userWebAPI forgotPasswordWithEmailID:strEmail];
    
    [[HUD sharedInstance]showHUD:self.view];
}
-(void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    [[HUD sharedInstance]hideHUD:self.view];
    UserService *service = (UserService *)serviceRequest;
    
    if (service.tag ==1){
        [[HUD sharedInstance]hideHUD:self.view];
        self.btnSend.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        self.txtEmail.text=@"";
        btnCanelUserText.hidden=YES;
        [[[UIAlertView alloc]initWithTitle:@"Thank you" message:@"Password reset link send. Please check your inbox" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        
        
    }
}

-(void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    UserService *service = (UserService *)serviceRequest;
    
    if (service.tag ==1){
        [[HUD sharedInstance]hideHUD:self.view];
        self.btnSend.backgroundColor=[UIColor colorWithRed:205/225.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        self.txtEmail.text=@"";
        btnCanelUserText.hidden=YES;
        [self showErrorMessage:@"Not able to send reset link"];
        
    }
}

#pragma mark -- error message method
-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"ERROR" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

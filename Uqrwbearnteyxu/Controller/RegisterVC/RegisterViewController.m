//
//  RegisterViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "RegisterViewController.h"
#import "TextFieldValidator.h"
#import "VIewUtility.h"
#import "UserService.h"

#import "HUD.h"


#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
//#define REGEX_PASSWORD @"^(?=.*?[0-9].*?[0-9])(?=.*[!@#$%])[0-9a-zA-Z!@#$%0-9]{6,}"
#define REGEX_PASSWORD @"^.*(?=.{6,})(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*${6,}"
//#define REGEX_PASSWORD @"^[a-zA-Z0-9]*$"

@interface RegisterViewController ()<WebServiceDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnGo;
@property (strong, nonatomic) IBOutlet UIView *viewButtonContainer;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtEmailID;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtPassword;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtConfirmPassword;
@property (strong, nonatomic) UserService *userWebAPI;

@end

@implementation RegisterViewController{
    UITextField *activeTextfield;
    UITapGestureRecognizer *tapGuesture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    //self.txtEmailID.text = @"rahul52@gmail.com";
    //self.txtPassword.text = @"Rahul@123";
      //  self.txtConfirmPassword.text = @"Rahul@123";
    
    // Do any additional setup after loading the view.
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
    [self setUptextFields];
}

-(void)setUpButtons{
    [VIewUtility addHexagoneShapeMaskFor:self.btnGo];
    [VIewUtility addHexagoneShapeMaskFor:self.viewButtonContainer];
    
}

-(void)setUptextFields{
    [self setupAlerts];
    
    NSAttributedString *strEmail = [[NSAttributedString alloc] initWithString:@"email" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtEmailID.attributedPlaceholder = strEmail;
    NSAttributedString *strPassword = [[NSAttributedString alloc] initWithString:@"password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtPassword.attributedPlaceholder = strPassword;

    NSAttributedString *strRepeatPassword = [[NSAttributedString alloc] initWithString:@"repeat password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtConfirmPassword.attributedPlaceholder = strRepeatPassword;

    
    [self addBottomBorder:self.txtEmailID];
    [self addBottomBorder:self.txtPassword];
    [self addBottomBorder:self.txtConfirmPassword];
    
    [self leftPanelView:self.txtPassword withImage:[UIImage imageNamed:@"lock.png"]];
    [self leftPanelView:self.txtEmailID withImage:[UIImage imageNamed:@"user.png"]];

    [self leftPanelView:self.txtConfirmPassword withImage:[UIImage imageNamed:@"lock.png"]];
    
    self.txtEmailID.returnKeyType = UIReturnKeyNext;
    self.txtPassword.returnKeyType = UIReturnKeyNext;

    self.txtConfirmPassword.returnKeyType = UIReturnKeySend;

}
-(void)addBottomBorder:(UIView *)view{
    CALayer *layer=[[CALayer alloc]init];
    layer.frame=CGRectMake(0, view.frame.size.height-1, view.frame.size.width,1);
    layer.backgroundColor=[UIColor whiteColor].CGColor;
    
    [view.layer addSublayer:layer];
}

-(void)leftPanelView:(UITextField *)txt withImage:(UIImage *)image{
    UIView *panel =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:panel.bounds];
    imageview.image=image;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [panel addSubview:imageview];
    
    txt.leftView = panel;
    txt.leftViewMode =UITextFieldViewModeAlways;
    
}

-(void)setupAlerts{
    
    [self.txtEmailID addRegx:REGEX_EMAIL withMsg:@"Please enter a valid email address"];
    self.txtEmailID.validateOnResign=YES;
    
  //  [self.txtPassword addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
    [self.txtPassword addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    
      [self.txtPassword addRegx:REGEX_PASSWORD withMsg:@"The entered password does not fit the password guilines. The password must be at lease 6 digits long contains one upper case and one lower case character and one number. Ex - Sample123"];

    
    [self.txtConfirmPassword addConfirmValidationTo:self.txtPassword withMsg:@"The entered passwords does not match. Please enter two matching passwords"];

    
}

-(void)addTapGuesture{
    if(tapGuesture){
        [self.view removeGestureRecognizer:tapGuesture];
    }
    
    tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuestureFired:)];
    [self.view addGestureRecognizer:tapGuesture];
}


#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!activeTextfield){
       // [self animateTextField:textField up:YES];
    }
    activeTextfield=textField;
    [self addTapGuesture];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
   // [self animateTextField:textField up:NO];
    activeTextfield = nil;
}


-(void)tapGuestureFired:(UITapGestureRecognizer *)tap{
    [self.view removeGestureRecognizer:tapGuesture];
    tapGuesture=nil;
    if(activeTextfield){
        [activeTextfield resignFirstResponder];
        //[self animateTextField:activeTextfield up:NO];
    }
}

#pragma mark - Helpers

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
    
    
    if([self.txtEmailID validate] && [self.txtPassword validate] && [self.txtConfirmPassword validate]){
        [[HUD sharedInstance]showHUD:self.view];
        [self webAPIToRegister];
    }

}

- (IBAction)btnCancelClicked:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:^{
        
  //  }];
    
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnFacebookClicked:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"Coming soon" message:@"Facebook login functionality will be available in later release !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

}

#pragma mark - Call web service

-(void)webAPIToRegister{
    self.userWebAPI = [[UserService alloc]init];
    self.userWebAPI.delegate = self;
    
    [self.userWebAPI registerWithUserName:self.txtEmailID.text andPassword:self.txtPassword.text];
    
    //[service signInWithEmailId:@"abc@brandscape-online.com" password:@"Tushar#123" deviceToken:nil target:self onSuccess:nil onFailure:nil];
    
}

-(void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    [[HUD sharedInstance]hideHUD:self.view];
    if(error.code == 1001){
        [self showErrorMessage:@"The entered Email is already taken. Please choose a different Email address."];
    }
    else{
        [self showErrorMessage:error.localizedDescription];
    }
}

-(void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    [[HUD sharedInstance]hideHUD:self.view];
   // [self showErrorMessage:@"User registered successfully"];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[[UIAlertView alloc]initWithTitle:@"CONGRATULATIONS" message:@"User registered successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"ERROR" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}


@end

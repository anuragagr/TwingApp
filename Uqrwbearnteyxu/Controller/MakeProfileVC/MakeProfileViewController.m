//
//  MakeProfileViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "MakeProfileViewController.h"
#import "TextFieldValidator.h"
#import "VIewUtility.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AADatePicker.h"
#import "CommansUtility.h"
#import "UserService.h"

#import "MBProgressHUD.h"


@interface MakeProfileViewController ()<WebServiceDelegate,CustomDatePickerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgviewProfile;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *btnMale;
@property (strong, nonatomic) IBOutlet UIButton *btnFemale;
@property (strong, nonatomic) IBOutlet UIButton *btnGo;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtUserName;

@property   (strong,nonatomic)UIImagePickerController *cameraPicker;
@property   (strong,nonatomic)UIImagePickerController *imagePicker;

@property   (strong,nonatomic)UserService *userWebAPI;



@end

@implementation MakeProfileViewController{
    UITapGestureRecognizer *tapGuestureForKeyboard;
    AADatePicker *datePicker;
    UITextField *activeTextfield;
    
    UITapGestureRecognizer *tapGuesture;
    UILongPressGestureRecognizer *longPress;

    
    UserModel *loggedInUser;
    NSString *strGender;
    
    NSDate *selectedDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    loggedInUser = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view.
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
}


#pragma mark - SetUp
#pragma mark

-(void)setUp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    //NSString *selectedDate = [formatter stringFromDate:self.datePicker.date];
    selectedDate = [formatter dateFromString:@"01/01/1990"];
    
    
    self.customDatePicker.delegate=self;
    
    [self setUpTextfields];
    [self setUpHexagonShapes];
    [self addTapGuesture];
    [self setupDatePicker];
    [self leftPanelView:self.txtUserName withImage:[UIImage imageNamed:@"person-icon.png"]];
    strGender= @"true";
    
    NSAttributedString *strEmail = [[NSAttributedString alloc] initWithString:@"UserName" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    self.txtUserName.attributedPlaceholder = strEmail;
    

}
-(void)addTapGuestureForKeyboard{
    if(tapGuestureForKeyboard){
        [self.view removeGestureRecognizer:tapGuestureForKeyboard];
    }
    
    tapGuestureForKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuestureKeyboardFired:)];
    [self.view addGestureRecognizer:tapGuestureForKeyboard];
}


-(void)SetDatePickerTime:(UIDatePicker *)picker{
    
}
-(void)setupDatePicker{
    NSLocale *uk = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:uk];
    //[uk release];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
  
    [self.datePicker addTarget:self action:@selector(SetDatePickerTime:) forControlEvents:UIControlEventValueChanged];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:30];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-50];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [self.datePicker setMaximumDate:currentDate];
    [self.datePicker setMinimumDate:minDate];
    
    
//    [self.datePicker setValue:[UIColor colorWithRed:70/255.0f green:161/255.0f blue:174/255.0f alpha:1.0f] forKeyPath:@"textColor"];

  //  [self.datePicker setCalendar:cal];
  //  [UIView appearanceWhenContainedIn:[UITableView class], [UIDatePicker class], nil].backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];

  //  self.datePicker.tintColor = [UIColor whiteColor];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setValue:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forKeyPath:@"textColor"];
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:self.datePicker];
    
    return;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-mm-DD"];
    
    NSDate *minimum = [formatter dateFromString:@"1950-01-01"];

    datePicker = [[AADatePicker alloc] initWithFrame:CGRectMake(0, 20, 320, 264)];//datePicker.delegate = self;
    [self.view addSubview:datePicker];
}

-(void)setUpHexagonShapes{
    [VIewUtility addHexagoneShapeMaskFor:self.btnGo];
    [VIewUtility addHexagoneShapeMaskFor:self.imgviewProfile];
}


-(void)setUpTextfields{
   // [self setupAlerts];
    [self addBottomBorder:self.txtUserName];
}

-(void)setupAlerts{
    [self.txtUserName addRegx:@"" withMsg:@"You username is already taken by another person. Please choose diffrent one."];
}

-(void)setUpActionSheet{
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Gallery",
                                @"Camera",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
}

-(void)addBottomBorder:(UIView *)view{
    CALayer *layer=[[CALayer alloc]init];
    layer.frame=CGRectMake(0, view.frame.size.height-1, view.frame.size.width,1);
    layer.backgroundColor=[UIColor whiteColor].CGColor;
    
    [view.layer addSublayer:layer];
}

-(void)addTapGuesture{
    tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuestureForProfile:)];
    self.imgviewProfile.userInteractionEnabled =YES;
    [self.imgviewProfile addGestureRecognizer:tapGuesture];
}

-(void)addLongGuesture{
    longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];

    self.imgviewProfile.userInteractionEnabled =YES;
    [self.imgviewProfile addGestureRecognizer:longPress];
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


#pragma mark - Tap guesture

-(void)tapGuestureKeyboardFired:(UITapGestureRecognizer *)guesture{
        [self.view removeGestureRecognizer:tapGuesture];
        tapGuesture=nil;
        if(activeTextfield){
            [activeTextfield resignFirstResponder];
            //[self animateTextField:activeTextfield up:NO];
        }
}
-(void)tapGuestureForProfile:(UITapGestureRecognizer *)guesture{
    [self setUpActionSheet];
}

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        [self setUpActionSheet];

        //Do Whatever You want on End of Gesture
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
    }
}


#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextfield=textField;
    [self addTapGuestureForKeyboard];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
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



#pragma mark - ActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
                [self showGallery];
    }
    else if (buttonIndex==1)
    {
        [self showCamera];
    }
}

-(void)showCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.cameraPicker=[[UIImagePickerController alloc]init];
        self.cameraPicker.delegate=self;
        self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        
        //  self.cameraPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
        self.cameraPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        
        
        self.cameraPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        self.cameraPicker.allowsEditing = YES;
        
        
        [self presentViewController:self.cameraPicker animated:YES completion:nil];
    }
    
}

-(void)showGallery
{
    self.imagePicker=[[UIImagePickerController alloc]init];
    self.imagePicker.delegate=self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    self.imagePicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

- (void) imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];

    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo)
    {
        UIImage *aImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        self.imgviewProfile.contentMode = UIViewContentModeScaleToFill;
        
        self.imgviewProfile.image= aImage;
        
        [self.imgviewProfile removeGestureRecognizer:tapGuesture];
        [self.imgviewProfile removeGestureRecognizer:longPress];
        
        [self addLongGuesture];

    }
    
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Button delegate
- (IBAction)btnGoClicked:(id)sender {
 
    if([self.txtUserName validate]){
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/YYYY"];
        NSString *date = [formatter stringFromDate:selectedDate];
        
        UserModel *model= [[UserModel alloc]init];
        model.strBirthdate = date;
        model.strEmailID = loggedInUser.strEmailID;
        model.strGender = strGender;
        //model.strUserId = @"Rahul";
        model.imgProfile = self.imgviewProfile.image;
        model.strUserName = self.txtUserName.text;
        
        self.userWebAPI = [[UserService alloc]init];
        self.userWebAPI.delegate=self;
        [self.userWebAPI makeProfileWithUserModel:model];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
}

- (IBAction)btnLogoutClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnGenderClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(btn.tag==0){
        [btn setSelected:YES];
        [self.btnFemale setSelected:NO];
        
        strGender = @"true";
    }
    else if(btn.tag==1){
        [btn setSelected:YES];
        [self.btnMale setSelected:NO];
        strGender = @"false";
    }
}




#pragma mark - Web service response

- (void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showErrorMessage:error.localizedDescription];
    });
}
- (void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        UserModel *model = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];
        if(responseData.count>0){
            UserModel *uModel = (UserModel *) responseData[0];
            model.strProfileURLThumb = uModel.strProfileURLThumb;
            model.strProfileURL = uModel.strProfileURL;
            model.strEmailID = uModel.strEmailID;
            model.strClientUserName = uModel.strClientUserName;

        }
        
        [[CommansUtility sharedInstance]saveUserObject:model key:@"loggedInUser"];
        
        [self performSegueWithIdentifier:@"segueTabbar" sender:self];
        
        /*[[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:NO completion:^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard" bundle:nil];
            
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            [ [UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }];*/

    
    });
    
}

-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"UrbanEx" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}

#pragma mark - Custom Date picker delegate
#pragma mark

-(void)customDatePicker:(id)datePicker withSelectedDate:(NSDate *)date{
    selectedDate = date;
    NSLog(@"Selected date### %@",date);
    
}

@end

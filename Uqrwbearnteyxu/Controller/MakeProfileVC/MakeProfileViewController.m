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
#import "SpotSelectionViewController.h"
#import "CameraSessionView.h"
#import <QuartzCore/QuartzCore.h>
@interface MakeProfileViewController ()<WebServiceDelegate,CustomDatePickerDelegate,UITextFieldDelegate,CACameraSessionDelegate>
{
    IBOutlet UIButton *btnClearUserName;
    IBOutlet UIImageView *userImageView;
    NSString *strUserIdCreated;
}

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *btnMale;
@property (strong, nonatomic) IBOutlet UIButton *btnFemale;
@property (strong, nonatomic) IBOutlet UIButton *btnGo;

@property (strong, nonatomic) IBOutlet UIButton *btnCameraCall;

@property   (strong,nonatomic)UIImagePickerController *cameraPicker;
@property   (strong,nonatomic)UIImagePickerController *imagePicker;

@property   (strong,nonatomic)UserService *userWebAPI;
@property (nonatomic, strong) CameraSessionView *cameraView;


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
    self.imgviewProfile.layer.cornerRadius = self.imgviewProfile.frame.size.width/2;
    self.imgviewProfile.layer.masksToBounds = YES;
    self.imgviewProfile.clipsToBounds = YES;
   // self.imgviewProfile.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.imageFacebookData) {
//        UIImage *imageNew;
//        CGSize newSize=CGSizeMake(self.imgviewProfile.frame.size.width, self.imgviewProfile.frame.size.width);
//        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//        [[UIImage imageWithData:self.imageFacebookData] drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
       // newImage=[UIImage imageWithData:self.imageFacebookData];
       self.imgviewProfile.layer.minificationFilter = kCAFilterTrilinear;
        self.imgviewProfile.image=[UIImage imageWithData:self.imageFacebookData];
    }
    if (![self.strFacebookMaleAndFemale isEqualToString:@""]) {
        if ([self.strFacebookMaleAndFemale isEqualToString:@"male"]) {
            [self.btnMale setSelected:YES];
            [self.btnFemale setSelected:NO];
            [self.btnMale setBackgroundImage:[UIImage imageNamed:@"maleselect.png"] forState:UIControlStateSelected];
            [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"femaleDeselect.png"] forState:UIControlStateNormal];
            strGender = @"true";
            
        }
        
        if ([self.strFacebookMaleAndFemale isEqualToString:@"female"]) {
            [self.btnFemale setSelected:YES];
            [self.btnMale setSelected:NO];
            [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"femaleSelected.png"] forState:UIControlStateSelected];
            [self.btnMale setBackgroundImage:[UIImage imageNamed:@"maleDeselect.png"] forState:UIControlStateNormal];
            strGender = @"false";
            
        }
    }
    if (![self.strFacebookDateOfBirth isEqualToString:@""]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *date = [dateFormatter dateFromString:self.strFacebookDateOfBirth];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *dateWithNewFormat = [dateFormatter stringFromDate:date];
        NSDate *dateNewFormat = [dateFormatter dateFromString:dateWithNewFormat];
        NSLog(@"dateWithNewFormat: %@", dateWithNewFormat);
        //selectedDate=self.strFacebookDateOfBirth;
       // NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //[formatter setDateFormat:@"dd/MM/YYYY"];
        //NSString *selectedDate = [formatter stringFromDate:self.datePicker.date];
       // NSDate *dateFromFaceBook=[[NSDate alloc] init];
        //dateFromFaceBook = [formatter dateFromString:self.strFacebookDateOfBirth];
       
        //[self.customDatePicker setDate:dateNewFormat animated:YES];
       // [self.delegate customDatePicker:self withSelectedDate:[formatter dateFromString:strDateToSend]];
        //[datePicker ]
        //[self customDatePicker:self.customDatePicker withSelectedDate:dateNewFormat];
        //[
       // [self.customDatePicker reloadPickerViewWithSelectedDate:dateWithNewFormat];
    }
    btnClearUserName.hidden=YES;
    loggedInUser = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveImageDataFromGallery:)
                                                 name:@"ImageDataFromGalleryNotification"
                                               object:nil];
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                  // initWithTarget:self
                                   //action:@selector(dismissKeyboard)];
    
    //[self.view addGestureRecognizer:tap];
    
}
//-(void)dismissKeyboard {
//    [self.txtUserName resignFirstResponder];
//    
//}
//+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    //UIGraphicsBeginImageContext(newSize);
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
- (void)receiveImageDataFromGallery:(NSNotificationCenter *)notification
{
    NSData* myEncodedImageData = [[NSUserDefaults standardUserDefaults] dataForKey:@"myEncodedImageDataKey"];
    if (myEncodedImageData) {
        self.imgviewProfile.layer.cornerRadius = self.imgviewProfile.frame.size.width/2;
        //self.imgviewProfile.contentMode = UIViewContentModeScaleAspectFit;
        self.imgviewProfile.layer.masksToBounds = YES;
        self.imgviewProfile.clipsToBounds = YES;
//        CGSize newSize=CGSizeMake(self.imgviewProfile.frame.size.width, self.imgviewProfile.frame.size.width);
//        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//        [[UIImage imageWithData:myEncodedImageData] drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
////        newImage=[UIImage imageWithData:myEncodedImageData];
//        self.imgviewProfile.image=newImage;
        self.imgviewProfile.layer.minificationFilter = kCAFilterTrilinear;
        self.imgviewProfile.image = [UIImage imageWithData:myEncodedImageData];
    }
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
    
    //[self setUpTextfields];
    
    [self addTapGuesture];
    [self setupDatePicker];
   // [self leftPanelView:self.txtUserName withImage:[UIImage imageNamed:@"person-icon.png"]];
    //strGender= @"true";
    
//    NSAttributedString *strEmail = [[NSAttributedString alloc] initWithString:@"UserName" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
//    self.txtUserName.attributedPlaceholder = strEmail;
    

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


-(void)setupAlerts{
    //[self.txtUserName addRegx:@"" withMsg:@"You username is already taken by another person. Please choose diffrent one."];
}

-(void)setUpActionSheet{
//        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
//                                @"Gallery",
//                                @"Camera",
//                                nil];
//        popup.tag = 1;
//        [popup showInView:self.view];
    _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    _cameraView.delegate = self;
    [self.view addSubview:_cameraView];
}

//-(void)addBottomBorder:(UIView *)view{
//    CALayer *layer=[[CALayer alloc]init];
//    layer.frame=CGRectMake(0, view.frame.size.height-1, view.frame.size.width,1);
//    layer.backgroundColor=[UIColor whiteColor].CGColor;
//    
//    [view.layer addSublayer:layer];
//}

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
-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    
    //self.imgviewProfile.layer.minificationFilter = kCAFilterTrilinear;
    CGSize newSize=CGSizeMake(self.imgviewProfile.frame.size.width/2, self.imgviewProfile.frame.size.height/2);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    self.imgviewProfile.image=newImage;
    self.imgviewProfile.layer.cornerRadius = self.imgviewProfile.frame.size.width/2;
    self.imgviewProfile.layer.masksToBounds = YES;
    //self.imgviewProfile.layer.masksToBounds = NO;
    self.imgviewProfile.clipsToBounds = YES;
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.cameraView removeFromSuperview];
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE DATA");
    //UIImage *image = [[UIImage alloc] initWithData:imageData];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //[self.cameraView removeFromSuperview];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    if (error) [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

//-(void)leftPanelView:(UITextField *)txt withImage:(UIImage *)image{
//    UIView *panel =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    UIImageView *imageview=[[UIImageView alloc]initWithFrame:panel.bounds];
//    imageview.image=image;
//    imageview.contentMode = UIViewContentModeScaleAspectFit;
//    [panel addSubview:imageview];
//    
//    txt.leftView = panel;
//    txt.leftViewMode =UITextFieldViewModeAlways;
//    
//}


#pragma mark - Tap guesture

//-(void)tapGuestureKeyboardFired:(UITapGestureRecognizer *)guesture{
//        [self.view removeGestureRecognizer:tapGuesture];
//        tapGuesture=nil;
//        if(activeTextfield){
//            [activeTextfield resignFirstResponder];
//            //[self animateTextField:activeTextfield up:NO];
//        }
//}
-(void)tapGuestureForProfile:(UITapGestureRecognizer *)guesture{
    [self setUpActionSheet];
}

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //[self setUpActionSheet];

        //Do Whatever You want on End of Gesture
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
    }
}


#pragma mark - Textfield delegates
//-(BOOL) NSStringIsValidEmail:(NSString *)checkString
//{
//    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
//    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
//    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
//    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:checkString];
//}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField==self.txtUserName) {
        if ([self.txtUserName.text length]>0) {
           
            if ([self.txtUserName.text length]>=5) {
                [self.txtUserName resignFirstResponder];
                self.userWebAPI = [[UserService alloc]init];
                self.userWebAPI.delegate=self;
                self.userWebAPI.tag=1;
                [self.userWebAPI checkUserName:self.txtUserName.text];
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
            }
            else
            {
                
                userImageView.image=[UIImage imageNamed:@"nuetral.png"];
                
            }
            btnClearUserName.hidden=NO;
        }
        else {
            userImageView.image=[UIImage imageNamed:@"nuetral.png"];
            btnClearUserName.hidden=YES;
        }
        
    }
}

-(IBAction)clearTextFieldButtonClicked:(UIButton *)sender
{
    if (sender==btnClearUserName) {
        self.txtUserName.text=@"";
        userImageView.image=[UIImage imageNamed:@"nuetral.png"];
        btnClearUserName.hidden=YES;
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
        self.imgviewProfile.contentMode = UIViewContentModeScaleAspectFit;
        
        self.imgviewProfile.image= aImage;
        
        [self.imgviewProfile removeGestureRecognizer:tapGuesture];
        [self.imgviewProfile removeGestureRecognizer:longPress];
        
        [self addLongGuesture];

    }
    
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Button delegate
- (IBAction)btnGoClicked:(id)sender {
 
   // if([self.txtUserName validate]){
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/YYYY"];
        NSString *date = [formatter stringFromDate:selectedDate];
        
//        UserModel *model= [[UserModel alloc]init];
//        model.strBirthdate = date;
//        model.strEmailID = loggedInUser.strEmailID;
//        model.strGender = strGender;
//        //model.strUserId = @"Rahul";
//        model.imgProfile = self.imgviewProfile.image;
//        model.strUserName = self.txtUserName.text;
    BOOL isValidUser=[self imageIsPresent];
    if (isValidUser && [date length]>0 && ([self.btnMale isSelected]||[self.btnFemale isSelected])) {
        self.userWebAPI = [[UserService alloc]init];
        self.userWebAPI.delegate=self;
        [self.userWebAPI registerWithUserName:self.strTxtUserName andDateOfBirth:date andGender:strGender andEmail:self.strTxtUserName andPassword:self.strPassword andConfirmPassowrd:self.strConfirmPassowrd andUploadImage:self.imgviewProfile.image andFirstName:@"" andLastName:@"" andResidence:@"" andClientUserName:self.txtUserName.text andStatus:@"I am using UrbanX!"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

    
    //}
    
}
-(BOOL)imageIsPresent
{
    UIImage *secondImage = [UIImage imageNamed:@"accepted.png"];
    
    NSData *imgData1 = UIImagePNGRepresentation(userImageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        isCompare=YES;
    }
    else
    {
        isCompare=NO;
    }
    return isCompare;
    
}
- (IBAction)btnLogoutClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnGenderClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(btn.tag==0){
        [btn setSelected:YES];
        [self.btnFemale setSelected:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"maleselect.png"] forState:UIControlStateSelected];
        [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"femaleDeselect.png"] forState:UIControlStateNormal];
        strGender = @"true";
    }
    else if(btn.tag==1){
        [btn setSelected:YES];
        [self.btnMale setSelected:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"femaleSelected.png"] forState:UIControlStateSelected];
        [self.btnMale setBackgroundImage:[UIImage imageNamed:@"maleDeselect.png"] forState:UIControlStateNormal];
        strGender = @"false";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    NSString *strdate = [formatter stringFromDate:selectedDate];
    BOOL isValidUser=[self imageIsPresent];
    if (isValidUser && [strdate length]>0 && ([self.btnMale isSelected]||[self.btnFemale isSelected])) {
        [self.btnGo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnGo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}




#pragma mark - Web service response

- (void)request:(id)serviceRequest didFailWithError:(NSError *)error{
     UserService *service = (UserService *)serviceRequest;
    if (service.tag==1) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error.code == 1009){
            //[self showErrorMessage:@"The entered Username is already taken. Please choose a different Username."];
             userImageView.image=[UIImage imageNamed:@"denied.png"];
        }
        else{
            //[self showErrorMessage:error.localizedDescription];
            userImageView.image=[UIImage imageNamed:@"denied.png"];
        }

    }
    else
    {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showErrorMessage:error.localizedDescription];
    });
    }
}
- (void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    UserService *service = (UserService *)serviceRequest;
    if (service.tag==1) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        userImageView.image=[UIImage imageNamed:@"accepted.png"];
        
    }
    else
    {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        

//        UserModel *model = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];
//        if(responseData.count>0){
//            UserModel *uModel = (UserModel *) responseData[0];
//            model.strProfileURLThumb = uModel.strProfileURLThumb;
//            model.strProfileURL = uModel.strProfileURL;
//            model.strEmailID = uModel.strEmailID;
//            model.strClientUserName = uModel.strClientUserName;
//
//        }
//        
//        [[CommansUtility sharedInstance]saveUserObject:model key:@"loggedInUser"];
        strUserIdCreated=[NSString stringWithFormat:@"%@",responseData];
                
        [self performSegueWithIdentifier:@"segueSportSelection" sender:self];
        
        /*[[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:NO completion:^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard" bundle:nil];
            
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            [ [UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }];*/

    
    });
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueSportSelection"])
    {
        // Get reference to the destination view controller
        SpotSelectionViewController *sportSelectionVC = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        sportSelectionVC.strUserId=strUserIdCreated;
    }
}

-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"UrbanEx" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}

#pragma mark - Custom Date picker delegate
#pragma mark

-(void)customDatePicker:(id)datePicker withSelectedDate:(NSDate *)date{
    selectedDate = date;
    NSLog(@"Selected date### %@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    NSString *strdate = [formatter stringFromDate:selectedDate];
    BOOL isValidUser=[self imageIsPresent];
    if (isValidUser && [strdate length]>0 && ([self.btnMale isSelected]||[self.btnFemale isSelected])) {
        [self.btnGo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnGo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

@end

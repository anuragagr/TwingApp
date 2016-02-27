//
//  AskForLoginViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "AskForLoginViewController.h"

@interface AskForLoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebookLogin;

@end

@implementation AskForLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
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
    
}


-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"UrbanEx" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}


@end

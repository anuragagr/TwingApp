//
//  ViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 05/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "ViewController.h"
#import "CCMPopupSegue.h"

@interface ViewController ()
@property (weak) UIViewController *popupController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    v.backgroundColor = [UIColor purpleColor];
//
//    CGRect rect = v.frame;
//    
//    CAShapeLayer *hexagonMask = [CAShapeLayer layer];
//    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
//    CGFloat sideWidth = 2 * ( 0.5 * rect.size.width / 2 );
//    CGFloat lcolumn = ( rect.size.width - sideWidth ) / 2;
//    CGFloat rcolumn = rect.size.width - lcolumn;
//    CGFloat height = 0.866025 * rect.size.height;
//    CGFloat y = (rect.size.height - height) / 2;
//    CGFloat by = rect.size.height - y;
//    CGFloat midy = rect.size.height / 2;
//    CGFloat rightmost = rect.size.width;
//    [hexagonPath moveToPoint:CGPointMake(lcolumn, y)];
//    [hexagonPath addLineToPoint:CGPointMake(rcolumn, y)];
//    [hexagonPath addLineToPoint:CGPointMake(rightmost, midy)];
//    [hexagonPath addLineToPoint:CGPointMake(rcolumn, by)];
//    [hexagonPath addLineToPoint:CGPointMake(lcolumn, by)];
//    [hexagonPath addLineToPoint:CGPointMake(0, midy)];
//    [hexagonPath addLineToPoint:CGPointMake(lcolumn, y)];
//    
//    hexagonMask.path = hexagonPath.CGPath;
//    v.layer.mask = hexagonMask;
//    
//    
//    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    imgView.image = [UIImage imageNamed:@"chooser-button-input-highlighted"];
//    hexagonMask.path = hexagonPath.CGPath;
//    imgView.layer.mask = hexagonMask;
//    imgView.backgroundColor=[UIColor redColor];
//    
//    
//    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    btn.backgroundColor=[UIColor redColor];
//    hexagonMask.path = hexagonPath.CGPath;
//    btn.layer.mask = hexagonMask;
//    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
//    
//    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CCMPopupSegue *popupSegue = (CCMPopupSegue *)segue;
    if (self.view.bounds.size.height < 420) {
        popupSegue.destinationBounds = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.height-20) * .75, [UIScreen mainScreen].bounds.size.height-20);
    } else {
        popupSegue.destinationBounds = CGRectMake(0, 0, 280, 200);
    }
    popupSegue.backgroundBlurRadius = 7;
    popupSegue.backgroundViewAlpha = 0.3;
    popupSegue.backgroundViewColor = [UIColor blackColor];
    popupSegue.dismissableByTouchingBackground = YES;
    self.popupController = popupSegue.destinationViewController;
}
- (IBAction)btnProgramClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard" bundle:nil];
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
    [ [UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    
}


@end

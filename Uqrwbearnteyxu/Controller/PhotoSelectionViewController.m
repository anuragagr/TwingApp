//
//  PhotoSelectionViewController.m
//  Uqrwbearnteyxu
//
//  Created by Mac on 06/03/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "PhotoSelectionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface PhotoSelectionViewController ()<UIImagePickerControllerDelegate>
{
    UIButton *btnBack;
    
}
@property (nonatomic, strong)UIImagePickerController *cameraPicker;
@end

@implementation PhotoSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

@end

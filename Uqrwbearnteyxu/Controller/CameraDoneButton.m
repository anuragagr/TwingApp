//
//  CameraDoneButton.m
//  CameraWithAVFoundation
//
//  Created by Mac on 09/03/16.
//  Copyright © 2016 Gabriel Alvarado. All rights reserved.
//

#import "CameraDoneButton.h"
#import "CameraStyleKitClass.h"
@implementation CameraDoneButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    [CameraStyleKitClass drawCameraDoneWithFrame:self.bounds];
}

@end

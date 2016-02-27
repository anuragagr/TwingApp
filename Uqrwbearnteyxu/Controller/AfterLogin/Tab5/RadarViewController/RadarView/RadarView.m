//
//  RadarView.m
//  CustomDatePicker
//
//  Created by Rahul Mane on 20/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import "RadarView.h"
#import "UIView+AddHexagone.h"
#import "UserModel.h"
#import "CommansUtility.h"
#import "FriendModel.h"

@import CoreGraphics;

#define largeSpacing 10
#define lineWidth 2

@implementation RadarView{
    int numberOfLines;
    int selectedOuterView;
    int selectedInnerView;
    NSMutableArray *arrayOfRadarAnnotations;
    NSCache *imageCache;
    UserModel *userModel;
    UIImageView *profileImageView;
    UIImage *imgProfile;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUp];
    }
    return self;
}


#pragma mark - SetUp
#pragma mark 

-(void)setUp{
    self.arrayOfLineViews = [[NSMutableArray alloc]init];
    self.arrayOfViews = [[NSMutableArray alloc]init];
    
    [self addRadarLines];
    [self setProfilePic];
    
}


-(void)setProfilePic{
    userModel = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        //  You may want to cache this explicitly instead of reloading every time.
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userModel.strProfileURLThumb]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Capture the indexPath variable, not the cell variable, and use that
            profileImageView.image = image;
        });
    });

}

-(void)addRadarLines{
    int yPos = 0;
    int xPos = 0;
    int width = self.bounds.size.width;
    int height = self.bounds.size.width;
    
    int maximumLines = (int)self.bounds.size.width/(largeSpacing+lineWidth);
    numberOfLines = maximumLines / 2;
    
    
    for (int k=0; k< numberOfLines; k++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(xPos,yPos,width,height)];
        lineView.backgroundColor = [UIColor grayColor];
        [lineView addHexaShape];
        [self addSubview:lineView];
        [self.arrayOfLineViews addObject:lineView];
        
        if(k == (numberOfLines-1)){
            UIImageView *profileImageV = [[UIImageView alloc] initWithFrame:CGRectMake(xPos+lineWidth,yPos+lineWidth,width-(2*lineWidth),height-(2*lineWidth))];
            profileImageV.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82/255.0 blue:89/255.0 alpha:1];
            profileImageV.image = imgProfile;
            
            [profileImageV addHexaShape];
            [self addSubview:profileImageV];
            [self.arrayOfViews addObject:profileImageV];
            profileImageView = profileImageV;
            
        }
        else{
            UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(xPos+lineWidth,yPos+lineWidth,width-(2*lineWidth),height-(2*lineWidth))];
            mainView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:82/255.0 blue:89/255.0 alpha:1];
            [mainView addHexaShape];
            [self addSubview:mainView];
            [self.arrayOfViews addObject:mainView];
        }
        
        xPos = xPos +largeSpacing;
        yPos = yPos + largeSpacing;
        width = width - (2*largeSpacing);
        height = height - (2*largeSpacing);
    }
    
    selectedInnerView = numberOfLines-1;
    selectedOuterView = numberOfLines-1;
    [self selectLineAtIndex:numberOfLines-1];
}

#pragma mark - Outers

-(void)selectLineAtIndex:(int)index{
    int isColored=0;
    for (int k=0; k<self.arrayOfLineViews.count; k++) {
        UIView *view = [self.arrayOfLineViews objectAtIndex:k];
        view.backgroundColor = [UIColor grayColor];
        NSLog(@"Index %d %d",index,k);
        if(k>=(index)){
            if(isColored == 0){
                view.backgroundColor = [UIColor colorWithRed:148/255 green:249.0/255 blue:253.255 alpha:1];
                isColored = YES;
            }
            else{
                isColored++;
                if(isColored > 2){
                    isColored=0;
                }
            }
        }
    }
    if(index>self.arrayOfLineViews.count-1){
        index = (int)self.arrayOfLineViews.count-1;
    }
    selectedOuterView = index;
}

-(void)selectAnnotationIndex:(int)index{
    for (int k=0; k<arrayOfRadarAnnotations.count; k++) {
        UIButton *v = [arrayOfRadarAnnotations objectAtIndex:k];
        
        if(k==index){
            [v setSelected:YES];
        }
        else{
                     [v setSelected:NO];
        }
    }

}

-(void)addRadarAnnotation:(NSMutableArray *)anotationArray{
    for (int k=0; k<arrayOfRadarAnnotations.count; k++) {
        UIButton *v = [arrayOfRadarAnnotations objectAtIndex:k];
        [v removeFromSuperview];
    }
    
    [arrayOfRadarAnnotations removeAllObjects];
    
    [self addAnotations:anotationArray];
}


-(void)addAnotations:(NSMutableArray *)anotationArray{
    arrayOfRadarAnnotations =[[NSMutableArray alloc]init];
    
    UIView *minView = [self.arrayOfViews objectAtIndex:selectedInnerView];
    UIView *maxView = [self.arrayOfViews objectAtIndex:selectedOuterView];
    

    int maxRadius = maxView.frame.size.width/2;
    int minRadius = minView.frame.size.width/2;
    
    if(maxRadius>minRadius){
        int annotationPoints = 0;
        while (annotationPoints < anotationArray.count) {
            float radius =minRadius + arc4random_uniform(maxRadius - minRadius + 1);
            ;
            
            if(radius>minRadius){
                CGPoint p = CGPointMake((maxView.frame.size.width / 2) + (radius * cos (annotationPoints)) , (maxView.frame.size.height / 2) + (radius * sin (annotationPoints)));
                
                
                UIButton *btnView = [[UIButton alloc]initWithFrame:CGRectMake(p.x+maxView.frame.origin.x, p.y+maxView.frame.origin.y, 30,50)];
                

                FriendModel *frModel = [anotationArray objectAtIndex:annotationPoints];
                if([frModel.strRelationshipStatus isEqualToString:@"2"]){
                    [btnView setImage:[UIImage imageNamed:@"RoundPinBlue.png"] forState:UIControlStateNormal];
                    [btnView setImage:[UIImage imageNamed:@"UserPinSelected.png"] forState:UIControlStateSelected];
                }
                else{
                [btnView setImage:[UIImage imageNamed:@"userPin.png"] forState:UIControlStateNormal];
                [btnView setImage:[UIImage imageNamed:@"UserPinSelected.png"] forState:UIControlStateSelected];
                }
                [btnView addTarget:self action:@selector(btnAnnotationClicked:) forControlEvents:UIControlEventTouchDown];
                btnView.tag = annotationPoints;
                
                int generatedX = p.x+maxView.frame.origin.x;
                int generatedY = p.y+maxView.frame.origin.y;

                if((generatedX >= self.frame.size.width/2) && (generatedY <= self.frame.size.height/2)){
                    // 1 quadrant
                    NSLog(@"Firt q");
                    if(generatedX<=(self.frame.size.width/2 + self.frame.size.width/4) && generatedY>=self.frame.size.height/4){
                        btnView.center = CGPointMake(generatedX+btnView.bounds.size.width/2,generatedY-btnView.bounds.size.height/2);
                    }
                    else{
                        btnView.center = CGPointMake(generatedX,generatedY);

                    }

                }
                else if((generatedX >= self.frame.size.width/2) && (generatedY >= self.frame.size.height/2)){
                    NSLog(@"secoond q");
                    if(generatedX<=(self.frame.size.width/2 + self.frame.size.width/4) && generatedY<=(self.frame.size.height/2 +self.frame.size.height/4)){
                        btnView.center = CGPointMake(generatedX+btnView.bounds.size.width/2,generatedY+btnView.bounds.size.height/2);
                    }
                    else{
                        btnView.center = CGPointMake(generatedX,generatedY);
                        
                    }
                }

                else if((generatedX <= self.frame.size.width/2) && (generatedY >= self.frame.size.height/2)){
                    NSLog(@"third q");
                    
                    if(generatedX>=(self.frame.size.width/4) && generatedY<=(self.frame.size.height/2 +self.frame.size.height/4)){
                       
                        btnView.center = CGPointMake(generatedX-btnView.bounds.size.width/2,generatedY+btnView.bounds.size.height/2);
                    }
                    else{
                        btnView.center = CGPointMake(generatedX,generatedY);
                        
                    }
                }

                else if((generatedX <= self.frame.size.width/2) && (generatedY <= self.frame.size.height/2)){
                    NSLog(@"forth q");
                    if(generatedX>=(self.frame.size.width/4) && generatedY>=(self.frame.size.height/4)){
                        
                        btnView.center = CGPointMake(generatedX-btnView.bounds.size.width/2,generatedY-btnView.bounds.size.height/2);
                    }
                    else{
                        btnView.center = CGPointMake(generatedX,generatedY);
                        
                    }
                }

//                UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
               // btn.backgroundColor =[UIColor greenColor];
               // [view addSubview:btn];
                
                btnView.backgroundColor = [UIColor clearColor];
                
                [self addSubview:btnView];
                annotationPoints ++;
                [arrayOfRadarAnnotations addObject:btnView];
            }
        }
    }
}

/*
-(void)addAnnotations:(NSMutableArray *)arrayOfAnnotations{
    
    float radius; //radius
    float rmax = MIN(maxView.frame.size.height/2,maxView.frame.size.width/2); //max radius
    float rmin = MIN(self.frame.size.height/2,self.frame.size.width/2);; //min radius
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (double a=0;a < 5;a += M_PI / 10) {
        radius = rmin +  ((arc4random_uniform((int)(rmax - rmin) * 100)) / 100.0f);
        NSLog(@"Print all %f",radius);
        radius =(arc4random_uniform((int) maxView.frame.size.width/2));
        
        CGPoint p = CGPointMake((maxView.frame.size.width / 2) + (radius * cos (a)) , (maxView.frame.size.height / 2) + (radius * sin (a)));
        [points addObject:[NSValue valueWithCGPoint:p]];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(p.x, p.y, 5, 5)];
        view.backgroundColor = [UIColor redColor];
        
        [self addSubview:view];
    }
    
}
 */

-(BOOL)hexagone:(UIView *)hexagone contains:(CGPoint)pointToCheck{
    UIBezierPath *path = [hexagone hexagonePath];
    return [path containsPoint:pointToCheck];
}


#pragma mark - Button delegates

-(void)btnAnnotationClicked:(id)sender{
    UIButton *btn=(UIButton *)sender;
    if(self.delegate){
        [self selectAnnotationIndex:(int)btn.tag];
        [self.delegate radarView:self didSelectAnnotation:(int)btn.tag];
    }
}






@end

//
//  RightMenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "RightMenuViewController.h"
#import "VIewUtility.h"
#import "CommansUtility.h"
#import "UserModel.h"
#import "BlockOperationWithIdentifier.h"
#import "WebConstants.h"

@interface RightMenuViewController()
@property (nonatomic, strong) NSCache *eventImageCache;
@property (nonatomic, strong) NSOperationQueue *eventImageOperationQueue;

@end
@implementation RightMenuViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.eventImageCache=[[NSCache alloc]init];
    self.eventImageOperationQueue = [[NSOperationQueue alloc]init];
    self.eventImageOperationQueue.maxConcurrentOperationCount = 2;

    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
   // NSo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:SlideNavigationControllerDidOpen
                                               object:nil];

    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
-(void)receiveTestNotification:(id)sender{
    [self.tableView reloadData];

}
#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell ;
	
	switch (indexPath.row)
	{
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
         
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
            UILabel *lblName = (UILabel *)[cell viewWithTag:101];
            
            [VIewUtility addHexagoneShapeMaskFor:imgView];
          
            
            UserModel *uModel = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];
            
            lblName.text = uModel.strClientUserName;
            
            if([uModel.strProfileURLThumb isEqualToString:[NSString stringWithFormat:@"%@/",baseURL]]){
                break;
            }
            UIImage *imageFromCache = [self.eventImageCache objectForKey:[NSString stringWithFormat:@"%@",uModel.strUserId]];
            if (imageFromCache) {
                imgView.image=imageFromCache;
            }else{
                
                imgView.image = nil;//user a placeholder later
                BlockOperationWithIdentifier *operation = [BlockOperationWithIdentifier blockOperationWithBlock:^{
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:uModel.strProfileURL]];
                    
                    UIImage *img = [UIImage imageWithData:imageData];
                    if (img) {
                        [self.eventImageCache setObject:img forKey:[NSString stringWithFormat:@"%@",uModel.strUserId]];
                    }
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            imgView.layer.cornerRadius=3;
                            imgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
                            imgView.layer.borderWidth=0.75;
                            imgView.image = img;
                            
                            CATransition *transition = [CATransition animation];
                            transition.duration = 0.75f;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            
                            [imgView.layer addAnimation:transition forKey:nil];
                            imgView.contentMode=UIViewContentModeScaleAspectFit;
                            imgView.clipsToBounds = YES;
                    }];
                }];
                operation.queuePriority = NSOperationQueuePriorityNormal;
                operation.identifier=uModel.strProfileURL;
                [self.eventImageOperationQueue addOperation:operation];
            }

            

            
            break;
        }
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
            UISearchBar *searchBar = [cell viewWithTag:101];
            
            searchBar.backgroundColor = [UIColor clearColor];
            searchBar.barTintColor = [UIColor clearColor];
            
			break;
        }
			
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];

            imgView.image = [UIImage imageNamed:@"sports-icon.png"];
            lblName.text = @"Sports";
            
			break;
        }
        case 3:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];
            
            imgView.image = [UIImage imageNamed:@"settings-icon.png"];
            lblName.text = @"Settings";
            
            break;
        }
			
		case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];
            
            imgView.image = [UIImage imageNamed:@"statastics.png"];
            lblName.text = @"Statistics";
            
            break;
        }
        case 5:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];
            
            imgView.image = [UIImage imageNamed:@"help-icon.png"];
            lblName.text = @"Log out";
            
            break;
        }
		case 6:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];
            
            imgView.image = [UIImage imageNamed:@"help-icon.png"];
            lblName.text = @"Help";
            
            break;
        }
    }
	
//	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height = 0;
    switch (indexPath.row)
    {
        case 0:
            height = 64;
            break;
            
        case 1:
            height = 60;
            break;
            
        case 2:
                        height = 50;
            break;
            
        case 3:
            height = 50;
            break;
            
        case 4:
            height = 50;
            break;
            
        case 5:
            height = 50;
            break;
        case 6:
            height = 50;
            break;
    }

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	id <SlideNavigationContorllerAnimator> revealAnimator;
	CGFloat animationDuration = 0;

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard"
                                                             bundle: nil];

    UIViewController *vc ;

    
	switch (indexPath.row)
	{
		case 0:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
            [self.delegate rightMenuVC:self didSelectMenu:menuProfile];

			break;
			
		case 1:
            [self.delegate rightMenuVC:self didSelectMenu:menuSearchFriend];

			break;
			
		case 2:

			break;
			
		case 3:
			//revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
			//animationDuration = .19;
			break;
			
		case 4:
			//revealAnimator = [[SlideNavigationContorllerAnimatorScale alloc] init];
			//animationDuration = .22;
			break;
			
		case 5:
			//revealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blackColor] andMinimumScale:.8];
			//animationDuration = .22;
            [self.delegate rightMenuVC:self didSelectMenu:menuLogOut];

			break;
		
        case 6:
            //revealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blackColor] andMinimumScale:.8];
            //animationDuration = .22;
            break;
            
            
		default:
			return;
	}

    
    /*[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:YES
                                                                     andCompletion:nil];
*/
    
    
[[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
//		[SlideNavigationController sharedInstance].menuRevealAnimationDuration = animationDuration;
//		[SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
	}];
}


//are you sure want to log out ?

@end

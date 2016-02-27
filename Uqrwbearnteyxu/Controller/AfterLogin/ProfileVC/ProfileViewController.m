//
//  ProfileViewController.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 03/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "ProfileViewController.h"
#import "SlideNavigationController.h"
#import "VIewUtility.h"
#import "PPImageScrollingTableViewCell.h"
#import "UserModel.h"
#import "CommansUtility.h"
#import "BlockOperationWithIdentifier.h"
#import "FriendsService.h"
#import "MBProgressHUD.h"
#import "WebConstants.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate,WebServiceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSCache *eventImageCache;
@property (nonatomic, strong) NSOperationQueue *eventImageOperationQueue;


@end

@implementation ProfileViewController{
    UserModel *loggedInUser;
    FriendsService *friendService;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    loggedInUser = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];

    [self.tableview registerClass:[PPImageScrollingTableViewCell class] forCellReuseIdentifier:@"cellImageScolling"];

    // Do any additional setup after loading the view.
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self setUpBackButton];
    self.eventImageCache=[[NSCache alloc]init];
    self.eventImageOperationQueue = [[NSOperationQueue alloc]init];
    self.eventImageOperationQueue.maxConcurrentOperationCount = 2;

    if(self.friendModel){
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile",self.friendModel.strClientUserName];

    }
}

-(void)setUpBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backCpy.png"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

   // self.topConstarintTable.constant = 2;
    NSLog(@"Constrin %f",self.topConstarintTable.constant);
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.navigationController.navigationBar.hidden =  NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationController.navigationBar.hidden =  YES;
    NSLog(@"Constrin %f",self.topConstarintTable.constant);
   // self.topConstarintTable.constant = 2;

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"Constrin %f",self.topConstarintTable.constant);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Web service

-(void)webAPIAddFriend:(FriendModel *)fModel{
    friendService = [[FriendsService alloc]init];
    friendService.tag = 0;
    friendService.delegate=self;
    [friendService sendFriendRequestFromUserId:loggedInUser.strUserId andTo:fModel.strUserID];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webCancelFriend:(FriendModel *)fModel{
    friendService = [[FriendsService alloc]init];
    friendService.tag = 1;
    friendService.delegate=self;
    [friendService deleteFriendRequestFromUserId:loggedInUser.strUserId   andTo:fModel.strUserID];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Tableview delegates
#pragma mark 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(self.friendModel){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsProfileCell"];
            
            UIImageView *imgviewProfile = (UIImageView *)[cell viewWithTag:100];
            UILabel *lblProfileName = (UILabel *)[cell viewWithTag:101];
            UILabel *lblProfileStatus = (UILabel *)[cell viewWithTag:102];
            UIButton *btnFriendshipStatus = (UIButton *)[cell viewWithTag:103];
            UIButton *btnChat = (UIButton *)[cell viewWithTag:104];
            UIButton *btnMeetup = (UIButton *)[cell viewWithTag:105];
            
            

            //friendship status
            [btnFriendshipStatus addTarget:self action:@selector(btnFriendshipStatusClicked:) forControlEvents:UIControlEventTouchDown];
            if([self.friendModel.strRelationshipStatus isEqualToString:@"0"]){
                [btnFriendshipStatus setImage:[UIImage imageNamed:@"addfriendship.png"] forState:UIControlStateNormal];
            }
            else if ([self.friendModel.strRelationshipStatus isEqualToString:@"1"]){
                if(self.friendModel.isRequestFriend){
                    [btnFriendshipStatus setImage:[UIImage imageNamed:@"requestfriend.png"] forState:UIControlStateNormal];
                }
                else{
                    [btnFriendshipStatus setImage:[UIImage imageNamed:@"requestfriend.png"] forState:UIControlStateNormal];
                }
                
            }
            else if ([self.friendModel.strRelationshipStatus isEqualToString:@"2"]){
                [btnFriendshipStatus setImage:[UIImage imageNamed:@"friendship-already-icon.png"] forState:UIControlStateNormal];

            }
            else{
                [btnFriendshipStatus setImage:[UIImage imageNamed:@"addfriend.png"] forState:UIControlStateNormal];

            }
            
            
            
            [VIewUtility addHexagoneShapeMaskFor:imgviewProfile];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [formatter setDateFormat:@"MM/dd/YYYY"];
            NSDate *birthDate = [formatter dateFromString:self.friendModel.strBithdate];
            NSInteger age = [self ageFromBirthday:birthDate];

            
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%ld)",self.friendModel.strClientUserName,(long)age]];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] range:NSMakeRange(0, self.friendModel.strClientUserName.length)];
            
            lblProfileName.attributedText = string;

            
            lblProfileStatus.text = @"";
            
            
            
            if(self.friendModel.strThumbImgPath.length==0){
                
            }
            UIImage *imageFromCache = [self.eventImageCache objectForKey:[NSString stringWithFormat:@"%@",self.friendModel.strThumbImgPath]];
            if (imageFromCache) {
                imgviewProfile.image=imageFromCache;
            }else{
                
                imgviewProfile.image = nil;//user a placeholder later
                BlockOperationWithIdentifier *operation = [BlockOperationWithIdentifier blockOperationWithBlock:^{
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.friendModel.strThumbImgPath]];
                    
                    UIImage *img = [UIImage imageWithData:imageData];
                    if (img) {
                        [self.eventImageCache setObject:img forKey:[NSString stringWithFormat:@"%@",self.friendModel.strThumbImgPath]];
                    }
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        imgviewProfile.layer.cornerRadius=3;
                        imgviewProfile.layer.borderColor=[UIColor lightGrayColor].CGColor;
                        imgviewProfile.layer.borderWidth=0.75;
                        imgviewProfile.image = img;
                        
                        CATransition *transition = [CATransition animation];
                        transition.duration = 0.75f;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                        transition.type = kCATransitionFade;
                        
                        [imgviewProfile.layer addAnimation:transition forKey:nil];
                        imgviewProfile.contentMode=UIViewContentModeScaleAspectFit;
                        imgviewProfile.clipsToBounds = YES;
                    }];
                }];
                operation.queuePriority = NSOperationQueuePriorityNormal;
                operation.identifier=self.friendModel.strThumbImgPath;
                [self.eventImageOperationQueue addOperation:operation];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }
        else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OwnProfileCell"];
        
        UIImageView *imgviewProfile = (UIImageView *)[cell viewWithTag:200];
        UILabel *lblProfileName = (UILabel *)[cell viewWithTag:201];
        UILabel *lblProfileStatus = (UILabel *)[cell viewWithTag:202];
        UIButton *btnFriendshipStatus = (UIButton *)[cell viewWithTag:203];
        UIButton *btnChat = (UIButton *)[cell viewWithTag:204];
        UIButton *btnMeetup = (UIButton *)[cell viewWithTag:205];

        [VIewUtility addHexagoneShapeMaskFor:imgviewProfile];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [formatter setDateFormat:@"MM/dd/YYYY"];
            NSDate *birthDate = [formatter dateFromString:loggedInUser.strBirthdate];
            NSInteger age = [self ageFromBirthday:birthDate];
            
            
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%ld)",loggedInUser.strClientUserName,(long)age]];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] range:NSMakeRange(0, loggedInUser.strClientUserName.length)];
            
            lblProfileName.attributedText = string;

            
      //  lblProfileName.text = loggedInUser.strClientUserName;
        lblProfileStatus.text = @"";
        //[btnFriendshipStatus addTarget:self action:@selector(btnFriendshipStatusClicked:) forControlEvents:UIControlEventTouchDown];
        
        
        
        if(loggedInUser.strProfileURLThumb.length==0){
            
        }
        UIImage *imageFromCache = [self.eventImageCache objectForKey:[NSString stringWithFormat:@"%@",loggedInUser.strUserId]];
        if (imageFromCache) {
            imgviewProfile.image=imageFromCache;
        }else{
            
            imgviewProfile.image = nil;//user a placeholder later
            BlockOperationWithIdentifier *operation = [BlockOperationWithIdentifier blockOperationWithBlock:^{
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:loggedInUser.strProfileURL]];
                
                UIImage *img = [UIImage imageWithData:imageData];
                if (img) {
                    [self.eventImageCache setObject:img forKey:[NSString stringWithFormat:@"%@",loggedInUser.strProfileURL]];
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    imgviewProfile.layer.cornerRadius=3;
                    imgviewProfile.layer.borderColor=[UIColor lightGrayColor].CGColor;
                    imgviewProfile.layer.borderWidth=0.75;
                    imgviewProfile.image = img;
                    
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.75f;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    
                    [imgviewProfile.layer addAnimation:transition forKey:nil];
                    imgviewProfile.contentMode=UIViewContentModeScaleAspectFit;
                    imgviewProfile.clipsToBounds = YES;
                }];
            }];
            operation.queuePriority = NSOperationQueuePriorityNormal;
            operation.identifier=loggedInUser.strProfileURL;
            [self.eventImageOperationQueue addOperation:operation];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }
        
    }
    else if(indexPath.section ==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSelection"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISegmentedControl *segmentControl = (UISegmentedControl *)[cell viewWithTag:200];
        
        [segmentControl setSelectedSegmentIndex:1];
        [segmentControl addTarget:self action:@selector(btnSegmentClikced:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    else if(indexPath.section ==2){
        NSString *strStatus;
        if(self.friendModel){
            //status
            strStatus = self.friendModel.strUserStatus;
        }
        else{
                        //status
            strStatus = loggedInUser.strUserStatus;
        }
      
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFriendStatus"];
        UILabel *lblProfileName = (UILabel *)[cell viewWithTag:400];
        lblProfileName.text = strStatus;
        
        lblProfileName.preferredMaxLayoutWidth = 250;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if(indexPath.section ==3){
        NSMutableArray *arrayOfSportsFriend;
        if(self.friendModel){
            arrayOfSportsFriend = self.friendModel.arrayOfSports;
        }
        else{
            arrayOfSportsFriend = loggedInUser.arrayOfSports;
        }
        
        NSMutableDictionary *category = [[NSMutableDictionary alloc]init];
        NSString *strCat = [NSString stringWithFormat:@"Your sports (%lu)",(unsigned long)arrayOfSportsFriend.count];
        [category setValue:strCat forKey:@"category"];
        
        NSMutableArray *arryOfImages = [[NSMutableArray alloc]init];
        for (int k=0; k<arrayOfSportsFriend.count; k++) {
            NSDictionary *propSports = [arrayOfSportsFriend objectAtIndex:k];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:@"Name" forKey:@"name"];
            NSString *url = [NSString stringWithFormat:@"%@/%@",baseURL,[propSports valueForKey:@"SportIconThumb"]];
            [dict setValue:url forKey:@"URL"];
            [arryOfImages addObject:dict];
        }
        [category setValue:arryOfImages forKey:@"images"];
        
        NSArray *array = @[category];
       /* NSArray *array = @[
                        @{ @"category": @"Your sports (25)",
                           @"images":
                               @[
                                   @{ @"name":@"icon29.png", @"URL":@"http://www.imge.com/wp-content/uploads/2011/07/jordanIMGE-340x300.jpg"},
                                   @{ @"name":@"icon29.png", @"title":@"A-1"},
                                   @{ @"name":@"", @"title":@"A-2"},
                                   @{ @"name":@"", @"title":@"A-3"},
                                   @{ @"name":@"", @"title":@"A-4"},
                                   @{ @"name":@"", @"title":@"A-5"}
                                   
                                ]
                           }
                        ];

        */
        
        PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellImageScolling" forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setTag:[indexPath section]];
        [customCell setImageData:[array objectAtIndex:0]];
       // [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
       // [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return customCell;
    }
    else if(indexPath.section ==4){
        NSMutableArray *arrayOfFriends;
        if(self.friendModel){
            arrayOfFriends = self.friendModel.arrayOfFriends;
        }
        else{
            arrayOfFriends = loggedInUser.arrayOfFriends;
        }
       
        
        NSMutableDictionary *category = [[NSMutableDictionary alloc]init];
        NSString *strCat = [NSString stringWithFormat:@"Your sports (%lu)",(unsigned long)arrayOfFriends.count];
        [category setValue:strCat forKey:@"category"];
        
        NSMutableArray *arryOfImages = [[NSMutableArray alloc]init];
        for (int k=0; k<arrayOfFriends.count; k++) {
            NSDictionary *propSports = [arrayOfFriends objectAtIndex:k];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:@"Name" forKey:@"ThumbImgPath"];
            NSString *url = [NSString stringWithFormat:@"%@/%@",baseURL,[propSports valueForKey:@"ThumbImgPath"]];
            [dict setValue:url forKey:@"URL"];
            [arryOfImages addObject:dict];
        }
        [category setValue:arryOfImages forKey:@"images"];
        
        NSArray *array = @[category];
      
        
        
        PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellImageScolling" forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setTag:[indexPath section]];
        [customCell setImageData:[array objectAtIndex:0]];
        // [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        // [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return customCell;
    }
    else if(indexPath.section ==5){
        NSArray *array = @[
                           @{ @"category": @"Your sports (32)",
                              @"images":
                                  @[
                                      ]
                              }
                           ];
        
        
        PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellImageScolling" forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setTag:[indexPath section]];
        [customCell setImageData:[array objectAtIndex:0]];
        // [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        // [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return customCell;
    }
    else if(indexPath.section ==6){
        NSArray *array = @[
                           @{ @"category": @"Your sports (34)",
                              @"images":
                                  @[
                                      ]
                              }
                           ];
        
        
        PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellImageScolling" forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setTag:[indexPath section]];
        [customCell setImageData:[array objectAtIndex:0]];
        // [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        // [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return customCell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFriendStatus"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 100;
    }
    else if(indexPath.section == 1){
        return 40;
    }
    else if(indexPath.section == 2){
        return 50;
    }
    else if(indexPath.section == 3){
        return 50;
    }
    else if(indexPath.section == 4){
        return 50;
    }
    else if(indexPath.section == 5){
        return 50;
    }

    else if(indexPath.section == 6){
        return 50;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 20)];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:lbl];
    
    if(section == 3){
        NSMutableArray *arrayOfSportsFriend;
        if(self.friendModel){
            arrayOfSportsFriend = self.friendModel.arrayOfSports;
            NSString *strCat = [NSString stringWithFormat:@"%@'s sports (%lu)",self.friendModel.strClientUserName,(unsigned long)arrayOfSportsFriend.count];
            lbl.text = strCat;

        }
        else{
            arrayOfSportsFriend = loggedInUser.arrayOfSports;
            NSString *strCat = [NSString stringWithFormat:@"Your sports (%lu)",(unsigned long)arrayOfSportsFriend.count];
            lbl.text = strCat;

        }
        
    }
    else if(section == 4){
        NSString *str;
        if(self.friendModel){
            str = self.friendModel.strFriendsCount;
            NSString *strCat = [NSString stringWithFormat:@"%@'s friends (%@)",self.friendModel.strClientUserName,str];
            lbl.text = strCat;

        }
        else{
            str = [NSString stringWithFormat:@"%lu",(unsigned long)loggedInUser.arrayOfFriends.count];
            NSString *strCat = [NSString stringWithFormat:@"Your friends (%@)",str];
            lbl.text = strCat;

        }
        
        
    }
    else if(section == 5){
        NSString *str;
        if(self.friendModel){
            str = self.friendModel.strMeetUpCount;
            NSString *strCat = [NSString stringWithFormat:@"%@'s 1:1 meetups (%@)",self.friendModel.strClientUserName,str];
            lbl.text = strCat;

        }
        else{
            str = loggedInUser.strMeetUpCount;
            NSString *strCat = [NSString stringWithFormat:@"Your 1:1 meetups (%@)",str];
            lbl.text = @"Your 1:1 meetups (0)";
        }
        
    }
    
    else if(section == 6){
        if(self.friendModel){
            NSString *strCat = [NSString stringWithFormat:@"%@'s upcoming meetups (0)",self.friendModel.strClientUserName];

            lbl.text = strCat;
        }
        else{
            lbl.text = @"Your upcoming meetups (0)";

        }

    }
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    if(section == 0){
        view.backgroundColor = [UIColor clearColor];
    }
    else if(section ==1){
        view.backgroundColor = [UIColor clearColor];
    }
    else if(section ==2){
        view.backgroundColor = [UIColor clearColor];
    }
    else if(section ==3){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    else if(section ==4){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    else if(section ==5){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    else if(section ==6){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    else if(section ==1){
        return 2;
    }
    else if(section ==2){
        return 2;
    }
    else if(section ==3){
        return 2;
    }
    else if(section ==4){
        return 2;
    }
    else if(section ==5){
        return 2;
    }
    else if(section ==6){
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    else if(section ==1){
        return 0;
    }
    else if(section ==2){
        return 0;
    }
    else if(section ==3){
        return 20;
    }
    else if(section ==4){
        return 20;
    }
    else if(section ==5){
        return 20;
    }
    else if(section ==6){
        return 20;
    }
    return 0;
}


#pragma mark - Button delegates
#pragma mark 

-(void)btnFriendshipStatusClicked:(id)sender{
    NSLog(@"Friednship clicked");
    if([self.friendModel.strRelationshipStatus isEqualToString:@"0"]){
        [self alertOKCancelActionForAddFriend];
    }
    else if ([self.friendModel.strRelationshipStatus isEqualToString:@"1"]){
        [self alertOKCancelAction];
    }
    else if ([self.friendModel.strRelationshipStatus isEqualToString:@"2"]){
        [self alertOKCancelAction];
    }
}

- (void)alertOKCancelActionForAddFriend {
    // open a alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SEND FRIEND REQUEST ?" message:@"ARE YOU SURE YOU WANT TO SEND FRIEND REQUEST?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 2;
    [alert show];
}

- (void)alertOKCancelAction {
    // open a alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DELETE FRIEND REQUEST?" message:@"DO YOU REALLY WANT TO QUIT OUR FRIENDSHIP?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if(alert.tag == 1)
    {
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        }
        else
        {
            [self webCancelFriend:self.friendModel];
        }
    }
    else if (alert.tag==2){
        if(buttonIndex != alert.cancelButtonIndex){
            [self webAPIAddFriend:self.friendModel];

        }
    }
}

- (IBAction)btnMenuClicked:(id)sender {
    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:^{
        
    }];
    
}

#pragma mark - PPImageScrollingTableViewCellDelegate

- (void)scrollingTableViewCell:(PPImageScrollingTableViewCell *)scrollingTableViewCell didSelectImageAtIndexPath:(NSIndexPath*)indexPathOfImage atCategoryRowIndex:(NSInteger)categoryRowIndex{
    
}

#pragma mark - Web service response
#pragma mark

- (void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
      [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}

- (void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    FriendsService *service=(FriendsService *)serviceRequest;
    if(service.tag==0){
        self.friendModel.strRelationshipStatus = @"1";
        [self.tableview reloadData];
        
    }
    else if (service.tag == 1){
        self.friendModel.strRelationshipStatus = @"4";
        [self.tableview reloadData];
    }
}

- (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}


-(void)btnSegmentClikced:(id)sender{
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0){
        [[[UIAlertView alloc]initWithTitle:@"Coming soon" message:@"Personal Stream functionality will be available in later release !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        [seg setSelectedSegmentIndex:1];

    }
    else{
        
    }
}
@end

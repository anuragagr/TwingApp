//
//  SpotSelectionViewController.m
//  Uqrwbearnteyxu
//
//  Created by Mac on 06/03/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "SpotSelectionViewController.h"
#import "HUD.h"
#import "UserService.h"
#import "WebConstants.h"
#import "SportsCollectionViewCell.h"
@interface SpotSelectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WebServiceDelegate,UICollectionViewDelegate>
{
    int finalCount;
    int indexForSport;
    
}
@property (nonatomic, strong)IBOutlet UICollectionView *collectionSportView;
@property (strong, nonatomic) UserService *userWebAPI;
@property (strong, nonatomic)NSArray *arraySport;
@property (strong, nonatomic)NSMutableArray *arrayForIndex;
@property (assign, nonatomic)int *sectionCount;
@property (nonatomic,strong)NSMutableArray *arrayForSelectedSports;
@property (nonatomic)BOOL getEqualIndex;
@property (nonatomic, strong)NSMutableDictionary *sportsSectionWithRowsWithArrayData;
@property (nonatomic, strong)NSMutableDictionary *sectionWithDataDict;
@property (nonatomic, strong)NSArray *allSectionsKeysArray;
@property (nonatomic, strong)NSMutableArray *arrayForFinalSports;
@property (nonatomic, strong)NSMutableDictionary *arrayForFinalSportsDict;
@end

@implementation SpotSelectionViewController
static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.getEqualIndex=NO;
    indexForSport=0;
    self.arrayForIndex=[[NSMutableArray alloc] init];
    self.arraySport=[[NSArray alloc] init];
    self.sectionWithDataDict=[[NSMutableDictionary alloc] init];
    self.sportsSectionWithRowsWithArrayData=[[NSMutableDictionary alloc] init];
    self.arrayForSelectedSports=[[NSMutableArray alloc] init];
    self.arrayForFinalSports=[[NSMutableArray alloc] init];
    self.arrayForFinalSportsDict=[[NSMutableDictionary alloc] init];
    self.collectionSportView.delegate=nil;
    self.collectionSportView.dataSource=nil;
    
    self.userWebAPI = [[UserService alloc]init];
    self.userWebAPI.delegate = self;
    self.userWebAPI.tag=1;
    [[HUD sharedInstance]showHUD:self.view];
    [self.userWebAPI SportListdata];
}
-(void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    UserService *service = (UserService *)serviceRequest;
    if (service.tag==1) {
        [[HUD sharedInstance]hideHUD:self.view];
        if(error.code == 1010){
            [self showErrorMessage:@"No sport found."];
        }
        else{
            [self showErrorMessage:error.localizedDescription];
        }
    }
    else
    {
        
    }
    
}
-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"ERROR" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}
-(void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    UserService *service = (UserService *)serviceRequest;
    if (service.tag==1) {
        [[HUD sharedInstance]hideHUD:self.view];
        // [self showErrorMessage:@"User registered successfully"];
        //    [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"%@",responseData);
        self.arraySport=[self.arraySport arrayByAddingObjectsFromArray:responseData];
       int countSports=(int)[self.arraySport count];
        int quotient=countSports/7;
        int remainder=countSports%7;
        int finalRemainder=0;
        if (remainder>0) {
            if (remainder<=4) {
                finalRemainder=1;
            }
            else
            {
                if (remainder>4) {
                    finalRemainder=2;
                }
                
            }
        }
    //   int arraycount=0;
        finalCount=quotient*2+finalRemainder;
        NSDictionary *DictWithRowSport;
        NSMutableArray *arrayForRowSport=[[NSMutableArray alloc] init];
        for (int i=0; i< finalCount; i++) {
            if (i % 2 == 0) {
                for (int j =0 ; j<4; j++) {
                   // [self.sportsSectionWithRowsWithArrayData setObject:[NSNumber numberWithInt:i] forKey:@"Section"];
                    //[self.sportsSectionWithRowsWithArrayData setObject:[NSNumber numberWithInt:indexForSport] forKey:@"Rows"];
                    [self.sportsSectionWithRowsWithArrayData setObject:[self.arraySport objectAtIndex:indexForSport] forKey:@"Sports"];
                    NSDictionary *DictWithRow=[NSDictionary dictionaryWithDictionary:self.sportsSectionWithRowsWithArrayData];
                    [self.arrayForIndex addObject:DictWithRow];
                    if ([self.arraySport count]>=indexForSport) {
                        indexForSport=indexForSport+1;
                    }
                    
                    
                }
               // [self.sectionWithDataDict setObject:self.arrayForIndex forKey:[NSNumber numberWithInt:i]];
                // NSDictionary *DictWithRowSport=[NSDictionary dictionaryWithDictionary:self.sectionWithDataDict];
               // [self.sectionWithDataDict setValue:self.arrayForIndex forKey:[NSString stringWithFormat:@"%d",i]];
              // [self.arrayForFinalSports addObject:DictWithRowSport];
               // [self.arrayForIndex removeAllObjects];
                //self.arrayForFinalSportsDict=[self.arrayForFinalSports]
               // dicto=[array objectAtIndex:i];
               // ndccode=[dicto objectForKey:@"NDCCode"];
                //[outputArray addObject:ndccode];
                arrayForRowSport=[self.arrayForIndex copy];
                 DictWithRowSport=[NSDictionary dictionaryWithObject:arrayForRowSport forKey:[NSString stringWithFormat:@"%d",i]];
                [self.arrayForFinalSports addObject:DictWithRowSport];
                [self.arrayForIndex removeAllObjects];
                
                
            }
            else
            {
                for (int k =0 ; k<3; k++) {
                    //[self.sportsSectionWithRowsWithArrayData setObject:[NSString stringWithFormat:@"%d",i] forKey:@"Section"];
                    //[self.sportsSectionWithRowsWithArrayData setObject:[NSNumber numberWithInt:indexForSport]  forKey:@"Rows"];
                    [self.sportsSectionWithRowsWithArrayData setObject:[self.arraySport objectAtIndex:indexForSport] forKey:@"Sports"];
                     NSDictionary *DictWithRow=[NSDictionary dictionaryWithDictionary:self.sportsSectionWithRowsWithArrayData];
                    [self.arrayForIndex addObject:DictWithRow];
                    if ([self.arraySport count]>=indexForSport) {
                        indexForSport=indexForSport+1;
                    }
                }
                 //[self.sectionWithDataDict setObject:self.arrayForIndex forKey:[NSNumber numberWithInt:i]];
                // NSDictionary *DictWithRowSelected=[NSDictionary dictionaryWithDictionary:self.sectionWithDataDict];
                //[self.arrayForFinalSports addObject:DictWithRowSelected];
                //[self.arrayForIndex removeAllObjects];
                arrayForRowSport=[self.arrayForIndex copy];
                 DictWithRowSport=[NSDictionary dictionaryWithObject:arrayForRowSport forKey:[NSString stringWithFormat:@"%d",i]];
                [self.arrayForFinalSports addObject:DictWithRowSport];
                [self.arrayForIndex removeAllObjects];
            }
            
           // [self.arrayForFinalSports addObject:DictWithRowSport];
            //[self.arrayForIndex removeAllObjects];
        }
//        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//        
//        NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
//        
//       self.allSectionsKeysArray = [[self.sectionWithDataDict allKeys] sortedArrayUsingDescriptors:sorters];
       // self.allSectionsKeysArray = [[self.sectionWithDataDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

        self.collectionSportView.delegate=self;
        self.collectionSportView.dataSource=self;
        [self.collectionSportView setAllowsMultipleSelection:YES];
        [self.collectionSportView registerClass:[SportsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        // NSArray *arraySport=[responseData valueForKey:@"Sports"];
        //  [[[UIAlertView alloc]initWithTitle:@"CONGRATULATIONS" message:@"User registered successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        
    }
    else
    {
        NSLog(@"send successfully");
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
-(IBAction)continueButtonClicked:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return 1;
   // int rowShowCount =0 ;
//    int countRows= (int)section;
//        if(countRows % 2 == 0) {
//            countRows = 4;
//            
//        } else {
//            countRows = 3;
//        
//        }
//    
   // return [self.arraySport count];
//
//    for (int i =0; i<[self.arraySport  count]; <#increment#>) {
//        <#statements#>
//    }
//    if (section %2 ==0) {
//        section =4;
//    }
//    else
//    {
//        section = 3;
//    }
    
//    if (section == 0) {
//        <#statements#>
//    }
    //return [self.arraySport count];
    int cellNum;
    if (section % 2 == 0)
        cellNum = 4; // Odd Number
    else
        cellNum = 3; // Even Number
    return cellNum;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
   
    
    return finalCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SportsCollectionViewCell *cellSports = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  // if ([self.arraySport count]>0) {
//    if (cellSports==nil)
//    {
//        cellSports = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];;
//    }
   
    NSString *url_Img1 = [NSString stringWithFormat:@"%@/",baseURL];
    NSString *url_Img2;
        NSString *sectionTitle = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        NSArray *sectionAnimals = [[self.arrayForFinalSports objectAtIndex:(long)indexPath.section] objectForKey:sectionTitle];
       NSDictionary *avatars = [sectionAnimals objectAtIndex:indexPath.row];
    
    if (cellSports.selected)
    {
        //cell.backgroundColor = [UIColor blueColor]; // highlight selection
        
        url_Img2 = [[avatars objectForKey:@"Sports"]objectForKey:@"SportIconOriginal"];
         //cellSports.labSport.text=[[avatars objectForKey:@"Sports"]objectForKey:@"Sport"];
        //url_Img2=self.arrayForIndex[indexPath.section]
    }
    else
    {
            //cell.backgroundColor = [UIColor redColor]; // Default color
        
        url_Img2 = [[avatars objectForKey:@"Sports"]objectForKey:@"SportIconThumb"];
         //cellSports.labSport.text=[[avatars objectForKey:@"Sports"]objectForKey:@"Sport"];
    }

            NSString *url_Img_FULL = [url_Img1 stringByAppendingPathComponent:url_Img2];
    
            NSLog(@"Show url_Img_FULL: %@",url_Img_FULL);
    cellSports.ImageSportView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
    cellSports.ImageSportView.layer.cornerRadius = cellSports.ImageSportView.frame.size.width / 2;
    cellSports.ImageSportView.clipsToBounds = YES;
    cellSports.ImageSportView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img_FULL]]];
    [cellSports.contentView addSubview:cellSports.ImageSportView];
    cellSports.labSport=[[UILabel alloc] initWithFrame:CGRectMake(0, 51, 80, 20)];
    cellSports.labSport.textAlignment=NSTextAlignmentCenter;
    cellSports.labSport.textColor=[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    cellSports.labSport.font =[UIFont fontWithName:@"SFUIDisplay-Regular" size:11.0];
    cellSports.labSport.tag=1;
    cellSports.labSport.text=[[avatars objectForKey:@"Sports"]objectForKey:@"Sport"];
    
    
    
    if ([cellSports.contentView viewWithTag:1])
    {
        [[cellSports.contentView viewWithTag:1]removeFromSuperview];
    }
   
    [cellSports.contentView addSubview:cellSports.labSport];
    
   // }
    cellSports.backgroundColor=[UIColor clearColor];
    return cellSports;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    int cellNum;
    if (section % 2 == 0)
    {
        cellNum = 10; // Even Number
        return UIEdgeInsetsMake(10, cellNum, 10, 10);
    }
    // top, left, bottom, right
    
    else
    {
        cellNum = 50; // Odd Number
        
        return UIEdgeInsetsMake(10, cellNum, 10, cellNum); // top, left, bottom, right
    }
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *url_Img1 = [NSString stringWithFormat:@"%@/",baseURL];
    NSString *url_Img2;
    NSInteger currentRow = indexPath.row;
    NSString *sectionTitle = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSArray *sectionAnimals = [[self.arrayForFinalSports objectAtIndex:(long)indexPath.section] objectForKey:sectionTitle];
    NSDictionary *avatars = [[sectionAnimals objectAtIndex:indexPath.row] objectForKey:@"Sports"];
     [self.arrayForSelectedSports removeObject:avatars];
    url_Img2 = [avatars objectForKey:@"SportIconThumb"];
    NSString *url_Img_FULL = [url_Img1 stringByAppendingPathComponent:url_Img2];
    
    SportsCollectionViewCell *cell=  (SportsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.ImageSportView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img_FULL]]];
 
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSString *url_Img1 = [NSString stringWithFormat:@"%@/",baseURL];
    NSString *url_Img2;
     NSString *sectionTitle = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSArray *sectionAnimals = [[self.arrayForFinalSports objectAtIndex:(long)indexPath.section] objectForKey:sectionTitle];
    NSDictionary *avatars = [[sectionAnimals objectAtIndex:indexPath.row] objectForKey:@"Sports"];
     [self.arrayForSelectedSports addObject:avatars];
    url_Img2 = [avatars objectForKey:@"SportIconOriginal"];
     NSString *url_Img_FULL = [url_Img1 stringByAppendingPathComponent:url_Img2];
  
  SportsCollectionViewCell *cell=  (SportsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.ImageSportView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img_FULL]]];
  
}
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"this is caled");
//    return YES;
//}
-(IBAction)sendSportListData:(id)sender
{
    if ([self.arrayForSelectedSports count]>0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i=0 ; i<[self.arrayForSelectedSports count]; i++) {
                self.userWebAPI = [[UserService alloc]init];
                self.userWebAPI.delegate = self;
                self.userWebAPI.tag=2;
                //[[HUD sharedInstance]showHUD:self.view];
                [self.userWebAPI sportListSendData:self.strUserId andSportId:[[self.arrayForSelectedSports objectAtIndex:i] objectForKey:@"Id"] andCreatedDate:[NSString stringWithFormat:@"12/12/2015"] andUpdatedDate:[NSString stringWithFormat:@"12/12/2015"]];
            }
        
        });
    }
    
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(50, 50);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

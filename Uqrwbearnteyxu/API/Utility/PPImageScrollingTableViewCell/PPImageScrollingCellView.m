//
//  PPImageScrollingCellView.m
//  PPImageScrollingTableViewDemo
//
//  Created by popochess on 13/8/9.
//  Copyright (c) 2013年 popochess. All rights reserved.
//

#import "PPImageScrollingCellView.h"
#import "PPCollectionViewCell.h"
#import "BlockOperationWithIdentifier.h"

@interface  PPImageScrollingCellView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) PPCollectionViewCell *myCollectionViewCell;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSArray *collectionImageData;
@property (nonatomic) CGFloat imagetitleWidth;
@property (nonatomic) CGFloat imagetitleHeight;
@property (strong, nonatomic) UIColor *imageTilteBackgroundColor;
@property (strong, nonatomic) UIColor *imageTilteTextColor;
@property (nonatomic, strong) NSCache *eventImageCache;
@property (nonatomic, strong) NSOperationQueue *eventImageOperationQueue;


@end

@implementation PPImageScrollingCellView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.eventImageCache=[[NSCache alloc]init];
    self.eventImageOperationQueue = [[NSOperationQueue alloc]init];
    self.eventImageOperationQueue.maxConcurrentOperationCount = 10;

    
    /* Set flowLayout for CollectionView*/
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(50, 50.0);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    flowLayout.minimumLineSpacing = 10;
    
    /* Init and Set CollectionView */
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    
    [self.myCollectionView registerClass:[PPCollectionViewCell class] forCellWithReuseIdentifier:@"PPCollectionCell"];
    [self addSubview:_myCollectionView];
}
- (id)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.eventImageCache=[[NSCache alloc]init];
        self.eventImageOperationQueue = [[NSOperationQueue alloc]init];
        self.eventImageOperationQueue.maxConcurrentOperationCount = 10;
        
        /* Set flowLayout for CollectionView*/
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(50, 50.0);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        flowLayout.minimumLineSpacing = 10;

        /* Init and Set CollectionView */
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.showsHorizontalScrollIndicator = NO;

        [self.myCollectionView registerClass:[PPCollectionViewCell class] forCellWithReuseIdentifier:@"PPCollectionCell"];
        [self addSubview:_myCollectionView];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    self.myCollectionView.frame=self.bounds;
}


- (void) setImageData:(NSArray*)collectionImageData{

    _collectionImageData = collectionImageData;
    [_myCollectionView reloadData];
}

- (void) setBackgroundColor:(UIColor*)color{

    self.myCollectionView.backgroundColor = color;
    [_myCollectionView reloadData];
}

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height{
    _imagetitleWidth = width;
    _imagetitleHeight = height;
}
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor{
    
    _imageTilteTextColor = textColor;
    _imageTilteBackgroundColor = bgColor;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionImageData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    PPCollectionViewCell *cell = (PPCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PPCollectionCell" forIndexPath:indexPath];
    NSDictionary *imageDic = [self.collectionImageData objectAtIndex:[indexPath row]];
    
    [cell setImage:[UIImage imageNamed:[imageDic objectForKey:@"name"]]];
    [cell setImageTitleLabelWitdh:_imagetitleWidth withHeight:_imagetitleHeight];
    [cell setImageTitleTextColor:_imageTilteTextColor withBackgroundColor:_imageTilteBackgroundColor];
    [cell setTitle:[imageDic objectForKey:@"title"]];
    
    NSString *urlToImage =[imageDic objectForKey:@"URL"];
   // urlToImage = @"http://5.189.161.31/images/usersports/thumb/e80718fb-f553-41ed-b755-c8fb049438ce.jpg";
    
    if(urlToImage.length){
    UIImage *imageFromCache = [self.eventImageCache objectForKey:[NSString stringWithFormat:@"%@",urlToImage]];
    if (imageFromCache) {
        [cell setImage:imageFromCache];
    }else{
        
        [cell setImage:nil];
        BlockOperationWithIdentifier *operation = [BlockOperationWithIdentifier blockOperationWithBlock:^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToImage]];
            
            UIImage *img = [UIImage imageWithData:imageData];
            if (img) {
                [self.eventImageCache setObject:img forKey:[NSString stringWithFormat:@"%@",urlToImage]];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    PPCollectionViewCell *updateCell =(PPCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                    if (updateCell) {
                        
                        [updateCell setImage:img];
                    }
                    else{
                                        NSLog(@"%%%%%%%%% NO cell");
                    }
                }];
            }
            else{
                NSLog(@"%%%%%%%%% NO IMG");
            }
        }];
        operation.queuePriority = NSOperationQueuePriorityNormal;
        operation.identifier=urlToImage;
        [self.eventImageOperationQueue addOperation:operation];
    }

    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate collectionView:self didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

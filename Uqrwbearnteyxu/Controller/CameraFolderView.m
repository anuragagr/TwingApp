;//
//  CameraFolderView.m
//  CameraWithAVFoundation
//
//  Created by Mac on 08/03/16.
//  Copyright © 2016 Gabriel Alvarado. All rights reserved.
//

#import "CameraFolderView.h"
#import "CameraDismissButton.h"
#import "CameraDoneButton.h"
#import "Constants.h"
#import "CameraGalleryButton.h"
#import <Photos/Photos.h>
#import "CameraTableViewCell.h"
#import "CameraTableViewCellSection.h"
#import <QuartzCore/QuartzCore.h>
#import "NSIndexSet+Convenience.h"
#import "UICollectionView+Convenience.h"
#import "MakeProfileVC/MakeProfileViewController.h"
#import "CameraSessionView.h"
@interface CameraFolderView ()<PHPhotoLibraryChangeObserver,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    //Size of the UI elements variables
    CGSize shutterButtonSize;
    CGSize topBarSize;
    CGSize barButtonItemSize;
    CGSize bottomBarSize;
    
}

@property (nonatomic, strong) CameraDismissButton *cameraFolderDismiss;
@property (nonatomic, strong) CameraDoneButton *cameraFolderDone;
@property (nonatomic, strong) CameraGalleryButton *cameraGalleryButton;
@property (nonatomic, strong) UITableView *photoFolderList;
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) UICollectionView *collectionPhotoView;
@property (nonatomic, strong) UILabel *labPhotoSelectionName;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UITableView *tableViewForFolder;
@property (nonatomic, strong) UICollectionView *collectionImageViews;
@property (nonatomic, strong) NSArray *sectionFetchResults;
@property (nonatomic, strong) NSArray *sectionLocalizedTitles;

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property CGRect previousPreheatRect;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, strong) UIImageView *circleView;
@property (nonatomic, strong) UIImageView *imageViewCollection;
@property (nonatomic) CGFloat circleRadius;
@property (nonatomic) CGPoint circleCenter;

@property (nonatomic, weak) CAShapeLayer *maskLayer;
@property (nonatomic, weak) CAShapeLayer *circleLayer;
@property (nonatomic, strong)UIScrollView *scrollSelectedImage;
@end
@implementation CameraFolderView
static NSString * const AllPhotosReuseIdentifier = @"AllPhotosCell";
static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";
static CGSize AssetGridThumbnailSize;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect {
    if (self) {
        [self composeInterface];
    }
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}
- (void)composeInterface
{
    [self setBackgroundColor:[UIColor whiteColor]];
    topBarSize = CGSizeMake(self.frame.size.width, [[UIScreen mainScreen] bounds].size.height * 0.15);
    bottomBarSize= CGSizeMake(self.frame.size.width, self.frame.size.height * 0.31);
    barButtonItemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.height * 0.05, [[UIScreen mainScreen] bounds].size.height * 0.05);
    
    //_topBarView = [UIView new];
    
    //if (_topBarView) {
        
        //Setup visual attribution for bar
      //  _topBarView.frame  = (CGRect){0,0, self.frame.size.width, 60};
        //_topBarView.backgroundColor = [UIColor colorWithRed:115/255.0 green:119/255.0 blue:119/255.0 alpha:0.6];
        //[self addSubview:_topBarView];
        
//        //Add the camera dismiss button
//        _cameraFolderDismiss = [CameraDismissButton new];
//        if (_cameraFolderDismiss) {
//            _cameraFolderDismiss.frame = (CGRect){0,0,100,30};
//            _cameraFolderDismiss.center = CGPointMake(40, _topBarView.center.y+15);
//            _cameraFolderDismiss.tag = DismissButtonTag;
//            [_topBarView addSubview:_cameraFolderDismiss];
//        }
//        
//        //Add the camera dismiss button
//        _cameraFolderDone = [CameraDoneButton new];
//        if (_cameraFolderDone) {
//            _cameraFolderDone.frame = (CGRect){50,0,100,30};
//            _cameraFolderDone.center = CGPointMake(_topBarView.frame.size.width-50, _topBarView.center.y+15);
//            _cameraFolderDone.tag = DoneButtonTag;
//            [_topBarView addSubview:_cameraFolderDone];
//        }
//        
//        //Add the camera dismiss button
//        _cameraGalleryButton = [CameraGalleryButton new];
//        if (_cameraGalleryButton) {
//            _cameraGalleryButton.frame = (CGRect){0,0,25,25};
//            _cameraGalleryButton.center = CGPointMake(_topBarView.frame.size.width/2+40, _topBarView.center.y+15);
//            [_cameraGalleryButton setBackgroundImage:[UIImage imageNamed:@"downarrow.png"] forState:UIControlStateNormal];
//            _cameraGalleryButton.tag = GalleryButtonTag;
//            [_topBarView addSubview:_cameraGalleryButton];
//        }
//
//        //Attribute and configure all buttons in the bar's subview
//        for (UIButton *button in _topBarView.subviews) {
//            button.backgroundColor = [UIColor clearColor];
//            [button addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        //Add the photo selection name
//        _labPhotoSelectionName=[[UILabel alloc] init];
//        if (_labPhotoSelectionName) {
//            _labPhotoSelectionName.frame = (CGRect){0,0,120,30};
//            _labPhotoSelectionName.center = CGPointMake(_topBarView.frame.size.width/2, _topBarView.center.y+15);
//            _labPhotoSelectionName.text=@"gallery";
//            _labPhotoSelectionName.textAlignment=NSTextAlignmentCenter;
//            _labPhotoSelectionName.textColor=[UIColor whiteColor];
//            _labPhotoSelectionName.font =[UIFont fontWithName:@"SFUIDisplay-light" size:13.0];
//            [_topBarView addSubview:_labPhotoSelectionName];
//            
//        }
        
        // Scrollview add subview
        _scrollSelectedImage=[[UIScrollView alloc] init];
        if (_scrollSelectedImage) {
            _scrollSelectedImage.frame =(CGRect){0,0,self.frame.size.width,self.frame.size.width};
            _scrollSelectedImage.minimumZoomScale=0.5;
            _scrollSelectedImage.maximumZoomScale=6.0;
             _scrollSelectedImage.scrollEnabled=YES;
            _scrollSelectedImage.backgroundColor=[UIColor clearColor];
            _scrollSelectedImage.contentSize=CGSizeMake(600, 600);
            _scrollSelectedImage.delegate=self;
            
            [self addSubview:_scrollSelectedImage];
            // Selected imageview
            _selectedImageView=[[UIImageView alloc] init];
            if (_selectedImageView) {
                _selectedImageView.frame =(CGRect){0,0,self.frame.size.width,self.frame.size.width};
               _selectedImageView.userInteractionEnabled=YES;
                _selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
                [_scrollSelectedImage addSubview:_selectedImageView];
            }
        }

    
        
        // add a circle in selected image
        _circleView=[[UIImageView alloc] init];
        if (_circleView) {
            _circleView.frame =(CGRect){0,0,self.frame.size.width,self.frame.size.width};
            _circleView.image=[UIImage imageNamed:@"ImageOverlay500X500new.png"];
           // _circleView.userInteractionEnabled=YES;
            _circleView.alpha=0.6;
            [self addSubview:_circleView];
          //  Add the camera dismiss button
                    _cameraFolderDismiss = [CameraDismissButton new];
                    if (_cameraFolderDismiss) {
                        _cameraFolderDismiss.frame = (CGRect){0,0,100,30};
                        _cameraFolderDismiss.center = CGPointMake(40, _circleView.frame.origin.y+60);
                        //_cameraFolderDismiss.tag = DismissButtonTag;
                        [_cameraFolderDismiss addTarget:self action:@selector(onTapDismissButton) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:_cameraFolderDismiss];
                      
                        
                    }
            //Add the camera done button
                    _cameraFolderDone = [CameraDoneButton new];
                    if (_cameraFolderDone) {
                        _cameraFolderDone.frame = (CGRect){50,0,100,30};
                        _cameraFolderDone.center = CGPointMake(_circleView.frame.size.width-50, _circleView.frame.origin.y+60);
                     //   _cameraFolderDone.tag = DoneButtonTag;
                        [_circleView addSubview:_cameraFolderDone];
                        [_cameraFolderDone addTarget:self action:@selector(onTapDoneButton) forControlEvents:UIControlEventTouchUpInside];
                       //[self bringSubviewToFront:_cameraFolderDone];
                      //  _circleView.userInteractionEnabled=YES;
                         [self addSubview:_cameraFolderDone];

                    }
            //Add the camera gallery button
                    _cameraGalleryButton = [CameraGalleryButton new];
                    if (_cameraGalleryButton) {
                        _cameraGalleryButton.frame = (CGRect){0,0,15,18};
                        _cameraGalleryButton.center = CGPointMake(_circleView.frame.size.width/2+30, _circleView.frame.origin.y+60);
                        [_cameraGalleryButton setBackgroundImage:[UIImage imageNamed:@"downarrow.png"] forState:UIControlStateNormal];
                        //_cameraGalleryButton.tag = GalleryButtonTag;
                        [_cameraGalleryButton addTarget:self action:@selector(onTapGalleryButton) forControlEvents:UIControlEventTouchUpInside];

                        [self addSubview:_cameraGalleryButton];
                       //[self bringSubviewToFront:_cameraGalleryButton];
                        //_circleView.userInteractionEnabled=YES;
                    }
            //Add the photo selection name
                    _labPhotoSelectionName=[[UILabel alloc] init];
                    if (_labPhotoSelectionName) {
                        _labPhotoSelectionName.frame = (CGRect){0,0,120,30};
                        _labPhotoSelectionName.center = CGPointMake(_circleView.frame.size.width/2, _circleView.frame.origin.y+60);
                        _labPhotoSelectionName.text=@"gallery";
                        _labPhotoSelectionName.textAlignment=NSTextAlignmentCenter;
                        _labPhotoSelectionName.textColor=[UIColor whiteColor];
                        _labPhotoSelectionName.font =[UIFont fontWithName:@"SFUIDisplay-light" size:13.0];
                        [self addSubview:_labPhotoSelectionName];
                        
                    }
            
            
        }
        
   // }
    //Add the photo selection name
    _tableViewForFolder=[[UITableView alloc] init];
    if (_tableViewForFolder) {
        _tableViewForFolder.frame = (CGRect){_labPhotoSelectionName.frame.origin.x+20,_labPhotoSelectionName.frame.origin.y+25,100,100};
        //_tableViewForFolder.center = CGPointMake(_circleView.frame.size.width/2, _labPhotoSelectionName.frame.origin.y+10);
        _tableViewForFolder.delegate=self;
        _tableViewForFolder.dataSource=self;
        [[_tableViewForFolder layer] setCornerRadius:3.0];
        _tableViewForFolder.hidden=YES;
        _tableViewForFolder.userInteractionEnabled=YES;
        [self addSubview:_tableViewForFolder];
       // [self bringSubviewToFront:_tableViewForFolder];
      //  _circleView.userInteractionEnabled=YES;
        
    }
    //Add the collection images selection images
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionImageViews=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    if (_collectionImageViews) {
        _collectionImageViews.frame = (CGRect){0,_selectedImageView.frame.size.height+_topBarView.frame.size.height,self.frame.size.width,self.frame.size.height-(_topBarView.frame.size.height+_selectedImageView.frame.size.height)};
       // _collectionImageViews.collectionViewLayout=layout;
       // _collectionImageViews.center = CGPointMake(_topBarView.frame.size.width/2, _topBarView.frame.size.height+20);
        _collectionImageViews.delegate=self;
        _collectionImageViews.dataSource=self;
        [_collectionImageViews registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
       // [[_tableViewForFolder layer] setCornerRadius:3.0];
        [self addSubview:_collectionImageViews];
        
    }
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)layout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
//    [_tableViewForFolder registerClass:[CameraTableViewCell class] forCellReuseIdentifier:AllPhotosReuseIdentifier];
//    [_tableViewForFolder registerClass:[CameraTableViewCellSection class] forCellReuseIdentifier:CollectionCellReuseIdentifier];
//    
    // Create a PHFetchResult object for each section in the table view.
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = @[allPhotos, smartAlbums, topLevelUserCollections];
   // self.sectionLocalizedTitles = @[@"", NSLocalizedString(@"Smart Albums", @""), NSLocalizedString(@"Albums", @"")];
    
    
    
    // Get the PHFetchResult for the selected section.
    NSIndexPath *indexPath = 0;
    PHFetchResult *fetchResult = self.sectionFetchResults[0];
    
    if (indexPath==0) {
        _assetsFetchResults = fetchResult;
    }
//    else if ([segue.identifier isEqualToString:CollectionSegue]) {
//        // Get the PHAssetCollection for the selected row.
//        PHCollection *collection = fetchResult[indexPath.row];
//        if (![collection isKindOfClass:[PHAssetCollection class]]) {
//            return;
//        }
//        
//        // Configure the AAPLAssetGridViewController with the asset collection.
//        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
//        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
//        
//        assetGridViewController.assetsFetchResults = assetsFetchResult;
//        assetGridViewController.assetCollection = assetCollection;
//    }
    self.imageManager = [[PHCachingImageManager alloc] init];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

}
- (UIBezierPath *)makeCircleAtLocation:(CGPoint)location radius:(CGFloat)radius
{
    CGPoint circleCenter = location;
     CGFloat circleRadius = radius;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:circleCenter
                    radius:circleRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    return path;
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//   // UITapGestureRecognizer *tap;
//    CGPoint location = [touch locationInView:self];
//    if (touch.view == _cameraFolderDismiss)
//    {
//        //_selectedImageView.userInteractionEnabled=NO;
//        //_circleView.userInteractionEnabled=YES;
//        [self performSelector:@selector(onTapDismissButton)];
//    }
//    if (touch.view == _cameraFolderDone)
//    {
//         _selectedImageView.userInteractionEnabled=NO;
//         _circleView.userInteractionEnabled=YES;
//       // [_selectedImageView removeGestureRecognizer:tap];
//        [self performSelector:@selector(onTapDoneButton)];
//    }
//    if (touch.view == _cameraGalleryButton)
//    {
//         _selectedImageView.userInteractionEnabled=NO;
//         _circleView.userInteractionEnabled=YES;
//        //[_selectedImageView removeGestureRecognizer:tap];
//        [self performSelector:@selector(onTapGalleryButton)];
//    }
////    if ([touch view] == _selectedImageView)
////    {
////        // move the image view
////        _selectedImageView.frame =(CGRect){0,0,self.frame.size.width,self.frame.size.width};
////        _selectedImageView.userInteractionEnabled=YES;
////        
////        //imageView.center = touchLocation;
////    }
//    if (CGRectContainsPoint([_selectedImageView frame], location)){
//        // code here
//        //tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
//        _circleView.userInteractionEnabled =NO;
//        _selectedImageView.frame =(CGRect){0,0,self.frame.size.width,self.frame.size.width};
//       _selectedImageView.userInteractionEnabled=YES;
//       // _scrollSelectedImage.delaysContentTouches=YES;
//       // _scrollSelectedImage.canCancelContentTouches=NO;
//        [[self superview] bringSubviewToFront:_scrollSelectedImage];
//        //[_selectedImageView addGestureRecognizer:tap];
//    }
//}
//- (void )imageTapped:(UITapGestureRecognizer *) gestureRecognizer
//{
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged)
//    {
//        CGPoint touchLocation = [gestureRecognizer locationInView:_scrollSelectedImage];
//        _selectedImageView.center = touchLocation;
//    }
//}
- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isDescendantOfView:_tableViewForFolder]) {
//        
//        // Don't let selections of auto-complete entries fire the
//        // gesture recognizer
//        return NO;
//    }
//    
//    return YES;
//}

//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint touchLocation = [touch locationInView:touch.view];
//    _selectedImageView.center = touchLocation;
//    
//    if ([touch.view isEqual: self.view] || touch.view == nil) {
//        return;
//    }
//    
//}
//
//- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint touchLocation = [touch locationInView:touch.view];
//    
//    if ([touch.view isEqual: self.view]) {
//        
//        self.imageview.center = touchLocation;
//        
//        return;
//    }
//}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _selectedImageView;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsFetchResults.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    _representedAssetIdentifier = asset.localIdentifier;
    
    _imageViewCollection=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 92, 85)];
    //imageView.backgroundColor=[UIColor blueColor];
    [cell.contentView addSubview:_imageViewCollection];
    // Add a badge to the cell if the PHAsset represents a Live Photo.
    if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
        // Add Badge Image to the cell to denote that the asset is a Live Photo.
//        UIImage *badge = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
//        cell.livePhotoBadgeImage = badge;
    }
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  if ([_representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      _imageViewCollection.image = result;
                                      if (indexPath.item==0) {
                                        _selectedImageView.image=result;
                                      }
                                  }
                              }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(92, 85);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   // UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    _representedAssetIdentifier = asset.localIdentifier;
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  if ([_representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      _selectedImageView.image = result;
                                      
                                  }
                              }];

    
}
// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}
- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        // The "All Photos" section only ever has a single row.
        numberOfRows = 1;
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[section];
        numberOfRows = fetchResult.count;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//    }
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // allocate the cell:
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        
//        // create a background image for the cell:
//        UIImageView *bgView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell setBackgroundView:bgView];
//        [cell setIndentationWidth:0.0];
        
        // create a custom label:                                        x    y   width  height
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.0, 100, 30.0)];
        [nameLabel setTag:1];
        [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [nameLabel setFont:[UIFont systemFontOfSize:8.0]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:nameLabel];
       
    }
    
    if (indexPath.section == 0) {
      //CameraTableViewCell *cell = (CameraTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AllPhotosReuseIdentifier];
        //cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"gallery", @"");
        cell.textLabel.font =[UIFont systemFontOfSize:8.0];
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
        PHCollection *collection = fetchResult[indexPath.row];
       // CameraTableViewCellSection *cell = (CameraTableViewCellSection *)[tableView dequeueReusableCellWithIdentifier:CollectionCellReuseIdentifier];
        //cell = [tableView dequeueReusableCellWithIdentifier:cell forIndexPath:indexPath];
        cell.textLabel.text = collection.localizedTitle;
        cell.textLabel.font =[UIFont systemFontOfSize:8.0];
    }
    
    //UITableViewCell *cell = nil;
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.sectionLocalizedTitles[section];
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
   // NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    
    if ([indexPath section]==0) {
        _assetsFetchResults = fetchResult;
        _labPhotoSelectionName.text= NSLocalizedString(@"gallery", @"");
        _cameraGalleryButton.center = CGPointMake(_circleView.frame.size.width/2+30, _circleView.frame.origin.y+60);
    } else if ([indexPath section]==1) {
        // Get the PHAssetCollection for the selected row.
        
        PHCollection *collection = fetchResult[indexPath.row];
        _labPhotoSelectionName.text=collection.localizedTitle;
        if ([_labPhotoSelectionName.text isEqualToString:@"Favorites"] || [_labPhotoSelectionName.text isEqualToString:@"Panoramas"] ||  [_labPhotoSelectionName.text isEqualToString:@"Camera Roll"] || [_labPhotoSelectionName.text isEqualToString:@"Screenshots"] || [_labPhotoSelectionName.text isEqualToString:@"Time-lapse"] || [_labPhotoSelectionName.text isEqualToString:@"Time-lapse"]) {
            _cameraGalleryButton.center = CGPointMake(_circleView.frame.size.width/2+45, _circleView.frame.origin.y+60);
        }
        else if ([_labPhotoSelectionName.text isEqualToString:@"Recently Added"] || [_labPhotoSelectionName.text isEqualToString:@"Recently Deleted"])
        {
             _cameraGalleryButton.center = CGPointMake(_circleView.frame.size.width/2+55, _circleView.frame.origin.y+60);
        }
        else
        {
            _cameraGalleryButton.center = CGPointMake(_circleView.frame.size.width/2+30, _circleView.frame.origin.y+60);
        }
        if (![collection isKindOfClass:[PHAssetCollection class]]) {
            return;
        }
        
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        _assetsFetchResults = assetsFetchResult;
        _assetCollection = assetCollection;
        //self.imageManager = [[PHCachingImageManager alloc] init];
        
       // [_collectionImageViews reloadData];
        
    }
    _tableViewForFolder.hidden=YES;
   [_collectionImageViews reloadData];
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
            [_tableViewForFolder reloadData];
        }
        // Get the new fetch result.
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = _collectionImageViews;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
            [collectionView reloadData];
            
        } else {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
             */
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        
        [self resetCachedAssets];

        
    });
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}
- (void)updateCachedAssets {
//    BOOL isViewVisible = [self isViewLoaded] && [self window] != nil;
//    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = _collectionImageViews.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(_collectionImageViews.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [_collectionImageViews aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [_collectionImageViews aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}
- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

#pragma mark - User Interaction

//-(void)inputManager:(id)sender {
//    
//    //If animation is in progress, ignore input
//    //if (_animationInProgress) return;
//    
//    //If sender does not inherit from 'UIButton', return
//    if (![sender isKindOfClass:[UIButton class]]) return;
//    
//    //Input manager switch
//    switch ([(UIButton *)sender tag]) {
//        //case ShutterButtonTag:  [self onTapShutterButton];  return;
//        //case ToggleButtonTag:   [self onTapToggleButton];   return;
//        //case FlashButtonTag:    [self onTapFlashButton];    return;
//        //case DismissButtonTag:  [self onTapDismissButton];  return;
//      //  case DoneButtonTag:   [self onTapDoneButton];    return;
//        //case GalleryButtonTag: [self onTapGalleryButton]; return;
//    }
//}


- (void)onTapDismissButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y*3);
    } completion:^(BOOL finished) {
       
        [self removeFromSuperview];
    }];
}
-(void)onTapDoneButton
{
    [UIView animateWithDuration:0.3 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y*3);
    } completion:^(BOOL finished) {
//        MakeProfileViewController *makeProfileVc=[[MakeProfileViewController alloc] init];
//        //[self performSegueWithIdentifier:segueMakeProfile sender:self];
//        makeProfileVc.imgviewProfile.image=_selectedImageView.image;
//        for(UIView *subview in [makeProfileVc.view subviews]) {
//                      
//            if ([subview isKindOfClass:[CameraSessionView class]]) { // Condition
//                    [subview removeFromSuperview];
//                }
//            
//        }
        self.circleCenter = _selectedImageView.center;
        self.circleRadius = 150;
        CGPoint center=CGPointMake(_selectedImageView.center.x, _selectedImageView.center.y);
        CGRect frame = CGRectMake(center.x,center.y,_scrollSelectedImage.frame.size.width,_scrollSelectedImage.frame.size.height);
        // render the clipped image
        CGSize size=CGSizeMake(_selectedImageView.frame.size.width, _selectedImageView.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if ([_selectedImageView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            // if iOS 7, just draw it
            
            [_selectedImageView drawViewHierarchyInRect:_selectedImageView.bounds afterScreenUpdates:YES];
        }
        else
        {
            // if pre iOS 7, manually clip it
            
            CGContextAddArc(context, self.circleCenter.x-100, self.circleCenter.y-100, self.circleRadius, 0, M_PI * 2.0, YES);
            CGContextClip(context);
            [_selectedImageView.layer renderInContext:context];
        }
        
        // capture the image and close the context
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // crop the image
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], frame);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        
        // save the image
        NSData* imageData = UIImagePNGRepresentation(croppedImage);
    
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"myEncodedImageDataKey"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"TestNotification" object:self];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ImageDataFromGalleryNotification" object:self];
        
        [self removeFromSuperview];
        
        
    }];
    

}
-(void)onTapGalleryButton
{
    _tableViewForFolder.hidden=NO;
}
@end

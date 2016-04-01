//
//  TableViewPullView.h
//  WCI
//
//  Created by Rahul N. Mane on 31/03/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	TableViewPullRefreshPulling = 0,
	TableViewPullRefreshNormal,
	TableViewPullRefreshLoading,
} TableViewPullRefreshState;


@protocol TableViewPullDelegate;
@interface TableViewPullView : UIView

@property(nonatomic,assign) id <TableViewPullDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)tableViewPullViewScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewPullViewScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)tableViewPullViewScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@protocol TableViewPullDelegate
- (void)TableViewPullDidTriggerRefresh:(TableViewPullView*)view;
- (BOOL)TableViewPullDataSourceIsLoading:(TableViewPullView*)view;
@optional
- (NSDate*)TableViewPullDataSourceLastUpdated:(TableViewPullView*)view;


@end


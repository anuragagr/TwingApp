//
//  TableViewPullView.m
//  WCI
//
//  Created by Rahul N. Mane on 31/03/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import "TableViewPullView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:114.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@implementation TableViewPullView
{
	TableViewPullRefreshState _state;
    
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, 0, 30.0f, 40);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		activityView = view;
		
		
		[self setState:TableViewPullRefreshNormal];
		
    }
	
    return self;
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)setState:(TableViewPullRefreshState)aState{
	
	switch (aState) {
		case TableViewPullRefreshPulling:
			
			statusLabel.text = NSLocalizedString(@"Release to load more...", @"Release to load status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			arrowImage.transform =CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case TableViewPullRefreshNormal:
			
			if (_state == TableViewPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
				[CATransaction commit];
			}
            
            
			
			statusLabel.text = NSLocalizedString(@"Pull up to load more...", @"Pull up to load more status");
			[activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			arrowImage.hidden = NO;
			arrowImage.transform =  CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case TableViewPullRefreshLoading:
			statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
			[activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)refreshLastUpdatedDate {
	
		NSDate *date = [_delegate TableViewPullDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
		lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)tableViewPullViewScrollViewDidScroll:(UIScrollView *)scrollView {
	
    if (_state == TableViewPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 64);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	}
    else  if (scrollView.isDragging && !scrollView.isDecelerating){
        
        BOOL _loading = NO;
        _loading = [_delegate TableViewPullDataSourceIsLoading:self];

       // if(scrollView.contentSize.height>700)
        {
            if (([scrollView contentOffset].y + scrollView.frame.size.height) > scrollView.contentSize.height+20)
            {
               
                if (_state == TableViewPullRefreshPulling && ([scrollView contentOffset].y + scrollView.frame.size.height) > scrollView.contentSize.height+50 && !_loading) {
                    
                    [self setState:TableViewPullRefreshLoading];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.2];
                    scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
                    [UIView commitAnimations];
                    [_delegate TableViewPullDidTriggerRefresh:self];
                } else if (_state == TableViewPullRefreshNormal && ([scrollView contentOffset].y + scrollView.frame.size.height) > scrollView.contentSize.height+20 && !_loading) {
                   [self setState:TableViewPullRefreshPulling];
                }
            }
        }
    }
}

- (void)tableViewPullViewScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
    
    
 	BOOL _loading = NO;
	_loading = [_delegate TableViewPullDataSourceIsLoading:self];
    if (_loading) return;
   
    
   

    
	if (([scrollView contentOffset].y + scrollView.frame.size.height) > scrollView.contentSize.height+20 && !_loading) {
		

		[self setState:TableViewPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
        [_delegate TableViewPullDidTriggerRefresh:self];

	}
    else{
       // NSLog(@"Loading rahul %f %f",[scrollView contentOffset].y + scrollView.frame.size.height,scrollView.contentSize.height+20);

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [UIView commitAnimations];
        
        [self setState:TableViewPullRefreshNormal];
    }
}

- (void)tableViewPullViewScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:TableViewPullRefreshNormal];
    
}




@end

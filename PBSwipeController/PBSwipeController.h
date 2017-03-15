//
//  PBSwipeController.h
//  PBSwipeController
//
//  Created by Pankaj Bhardwaj on 07/03/17.
//  Copyright © 2017 Pankaj Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildViewController.h"

@protocol PBSwipeControllerDelegate <NSObject>
-(void)swipeAtIndex:(int)index;
@end

@interface PBSwipeController : UINavigationController <UIScrollViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, weak) id<PBSwipeControllerDelegate> swipeDelegate;
@property (nonatomic, strong) NSArray *pagesNameArray;
@property (nonatomic, strong) NSArray *pageDataArray;
- (ChildViewController *)viewControllerAtIndex:(NSUInteger)index;
-(void)gotoPage:(int)index;
-(UIScrollView*)addInitialObjects;
@end

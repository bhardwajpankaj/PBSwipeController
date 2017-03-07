//
//  PBSwipeController.m
//  PBSwipeController
//
//  Created by Pankaj Bhardwaj on 07/03/17.
//  Copyright © 2017 Pankaj Bhardwaj. All rights reserved.
//

#import "PBSwipeController.h"

@interface PBSwipeController ()

@end

@implementation PBSwipeController
{
    ChildViewController * pageContentViewController;
    NSMutableArray *pageControllerArray;
    NSMutableArray *viewControllersAr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    viewControllersAr = [[NSMutableArray alloc]init];
    self.currentIndex = 0;
    self.navigationBar.hidden = true;
}
-(void)viewWillAppear:(BOOL)animated {
    if (!self.boolOnce) {
        [self initiatPageController];
        self.boolOnce = YES;
    }
}

-(void)initiatPageController {
    _pageController = (UIPageViewController*)self.topViewController;
    _pageController.delegate = self;
    _pageController.dataSource = self;
    [_pageController setViewControllers:@[[viewControllersAr objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((ChildViewController*) viewController).view.tag;
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((ChildViewController*) viewController).view.tag;
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}

- (ChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_pagesNameArray count] == 0) || (index >= [_pagesNameArray count])) {
        return nil;
    }
    if (!pageContentViewController) {
        pageContentViewController = [[ChildViewController alloc]init];
        pageContentViewController.view.tag = index;
    }else
    {
        if (![pageContentViewController.view viewWithTag:index]) {
            pageContentViewController = [[ChildViewController alloc]init];
            pageContentViewController.view.tag = index;
        }{
            for (ChildViewController*vc in viewControllersAr) {
                if (vc.view.tag == index){
                    pageContentViewController = vc;
                    break;
                }
            }
        }
    }
    if (index >= [viewControllersAr count]) {
        [viewControllersAr addObjectsFromArray:@[pageContentViewController]];
    }else if(index < [viewControllersAr count]){
        
    }
    [pageContentViewController reloadData:_pageDataArray[index]];
    pageContentViewController.pageIndex = index;
    [pageContentViewController scrollDisable];
    return pageContentViewController;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentIndex = ((ChildViewController*)[pageViewController.viewControllers lastObject]).pageIndex;
        _curIndex = self.currentIndex;
        [self.swipeDelegate swipeAtIndex:self.currentIndex];
        
    }
}

-(void)gotoPage:(int)index{
    ChildViewController *viewController = [self viewControllerAtIndex:index];
    
    UIPageViewControllerNavigationDirection direction;
    if(_curIndex <= index){
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    else
    {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    if(_curIndex < index)
    {
        for (int i = 0; i <= index; i++)
        {
            if (i == index) {
                [_pageController setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
            }
            else
            {
                [_pageController setViewControllers:@[[self viewControllerAtIndex:i]] direction:direction animated:NO completion:nil];
            }
        }
    }
    else
    {
        for (int i = _curIndex; i >= index; i--)
        {
            if (i == index) {
                [_pageController setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
            }
            else
            {
                [_pageController setViewControllers:@[[self viewControllerAtIndex:i]] direction:direction animated:NO completion:nil];
            }
        }
    }
    _curIndex = index;
}

@end

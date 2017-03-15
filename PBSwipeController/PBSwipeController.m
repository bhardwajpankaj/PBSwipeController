//
//  PBSwipeController.m
//  PBSwipeController
//
//  Created by Pankaj Bhardwaj on 07/03/17.
//  Copyright © 2017 Pankaj Bhardwaj. All rights reserved.
//

#import "PBSwipeController.h"

@interface PBSwipeController ()
@property (nonatomic) BOOL boolOnce;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) UIView *buttonBar;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageViewController *pageController;
@end

@implementation PBSwipeController
{
    PBSwipeChildViewController * pageContentViewController;
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

-(UIScrollView*)addInitialObjects{
    
    // Add Scroolable object in section header
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
    _scrollView.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:144.0f/255.0f blue:255.0f/255.0f alpha:1];
    for (int i = 0; i<_pagesNameArray.count; i++) {
        UIButton  *button = [[UIButton alloc]init];
        button.frame = CGRectMake(i*100, 0, 100, 40);
        [_scrollView addSubview:button];
        button.tag = i;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[_pagesNameArray objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor blackColor];
    }
    [self setupSelector];
    CGRect contentRect = CGRectZero;
    for (UIView *view in _scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    _scrollView.contentSize = contentRect.size;
    return _scrollView;
}
-(void)tapSegmentButtonAction:(UIButton *)button {
    self.currentIndex = button.tag;
    [self gotoPage:self.self.currentIndex];
    [self.swipeDelegate swipeAtIndex:self.currentIndex];
    [self animateScroller];
}

-(void)animateScroller{
    NSInteger xValue = self.currentIndex * 100;
    [UIView animateWithDuration:0.2
                     animations:^{
                         _buttonBar.frame = CGRectMake(xValue, _buttonBar.frame.origin.y, _buttonBar.frame.size.width, _buttonBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [_scrollView scrollRectToVisible:_buttonBar.frame animated:YES];
                     }];
    [UIView commitAnimations];
    
}
-(void)setupSelector {
    _buttonBar = [[UIView alloc]initWithFrame:CGRectMake(0, 36,100, 4)];
    _buttonBar.backgroundColor = [UIColor orangeColor];
    _buttonBar.alpha = 0.8;
    [_scrollView addSubview:_buttonBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((PBSwipeChildViewController*) viewController).view.tag;
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((PBSwipeChildViewController*) viewController).view.tag;
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}

- (PBSwipeChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_pagesNameArray count] == 0) || (index >= [_pagesNameArray count])) {
        return nil;
    }
    if (!pageContentViewController) {
        pageContentViewController = [[PBSwipeChildViewController alloc]init];
        pageContentViewController.view.tag = index;
    }else
    {
        if (![pageContentViewController.view viewWithTag:index]) {
            pageContentViewController = [[PBSwipeChildViewController alloc]init];
            pageContentViewController.view.tag = index;
        }{
            for (PBSwipeChildViewController*vc in viewControllersAr) {
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
        self.currentIndex = ((PBSwipeChildViewController*)[pageViewController.viewControllers lastObject]).pageIndex;
        [self.swipeDelegate swipeAtIndex:self.currentIndex];
        [self animateScroller];
    }
}
-(void)gotoPage:(int)index{
    PBSwipeChildViewController *viewController = [self viewControllerAtIndex:index];
    
    UIPageViewControllerNavigationDirection direction;
    if(_currentIndex <= index){
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    else
    {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    if(_currentIndex < index)
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
        for (int i = _currentIndex; i >= index; i--)
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
    _currentIndex = index;
}

@end

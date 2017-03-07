//
//  ViewController.m
//  PBSwipeController
//
//  Created by Pankaj Bhardwaj on 07/03/17.
//  Copyright © 2017 Pankaj Bhardwaj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *dataArray;
    NSArray *HeadingArray;
    PBSwipeController *navigationController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Get your own data and manipulate as per your requirement
    HeadingArray = @[@"Counting",@"Alphabets",@"Colors",@"Random",@"Names"];
    NSArray *array1 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    NSArray *array2 = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    NSArray *array3 = @[@"White",@"Orange",@"Blue",@"Green",@"Yellow"];
    NSArray *array4 = @[@"p",@"q",@"r",@"s",@"t"];
    NSArray *array5 = @[@"Abhi",@"Kabhi",@"Jabhi",@"Ravi",@"Lavi"];
    dataArray = [[NSMutableArray alloc]initWithObjects:array1,array2,array3,array4,array5, nil];
    
    [self addInitialObjects];
    [self setupSelector];
    
}
-(void)addInitialObjects{
    
    // Add Scroolable object in section header
    self.currentPageIndex = 0;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
    _scrollView.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:144.0f/255.0f blue:255.0f/255.0f alpha:1];
    for (int i = 0; i<HeadingArray.count; i++) {
        UIButton  *button = [[UIButton alloc]init];
        button.frame = CGRectMake(i*100, 0, 100, 40);
        [_scrollView addSubview:button];
        button.tag = i;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[HeadingArray objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor blackColor];
    }
    CGRect contentRect = CGRectZero;
    for (UIView *view in _scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    _scrollView.contentSize = contentRect.size;
    
    // Page view controller for swipeable view
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    navigationController = [[PBSwipeController alloc]initWithRootViewController:pageController];
    navigationController.swipeDelegate = self;
    [self addChildViewController:navigationController];
    [navigationController didMoveToParentViewController:self];
}
-(void)swipeAtIndex:(int)index{
    [self controllerSwipeAtIndex:index];
}
-(void)tapSegmentButtonAction:(UIButton *)button {
    self.currentPageIndex = button.tag;
    [navigationController gotoPage:self.currentPageIndex];
    [self animateScrollHeader];
}

-(float)labelWidthForText:(NSString*)text fontName:(NSString*)fontName fontSize:(float)size{
    UIFont *font = [UIFont fontWithName:fontName size:size];
    NSDictionary *userAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};
    const CGSize textSize = [text sizeWithAttributes: userAttributes];
    return textSize.width;
}

-(void)animateScrollHeader{
    [self.mytableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.mytableView endUpdates];
    
    NSInteger xCoor = self.currentPageIndex * 100;
    [UIView animateWithDuration:0.2
                     animations:^{
                         _buttonBar.frame = CGRectMake(xCoor, _buttonBar.frame.origin.y, _buttonBar.frame.size.width, _buttonBar.frame.size.height);
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] init];
    if(section == 1){
        [customView addSubview:_scrollView];
    }
    [customView setAutoresizingMask:UIViewAutoresizingNone];
    customView.userInteractionEnabled = YES;
    return customView;
}

#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 40;
    }
    else{
        NSArray *array = [dataArray objectAtIndex:self.currentPageIndex];
        float cellHeight = array.count * 44;
        return cellHeight;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return 1;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Section 1";
    else
        return @"Section 2";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0;
    else
        return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0) {
        cell1.textLabel.text = @"Cell - Below is section header";
        cell1.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:127.0f/255.0f alpha:1];
    }
    else {
        cell1.textLabel.text = @"";
        cell1.backgroundColor = [UIColor clearColor];
        navigationController.pagesNameArray = HeadingArray;
        navigationController.pageDataArray = dataArray;
        [navigationController viewControllerAtIndex:0];
        [cell1.contentView addSubview:navigationController.view];
    }
    return cell1;
}

-(void)controllerSwipeAtIndex:(int)index{
    self.currentPageIndex = index;
    [self animateScrollHeader];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

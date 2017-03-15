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
    
}
-(void)addInitialObjects{
    
    // Add Scroolable object in section header
    self.currentPageIndex = 0;
    // Page view controller for swipeable view
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    navigationController = [[PBSwipeController alloc]initWithRootViewController:pageController];
    navigationController.swipeDelegate = self;
    [self addChildViewController:navigationController];
    [navigationController didMoveToParentViewController:self];
}
-(void)swipeAtIndex:(int)index{
    self.currentPageIndex = index;
    [self animateTableHeader];
}

-(float)labelWidthForText:(NSString*)text fontName:(NSString*)fontName fontSize:(float)size{
    UIFont *font = [UIFont fontWithName:fontName size:size];
    NSDictionary *userAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};
    const CGSize textSize = [text sizeWithAttributes: userAttributes];
    return textSize.width;
}

-(void)animateTableHeader{
    [self.mytableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.mytableView endUpdates];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] init];
    if(section == 1){
        [customView addSubview:[navigationController addInitialObjects]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

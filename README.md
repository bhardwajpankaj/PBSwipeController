# PBSwipeController

![giphy](https://cloud.githubusercontent.com/assets/21870039/23964819/d2fcca42-09db-11e7-842a-2d1d2a094e1c.gif)

**UIPageViewController inside a UITableViewCell and Swipe between ViewControllers comprises of UITableview**

_Drag PBSwipeController.h, PBSwipeController.m, PBSwipeChildViewController.h, PBSwipeChildViewController.m and PBSwipeChildViewController.xib files manually into your project_
**how to use**

Import PBSwipeController.h
`#import "PBSwipeController.h"
`
Accept PBSwipeControllerDelegate delegate
`@interface ViewController : UIViewController<PBSwipeControllerDelegate>
`
**Initialize a UIPageViewController in your implementation file
We Initialize this at first as we need to add this PageController in cell later**
```
UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
navigationController = [[PBSwipeController alloc]initWithRootViewController:pageController];
    navigationController.swipeDelegate = self;
    [self addChildViewController:navigationController];
    [navigationController didMoveToParentViewController:self];
```
 
 We add custom view in section header as we need to keep the scrollable tabs stick on screen
 Add a custom view in your Table Section Header
 
 ```
 UIView* customView = [[UIView alloc] init];
    if(section == 1){
        [customView addSubview:[navigationController addInitialObjects]];
    }
    [customView setAutoresizingMask:UIViewAutoresizingNone];
    customView.userInteractionEnabled = YES;
```
    
### Now Update height of the cell as per the content size of array in heightForRowAtIndexPath method
    
```
NSArray *array = [dataArray objectAtIndex:self.currentPageIndex];
float cellHeight = array.count * 44;
```
        
### Add PBSwipeController view into cell in cellForRowAtIndexPath method and pass the array**

```
navigationController.pagesNameArray = HeadingArray;
navigationController.pageDataArray = dataArray;
[navigationController viewControllerAtIndex:0];
[cell1.contentView addSubview:navigationController.view];
```
        
### Implement delegate method for Scroll view animation 
        
```
-(void)swipeAtIndex:(int)index{
    self.currentPageIndex = index;
    [self animateTableHeader];
}
```
### Method to update the section header

```
-(void)animateTableHeader{
    [self.mytableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.mytableView endUpdates];
}
```






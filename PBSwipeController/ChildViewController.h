//
//  ChildViewController.h
//  PBSwipeController
//
//  Created by Pankaj Bhardwaj on 07/03/17.
//  Copyright © 2017 Pankaj Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tableview;
}
-(void)reloadData:(NSArray*)array;
@property NSUInteger pageIndex;
-(void)scrollEnable;
-(void)scrollDisable;
@end

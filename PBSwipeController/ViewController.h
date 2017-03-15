//
//  ViewController.h
//  PBSwipeController
//
//  Created by Pankaj Bhardwaj on 07/03/17.
//  Copyright © 2017 Pankaj Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PBSwipeController.h"

@interface ViewController : UIViewController<PBSwipeControllerDelegate>
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) IBOutlet UITableView *mytableView;

@end

//
//  FilterViewController.h
//  Yelp
//
//  Created by Stephani Alves on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterOptions.h"

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FilterOptions *filterOptions;

@end

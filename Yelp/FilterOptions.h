//
//  FilterOptions.h
//  Yelp
//
//  Created by Stephani Alves on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterOptions : NSObject

@property int price;
@property (strong, nonatomic) NSMutableArray *category;
@property (strong, nonatomic) NSString *sortBy;
@property (strong, nonatomic) NSString *distance;
@property BOOL *deals;

@end

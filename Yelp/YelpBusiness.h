//
//  YelpBusiness.h
//  Yelp
//
//  Created by Stephani Alves on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpBusiness : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *location; //street + city
@property (strong,nonatomic) NSNumber *rating;
@property (strong,nonatomic) NSNumber *reviewCount;
@property (strong,nonatomic) NSString *categories;
@property (strong,nonatomic) NSString *posterURL;
@property (strong,nonatomic) NSString *ratingImageURL;

- (id)initWithDictionary: (NSDictionary *)dictionary;
+ (NSArray *)yelpWithArray: (NSArray *)array;
@end

//
//  YelpBusiness.m
//  Yelp
//
//  Created by Stephani Alves on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpBusiness.h"

@implementation YelpBusiness

- (id)initWithDictionary: (NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        
        //create location = address + city
        NSMutableString *loc = [NSMutableString string];
        if ([dictionary[@"location"][@"address"] count]>0) {
            [loc appendString: dictionary[@"location"][@"address"][0]];
            [loc appendString: @", "];
            [loc appendString: dictionary[@"location"][@"city"]];
            self.location =  [NSString stringWithString:loc];
        }else{
            self.location = dictionary[@"location"][@"city"];
        }
        
        
        
        self.name = dictionary[@"name"];
        self.rating = dictionary[@"rating"];
        self.reviewCount = dictionary[@"review_count"];
        self.posterURL = dictionary[@"image_url"];
        self.ratingImageURL = dictionary[@"rating_img_url_large"];
        self.categories = dictionary[@"categories"];
    }
    
    return self;
}

+ (NSArray *)yelpWithArray: (NSArray *)array {
    NSMutableArray *bizes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array){
        YelpBusiness *business = [[YelpBusiness alloc] initWithDictionary:dictionary];
        [bizes addObject:business];
    }
    
    return bizes;
}
@end

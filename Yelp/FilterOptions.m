//
//  FilterOptions.m
//  Yelp
//
//  Created by Stephani Alves on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterOptions.h"

@implementation FilterOptions
- (instancetype)init{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [self initWithSavedFilters:defaults];
}

-(id)initWithSavedFilters: (NSUserDefaults *)defaults{
    
    if (self = [super init]) {
        //price
        int priceControlIndex = [defaults integerForKey:@"price_control_index"];
        if(!priceControlIndex){
            self.price = 0; //lowest price
        }else{
            self.price = priceControlIndex;
        }
        NSLog(@"init filters called, priceControlIndex is: %d", self.price);
        
        //category
        NSMutableArray *cat = [[defaults arrayForKey:@"category"] mutableCopy];
        if(cat == nil){
            self.category = [[NSMutableArray alloc] init];
        }else{
            self.category = cat;
        }
        NSLog(@"init filters called, categories is: %@", [defaults arrayForKey:@"category"]);
        
        //sort by
        NSString *sort = [defaults stringForKey:@"sort"];
        if (!sort){
            self.sortBy = @"Best Match";
        }else{
            self.sortBy = sort;
        }
        NSLog(@"sort set on init: %@", self.sortBy);
        
        //distance
        NSString *dist = [defaults stringForKey:@"distance"];
        if (!dist){
            self.distance = @"Auto";
        }else{
            self.distance = dist;
        }
        NSLog(@"distance set on init: %@", self.distance);
        
        //deals
        BOOL d = [defaults boolForKey:@"deals"];
        if(!d){
            self.deals = NO;
        }else{
            self.deals = &(d);
        }
    }
    return self;
}
@end

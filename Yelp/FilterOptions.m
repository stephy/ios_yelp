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
       // NSLog(@"init filters called, priceControlIndex is: %d", self.price);
        
        //category
        NSMutableArray *cat = [[defaults arrayForKey:@"category"] mutableCopy];
        if(cat == nil){
            self.category = [[NSMutableArray alloc] init];
        }else{
            self.category = cat;
        }
        //NSLog(@"init filters called, categories is: %@", [defaults arrayForKey:@"category"]);
        
        //sort by
        NSString *sort = [defaults stringForKey:@"sort"];
        if (!sort){
            self.sortBy = @"Best Match";
        }else{
            self.sortBy = sort;
        }
       // NSLog(@"sort set on init: %@", self.sortBy);
        
        //distance
        NSString *dist = [defaults stringForKey:@"distance"];
        if (!dist){
            self.distance = @"Auto";
        }else{
            self.distance = dist;
        }
       // NSLog(@"distance set on init: %@", self.distance);
        
        //deals
        BOOL d = [defaults boolForKey:@"deals"];
        if(!d){
            self.deals = NO;
        }else{
            self.deals = &(d);
        }
        
        
        //set dictionaries
        self.categoryCodes = @{
                              @"Active Life" : @"active",
                              @"Arts & Entertainment" : @"arts",
                              @"Automotive" : @"auto",
                              @"Beauty & Spas" : @"beautysvc",
                              @"Education" : @"education",
                              @"Event Planning & Services" : @"eventservices",
                              @"Financial Services" : @"financialservices",
                              @"Food" : @"food",
                              @"Health & Medical" : @"health",
                              @"Home Services" : @"homeservices",
                              @"Hotels & Travel" : @"hotelstravel",
                              @"Local Flavor" : @"localflavor",
                              @"Local Services" : @"localservices",
                              @"Mass Media" : @"massmedia",
                              @"Nightlife" : @"nightlife",
                              @"Pets" : @"pets",
                              @"Professional Services" : @"professional",
                              @"Public Services & Government" : @"publicservicesgovt",
                              @"Real Estate" : @"realestate",
                              @"Religious Organizations" : @"religiousorgs",
                              @"Restaurants" : @"restaurants",
                              @"Shopping" : @"shopping"
                              };
        self.distanceConversions = @{@"Auto": @"4000", @"0.5 miles" : @"804", @"1 mile":@"1609", @"5 miles":@"8046"};
        self.sortCodes = @{ @"Best Match": @"0", @"Distance": @"1", @"Highest Rated": @"2" };
    }
    return self;
}
@end

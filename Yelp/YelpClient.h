//
//  YelpClient.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface YelpClient : BDBOAuth1RequestOperationManager

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
             accessSecret:(NSString *)accessSecret;

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                                      sort:(NSString *)sort
                                  category:(NSString *)category
                                    radius:(NSString *)radius
                                     deals:(NSString *)deals
                                   success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

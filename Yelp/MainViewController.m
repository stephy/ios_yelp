//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "FilterViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "YelpClient.h"
#import "YelpCell.h"
#import "YelpBusiness.h"


NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

int const SEARCHBAR_HEIGHT = 40;
int const SEARCHBAR_WIDTH = 230;
int const BUTTON_HEIGHT = 40;
int const BUTTON_WIDTH = 70;

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *filterButton;
@property (strong, nonatomic) NSArray *yelpResults;

@property BOOL *isFiltered;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isFiltered = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *mainColor = [UIColor colorWithRed:0.212 green:0.212 blue:0.192 alpha:1]; /*#363631*/
    //creating search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, SEARCHBAR_WIDTH, SEARCHBAR_HEIGHT)];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    
    //creating button for filter
    self.filterButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 0.0, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [self.filterButton setBackgroundColor:mainColor];
    
    //adding action to button
    [self.filterButton addTarget:self action:@selector(onFiltersButton) forControlEvents:UIControlEventTouchDown];
    
    //creating a view
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, SEARCHBAR_HEIGHT)];
    
    //adding search bar and button to view
    [searchBarView addSubview:self.searchBar];
    [searchBarView addSubview:self.filterButton];
    
    
    self.navigationItem.titleView = searchBarView;
    
    //load personalized cell
    //registration process
    [self.tableView registerNib:[UINib nibWithNibName:@"YelpCell" bundle:nil] forCellReuseIdentifier:@"YelpCell"];
    //set row height
    self.tableView.rowHeight = 120;
    
    //change navigation controller color
    self.navigationController.navigationBar.barTintColor = mainColor;
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods
//number of rows
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of rows you want in this table view
    return self.yelpResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"table view indexpath.row = %d", indexPath.row);
    YelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpCell"];
    
    YelpBusiness *b = [self.yelpResults objectAtIndex:indexPath.row];

    cell.nameLabel.text = b.name;
    cell.locationLabel.text = b.location;
    cell.categoriesLabel.text = [b.categories[0] componentsJoinedByString:@", "];
    [cell.reviewCountLabel setText:[NSString stringWithFormat:@"%@ Reviews", b.reviewCount]];
    
    //poster image
    NSString *posterUrlThumbnail = b.posterURL;
    //Asynchronously load the image
    [cell.poster setImageWithURL:[NSURL URLWithString:posterUrlThumbnail]];
    
    //rating image
    NSString *ratingURL = b.ratingImageURL;
    //Asynchronously load the image
    [cell.ratingPoster setImageWithURL:[NSURL URLWithString:ratingURL]];
    
    return cell;
}

- (void)searchWithTerm:(NSString *)term
                  sort:(NSString *)sort
              category:(NSString *)category
                radius:(NSString *)radius
                 deals:(NSString *)deals{
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    [self.client searchWithTerm:term sort:sort category:category radius:radius deals:deals
                        success:^(AFHTTPRequestOperation *operation, id response) {
        
        self.yelpResults = [YelpBusiness yelpWithArray:[response objectForKey:@"businesses"]];
                            NSLog(@"response: %@", response);
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)onFiltersButton {
    FilterViewController *fvc =[[FilterViewController alloc] init];
    fvc.filterOptions= self.filterOptions;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    //get filter options
    NSMutableArray *catCodes = [[NSMutableArray alloc] init];
    for (NSString *s in self.filterOptions.category) {
        NSString *code = [self.filterOptions.categoryCodes objectForKey:s];
        [catCodes addObject:code];
    }
    NSString *category = [catCodes componentsJoinedByString:@","];
    NSString *deals = self.filterOptions.deals ? @"true" : @"false";
    NSString *sort = [self.filterOptions.sortCodes objectForKey: self.filterOptions.sortBy];
    NSString *distance = [self.filterOptions.distanceConversions objectForKey: self.filterOptions.distance];
    [self searchWithTerm:searchBar.text sort:sort category:category radius:distance deals:deals];
}

- (void)viewWillAppear:(BOOL)animated {
    //load default settings
    self.filterOptions = [[FilterOptions alloc] init];
}

#pragma Mark Helper Functions
- (NSString *)getSubstring:(NSString *)value betweenString:(NSString *)separator{
    NSRange firstInstance = [value rangeOfString:separator];
    NSRange secondInstance = [[value substringFromIndex:firstInstance.location + firstInstance.length] rangeOfString:separator];
    NSRange finalRange = NSMakeRange(firstInstance.location + separator.length, secondInstance.location);
    
    return [value substringWithRange:finalRange];
}
@end

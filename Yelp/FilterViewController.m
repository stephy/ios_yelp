//
//  FilterViewController.m
//  Yelp
//
//  Created by Stephani Alves on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "MostPopularCell.h"
#import "AccordionCell.h"
#import "PriceCell.h"

int const CATEGORIES_ROW_AMOUNT = 3;
int const SECTION_PRICE = 0;
int const SECTION_CATEGORY = 1;
int const SECTION_SORT = 2;
int const SECTION_DISTANCE = 3;
int const SECTION_DEALS = 4;
int const TOTAL_SECTIONS = 5;

@interface FilterViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *mostPopularArray;
@property (strong, nonatomic) NSArray *sortBy;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *distance;
@property (strong, nonatomic) NSDictionary *categoryKeys;
@property BOOL *showAllCategories;
@property BOOL *actionCell;
@property (nonatomic, retain) NSIndexPath *checkedIndexPath;
@property (nonatomic, retain) NSIndexPath *checkedSortIndexPath;
@property (nonatomic, retain) NSIndexPath *checkedDistanceIndexPath;
@property (strong, nonatomic) NSMutableArray *categoriesFilter;
@property (strong, nonatomic) NSString *distanceFilter;
@property (strong, nonatomic) NSString *sortByFilter;


@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mostPopularArray = @[ @"Open Now", @"Hot & New", @"Offering a deal", @"Delivery" ];
        self.sortBy = @[ @"Best Match", @"Distance", @"Highest Rated" ];
        self.distance = @[ @"Auto", @"0.5 miles", @"1 mile", @"5 miles"];
        [self setTopLevelCategories];
        self.showAllCategories = NO;
        self.actionCell = NO;
        self.categoriesFilter = [[NSMutableArray alloc] init];

    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //load personalized cell
    //registration process
    [self.tableView registerNib:[UINib nibWithNibName:@"PriceCell" bundle:nil] forCellReuseIdentifier:@"PriceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MostPopularCell" bundle:nil] forCellReuseIdentifier:@"MostPopularCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccordionCell" bundle:nil] forCellReuseIdentifier:@"AccordionCell"];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section == SECTION_PRICE){
        return @"Price";
    }
    if (section == SECTION_CATEGORY){
        return @"Categories";
    }
    if (section == SECTION_SORT){
        return @"Sort By";
    }
    if (section == SECTION_DISTANCE){
        return @"Distance";
    }
    if (section == SECTION_DEALS){
        return @"Deals";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //price,  deals
    if (section == SECTION_PRICE || section == SECTION_DEALS) {
        return 1;
    }
    //categories
    if (section == SECTION_CATEGORY) {
        if (!self.showAllCategories){
            return CATEGORIES_ROW_AMOUNT+1; //3 categories + show all row
        }else{
           return ([self.categories count]);//all categories + show less row
        }
    }
    //sort by
    if (section == SECTION_SORT) {
        return [self.sortBy count];
    }
    
    //distance
    if (section == SECTION_DISTANCE) {
        return [self.distance count];
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return TOTAL_SECTIONS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    UITableViewCell *cell;
    //price
    if (indexPath.section == SECTION_PRICE) {
        PriceCell *priceCell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
        priceCell.priceControl.selectedSegmentIndex = self.filterOptions.price;
        [priceCell.priceControl addTarget:self action:@selector(setPriceFilter:) forControlEvents:UIControlEventValueChanged];
        cell = priceCell;
    }
    
    //categories
    if(indexPath.section == SECTION_CATEGORY){
        AccordionCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"AccordionCell"];
        
        if (!self.showAllCategories){
            if (indexPath.row == (CATEGORIES_ROW_AMOUNT)) {
                //show more option on the 4th row
                categoryCell.rowLabel.text = @"Show more ...";
            }else{
                categoryCell.rowLabel.text = self.categories[indexPath.row];
            }
        }else{
            NSLog(@"indexpath.row %d, catcount: %d", indexPath.row, ([self.categories count]-1));
            if (indexPath.row == ([self.categories count]-1)) {
               //show less option on the last row
                categoryCell.rowLabel.text = @"Show Less ...";
            }else{
                categoryCell.rowLabel.text = self.categories[indexPath.row];
            }
            
        }
        cell = categoryCell;
        
        if([self isCategorySavedInFilteredSettings:self.categories[indexPath.row]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    //sort by
    if(indexPath.section == SECTION_SORT){
        AccordionCell *sortByCell = [tableView dequeueReusableCellWithIdentifier:@"AccordionCell"];
        sortByCell.rowLabel.text = self.sortBy[indexPath.row];
        cell = sortByCell;
        NSLog(@"default sort: %@,%@", self.filterOptions.sortBy, self.sortBy[indexPath.row]);
        
        if([self.filterOptions.sortBy isEqualToString:self.sortBy[indexPath.row]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSLog(@"equal");
            self.checkedSortIndexPath = indexPath;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    //distance
    if(indexPath.section == SECTION_DISTANCE){
        AccordionCell *distanceCell = [tableView dequeueReusableCellWithIdentifier:@"AccordionCell"];
        distanceCell.rowLabel.text = self.distance[indexPath.row];
        cell = distanceCell;
        NSLog(@"default distance: %@,%@", self.filterOptions.distance, self.distance[indexPath.row]);

        if([self.filterOptions.distance isEqualToString:self.distance[indexPath.row]]){
            NSLog(@"equal");
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.checkedDistanceIndexPath = indexPath;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    //deals
    if(indexPath.section == SECTION_DEALS){
        MostPopularCell *dealsCell = [tableView dequeueReusableCellWithIdentifier:@"MostPopularCell"];
        [dealsCell.switchControl setOn: self.filterOptions.deals animated:YES];
        [dealsCell.switchControl addTarget:self action:@selector(dealsSwitchToggled:) forControlEvents:UIControlEventValueChanged];
        dealsCell.cellLabel.text = @"Deals";
        cell = dealsCell;
    }
    
    return cell;
}

-(void) setTopLevelCategories{
     self.categoryKeys = @{
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
    
    NSMutableArray *topLevelCategoriesArray = [[NSMutableArray alloc] init];
    //create an array with categories to display on the table view
    for (id key in [self.categoryKeys allKeys]) {
        [topLevelCategoriesArray addObject:key];
    }
    
    //categories sorted by alphabetical order
    self.categories = [[topLevelCategoriesArray copy] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     *  Categories Section
     *  Selecting and deselecting rows
     *  Saving filter setttings
     */
    
    
    if (indexPath.section == SECTION_CATEGORY) {
        //allow to expand categories section
        if (!self.showAllCategories && indexPath.row == CATEGORIES_ROW_AMOUNT) {
            self.actionCell = YES; //using has clicked to show more
            [self showMoreCategories];
        }
        //allow to contract categories section
        else if (self.showAllCategories && indexPath.row == ([self.categories count]-1)) {
            self.actionCell = YES;
            [self showLessCategories];
            //clear any checkmarks from show more button
            //TODO
        }else{
            self.actionCell = NO;
        }

        //if user is not clicking on show more or show less
        //allow user to check cells
        if (!self.actionCell) {
            NSLog(@"Did I get here?");
            //allow users to uncheck the cell
            //don't remove checkmark from previous cells
            if ([self.checkedIndexPath isEqual:indexPath] && [self isInArray:self.categoriesFilter item:self.categories[indexPath.row]]){
                UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
                uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                //remove from filter and save settings
                [self removeItemFromArray:self.categoriesFilter item:self.categories[indexPath.row]];
                NSLog(@"cell checked,");
                
            }

            if ([self.checkedIndexPath isEqual:indexPath]){
                //allow the user to check the cell again right after the user has unchecked the cell
                self.checkedIndexPath = nil;
                [self removeItemFromArray:self.categoriesFilter item:self.categories[indexPath.row]];

            } else {
                NSLog(@"am I here?");
                UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                //saving to filter
                if (![self.categoriesFilter containsObject:self.categories[indexPath.row]])
                    [self.categoriesFilter addObject:self.categories[indexPath.row]];
                //[self.categoriesFilter addObject:self.categories[indexPath.row]];
                self.checkedIndexPath = indexPath;
            }
        }
        
        NSLog(@"Category filter: %@", self.categoriesFilter);
    }
    
    /*
     *  SortBy Section
     *  Selecting and deselecting rows
     *  Saving filter setttings
     */
    
    if (indexPath.section == SECTION_SORT) {
        
        // Uncheck the previous checked row
        if(self.checkedSortIndexPath){
            UITableViewCell* uncheckCell = [tableView
                                            cellForRowAtIndexPath:self.checkedSortIndexPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self setSortByFilter:self.sortBy[indexPath.row]];
        self.checkedSortIndexPath = indexPath;

    }
    
    /*
     *  Distance Section
     *  Selecting and deselecting rows
     *  Saving filter setttings
     */
    
    if (indexPath.section == SECTION_DISTANCE) {
        // Uncheck the previous checked row
        if(self.checkedDistanceIndexPath){
            UITableViewCell* uncheckCell = [tableView
                                            cellForRowAtIndexPath:self.checkedDistanceIndexPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }

        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self setDistanceFilter:self.distance[indexPath.row]];
        self.checkedDistanceIndexPath = indexPath;
    }
}


-(void)showMoreCategories {

   self.showAllCategories = YES;
    
    /* Animate the table view reload */
    [UIView transitionWithView: self.tableView
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [self.tableView reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
         /* TODO: Whatever you want here */
         
     }];

}

-(void)showLessCategories {
    self.showAllCategories = NO;
    
    /* Animate the table view reload */
    [UIView transitionWithView: self.tableView
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [self.tableView reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
         /* TODO: Whatever you want here */
         
     }];
}


#pragma mark Managing Arrays

- (BOOL)isInArray:(NSMutableArray *)array item:(NSString *)item {
    BOOL checked = NO;
    for (NSString *d in array) {
        if( d == item){
            checked = YES;
        }
    }
    NSLog(@"checked? %d", checked);
    return checked;
    
}

- (void)removeItemFromArray:(NSMutableArray *)array item:(NSString *)item {
    id itemToRemove;
    for (NSString *s in array) {
        if (s == item){
            //remove item from array
            NSLog(@"Found!, removing %@", item);
            itemToRemove = s;
            break;
        }
    }
    [array removeObject:itemToRemove];
}
#pragma mark Saving Defaults

- (void)saveFilterSettingArray: (NSArray *)array withKey: (NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:key];
    [defaults synchronize];
}

- (void)saveFilterSettingObject: (id)obj withKey: (NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

- (void)saveFilterSettingInteger:(int)i withKey: (NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:i forKey:key];
    [defaults synchronize];
}

- (void)saveFilterSettingBOOL: (BOOL)b  withKey: (NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:b forKey:key];
    [defaults synchronize];
}

#pragma mark Setting Filters

- (void)dealsSwitchToggled:(id)sender {
    UISwitch *theSwitch = (UISwitch *)sender;
    if(theSwitch.on) {
        // switch turned on
        [self saveFilterSettingBOOL:YES withKey:@"deals"];
        self.filterOptions.deals = YES;
    }
    else {
        // switch turned off
        [self saveFilterSettingBOOL:NO withKey:@"deals"];
        self.filterOptions.deals = NO;
    }
}

- (void)setPriceFilter:(id)sender {
    UISegmentedControl *controlSegment = (UISegmentedControl *)sender;
    [self saveFilterSettingInteger:controlSegment.selectedSegmentIndex withKey:@"price_control_index"];
    self.filterOptions.price = controlSegment.selectedSegmentIndex;
}

- (void)setSortByFilter:(id)sender{
    [self saveFilterSettingObject:sender withKey:@"sort"];
    NSLog(@"sender sort: %@", sender);
    self.filterOptions.sortBy = sender;
    
}

- (void)setDistanceFilter:(id)sender{
    [self saveFilterSettingObject:sender withKey:@"distance"];
    NSLog(@"sender distance: %@", sender);
    self.filterOptions.distance = sender;
}

- (void)setCategoryFilter{
    NSArray *array = [self.categoriesFilter copy];
    NSLog(@"setting category filter array: %@", array);
    [self saveFilterSettingArray:array withKey:@"category"];
    self.filterOptions.category = [self.categoriesFilter copy];
}

- (BOOL)isCategorySavedInFilteredSettings: (NSString *)category{
    //load saved defaults
    for (NSString *cat in self.filterOptions.category){
        if (cat == category){
            return YES;
        }
    }
    
    return NO;
}

#pragma Mark View
- (void)viewWillAppear:(BOOL)animated {
    
    //load saved defaults
    self.filterOptions = [[FilterOptions alloc] init];
    //self.categoriesFilter = [[NSMutableArray alloc] init];
    self.categoriesFilter = self.filterOptions.category;

}

- (void)viewWillDisappear:(BOOL)animated {
    //saving tip default
    [self setCategoryFilter];
}




@end

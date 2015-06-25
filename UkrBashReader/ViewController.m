//
//  ViewController.m
//  UkrBashReader
//
//  Created by Admin on 29.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

//
//  APPMasterViewController.m
//  RSSreader
//
//  Created by Rafael Garcia Leiva on 08/04/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "ViewController.h"
@interface ViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *quote;
    NSMutableString *text;
    NSMutableString *author;
    NSMutableString *pubDate;
    NSMutableString *rating;
    NSString *element;
}
@end

@implementation ViewController
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Published";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.6 green:0.8 blue:0.8 alpha:0.4];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor]};
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://api.ukrbash.org/1/quotes.getTheBest.xml?client=8fca3e61502a0ec2"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString*) unixToString: (double) date {
    double unixTimeStamp = date;
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [formatter stringFromDate:myDate];
    return dateString;
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    double unixTimeStamp =[[[feeds objectAtIndex:indexPath.row] objectForKey: @"pub_date"]doubleValue];
    NSString *dateString = [self unixToString:unixTimeStamp];
    cell.userText.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"text"];
    cell.userAuthor.text = [[[[feeds objectAtIndex:indexPath.row] objectForKey: @"author"]stringByAppendingString:@" | " ]stringByAppendingString:dateString];
    cell.userRating.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"rating"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        NSString * tweetTextString = [[feeds objectAtIndex:indexPath.row] objectForKey: @"text"] ;
        CGSize textSize = [tweetTextString sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-60, 20000) lineBreakMode: NSLineBreakByWordWrapping];
        return textSize.height + 150;
    }
    NSString * tweetTextString = [[feeds objectAtIndex:indexPath.row] objectForKey: @"text"] ;
    CGSize textSize = [tweetTextString sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-80, 20000) lineBreakMode: NSLineBreakByWordWrapping];
    return textSize.height + 170;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"quote"]) {
        
        quote    = [[NSMutableDictionary alloc] init];
        text   = [[NSMutableString alloc] init];
        author   = [[NSMutableString alloc] init];
        pubDate    = [[NSMutableString alloc] init];
        rating   = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"quote"]) {
        
        [quote setObject:text forKey:@"text"];
        [quote setObject:author forKey:@"author"];
        [quote setObject:pubDate forKey:@"pub_date"];
        [quote setObject:rating forKey:@"rating"];
        
        [feeds addObject:[quote copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"text"]) {
        [text appendString:string];
    } else if ([element isEqualToString:@"author"]) {
        [author appendString:string];
    }
    else if ([element isEqualToString:@"pub_date"]) {
        [pubDate appendString:string];
    }
    else if ([element isEqualToString:@"rating"]) {
        [rating appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
}

@end

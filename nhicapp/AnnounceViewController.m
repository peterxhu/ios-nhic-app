//
//  AnnounceViewController.m
//  nhicapp
//
//  Created by Mark John Merin on 10/9/14.
//  Copyright (c) 2014 Apps4Christ. All rights reserved.
//

#import "AnnounceViewController.h"
#import "AnnounceDetailViewController.h"
#import "Reachability.h"

@interface AnnounceViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation AnnounceViewController

-(void)loadAnnounceData{
    // Do any additional setup after loading the view.
    feeds = [[NSMutableArray alloc] init];
    NSLog(@"trying to load webpage");
    NSURL *url = [NSURL URLWithString: @"http://www.newhic.org/feed/rss"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    NSLog(@"resulting count is: %d", (int)feeds.count);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    self.screenName = @"Announcements";
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"Announcements", nil), nil];
    
    //Display an activity indicator while loading the RSS feed
    self.indicator.center = CGPointMake(self.view.center.x, self.view.center.y-64);
    [self.view addSubview:self.indicator];
    
    if(networkStatus != NotReachable){
        [self.indicator startAnimating];
        [self performSelector:@selector(loadAnnounceData)withObject:nil afterDelay:0];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"table view count is: %d", (int)feeds.count);
    return feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    NSLog(@"Starting Announcement parser");
    
    if([element isEqualToString:@"item"]) {
        
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"found characters");
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    }else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        
        [feeds addObject:[item copy]];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
    [self.indicator stopAnimating];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"showAnnounceDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
        
        NSLog(@"announce view link is: %@", string);
        [[segue destinationViewController] setUrl:string];
    }
}


@end

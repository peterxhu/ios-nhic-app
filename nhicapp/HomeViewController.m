//
//  HomeViewController.m
//  nhicapp
//
//  Created by Mark John Merin on 10/9/14.
//  Copyright (c) 2014 Apps4Christ. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeDetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSArray *homeAbout;
    NSArray *links;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"Home";
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"Home", nil), nil];

    
    homeAbout = [NSArray arrayWithObjects: NSLocalizedString(@"Our Vision", nil),
                 NSLocalizedString(@"Statement of Faith", nil),
                 NSLocalizedString(@"Core Values", nil), nil];
    
    
    
    links = [NSArray arrayWithObjects:@"http://www.newhic.org/about/our-vision/",
             @"http://www.newhic.org/about/statement-of-faith/", @"http://www.newhic.org/about/core-values/", nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        return YES;
    
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    
    return UIInterfaceOrientationMaskPortrait;
}

//Debug routine that lets me see the size classes. 
-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
             withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"Trait collection = %@", newCollection);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberofSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return homeAbout.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollEnabled = NO;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [homeAbout objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *string;
    
    if ([[segue identifier] isEqualToString:@"showHomeDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        string = links[indexPath.row];
        
        NSLog(@"home detail view link is: %@", string);
        [[segue destinationViewController] setUrl:string];
    }
}
 



@end

//
//  FeedbackViewController.m
//  Feedback
//
//  Created by Cyril CHANDELIER on 12/20/13.
//  Copyright (c) 2013 Cyril Chandelier. All rights reserved.
//

#import "FeedbackViewController.h"




@interface FeedbackViewController ()

// Outlets
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// Actions
@property (nonatomic, strong) NSArray *actions;

@end




@implementation FeedbackViewController

#pragma mark - Constructor
- (id)init
{
    if (self = [super initWithNibName:@"FeedbackViewController" bundle:nil])
    {
        // Title
        self.title = NSLocalizedString(@"Leave Feedback", @"Leave Feedback");
        
        // Binding
        [self addObserver:self forKeyPath:@"userFeeling" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Refresh UI
    [self refreshUI];
}

- (void)refreshUI
{
    // Build actions
    [self buildActions];
    
    // Reload table view
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FeedbackCell";
    
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure text
    cell.textLabel.text = [[_actions objectAtIndex:indexPath.row] objectForKey:@"title"];
}

#pragma mark - Utils
- (void)buildActions
{
    NSMutableArray *actions = [NSMutableArray array];
    
    // Review
    if (_userFeeling == UserFeelingHappy)
        [actions addObject:@{
                             @"title" : NSLocalizedString(@"Write a review", @"Feedback actions")
                             }];
    
    // Getting started
    if (_userFeeling == UserFeelingConfused)
        [actions addObject:@{
                             @"title" : NSLocalizedString(@"Getting Started Guide", @"Feedback actions")
                             }];
    
    // Email
    [actions addObject:@{
                         @"title" : NSLocalizedString(@"Contact our team", @"Feedback actions")
                         }];
    
    // Hold actions
    self.actions = actions;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userFeeling"])
    {
        [self refreshUI];
    }
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"userFeeling"];
}

@end

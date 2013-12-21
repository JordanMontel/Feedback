//
//  FeedbackViewController.m
//  Feedback
//
//  Created by Cyril CHANDELIER on 12/20/13.
//  Copyright (c) 2013 Cyril Chandelier. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackActionItem.h"




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
    // Action item
    FeedbackActionItem *actionItem = [_actions objectAtIndex:indexPath.row];
    
    // Configure text
    cell.textLabel.text = actionItem.title;
    cell.imageView.image = actionItem.image;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Action item
    FeedbackActionItem *actionItem = [_actions objectAtIndex:indexPath.row];
    
    // Execute action
    [actionItem executeAction];
}

#pragma mark - Utils
- (void)buildActions
{
    NSMutableArray *actions = [NSMutableArray array];
    
    // Review
    if (_userFeeling == UserFeelingHappy)
        [actions addObject:[FeedbackActionItem actionItemWithTitle:NSLocalizedString(@"Write a review", @"Feedback actions")
                                                             image:nil
                                                            action:^{
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello world!"
                                                                                                                message:@"..."
                                                                                                               delegate:nil
                                                                                                      cancelButtonTitle:@"OK"
                                                                                                      otherButtonTitles:nil];
                                                                [alert show];
                                                            }]];
    
    // Getting started
    if (_userFeeling == UserFeelingConfused)
        [actions addObject:[FeedbackActionItem actionItemWithTitle:NSLocalizedString(@"Getting Started Guide", @"Feedback actions")
                                                             image:nil
                                                            action:^{
                                                                // TODO
                                                            }]];
    
    // Email
    [actions addObject:[FeedbackActionItem actionItemWithTitle:NSLocalizedString(@"Contact our team", @"Feedback actions")
                                                         image:nil
                                                        action:^{
                                                            // TODO
                                                        }]];
    
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

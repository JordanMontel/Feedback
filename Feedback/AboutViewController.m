//
//  AboutViewController.m
//  Feedback
//
//  Created by Cyril CHANDELIER on 12/20/13.
//  Copyright (c) 2013 Cyril Chandelier. All rights reserved.
//

#import "AboutViewController.h"
#import "FeedbackViewController.h"

@interface AboutViewController ()

// View controllers
@property (nonatomic, strong) FeedbackViewController *feedbackViewController;

@end

@implementation AboutViewController

#pragma mark - Constructor
- (id)init
{
    if (self = [super initWithNibName:@"AboutViewController" bundle:nil])
    {
        // Title
        self.title = NSLocalizedString(@"About", @"About");
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AboutCell";
    
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
    cell.textLabel.text = NSLocalizedString(@"Leave Feedback", @"Leave Feedback");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Display action sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"How do you feel about the app?", @"User feeling question")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Happy", @"How does the user feel about the app"), NSLocalizedString(@"Confused", @"How does the user feel about the app"), NSLocalizedString(@"Unhappy", @"How does the user feel about the app"), nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Lazy loading
    if (!_feedbackViewController)
        [self configureFeedbackViewController];
    
    // Configure according to selected feeling
    switch (buttonIndex)
    {
        case 2:
            _feedbackViewController.userFeeling = UserFeelingUnhappy;
            break;
            
        case 1:
            _feedbackViewController.userFeeling = UserFeelingConfused;
            break;
            
        case 0:
        default:
            _feedbackViewController.userFeeling = UserFeelingHappy;
            break;
    }
    
    // Push view controller
    [self.navigationController pushViewController:_feedbackViewController animated:YES];
}

#pragma mark - Configuration
- (void)configureFeedbackViewController
{
    // Create a feedback view controller
    _feedbackViewController = [[FeedbackViewController alloc] init];

    // Apply configuration
    _feedbackViewController.appId = _appId;
    _feedbackViewController.contactEmail = _contactEmail;
    _feedbackViewController.gettingStartedGuideBlock = _gettingStartedGuideBlock;
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Release view controllers
    self.feedbackViewController = nil;
}

@end

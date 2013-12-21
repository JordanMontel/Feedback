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
    // Deselect
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Action item
    FeedbackActionItem *actionItem = [_actions objectAtIndex:indexPath.row];
    
    // Execute action
    [actionItem executeAction];
}

#pragma mark - Actions
- (void)openInAppStore
{
    // Build URL
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", self.appId];
    NSURL *urlToOpen = [NSURL URLWithString:urlString];
    
    // Open url
    [[UIApplication sharedApplication] openURL:urlToOpen];
}

- (void)composeEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        // Configure email composer
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        [controller setToRecipients:@[ self.contactEmail ]];
        [controller setMessageBody:[self messageContent] isHTML:NO];
        
        // Present email composer
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Alert view")
                                                        message:NSLocalizedString(@"An error occured while opening email composer", @"Alert view")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil] ;
        [alert show];
    }
}

#pragma mark - Utils
- (void)buildActions
{
    NSMutableArray *actions = [NSMutableArray array];
    
    // Weak self
    __weak FeedbackViewController *weakSelf = self;
    
    // Review
    if (_userFeeling == UserFeelingHappy && _appId)
        [actions addObject:[FeedbackActionItem actionItemWithTitle:NSLocalizedString(@"Write a review", @"Feedback actions")
                                                             image:nil
                                                            action:^{
                                                                // Open app store
                                                                [self openInAppStore];
                                                            }]];
    
    // Getting started
    if (_userFeeling == UserFeelingConfused && _gettingStartedGuideBlock)
        [actions addObject:[FeedbackActionItem actionItemWithTitle:NSLocalizedString(@"Getting Started Guide", @"Feedback actions")
                                                             image:nil
                                                            action:_gettingStartedGuideBlock]];
    
    // Email
    if ((_userFeeling == UserFeelingHappy || _userFeeling == UserFeelingConfused || _userFeeling == UserFeelingUnhappy) && [_contactEmail length])
    [actions addObject:[FeedbackActionItem actionItemWithTitle:NSLocalizedString(@"Contact our team", @"Feedback actions")
                                                         image:nil
                                                        action:^{
                                                            // Compose a pre-configured email
                                                            [weakSelf composeEmail];
                                                        }]];
    
    // Hold actions
    self.actions = actions;
}

- (NSString *)messageContent
{
    NSMutableString *content = [NSMutableString string];
    
    // Find out informations
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *osName = [[UIDevice currentDevice] systemName];
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    
    // App version
    [content appendFormat:@"%@ %@", NSLocalizedString(@"App version:", @"Email content"), appShortVersion];
    if ([appVersion length])
        [content appendFormat:@" (%@)", appVersion];
    
    // Breath
    [content appendString:@"\n"];
    
    // Device
    if ([deviceName length])
        [content appendFormat:@"%@ %@", NSLocalizedString(@"Device:", @"Email content"), deviceName];
    
    // Breath
    [content appendString:@"\n"];
    
    // OS name
    if ([osName length])
        [content appendFormat:@"%@ %@", NSLocalizedString(@"Operating system:", @"Email content"), osName];
    
    // Breath
    [content appendString:@"\n"];
    
    // OS version
    if ([osVersion length])
        [content appendFormat:@"%@ %@", NSLocalizedString(@"OS version:", @"Email content"), osVersion];
    
    return content;
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // Dismiss email composer
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userFeeling"])
    {
        // Refresh UI
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

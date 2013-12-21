//
//  GettingStartedGuideViewController.m
//  Feedback
//
//  Created by Cyril CHANDELIER on 12/22/13.
//  Copyright (c) 2013 Cyril Chandelier. All rights reserved.
//

#import "GettingStartedGuideViewController.h"

@interface GettingStartedGuideViewController ()

@end

@implementation GettingStartedGuideViewController

#pragma mark - Constructor
- (id)init
{
    if (self = [super initWithNibName:@"GettingStartedGuideViewController" bundle:nil])
    {
        // Title
        self.title = NSLocalizedString(@"Getting Started", @"Getting Started Guide");
    }
    
    return self;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

//
//  FeedbackViewController.h
//  Feedback
//
//  Created by Cyril CHANDELIER on 12/20/13.
//  Copyright (c) 2013 Cyril Chandelier. All rights reserved.
//

#import <MessageUI/MessageUI.h>

typedef enum {
    UserFeelingHappy = 0,
    UserFeelingConfused,
    UserFeelingUnhappy
} UserFeeling;

@interface FeedbackViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

// Feedback feeling
@property (nonatomic, readwrite) UserFeeling userFeeling;

@end

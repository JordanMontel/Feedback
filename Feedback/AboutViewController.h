//
//  AboutViewController.h
//  Feedback
//
//  Created by Cyril CHANDELIER on 12/20/13.
//  Copyright (c) 2013 Cyril Chandelier. All rights reserved.
//

@interface AboutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

// Configuration
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *contactEmail;
@property (nonatomic, strong) void(^gettingStartedGuideBlock)(void);

@end

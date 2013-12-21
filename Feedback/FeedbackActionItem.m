//
//  FeedbackActionItem.m
//  Feedback
//
//  Created by Cyril CHANDELIER on 12/21/13.
//  Copyright (c) 2013 Cyril Chandelier. All rights reserved.
//

#import "FeedbackActionItem.h"

@interface FeedbackActionItem ()

// Held parameters
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) void(^action)(void);

@end

@implementation FeedbackActionItem

#pragma mark - Constructor
+ (FeedbackActionItem *)actionItemWithTitle:(NSString *)title image:(UIImage *)image action:(void (^)(void))action
{
    return [[self alloc] initWithTitle:title image:image action:action];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image action:(void (^)(void))action
{
    if (self = [super init])
    {
        // Hold parameters
        _title = title;
        _image = image;
        _action = action;
    }
    
    return self;
}

#pragma mark - Action
- (void)executeAction
{
    if (_action)
        _action();
}

@end

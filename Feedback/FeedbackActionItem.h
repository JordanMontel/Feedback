//
//  FeedbackActionItem.h
//  Feedback
//
//  Created by Cyril CHANDELIER on 12/21/13.
//  Copyright (c) 2013 Cyril Chandelier. All rights reserved.
//

@interface FeedbackActionItem : NSObject

+ (FeedbackActionItem *)actionItemWithTitle:(NSString *)title image:(UIImage *)image action:(void (^)(void))action;

// Constructor
- (id)initWithTitle:(NSString *)title image:(UIImage *)image action:(void (^)(void))action;

// Execute held action
- (void)executeAction;

// Held elements
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) void(^action)(void);

@end

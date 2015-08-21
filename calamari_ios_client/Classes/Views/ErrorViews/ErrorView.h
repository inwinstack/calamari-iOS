//
//  ErrorView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ErrorDelegate <NSObject>

@required
- (void) didConfirm;

@end

@interface ErrorView : UIView

@property (nonatomic, weak) id <ErrorDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame title:(NSString*)title message:(NSString*)message;

@end

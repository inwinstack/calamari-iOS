//
//  OSDHeaderView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/19.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DidReceiveButtonDelegate <NSObject>

@required
- (void) didReceviButton:(UIButton*)button;

@end

@interface OSDHeaderView : UIView

@property (nonatomic, weak) id <DidReceiveButtonDelegate> delegate;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *warnButton;
@property (nonatomic, strong) UIButton *errorButton;

- (void) didSelectButton:(UIButton*)button;
- (void) setCurrentButton:(NSInteger)buttonTag;

@end

//
//  ClusterHealthCellBar.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/15.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClusterHealthCellBar : UIView

@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *warningTextLabel;
@property (nonatomic, strong) UILabel *errorTextLabel;

- (void) setWarningValue:(NSString*)value;
- (void) setErrorValue:(NSString*)value;

@end

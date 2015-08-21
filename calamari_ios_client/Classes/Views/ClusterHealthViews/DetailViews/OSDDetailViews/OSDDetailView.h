//
//  OSDDetailView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSDDetailView : UIView

@property (nonatomic, strong) UILabel *hostNameValueLabel;
@property (nonatomic, strong) UILabel *publicValueLabel;
@property (nonatomic, strong) UILabel *clusterValueLabel;
@property (nonatomic, strong) UILabel *poolValueLabel;
@property (nonatomic, strong) UILabel *reWeightValueLabel;
@property (nonatomic, strong) UILabel *uuidValueLabel;

- (void) setPoolLabelsArray:(NSArray*)labelArray;

@end

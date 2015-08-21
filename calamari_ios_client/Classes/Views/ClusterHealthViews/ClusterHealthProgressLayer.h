//
//  ClusterHealthProgressLayer.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/12.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClusterHealthProgressLayer : UIView

@property (nonatomic, strong) CAShapeLayer *progressLayer;

- (void) setProgressValue:(int)value;

@end

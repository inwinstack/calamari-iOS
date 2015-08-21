//
//  CPUIOPSView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/7/8.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPUIOPSView : UIView

@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *midYLabel;
@property (nonatomic, strong) NSString *tempMidString;

- (void) setDataWithDataArray:(NSMutableArray*)dataArray;

@end

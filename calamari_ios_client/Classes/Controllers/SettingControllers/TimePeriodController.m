//
//  TimePeriodController.m
//  calamari_ios_client
//
//  Created by Francis on 2015/10/13.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "TimePeriodController.h"
#import "TimePeriodView.h"
#import "SettingViewCell.h"
#import "SelectionViewCell.h"
#import "SettingViewFlowLayout.h"
#import "ClockSettingView.h"
#import "UIColor+Reader.h"

@interface TimePeriodController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TimePeriodView *timePeriodView;
@property (nonatomic, strong) SettingViewFlowLayout *flowLayout;
@property (nonatomic, strong) ClockSettingView *clockSettingView;
@property (nonatomic, strong) UIPanGestureRecognizer *clockPanGesture;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) NSArray *testArray;
@property (nonatomic) CGPoint tempHourPoint;
@property (nonatomic) CGPoint tempMinutePoint;
@property (nonatomic) CGPoint tempSecondPoint;
@property (nonatomic, strong) NSArray *timePointArray;
@property (nonatomic) BOOL gestureEnable;

@end

@implementation TimePeriodController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.title = @"Time Period";
    self.flowLayout = [[SettingViewFlowLayout alloc] init];
    self.timePeriodView = [[TimePeriodView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    self.view = self.timePeriodView;
    self.timePeriodView.delegate = self;
    self.timePeriodView.dataSource = self;
    
    [self.timePeriodView registerClass:[SettingViewCell class] forCellWithReuseIdentifier:@"TimePeriodViewCellIdentifier"];
    
    self.clockPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clockAction:)];
    self.testArray = @[@"請按我", @"請按我", @"請按我"];
    self.timePointArray = @[@"145, 135.5", @"223.5,182", @"221.4,271.5", @"145, 314.5", @"67,269", @"68.3,178.9"];
    self.gestureEnable = NO;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectionViewCell *alertTriggerSelectionCell  = [tableView dequeueReusableCellWithIdentifier:@"TimePeriodSelectionViewCellIdentifier"];
    if (!alertTriggerSelectionCell) {
        alertTriggerSelectionCell = [[SelectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimePeriodSelectionViewCellIdentifier"];
    }
    alertTriggerSelectionCell.checkBoxButton.hidden = YES;
    alertTriggerSelectionCell.districtLineView.frame = CGRectMake(alertTriggerSelectionCell.districtLineView.frame.origin.x, 73, alertTriggerSelectionCell.districtLineView.frame.size.width, alertTriggerSelectionCell.districtLineView.frame.size.height);
    alertTriggerSelectionCell.mainLabel.text = self.testArray[indexPath.row];
    return alertTriggerSelectionCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.view.window.subviews indexOfObject:self.clockSettingView] > self.view.window.subviews.count) {
        self.clockSettingView = [[ClockSettingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.clockSettingView.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.hourButton addTarget:self action:@selector(hourAction) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.minuteButton addTarget:self action:@selector(minuteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.secondButton addTarget:self action:@selector(secondAction) forControlEvents:UIControlEventTouchUpInside];
        self.tempLabel = self.clockSettingView.minuteLabel;
        [self.view.window addSubview:self.clockSettingView];
        [self.clockSettingView addGestureRecognizer:self.clockPanGesture];
        
        self.tempHourPoint = CGPointMake(145, 135.5);
        self.tempMinutePoint = CGPointMake(145, 135.5);
        self.tempSecondPoint = CGPointMake(145, 314.5);

        [self.clockSettingView.zeroButton addTarget:self action:@selector(timeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.tenButton addTarget:self action:@selector(timeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.twentyButton addTarget:self action:@selector(timeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.thirtyButton addTarget:self action:@selector(timeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.fortyButton addTarget:self action:@selector(timeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.fiftyButton addTarget:self action:@selector(timeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];

        self.tempLabel = self.clockSettingView.minuteLabel;
    }
}

- (void) hourAction {
    if (self.tempLabel == self.clockSettingView.minuteLabel) {
        self.tempMinutePoint = self.clockSettingView.circleView.center;
    } else if (self.tempLabel == self.clockSettingView.secondLabel) {
        self.tempSecondPoint = self.clockSettingView.circleView.center;
    }
    self.tempLabel.textColor = [UIColor blackColor];

    self.clockSettingView.hourLabel.textColor = [UIColor oceanNavigationBarColor];
    self.clockSettingView.selectedCircleView.frame = CGRectMake(CGRectGetMidX(self.clockSettingView.hourButton.frame) - 15, CGRectGetMidY(self.clockSettingView.hourButton.frame) - 15, 30, 30);
    
    CGMutablePathRef trianglePath = CGPathCreateMutable();
    CGPathMoveToPoint(trianglePath, nil, CGRectGetMidX(self.clockSettingView.hourButton.frame), CGRectGetMaxY(self.clockSettingView.hourButton.frame) + 8);
    CGPathAddLineToPoint(trianglePath, nil, CGRectGetMaxX(self.clockSettingView.hourButton.frame) - 10, CGRectGetMaxY(self.clockSettingView.hourButton.frame) + 13);
    CGPathAddLineToPoint(trianglePath, nil, CGRectGetMinX(self.clockSettingView.hourButton.frame) + 10, CGRectGetMaxY(self.clockSettingView.hourButton.frame) + 13);
    CGPathCloseSubpath(trianglePath);
    
    self.clockSettingView.selectedTriangleLayer.path = trianglePath;
    CGPathRelease(trianglePath);
    
    self.tempLabel = self.clockSettingView.hourLabel;
    
    [self.clockSettingView.zeroButton setTitle:@"00" forState:UIControlStateNormal];
    [self.clockSettingView.tenButton setTitle:@"04" forState:UIControlStateNormal];
    [self.clockSettingView.twentyButton setTitle:@"08" forState:UIControlStateNormal];
    [self.clockSettingView.thirtyButton setTitle:@"12" forState:UIControlStateNormal];
    [self.clockSettingView.fortyButton setTitle:@"16" forState:UIControlStateNormal];
    [self.clockSettingView.fiftyButton setTitle:@"20" forState:UIControlStateNormal];
    
    self.clockSettingView.circleView.center = self.tempHourPoint;
}

- (void) minuteAction {
    if (self.tempLabel == self.clockSettingView.hourLabel) {
        self.tempHourPoint = self.clockSettingView.circleView.center;
    } else if (self.tempLabel == self.clockSettingView.secondLabel) {
        self.tempSecondPoint = self.clockSettingView.circleView.center;
    }
    self.tempLabel.textColor = [UIColor blackColor];
    
    self.clockSettingView.minuteLabel.textColor = [UIColor oceanNavigationBarColor];
    
    self.clockSettingView.selectedCircleView.frame = CGRectMake(CGRectGetMidX(self.clockSettingView.minuteButton.frame) - 15, CGRectGetMidY(self.clockSettingView.minuteButton.frame) - 15, 30, 30);
    
    CGMutablePathRef trianglePath = CGPathCreateMutable();
    CGPathMoveToPoint(trianglePath, nil, CGRectGetMidX(self.clockSettingView.minuteButton.frame), CGRectGetMaxY(self.clockSettingView.minuteButton.frame) + 8);
    CGPathAddLineToPoint(trianglePath, nil, CGRectGetMaxX(self.clockSettingView.minuteButton.frame) - 10, CGRectGetMaxY(self.clockSettingView.minuteButton.frame) + 13);
    CGPathAddLineToPoint(trianglePath, nil, CGRectGetMinX(self.clockSettingView.minuteButton.frame) + 10, CGRectGetMaxY(self.clockSettingView.minuteButton.frame) + 13);
    CGPathCloseSubpath(trianglePath);
    
    self.clockSettingView.selectedTriangleLayer.path = trianglePath;
    CGPathRelease(trianglePath);
    self.tempLabel = self.clockSettingView.minuteLabel;

    [self.clockSettingView.zeroButton setTitle:@"00" forState:UIControlStateNormal];
    [self.clockSettingView.tenButton setTitle:@"10" forState:UIControlStateNormal];
    [self.clockSettingView.twentyButton setTitle:@"20" forState:UIControlStateNormal];
    [self.clockSettingView.thirtyButton setTitle:@"30" forState:UIControlStateNormal];
    [self.clockSettingView.fortyButton setTitle:@"40" forState:UIControlStateNormal];
    [self.clockSettingView.fiftyButton setTitle:@"50" forState:UIControlStateNormal];
    
    self.clockSettingView.circleView.center = self.tempMinutePoint;
}

- (void) secondAction {
    if (self.tempLabel == self.clockSettingView.hourLabel) {
        self.tempHourPoint = self.clockSettingView.circleView.center;
    } else if (self.tempLabel == self.clockSettingView.minuteLabel) {
        self.tempMinutePoint = self.clockSettingView.circleView.center;
    }
    self.tempLabel.textColor = [UIColor blackColor];
    
    self.clockSettingView.secondLabel.textColor = [UIColor oceanNavigationBarColor];
    self.clockSettingView.selectedCircleView.frame = CGRectMake(CGRectGetMidX(self.clockSettingView.secondButton.frame) - 15, CGRectGetMidY(self.clockSettingView.secondButton.frame) - 15, 30, 30);
    
    CGMutablePathRef trianglePath = CGPathCreateMutable();
    CGPathMoveToPoint(trianglePath, nil, CGRectGetMidX(self.clockSettingView.secondButton.frame), CGRectGetMaxY(self.clockSettingView.secondButton.frame) + 8);
    CGPathAddLineToPoint(trianglePath, nil, CGRectGetMaxX(self.clockSettingView.secondButton.frame) - 10, CGRectGetMaxY(self.clockSettingView.secondButton.frame) + 13);
    CGPathAddLineToPoint(trianglePath, nil, CGRectGetMinX(self.clockSettingView.secondButton.frame) + 10, CGRectGetMaxY(self.clockSettingView.secondButton.frame) + 13);
    CGPathCloseSubpath(trianglePath);
    
    self.clockSettingView.selectedTriangleLayer.path = trianglePath;
    CGPathRelease(trianglePath);
    self.tempLabel = self.clockSettingView.secondLabel;
    
    [self.clockSettingView.zeroButton setTitle:@"00" forState:UIControlStateNormal];
    [self.clockSettingView.tenButton setTitle:@"10" forState:UIControlStateNormal];
    [self.clockSettingView.twentyButton setTitle:@"20" forState:UIControlStateNormal];
    [self.clockSettingView.thirtyButton setTitle:@"30" forState:UIControlStateNormal];
    [self.clockSettingView.fortyButton setTitle:@"40" forState:UIControlStateNormal];
    [self.clockSettingView.fiftyButton setTitle:@"50" forState:UIControlStateNormal];
    
    self.clockSettingView.circleView.center = self.tempSecondPoint;
    

}

- (void) cancelAction {
    [self.clockSettingView removeFromSuperview];
}

- (void) saveAction {
    [self.clockSettingView removeFromSuperview];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimePeriodViewCellIdentifier" forIndexPath:indexPath];
    cell.selectionView.delegate = self;
    cell.selectionView.dataSource = self;
    cell.settingNameLabel.frame = CGRectMake(0, 0, 0, 0);
    CGRect tempFrame = cell.selectionView.frame;
    
    cell.selectionView.frame = CGRectMake(tempFrame.origin.x, 0, tempFrame.size.width, 222);
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 222);
}

- (void) clockAction:(UIPanGestureRecognizer*)panGesture {
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        float tempX = fabs([panGesture locationInView:self.clockSettingView].x - CGRectGetWidth(self.clockSettingView.frame) / 2.0);
        float tempY = fabs([panGesture locationInView:self.clockSettingView].y - CGRectGetHeight(self.clockSettingView.frame) / 2.0);
        float tempLength = sqrt((tempX * tempX + tempY * tempY));
        
        if (tempLength > 85.5 && tempLength < 95.5) {
            self.gestureEnable = YES;

        } else {
            self.gestureEnable = NO;

        }
    }
    float testA = fabs(([panGesture locationInView:self.clockSettingView].y - CGRectGetHeight(self.clockSettingView.frame) / 2.0) / ([panGesture locationInView:self.clockSettingView].x - CGRectGetWidth(self.clockSettingView.frame) / 2.0));
    if (self.gestureEnable) {
        if ([panGesture locationInView:self.clockSettingView].y > CGRectGetHeight(self.clockSettingView.frame) / 2.0) {
            if ([panGesture locationInView:self.clockSettingView].x > CGRectGetWidth(self.clockSettingView.frame) / 2.0) {
                self.clockSettingView.circleView.center = CGPointMake(145.0 + 89.5 * cos(atan(testA)), 225.0 + 89.5 * sin(atan(testA)));
                float doub = ([self.tempLabel isEqual:self.clockSettingView.hourLabel]) ? 6.0 : 15.0;
                int value = atan(testA) / (M_PI / 2) * doub + doub;
                self.tempLabel.text = (value < 10) ? [NSString stringWithFormat:@"0%d", value] : [NSString stringWithFormat:@"%d", value];
                
            } else {
                self.clockSettingView.circleView.center = CGPointMake(145.0 - 89.5 * cos(atan(testA)), 225.0 + 89.5 * sin(atan(testA)));
                float doub = ([self.tempLabel isEqual:self.clockSettingView.hourLabel]) ? 6.0 : 15.0;
                
                int value = doub * 3 - atan(testA) / (M_PI / 2) * doub;
                self.tempLabel.text = (value < 10) ? [NSString stringWithFormat:@"0%d", value] : [NSString stringWithFormat:@"%d", value];

            }
        } else {
            if ([panGesture locationInView:self.clockSettingView].x > CGRectGetWidth(self.clockSettingView.frame) / 2.0) {
                self.clockSettingView.circleView.center = CGPointMake(145.0 + 89.5 * cos(atan(testA)), 225.0 - 89.5 * sin(atan(testA)));
                float doub = ([self.tempLabel isEqual:self.clockSettingView.hourLabel]) ? 6.0 : 15.0;
                
                int value = doub - atan(testA) / (M_PI / 2) * doub;
                self.tempLabel.text = (value < 10) ? [NSString stringWithFormat:@"0%d", value] : [NSString stringWithFormat:@"%d", value];
                

            } else {
                self.clockSettingView.circleView.center = CGPointMake(145.0 - 89.5 * cos(atan(testA)), 225.0 - 89.5 * sin(atan(testA)));
                float doub = ([self.tempLabel isEqual:self.clockSettingView.hourLabel]) ? 6.0 : 15.0;
                int value = atan(testA) / (M_PI / 2) * doub + doub * 3;
                if (value == 60) {
                    self.tempLabel.text = @"00";
                } else {
                    self.tempLabel.text = (value < 10) ? [NSString stringWithFormat:@"0%d", value] : [NSString stringWithFormat:@"%d", value];
                }
            }
        }

    }
}

- (void) timeButtonClickAction:(UIButton*)timeButton {
    self.tempLabel.text = timeButton.titleLabel.text;
    NSString *pointString = self.timePointArray[timeButton.tag];
    NSRange districtRange = [pointString rangeOfString:@","];
    float pointX = [[pointString substringToIndex:districtRange.location] floatValue];
    float pointY = [[pointString substringFromIndex:districtRange.location + districtRange.length] floatValue];
    self.clockSettingView.circleView.center = CGPointMake(pointX, pointY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

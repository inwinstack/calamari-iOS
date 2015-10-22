//
//  UsageStatusView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "UsageStatusView.h"
#import "UIColor+Reader.h"
#import "DateMaker.h"
#import "UIView+SizeMaker.h"
#import "LocalizationManager.h"

@interface UsageStatusView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *availableLabel;
@property (nonatomic, strong) UILabel *usedLabel;
@property (nonatomic, strong) CAShapeLayer *xLayer;
@property (nonatomic, strong) CAShapeLayer *yLayer;
@property (nonatomic, strong) CAShapeLayer *xTagLayer;
@property (nonatomic, strong) CAShapeLayer *firstTag;
@property (nonatomic, strong) CAShapeLayer *secondTag;
@property (nonatomic, strong) CAShapeLayer *thirdTag;
@property (nonatomic, strong) CAShapeLayer *fourthTag;
@property (nonatomic, strong) CAShapeLayer *fifthTag;
@property (nonatomic, strong) CAShapeLayer *sixthTag;
@property (nonatomic, strong) CAShapeLayer *availableLayer;
@property (nonatomic, strong) CAShapeLayer *usedLayer;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UILabel *fifthLabel;
@property (nonatomic, strong) UILabel *sixthLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) NSMutableArray *tagLayerArray;
@property (nonatomic, strong) NSMutableArray *tagLabelStringArray;
@property (nonatomic, strong) UIView *tempWhiteView;

@end

@implementation UsageStatusView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03, 5 + CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.94, 25)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        self.titleLabel.textColor = [UIColor normalBlackColor];
        self.titleLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"usage_status_disk_usage_statistics"];
        [self addSubview:self.titleLabel];
        
        self.availableLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.04, CGRectGetMaxY(self.titleLabel.frame) + CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03, 80, 25)];
        self.availableLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.availableLabel.textColor = [UIColor okGreenColor];
        self.availableLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"usage_status_disk_usage_available"];
        [self addSubview:self.availableLabel];
        
        self.usedLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.availableLabel.frame), CGRectGetMinY(self.availableLabel.frame), 120, 25)];
        self.usedLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.usedLabel.textColor = [UIColor warningColor];
        self.usedLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"usage_status_disk_usage_used"];
        [self addSubview:self.usedLabel];
        
        self.tempWhiteView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.availableLabel.frame) / 3 - height * 15 / 255, CGRectGetMaxY(self.availableLabel.frame) + 10 * height / 255, CGRectGetWidth(self.frame) - (CGRectGetWidth(self.availableLabel.frame) / 3 - height * 30 / 255), CGRectGetMidY(self.frame) - CGRectGetMaxY(self.availableLabel.frame) + height * 15 / 255)];
        self.tempWhiteView.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self addSubview:self.tempWhiteView];
        
        self.xLayer = [CAShapeLayer layer];
        self.xLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.xLayer.frame = CGRectMake(CGRectGetWidth(self.availableLabel.frame) / 3 + 5 * height / 255, CGRectGetMidY(self.frame) + 10 * height / 255, CGRectGetWidth(self.frame) - CGRectGetWidth(self.availableLabel.frame) * 2 / 3, 1);
        [self.layer addSublayer:self.xLayer];
        
        self.yLayer = [CAShapeLayer layer];
        self.yLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.yLayer.frame = CGRectMake(CGRectGetMinX(self.xLayer.frame), CGRectGetMaxY(self.availableLabel.frame) + 10 * height / 255, 1, CGRectGetMinY(self.xLayer.frame) - CGRectGetMaxY(self.availableLabel.frame) - 10 * height / 255);
        [self.layer addSublayer:self.yLayer];
        
        self.xTagLayer = [CAShapeLayer layer];
        self.xTagLayer.strokeColor = [UIColor normalBlackColor].CGColor;
        self.xTagLayer.lineWidth = 0.5;
        
        float tempHeight = CGRectGetHeight(self.yLayer.frame) / 15.0;
        CGMutablePathRef tempXPath = CGPathCreateMutable();
        CGPathMoveToPoint(tempXPath, nil, CGRectGetMinX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 14);
        CGPathAddLineToPoint(tempXPath, nil, CGRectGetMaxX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 14);
        CGPathMoveToPoint(tempXPath, nil, CGRectGetMinX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 7);
        CGPathAddLineToPoint(tempXPath, nil, CGRectGetMaxX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 7);
        CGPathCloseSubpath(tempXPath);
        self.xTagLayer.path = tempXPath;
        CGPathRelease(tempXPath);
        [self.layer addSublayer:self.xTagLayer];
        
        self.maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMinY(self.xLayer.frame) - tempHeight * 14 - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        [self setDefaultYLabel:self.maxLabel];
        
        self.minLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMinY(self.xLayer.frame) - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        [self setDefaultYLabel:self.minLabel];
        
        self.midYLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255,  CGRectGetMinY(self.xLayer.frame) - tempHeight * 7 - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        [self setDefaultYLabel:self.midYLabel];
        
        self.tagLayerArray = [NSMutableArray array];
        self.firstTag = [CAShapeLayer layer];
        [self setTagLayer:self.firstTag];
        
        self.secondTag = [CAShapeLayer layer];
        [self setTagLayer:self.secondTag];
        
        self.thirdTag = [CAShapeLayer layer];
        [self setTagLayer:self.thirdTag];
        
        self.fourthTag = [CAShapeLayer layer];
        [self setTagLayer:self.fourthTag];
        
        self.fifthTag = [CAShapeLayer layer];
        [self setTagLayer:self.fifthTag];
        
        self.sixthTag = [CAShapeLayer layer];
        [self setTagLayer:self.sixthTag];
        
        self.availableLayer = [CAShapeLayer layer];
        self.availableLayer.strokeColor = [UIColor okGreenColor].CGColor;
        self.availableLayer.lineWidth = 0.5;
        self.availableLayer.fillColor = [UIColor okGreenShapelayerColor].CGColor;
        [self.layer addSublayer:self.availableLayer];
        
        self.usedLayer = [CAShapeLayer layer];
        self.usedLayer.strokeColor = [UIColor warningColor].CGColor;
        self.usedLayer.lineWidth = 0.5;
        self.usedLayer.fillColor = [UIColor warningShapelayerColor].CGColor;
        [self.layer addSublayer:self.usedLayer];
    }
    return self;
}


- (void) setTagLayer:(CAShapeLayer*)tagLayer {
    tagLayer.backgroundColor = [UIColor TagLineColor].CGColor;
    [self.layer addSublayer:tagLayer];
    [self.tagLayerArray addObject:tagLayer];
}

- (void) setTagLabel {
    float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    
    [self.firstLabel removeFromSuperview];
    [self.secondLabel removeFromSuperview];
    [self.thirdLabel removeFromSuperview];
    [self.fourthLabel removeFromSuperview];
    [self.fifthLabel removeFromSuperview];
    [self.sixthLabel removeFromSuperview];
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[0] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[0] frame]), height * 60 / 255, height * 15 / 255)];
    self.firstLabel.text = self.tagLabelStringArray[0];
    [self setTagLabel:self.firstLabel];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[1] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[1] frame]), height * 60 / 255, height * 15 / 255)];
    self.secondLabel.text = self.tagLabelStringArray[1];
    [self setTagLabel:self.secondLabel];
    
    self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[2] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[2] frame]), height * 60 / 255, height * 15 / 255)];
    self.thirdLabel.text = self.tagLabelStringArray[2];
    [self setTagLabel:self.thirdLabel];
    
    self.fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[3] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[3] frame]), height * 60 / 255, height * 15 / 255)];
    self.fourthLabel.text = self.tagLabelStringArray[3];
    [self setTagLabel:self.fourthLabel];
    
    self.fifthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[4] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[4] frame]), height * 60 / 255, height * 15 / 255)];
    self.fifthLabel.text = self.tagLabelStringArray[4];
    [self setTagLabel:self.fifthLabel];
    
    self.sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[5] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[5] frame]), height * 60 / 255, height * 15 / 255)];
    self.sixthLabel.text = self.tagLabelStringArray[5];
    [self setTagLabel:self.sixthLabel];
}

- (void) setTagLabel:(UILabel*)tagLabel {
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:tagLabel];
}

- (void) setDefaultYLabel:(UILabel*)yLabel {
    yLabel.textColor = [UIColor normalBlackColor];
    yLabel.font = [UIFont systemFontOfSize:10];
    yLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:yLabel];
}

- (void) setDataWithDataArray:(NSMutableArray*)dataArray {
    if (dataArray.count > 0) {
        float tempheight = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        
        self.tagLabelStringArray = [NSMutableArray array];
        CGMutablePathRef writePath = CGPathCreateMutable();
        CGMutablePathRef readPath = CGPathCreateMutable();
        
        float startX = CGRectGetMaxX(self.yLayer.frame);
        float startY = CGRectGetMinY(self.xLayer.frame);
        float height = CGRectGetMinY(self.xLayer.frame) - CGRectGetMidY(self.maxLabel.frame);
        float availableLocationY = startY;
        float usedLocationY = startY;

        int tempX = 0;
        int count = 0;
        
        CGPathMoveToPoint(writePath, nil, startX + (tempX * tempheight * 0.7 / 255), startY);
        
        CGPathMoveToPoint(readPath, nil, startX + (tempX * tempheight * 0.7 / 255), startY);
        
        for (id object in dataArray) {
            float x = startX + (tempX * tempheight * 0.7 / 255);
            float addX = startX + ((tempX + 1) * tempheight * 0.7 / 255);
            float y;
            float readY;
            if ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@":"].location] isEqualToString:@":00"]) {
                [self.tagLayerArray[count] setFrame:CGRectMake(x, CGRectGetMinY(self.yLayer.frame), tempheight * 0.5 / 255, height + CGRectGetMidY(self.maxLabel.frame) - CGRectGetMinY(self.yLayer.frame))];
                ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1] isEqualToString:@"00:00"]) ? [self.tagLabelStringArray addObject:[[DateMaker shareDateMaker] getDateWithDate:object[0]]] : [self.tagLabelStringArray addObject:[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1]];
                count++;
            }
            
            if ([object[2] isEqualToString:@"<null>"] || [object[2] isEqualToString:@"0"]) {
                readY = startY;
            } else {
                readY = CGRectGetMidY(self.maxLabel.frame) + height * (1 - [object[2] floatValue] / ([self.tempMidString floatValue] * 2));
            }
            if (isnan(readY) || isinf(readY)) {
                readY = startY;
            }
            usedLocationY = ([object[2] isEqualToString:@"<null>"]) ? usedLocationY : readY ;
            CGPathAddLineToPoint(readPath, nil, x, usedLocationY);
            CGPathAddLineToPoint(readPath, nil, addX, usedLocationY);
            
            if ([object[1] isEqualToString:@"<null>"] || [object[1] isEqualToString:@"0"]) {
                y = readY;
            } else {
                y = CGRectGetMidY(self.maxLabel.frame) + height * (1 - ([object[1] floatValue] + [object[2] floatValue]) / ([self.tempMidString floatValue] * 2));
            }
            if (isnan(y) || isinf(y)) {
                y = readY;
            }
            availableLocationY = ([object[1] isEqualToString:@"<null>"]) ? availableLocationY : y;
            CGPathAddLineToPoint(writePath, nil, x, availableLocationY);
            CGPathAddLineToPoint(writePath, nil, addX, availableLocationY);
            tempX++;
        }
        
        CGPathAddLineToPoint(writePath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        
        CGPathAddLineToPoint(readPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathCloseSubpath(writePath);
        CGPathCloseSubpath(readPath);
        
        self.usedLayer.path = readPath;
        self.availableLayer.path = writePath;
        CGPathRelease(writePath);
        CGPathRelease(readPath);
        
        [self setTagLabel];
        

    }
}

@end

//
//  IOPSChartView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/17.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "IOPSChartView.h"
#import "UIColor+Reader.h"
#import "DateMaker.h"
#import "AnimationMaker.h"
#import "LocalizationManager.h"

@interface IOPSChartView ()

@property (nonatomic, strong) NSMutableArray *tagLayerArray;
@property (nonatomic, strong) NSMutableArray *tagLabelStringArray;
@property (nonatomic, strong) UILabel *readWriteLabel;
@property (nonatomic, strong) UILabel *zeroLabel;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UILabel *fifthLabel;
@property (nonatomic, strong) UILabel *sixthLabel;
@property (nonatomic, strong) CAShapeLayer *chartBackground;
@property (nonatomic, strong) CAShapeLayer *yLayer;
@property (nonatomic, strong) CAShapeLayer *xLayer;
@property (nonatomic, strong) CAShapeLayer *middleLayer;
@property (nonatomic, strong) CAShapeLayer *chartLayer;
@property (nonatomic, strong) CAShapeLayer *firstTag;
@property (nonatomic, strong) CAShapeLayer *secondTag;
@property (nonatomic, strong) CAShapeLayer *thirdTag;
@property (nonatomic, strong) CAShapeLayer *fourthTag;
@property (nonatomic, strong) CAShapeLayer *fifthTag;
@property (nonatomic, strong) CAShapeLayer *sixthTag;

@end

@implementation IOPSChartView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        float height;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            height = ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2;
        } else {
            height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        }
        self.readWriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, height * 5 / 255, CGRectGetWidth(self.frame) - height * 5 / 255, height * 30 / 255)];
        self.readWriteLabel.text = [NSString stringWithFormat:@"   %@", [[LocalizationManager sharedLocalizationManager] getTextByKey:@"health_card_read_write"]];
        self.readWriteLabel.font = [UIFont systemFontOfSize:height * 14 / 255];
        self.readWriteLabel.textColor = [UIColor okGreenColor];
        [self addSubview:self.readWriteLabel];
        
        self.chartBackground = [CAShapeLayer layer];
        self.chartBackground.frame = CGRectMake(CGRectGetWidth(self.frame) * 0.05, CGRectGetMaxY(self.readWriteLabel.frame), CGRectGetWidth(self.frame) * 0.9, CGRectGetWidth(self.frame) * 0.45);
        self.chartBackground.backgroundColor = [UIColor oceanBackgroundThreeColor].CGColor;
        [self.layer addSublayer:self.chartBackground];
        
        self.yLayer = [CAShapeLayer layer];
        self.yLayer.frame = CGRectMake(CGRectGetMinX(self.chartBackground.frame) + height * 10 / 255, CGRectGetMaxY(self.readWriteLabel.frame) + height * 15 / 255, 1, CGRectGetHeight(self.chartBackground.frame) - height * 35 / 255);
        self.yLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        [self.layer addSublayer:self.yLayer];
        
        self.xLayer = [CAShapeLayer layer];
        self.xLayer.frame = CGRectMake(CGRectGetMinX(self.yLayer.frame), CGRectGetMaxY(self.yLayer.frame), CGRectGetWidth(self.chartBackground.frame) - height * 10 / 255, 1);
        self.xLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        [self.layer addSublayer:self.xLayer];
        
        self.middleLayer = [CAShapeLayer layer];
        self.middleLayer.frame = CGRectMake(CGRectGetMinX(self.yLayer.frame), CGRectGetMidY(self.yLayer.frame), CGRectGetWidth(self.chartBackground.frame) - height * 10 / 255, 1);
        self.middleLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.middleLayer.opacity = 0.5;
        [self.layer addSublayer:self.middleLayer];
        
        self.zeroLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 10 / 255, CGRectGetMaxY(self.yLayer.frame) - height * 5 / 255, height * 10 / 255, height * 10 / 255)];
        self.zeroLabel.font = [UIFont systemFontOfSize:height * 8 / 255];
        self.zeroLabel.text = @"0";
        self.zeroLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.zeroLabel];
        
        self.middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMidY(self.yLayer.frame) - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        self.middleLabel.font = [UIFont systemFontOfSize:height * 8 / 255];
        self.middleLabel.text = @"5";
        self.middleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.middleLabel];
        
        self.maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMinY(self.yLayer.frame) + height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        self.maxLabel.font = [UIFont systemFontOfSize:height * 8 / 255];
        self.maxLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.maxLabel];
        
        self.chartLayer = [CAShapeLayer layer];
        self.chartLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.chartLayer.lineWidth = 0.7;
        self.chartLayer.fillColor = [UIColor clearColor].CGColor;
        self.chartLayer.strokeColor = [UIColor okGreenColor].CGColor;
        [self.layer addSublayer:self.chartLayer];
        
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
        
    }
    return self;
}

- (void) setTagLayer:(CAShapeLayer*)tagLayer {
    tagLayer.backgroundColor = [UIColor TagLineColor].CGColor;
    [self.layer addSublayer:tagLayer];
    [self.tagLayerArray addObject:tagLayer];
}

- (void) setTagLabel {
    float height;
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        height = ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2;
    } else {
        height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    }
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
    float height;
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        height = ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2;
    } else {
        height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    }
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.font = [UIFont systemFontOfSize:height * 8 / 255];
    [self addSubview:tagLabel];
}

- (void) setDataWithDataArray:(NSMutableArray*)dataArray {
    if (dataArray.count > 0) {
        float tempheight;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            tempheight = ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2;
        } else {
            tempheight = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        }
        self.tagLabelStringArray = [NSMutableArray array];
        CGMutablePathRef chartPath = CGPathCreateMutable();
        float startX = CGRectGetMaxX(self.yLayer.frame);
        float startY = CGRectGetMinY(self.xLayer.frame);
        float height = CGRectGetMinY(self.xLayer.frame) - CGRectGetMinY(self.yLayer.frame);
        float IOPSY = startY;
        int tempX = 0;
        int count = 0;
        if ([dataArray[0][1] isEqualToString:@"<null>"] || [dataArray[0][1] isEqualToString:@"0"]) {
            CGPathMoveToPoint(chartPath, nil, startX, startY);
        } else {
            CGPathMoveToPoint(chartPath, nil, startX, CGRectGetMinY(self.yLayer.frame) + height * (1 - [dataArray[0][1] floatValue] / ([self.middleLabel.text floatValue] * 2)));
        }        for (id object in dataArray) {
            float x = startX + (tempX * tempheight * 0.7 / 255);
            float y;
            if ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@":"].location] isEqualToString:@":00"]) {
                [self.tagLayerArray[count] setFrame:CGRectMake(x, CGRectGetMinY(self.yLayer.frame), tempheight * 0.8 / 255, height)];
                ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1] isEqualToString:@"00:00"]) ? [self.tagLabelStringArray addObject:[[DateMaker shareDateMaker] getDateWithDate:object[0]]] : [self.tagLabelStringArray addObject:[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1]];
                count++;
            }
            if ([object[1] isEqualToString:@""] || [object[1] isEqualToString:@"0"]) {
                y = startY;
            } else {
                y = CGRectGetMinY(self.yLayer.frame) + height * (1 - [object[1] floatValue] / ([self.middleLabel.text floatValue] * 2));
            }
            if (isnan(y) || isinf(y)) {
                y = startY;
            }
            IOPSY = (([object[1] isEqualToString:@"<null>"])) ? IOPSY : y;
            CGPathAddLineToPoint(chartPath, nil, x, IOPSY);
            tempX++;
        }
        self.chartLayer.path = chartPath;
        [[AnimationMaker shareInstance] animationByShapeLayer:self.chartLayer duration:2.0];
        CGPathRelease(chartPath);
        [self setTagLabel];
        
    }
}

@end

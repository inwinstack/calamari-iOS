//
//  CPUIOPSView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/8.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "CPUIOPSView.h"
#import "UIColor+Reader.h"
#import "DateMaker.h"
#import "UIView+SizeMaker.h"

@interface CPUIOPSView ()

@property (nonatomic, strong) UILabel *iopsLabel;
@property (nonatomic, strong) CAShapeLayer *xLayer;
@property (nonatomic, strong) CAShapeLayer *yLayer;
@property (nonatomic, strong) CAShapeLayer *xTagLayer;
@property (nonatomic, strong) CAShapeLayer *firstTag;
@property (nonatomic, strong) CAShapeLayer *secondTag;
@property (nonatomic, strong) CAShapeLayer *thirdTag;
@property (nonatomic, strong) CAShapeLayer *fourthTag;
@property (nonatomic, strong) CAShapeLayer *fifthTag;
@property (nonatomic, strong) CAShapeLayer *sixthTag;
@property (nonatomic, strong) CAShapeLayer *iopsLayer;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UILabel *fifthLabel;
@property (nonatomic, strong) UILabel *sixthLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) NSMutableArray *tagLayerArray;
@property (nonatomic, strong) NSMutableArray *tagLabelStringArray;
@property (nonatomic, strong) UIView *backgroundWhiteView;

@end

@implementation CPUIOPSView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        
        self.iopsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.04, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03, 0, height * 25 / 255)];
        self.iopsLabel.textColor = [UIColor okGreenColor];
        self.iopsLabel.text = @"-IOPS";
        self.iopsLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        [self.iopsLabel sizeToFit];
        [self addSubview:self.iopsLabel];
        
        self.backgroundWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iopsLabel.frame) + 10 * height / 255, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.iopsLabel.frame) - height * 15 / 255)];
        self.backgroundWhiteView.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self addSubview:self.backgroundWhiteView];
        
        self.xLayer = [CAShapeLayer layer];
        self.xLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.xLayer.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.04, CGRectGetMidY(self.frame) + height * 35 / 255, CGRectGetWidth(self.frame) - CGRectGetWidth([UIScreen mainScreen].bounds) * 0.08, 1);
        [self.layer addSublayer:self.xLayer];
        
        self.yLayer = [CAShapeLayer layer];
        self.yLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.yLayer.frame = CGRectMake(CGRectGetMinX(self.xLayer.frame), CGRectGetMaxY(self.iopsLabel.frame) + 10 * height / 255, 1, CGRectGetMinY(self.xLayer.frame) - CGRectGetMaxY(self.iopsLabel.frame) - 10 * height / 255);
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
        
        self.iopsLayer = [CAShapeLayer layer];
        self.iopsLayer.strokeColor = [UIColor okGreenColor].CGColor;
        self.iopsLayer.lineWidth = 1.0;
        self.iopsLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.iopsLayer];
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
        CGMutablePathRef iopsPath = CGPathCreateMutable();
        
        float startX = CGRectGetMaxX(self.yLayer.frame);
        float startY = CGRectGetMinY(self.xLayer.frame);
        float height = CGRectGetMinY(self.xLayer.frame) - CGRectGetMidY(self.maxLabel.frame);
        float IOPSY = startY;
        int tempX = 0;
        int count = 0;
        
        if ([dataArray[0][1] isEqualToString:@"<null>"] || [dataArray[0][1] isEqualToString:@"0"]) {
            CGPathMoveToPoint(iopsPath, nil, startX, startY);
        } else {
            CGPathMoveToPoint(iopsPath, nil, startX, CGRectGetMidY(self.maxLabel.frame) + height * (1 - [dataArray[0][1] floatValue] / ([self.tempMidString floatValue] * 2)));
        }

        for (id object in dataArray) {
            float x = startX + (tempX * tempheight * 0.7 / 255);
            float y;
            if ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@":"].location] isEqualToString:@":00"]) {
                [self.tagLayerArray[count] setFrame:CGRectMake(x, CGRectGetMinY(self.yLayer.frame), tempheight * 0.5 / 255, height + CGRectGetMidY(self.maxLabel.frame) - CGRectGetMinY(self.yLayer.frame))];
                ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1] isEqualToString:@"00:00"]) ? [self.tagLabelStringArray addObject:[[DateMaker shareDateMaker] getDateWithDate:object[0]]] : [self.tagLabelStringArray addObject:[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1]];
                count++;
            }
            
            if ([object[1] isEqualToString:@"<null>"] || [object[1] isEqualToString:@"0"]) {
                y = startY;
            } else {
                y = CGRectGetMidY(self.maxLabel.frame) + height * (1 - [object[1] floatValue] / ([self.tempMidString floatValue] * 2));
            }
            if (isnan(y) || isinf(y)) {
                y = startY;
            }
            IOPSY = (([object[1] isEqualToString:@"<null>"])) ? IOPSY : y;
            CGPathAddLineToPoint(iopsPath, nil, x, IOPSY);
            tempX++;
        }
        
        self.iopsLayer.path = iopsPath;
        CGPathRelease(iopsPath);
        
        [self setTagLabel];
    }
}

@end

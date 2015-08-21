//
//  IOPSDetailChartView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "IOPSDetailChartView.h"
#import "UIColor+Reader.h"
#import "DateMaker.h"

@interface IOPSDetailChartView()

@property (nonatomic, strong) CAShapeLayer *xLayer;
@property (nonatomic, strong) CAShapeLayer *yLayer;
@property (nonatomic, strong) CAShapeLayer *xTagLayer;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *IOPSLabel;
@property (nonatomic, strong) CAShapeLayer *readLayer;
@property (nonatomic, strong) CAShapeLayer *writeLayer;
@property (nonatomic, strong) NSMutableArray *tagLayerArray;
@property (nonatomic, strong) NSMutableArray *tagLabelStringArray;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UILabel *fifthLabel;
@property (nonatomic, strong) UILabel *sixthLabel;
@property (nonatomic, strong) CAShapeLayer *firstTag;
@property (nonatomic, strong) CAShapeLayer *secondTag;
@property (nonatomic, strong) CAShapeLayer *thirdTag;
@property (nonatomic, strong) CAShapeLayer *fourthTag;
@property (nonatomic, strong) CAShapeLayer *fifthTag;
@property (nonatomic, strong) CAShapeLayer *sixthTag;

@end

@implementation IOPSDetailChartView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;

        self.xLayer = [CAShapeLayer layer];
        self.xLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.xLayer.frame = CGRectMake(25, CGRectGetHeight(self.frame) - 26, CGRectGetWidth(self.frame) - 25, 1);
        [self.layer addSublayer:self.xLayer];
        
        self.yLayer = [CAShapeLayer layer];
        self.yLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.yLayer.frame = CGRectMake(25, 0, 1, CGRectGetHeight(self.frame) - 25);
        [self.layer addSublayer:self.yLayer];
        
        self.xTagLayer = [CAShapeLayer layer];
        self.xTagLayer.strokeColor = [UIColor normalBlackColor].CGColor;
        self.xTagLayer.lineWidth = 0.5;
        
        float tempHeight = CGRectGetHeight(self.yLayer.frame) / 13.0;
        CGMutablePathRef tempXPath = CGPathCreateMutable();
        for (int i = 0; i < 6; i++) {
            if (i == 2 || i ==5) {
                CGPathMoveToPoint(tempXPath, nil, CGRectGetMinX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 2 * (i + 1));
                CGPathAddLineToPoint(tempXPath, nil, CGRectGetMaxX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 2 * (i + 1));
            }
        }
        CGPathCloseSubpath(tempXPath);
        self.xTagLayer.path = tempXPath;
        [self.layer addSublayer:self.xTagLayer];
        
        CGPathRelease(tempXPath);
        
        self.maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMinY(self.xLayer.frame) - tempHeight * 12 - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        self.maxLabel.text = @"2000";
        [self setDefaultYLabel:self.maxLabel];
        
        self.midYLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMinY(self.xLayer.frame) - tempHeight * 6 - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        self.midYLabel.text = @"1000";
        [self setDefaultYLabel:self.midYLabel];
        
        self.minLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMinY(self.xLayer.frame) - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        self.minLabel.text = @"0";
        [self setDefaultYLabel:self.minLabel];
        
        self.readLayer = [CAShapeLayer layer];
        self.readLayer.strokeColor = [UIColor okGreenColor].CGColor;
        self.readLayer.lineWidth = 0.5;
        self.readLayer.fillColor = [UIColor okGreenShapelayerColor].CGColor;
        [self.layer addSublayer:self.readLayer];
        
        self.writeLayer = [CAShapeLayer layer];
        self.writeLayer.strokeColor = [UIColor warningColor].CGColor;
        self.writeLayer.lineWidth = 0.5;
        self.writeLayer.fillColor = [UIColor warningShapelayerColor].CGColor;
        [self.layer addSublayer:self.writeLayer];
        
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
        int tempX = 0;
        int count = 0;
        float writeLocationY = startY;
        float readLocationY = startY;
        
        CGPathMoveToPoint(writePath, nil, startX + (tempX * tempheight * 0.7 / 255), startY);

        CGPathMoveToPoint(readPath, nil, startX + (tempX * tempheight * 0.7 / 255), startY);

        for (id object in dataArray) {
            float x = startX + (tempX * tempheight * 0.7 / 255);
            float y;
            float readY;
            if ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@":"].location] isEqualToString:@":00"]) {
                [self.tagLayerArray[count] setFrame:CGRectMake(x, CGRectGetMinY(self.yLayer.frame), tempheight * 0.5 / 255, height + CGRectGetMidY(self.maxLabel.frame) - CGRectGetMinY(self.yLayer.frame))];
                ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1] isEqualToString:@"00:00"]) ? [self.tagLabelStringArray addObject:[[DateMaker shareDateMaker] getDateWithDate:object[0]]] : [self.tagLabelStringArray addObject:[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1]];
                count++;
            }
            if ([object[1] isEqualToString:@""] || [object[1] isEqualToString:@"0"]) {
                y = startY;
            } else {
                y = CGRectGetMidY(self.maxLabel.frame) + height * (1 - [object[1] floatValue] / [self.maxLabel.text floatValue]);
            }
            if (isnan(y) || isinf(y)) {
                y = startY;
            }
            writeLocationY = (([object[1] isEqualToString:@"<null>"])) ? writeLocationY : y;
            CGPathAddLineToPoint(writePath, nil, x, writeLocationY);

            if ([object[2] isEqualToString:@""] || [object[2] isEqualToString:@"0"] || [object[1] floatValue] >= [object[2] floatValue]) {
                readY = y;
            } else {
                readY = CGRectGetMidY(self.maxLabel.frame) + height * (1 - [object[2] floatValue] / [self.maxLabel.text floatValue]);
            }
            if (isnan(readY) || isinf(readY)) {
                readY = y;
            }
            readLocationY = (([object[2] isEqualToString:@"<null>"])) ? readLocationY : readY;
            CGPathAddLineToPoint(readPath, nil, x, readLocationY);
            tempX++;
        }
        
        CGPathAddLineToPoint(writePath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        
        CGPathAddLineToPoint(readPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathCloseSubpath(writePath);
        CGPathCloseSubpath(readPath);
        
        self.readLayer.path = readPath;
        self.writeLayer.path = writePath;
        CGPathRelease(writePath);
        CGPathRelease(readPath);

        [self setTagLabel];
        
    }
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


@end

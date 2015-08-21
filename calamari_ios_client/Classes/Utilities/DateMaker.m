//
//  DateMaker.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "DateMaker.h"

@interface DateMaker()

@property (nonatomic, strong) NSDictionary *dateDic;

@end

@implementation DateMaker

+ (DateMaker*) shareDateMaker {
    static DateMaker *dateMaker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateMaker = [[DateMaker alloc] init];
    });
    return dateMaker;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.dateDic = @{@"1" : @"Jan", @"2" : @"Feb", @"3" : @"Mar", @"4" : @"Apr" , @"5" : @"May", @"6" : @"Jun", @"7" : @"Jul", @"8" : @"Aug", @"9" : @"Sep", @"10" : @"Oct", @"11" : @"Nov", @"12" : @"Dec"};
    }
    return self;
}

- (NSString*) getTodayWithNotificationFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/M/d HH:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSString*) getTimeWithTimeStamp:(NSString *)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/M/d HH:mm"];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]]];
}

- (NSString*) getDateWithDate:(NSString*)dateString {
    NSString *tempString = [dateString substringFromIndex:5];
    NSString *monString = [tempString substringToIndex:[tempString rangeOfString:@"/"].location];
    NSString *dayString = [tempString substringWithRange:NSMakeRange([tempString rangeOfString:@"/"].location + [tempString rangeOfString:@"/"].length, [tempString rangeOfString:@" "].location - [tempString rangeOfString:@"/"].location - 1)];
    return [NSString stringWithFormat:@"%@%@", dayString, self.dateDic[monString]];
}

- (NSString*) getTimeWithDate:(NSString*)dateString {
    NSString *tempString = [dateString substringFromIndex:[dateString rangeOfString:@" "].location + [dateString rangeOfString:@" "].length];
    return tempString;
}

@end

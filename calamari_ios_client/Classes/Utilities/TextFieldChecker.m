//
//  TextFieldChecker.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "TextFieldChecker.h"

@implementation TextFieldChecker

+ (TextFieldChecker*)shareInstance {
    static TextFieldChecker *checker = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        checker = [[TextFieldChecker alloc] init];
    });
    return checker;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.checkArray = [NSMutableArray array];
    }
    return self;
}

- (BOOL) startCheck {
    for (UITextField *value in self.checkArray) {
        if ([value.text isEqual:@""]) {
            return false;
        }
    }
    return true;
}

@end

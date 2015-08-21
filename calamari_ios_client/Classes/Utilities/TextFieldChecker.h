//
//  TextFieldChecker.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextFieldChecker : NSObject

@property (nonatomic, strong) NSMutableArray *checkArray;

+ (TextFieldChecker*) shareInstance;
- (BOOL) startCheck;

@end

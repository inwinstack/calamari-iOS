//
//  AlertTriggersController.h
//  calamari_ios_client
//
//  Created by Francis on 2015/10/8.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSUInteger, AlertCalculatorType) {
    AlertCalculatorOSDType = 0,
    AlertCalculatorMONType,
    AlertCalculatorPGType,
    AlertCalculatorUsageType,
};

@interface AlertTriggersController : BaseController

@end

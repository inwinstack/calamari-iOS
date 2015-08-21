//
//  ClusterHealthController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClusterHealthView;
@class ClusterHealthViewFlowLayout;

@protocol DidReceiveCollectionIndexDelegate <NSObject>

@required
- (void) didReceiveIndex:(NSInteger)collectionIndex;

@end

@interface ClusterHealthController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) id <DidReceiveCollectionIndexDelegate> delegate;
@property (nonatomic, strong) ClusterHealthView *clusterHealthView;
@property (nonatomic, strong) ClusterHealthViewFlowLayout *flowLayout;

@end

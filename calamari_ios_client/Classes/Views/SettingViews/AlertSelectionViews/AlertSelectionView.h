//
//  AlertSelectionView.h
//  calamari_ios_client
//
//  Created by Francis on 2015/9/22.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertSectionDelegate <NSObject>

@required
- (void) alertButtonDidSelect:(UIButton*)alertButton;

@end

@interface AlertSelectionView : UIView

@property (nonatomic, weak) id<AlertSectionDelegate> alertSectionDelegate;
@property (nonatomic, strong) UILabel *selectionTitleLabel;
@property (nonatomic, strong) UITableView *selectionTableView;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *cancelButton;

- (instancetype) initWithTitle:(NSString*)title content:(NSString*)content;

@end

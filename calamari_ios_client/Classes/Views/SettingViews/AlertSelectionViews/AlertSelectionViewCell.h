//
//  AlertSelectionViewCell.h
//  calamari_ios_client
//
//  Created by Francis on 2015/9/23.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertSelectionViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *countryImageView;
@property (nonatomic, strong) UILabel *mainNameLabel;
@property (nonatomic, strong) UIView *selectedBackgroundCircleView;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIView *districtLineView;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageName:(NSString*)imageName;

@end

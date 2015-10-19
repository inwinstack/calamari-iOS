//
//  SettingController.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/22.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "SettingController.h"
#import "SettingView.h"
#import "SettingViewCell.h"
#import "SettingViewFlowLayout.h"
#import "UIView+SizeMaker.h"
#import "SettingData.h"
#import "SelectionViewCell.h"
#import "AlertSelectionView.h"
#import "NotificationData.h"
#import "AlertSelectionViewCell.h"
#import "UIColor+Reader.h"
#import "AlertTriggersController.h"
#import "TimePeriodController.h"

@interface SettingController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, AlertSectionDelegate>

@property (nonatomic, strong) SettingView *settingView;
@property (nonatomic, strong) SettingViewFlowLayout *flowLayout;
@property (nonatomic, strong) AlertSelectionView *alertSelectionView;
@property (nonatomic, strong) NSString *tempDateFormat;
@property (nonatomic, strong) AlertTriggersController *alertTriggersController;
@property (nonatomic, strong) TimePeriodController *timePeriodController;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_option_setting"];
    self.flowLayout = [[SettingViewFlowLayout alloc] init];
    self.settingView = [[SettingView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    self.settingView.delegate = self;
    self.settingView.dataSource = self;
    self.view = self.settingView;
    
    [self.settingView registerClass:[SettingViewCell class] forCellWithReuseIdentifier:@"SettingViewCellIdentifier"];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [SettingData shareSettingData].settingNameArray.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SettingViewCellIdentifier" forIndexPath:indexPath];
    cell.settingNameLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:[SettingData shareSettingData].settingNameArray[indexPath.row]];
    cell.selectionView.delegate = self;
    cell.selectionView.dataSource = self;
    cell.selectionView.tag = indexPath.row;
    CGRect tempFrame = cell.selectionView.frame;
    switch (indexPath.row) {
        case 0:
            cell.selectionView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, 74);
            break;
            
        case 1:
            cell.selectionView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, 370);
            break;
            
        case 2:
            cell.selectionView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, 37);
            break;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (tableView.tag == 1) ? 74 : 37;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 104);
            break;
            
        case 1:
            return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 400);
            break;
            
        case 2:
            return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 67);
            break;
            
    }
    return CGSizeMake(0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case 0:
            return [SettingData shareSettingData].settingMainNameArray.count;
            break;
            
        case 1:
            return [SettingData shareSettingData].alertTitleArray.count;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return [SettingData shareSettingData].dateFormatOptionArray.count;
            break;
    }
    return -1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag > 2) {
        AlertSelectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionTableViewCellIdentifier"];
        if (!cell) {
            cell = [[AlertSelectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionTableViewCellIdentifier" imageName:@""];
        }
        cell.mainNameLabel.text = [SettingData shareSettingData].dateFormatOptionArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedView.backgroundColor = ([self.tempDateFormat isEqualToString:cell.mainNameLabel.text]) ? [UIColor oceanNavigationBarColor] : [UIColor osdButtonHighlightColor];
        cell.districtLineView.alpha = (indexPath.row == 2) ? 0.0 : 1.0;
        return cell;
    } else {
        SelectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCellIdentifier"];
        if (!cell) {
            cell = [[SelectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionCellIdentifier"];
        }
        switch (tableView.tag) {
            case 0:
                cell.mainLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:[SettingData shareSettingData].settingMainNameArray[indexPath.row]];
                cell.rightDetailLabel.text = (indexPath.row == 0) ? [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"] : [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentDateFormat"] ;
                cell.checkBoxButton.hidden = YES;
                break;
                
            case 1:
                cell.districtLineView.frame =  CGRectMake(0, 73, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 2);
                cell.rightDetailLabel.frame = (indexPath.row > 2) ? CGRectMake(10, CGRectGetMaxY(cell.mainLabel.frame), CGRectGetWidth(cell.districtLineView.frame) - 20, 37) : CGRectMake(10, CGRectGetMaxY(cell.mainLabel.frame), CGRectGetWidth(cell.districtLineView.frame) - 50, 37);
                cell.rightDetailLabel.font = [UIFont systemFontOfSize:[UIView noteSize]];
                cell.rightDetailLabel.textAlignment = NSTextAlignmentLeft;
                
                cell.mainLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:[SettingData shareSettingData].alertTitleArray[indexPath.row]];
                cell.rightDetailLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:[SettingData shareSettingData].alertBodyArray[indexPath.row]];
                cell.checkBoxButton.hidden = (indexPath.row > 2);
                cell.checkBoxButton.frame = CGRectMake(CGRectGetWidth(cell.districtLineView.frame) - 30, 27, 20, 20);
                cell.checkBoxButton.tag = indexPath.row;
                cell.checkBoxButton.backgroundColor = ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], [SettingData shareSettingData].checkBoxArray[indexPath.row]]] isEqualToString:@"YES"]) ? [UIColor oceanNavigationBarColor] : [UIColor clearColor];
                [cell.checkBoxButton addTarget:self action:@selector(didSelectCheckBoxButton:) forControlEvents:UIControlEventTouchUpInside];
                cell.checkBoxButton.layer.borderWidth = ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], [SettingData shareSettingData].checkBoxArray[indexPath.row]]] isEqualToString:@"YES"]) ? 0.0 : 2.0;
                
                break;
                
            case 2:
                cell.mainLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_about_version"];
                cell.rightDetailLabel.text = @"0.12.1";
                cell.checkBoxButton.hidden = YES;
                break;
        }
        return cell;
    }
}

- (void) didSelectCheckBoxButton:(UIButton*)checkBoxButton {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], [SettingData shareSettingData].checkBoxArray[checkBoxButton.tag]]] isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:[NSString stringWithFormat:@"%@_%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], [SettingData shareSettingData].checkBoxArray[checkBoxButton.tag]]];
        checkBoxButton.layer.borderWidth = 2.0;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"%@_%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], [SettingData shareSettingData].checkBoxArray[checkBoxButton.tag]]];
        checkBoxButton.layer.borderWidth = 0.0;
    }
    [(UITableView*)checkBoxButton.superview.superview.superview reloadData];

}

- (void) alertButtonDidSelect:(UIButton *)alertButton {
    if (alertButton.tag) {
        NSIndexPath *tempPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [[(SettingViewCell*)[self.settingView cellForItemAtIndexPath:tempPath] selectionView] reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:self.tempDateFormat forKey:@"CurrentDateFormat"];
    } else {
        [[NotificationData shareInstance] stopTimer];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        switch (indexPath.row) {
            case 0:
                self.alertSelectionView = [[AlertSelectionView alloc] initWithTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_profile_language"] content:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_language_dialog_description"]];
                self.alertSelectionView.alertSectionDelegate = self;
                self.alertSelectionView.enterButton.tag = 0;
                [self.view.window addSubview:self.alertSelectionView];
                break;
            case 1:
                self.alertSelectionView = [[AlertSelectionView alloc] initWithTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_profile_formats"] content:@""];
                self.alertSelectionView.selectionTableView.delegate = self;
                self.alertSelectionView.selectionTableView.dataSource = self;
                self.alertSelectionView.alertSectionDelegate = self;
                self.alertSelectionView.enterButton.tag = 1;
                [self.view.window addSubview:self.alertSelectionView];
                self.tempDateFormat = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentDateFormat"];
                break;
        }
    } else if (tableView.tag == 3) {
        self.tempDateFormat = [SettingData shareSettingData].dateFormatOptionArray[indexPath.row];
        [tableView reloadData];
    } else if (tableView.tag == 1) {
        if (indexPath.row == 4) {
            self.alertTriggersController = [[AlertTriggersController alloc] init];
            [self.navigationController pushViewController:self.alertTriggersController animated:YES];
        } else if (indexPath.row == 3) {
//            self.timePeriodController = [[TimePeriodController alloc] init];
//            [self.navigationController pushViewController:self.timePeriodController animated:YES];
        } else {
            UIButton *tempCheckBoxButton = [(SelectionViewCell*)[tableView cellForRowAtIndexPath:indexPath] checkBoxButton];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], [SettingData shareSettingData].checkBoxArray[indexPath.row]]] isEqualToString:@"YES"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:[NSString stringWithFormat:@"%@_%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], [SettingData shareSettingData].checkBoxArray[indexPath.row]]];
                tempCheckBoxButton.layer.borderWidth = 2.0;
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"%@_%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], [SettingData shareSettingData].checkBoxArray[indexPath.row]]];
                tempCheckBoxButton.layer.borderWidth = 0.0;
            }
            [tableView reloadData];
        }
    }
}

@end

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

@interface SettingController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, AlertSectionDelegate>

@property (nonatomic, strong) SettingView *settingView;
@property (nonatomic, strong) SettingViewFlowLayout *flowLayout;
@property (nonatomic, strong) AlertSelectionView *alertSelectionView;
@property (nonatomic, strong) NSString *tempDateFormat;

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
            cell.selectionView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, 0);
            break;
            
        case 2:
            cell.selectionView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, 37);
            break;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 37;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 104);
            break;
            
        case 1:
            return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 30);
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
            return 0;
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
                break;
                
            case 1:
                cell.mainLabel.text = @"";
                cell.rightDetailLabel.text = @"";
                break;
                
            case 2:
                cell.mainLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_about_version"];
                cell.rightDetailLabel.text = @"0.11.1";
                break;
        }
        cell.districtLineView.alpha = (indexPath.row == 2) ? 0.0 : 1.0;
        return cell;
    }
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
    }
}

@end
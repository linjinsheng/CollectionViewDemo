//
//  FSWebShowController.m
//  FSIPM
//
//  Created by eddy_Mac on 2019/3/27.
//  Copyright © 2019年 nickwong. All rights reserved.
//

#import "FSWebShowController.h"
#import "FSWebShowCell.h"
#import "UIView+SDAutoLayout.h"
#import "FSWebTagModel.h"

static NSString * const kShowingTagCellFlag = @"kShowingTagCellFlag";
static NSString * const kNotShowTagCellFlag = @"kNotShowTagCellFlag";

static NSString * const kSectionHeaderViewFlag = @"kSectionHeaderViewFlag";
static NSString * const kSectionFooterViewFlag = @"kSectionFooterViewFlag";

@interface FSWebShowController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,recevFinish>
{
    FS_Request *_request;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation FSWebShowController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    
    [self configDataSource];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[FSShowingCell class] forCellWithReuseIdentifier:kShowingTagCellFlag];
    [self.collectionView registerClass:[FSNotShowingCell class] forCellWithReuseIdentifier:kNotShowTagCellFlag];
    
    [self.collectionView registerClass:[WebTagCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderViewFlag];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSectionFooterViewFlag];
}

- (void)configDataSource
{
    [_dataSource removeAllObjects];
    
    FSNSUserDefault(FSUser);
    NSArray *webSiteNameArray = [FSUser objectForKey:@"webSiteNameArray"];
    NSArray *terminalCustomInfoIdArray = [FSUser objectForKey:@"terminalCustomInfoIdArray"];
    
    NSArray *webSiteNameNotDisplayArray = [FSUser objectForKey:@"webSiteNameNotDisplayArray"];
    NSArray *terminalCustomInfoIdNotDisplayArray = [FSUser objectForKey:@"terminalCustomInfoIdNotDisplayArray"];
    
    NSMutableArray *notShowArr = [NSMutableArray array];
    for (NSString *name in webSiteNameArray)
    {
        NSInteger index = [webSiteNameArray indexOfObject:name];
        NSString *tagId = terminalCustomInfoIdArray[index];
        
        FSWebTagModel *tag = [[FSWebTagModel alloc] init];
        tag.tagName = name;
        tag.tagId = tagId;
        
        if (index == 0)
        {
            tag.deleteBtnHiden = YES;
        }
        
        [notShowArr addObject:tag];
    }
    
    NSMutableArray *showingArr = [NSMutableArray array];
    for (NSString *name in webSiteNameNotDisplayArray)
    {
        NSInteger index = [webSiteNameNotDisplayArray indexOfObject:name];
        NSString *tagId = terminalCustomInfoIdNotDisplayArray[index];
        
        FSWebTagModel *tag = [[FSWebTagModel alloc] init];
        tag.tagName = name;
        tag.tagId = tagId;
        
        [showingArr addObject:tag];
    }
    
    [_dataSource addObject:notShowArr];
    [_dataSource addObject:showingArr];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *_flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _flowLayout.minimumLineSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_collectionView];
        
        _collectionView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(self.view, kTopHeight)
        .bottomEqualToView(self.view);
    }
    
    return _collectionView;
}

- (void)deleteBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    _currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    FSWebTagModel *tag = _dataSource[_currentIndexPath.section][_currentIndexPath.row];
    
    [ProgressHUD show:@"取消展示"];
    
    /** 改变关注菜单中选中站点的展示状态） */
    [[self getRequest] sendRequestWithUrl:changeDisplayFlagCustomWebsite
                               parameters:[FSRequestDictionary
                                           change_DisplayFlagCustomWebsite:tag.tagId.integerValue]
                              NetWorkType:changeDisplayFlagCustomWebsiteTag];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(FSScreenWidth, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        NSArray *titles = @[@"展示站点",@"未展示站点"];

        NSInteger section = indexPath.section;
        
        WebTagCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeaderViewFlag forIndexPath:indexPath];
        header.nameLb.text = titles[section];
        
        return header;
    }
    
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSectionFooterViewFlag forIndexPath:indexPath];
    footer.backgroundColor = nil;
    
    return footer;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [FSWebShowCell cellSize];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *items = _dataSource[section];
    
    return items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSWebShowCell *baseCell = nil;
    
    NSArray *tags = _dataSource[indexPath.section];
    FSWebTagModel *tag = tags[indexPath.row];

    if (indexPath.section == 0)
    {
        FSShowingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShowingTagCellFlag forIndexPath:indexPath];
        
        cell.titleLb.text = tag.tagName;
        cell.closeBtn.hidden = tag.deleteBtnHiden;
        cell.closeBtn.tag = indexPath.row;
        [cell.closeBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        baseCell = cell;
    }
    else
    {
        FSNotShowingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNotShowTagCellFlag forIndexPath:indexPath];
        cell.titleLb.text = [NSString stringWithFormat:@"➕%@",tag.tagName];

        baseCell = cell;
    }
    
    return baseCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        _currentIndexPath = indexPath;
        
        FSWebTagModel *tag = _dataSource[_currentIndexPath.section][_currentIndexPath.row];

        [ProgressHUD show:@"进行展示"];

        /** 改变关注菜单中选中站点的展示状态） */
        [[self getRequest] sendRequestWithUrl:changeDisplayFlagCustomWebsite
                                   parameters:[FSRequestDictionary
                                               change_DisplayFlagCustomWebsite:tag.tagId.integerValue]
                                  NetWorkType:changeDisplayFlagCustomWebsiteTag];
    }
}

#pragma mark 网络请求成功与否的代理方法
- (void)requestDidSuccess:(NSData *)receiveData andNetWorkType:(NSInteger)netType
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:receiveData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    [ProgressHUD dismiss];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    FSNSUserDefault(FSUser);
    
    if(changeDisplayFlagCustomWebsiteTag == netType){
        if ([dict[@"message"] isEqualToString:@"成功"]) {
            DLog(@"成功改变关注菜单中选中站点的展示状态");
   
            FSLog(@"进行网站展示设置");
            /**  用户定制资讯已审核通过的站点列表（包含关注菜单展示站点和关注菜单不展示站点） */
            [[self getRequest] sendRequestWithUrl:getTerminalUserAuditedWebsiteList
                                       parameters:[FSRequestDictionary
                                                   get_TerminalUserAuditedWebsiteList]
                                      NetWorkType:getTerminalUserAuditedWebsiteListTag];
            
        }else{
            FSLog(@"返回信息是%@",dict[@"message"]);
            [Tools showTipsWithHUD:dict[@"message"] showTime:1];
        }
    }
    
    if(getTerminalUserAuditedWebsiteListTag == netType){
        if ([dict[@"message"] isEqualToString:@"成功"]) {
            FSLog(@"成功获取定制站点规则");
            
            [FSUser removeObjectForKey:@"webSiteNameArray"];
            [FSUser removeObjectForKey:@"terminalCustomInfoIdArray"];
            
            [FSUser removeObjectForKey:@"webSiteNameNotDisplayArray"];
            [FSUser removeObjectForKey:@"terminalCustomInfoIdNotDisplayArray"];
            
            [FSUser synchronize];
            
            NSArray *terminalUserAuditedWebsiteListArray = dict[@"data"];
            
            if ([dict[@"data"]isKindOfClass:[NSNull class]]) {
                return ;
            }
            
            NSMutableArray *webSiteNameNotDisplayArray = [NSMutableArray array];
            NSMutableArray *terminalCustomInfoIdNotDisplayArray = [NSMutableArray array];
            
            NSMutableArray *webSiteNameArray = [NSMutableArray array];
            NSMutableArray *terminalCustomInfoIdArray = [NSMutableArray array];
            
            for(NSDictionary *subMessage in terminalUserAuditedWebsiteListArray){
                
                NSString *webSiteNameStr = [subMessage objectForKey:@"webSiteName"];
                NSString *terminalCustomInfoIdStr = [subMessage objectForKey:@"terminalCustomInfoId"];
                NSString *displayFlag =[NSString stringWithFormat:@"%@",[subMessage objectForKeyWithoutNull:@"displayFlag"]];
                if([displayFlag isEqualToString:@"0"]){
                    [webSiteNameNotDisplayArray addObject:webSiteNameStr];
                    [terminalCustomInfoIdNotDisplayArray addObject:terminalCustomInfoIdStr];
                }
                
                if([displayFlag isEqualToString:@"1"]){
                    [webSiteNameArray addObject:webSiteNameStr];
                    [terminalCustomInfoIdArray addObject:terminalCustomInfoIdStr];
                }
                
            }
            
            FSLog(@"webSiteNameNotDisplayArray为%@",webSiteNameNotDisplayArray);
            FSLog(@"terminalCustomInfoIdNotDisplayArray为%@",terminalCustomInfoIdNotDisplayArray);
            
            if (webSiteNameNotDisplayArray.count > 0) {
                [FSUser setObject: webSiteNameNotDisplayArray forKey:@"webSiteNameNotDisplayArray"];
                [FSUser synchronize];
            }
            
            if (terminalCustomInfoIdNotDisplayArray.count > 0) {
                [FSUser setObject: terminalCustomInfoIdNotDisplayArray forKey:@"terminalCustomInfoIdNotDisplayArray"];
                [FSUser synchronize];
            }
            
            if (webSiteNameArray.count > 0) {
                [FSUser setObject: webSiteNameArray forKey:@"webSiteNameArray"];
                [FSUser synchronize];
            }
            
            if (terminalCustomInfoIdArray.count > 0) {
                [FSUser setObject: terminalCustomInfoIdArray forKey:@"terminalCustomInfoIdArray"];
                [FSUser synchronize];
            }
            
            [self configDataSource];
            
            [self.collectionView reloadData];
            
            [FSNotificationCenter postNotificationName:@"refreshMenuView" object:nil];
            
            
        }else{
            FSLog(@"返回信息是%@",dict[@"message"]);
            [Tools showTipsWithHUD:dict[@"message"] showTime:1];
        }
    }
    
}

- (void)requestDidFailure:(NSError *)error andNetWorkType:(NSInteger)netType
{
    [ProgressHUD dismiss];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showTipsWithHUD:netWork_isAbnormal showTime:1.0];
}

#pragma mark --发送网络请求
- (FS_Request *)getRequest
{
    if (_request == nil)
    {
        _request = [[FS_Request alloc]init];
        _request.delegate = self;
    }
    return _request;
}

@end

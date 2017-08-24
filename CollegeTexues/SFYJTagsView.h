//
//  SFYJTagsView.h
//  CollegeTexues
//
//  Created by yuanjianguo on 2017/8/22.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFYJTagsView;
@protocol SFYJTagsViewDelegate <NSObject>

@optional
- (CGFloat)MinimunLineSpaceForSFTagsView:(SFYJTagsView *)tagsView;

- (CGFloat)MinimumRowsSpaceForSFTagsView:(SFYJTagsView *)tagsView;

- (CGFloat)heightWithRemoveForSFTagsView:(SFYJTagsView *)tagsView;

- (CGFloat)heightWithTTPaddingForSFTagsView:(SFYJTagsView *)tagsView;

- (CGFloat)heightWithLRPaddingForSFTagsView:(SFYJTagsView *)tagsView;

- (CGSize)sizeWithItemForSFTagsView:(SFYJTagsView *)tagsView;

@end



@interface SFYJTagsView : UIView

@property (nonatomic, weak) id <SFYJTagsViewDelegate> delegate;

@property (nonatomic, strong)id owner;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataSource;


//设置滑动方向
@property (nonatomic, assign)UICollectionViewScrollDirection layoutDirections;

//设置是否处于可删除状态
@property (nonatomic, assign)BOOL isEditing;

//设置是否可拖动重新排序
@property (nonatomic, assign)BOOL isCanReArrange;

//设置是否处于可选择模式（暂不支持）
@property (nonatomic, assign)BOOL isCheckEnable;

//设置是否item宽度自动改变
@property (nonatomic, assign)BOOL isAutoItemLength;


@property (nonatomic, assign)UIEdgeInsets sectionInsets;

//右上角删除按钮高度
@property (nonatomic, assign)CGFloat removeHeight;

//横向最小间距
@property (nonatomic, assign)CGFloat lineMiniSpace;

//竖向最小间距
@property (nonatomic, assign)CGFloat verticalMiniSpace;

@end

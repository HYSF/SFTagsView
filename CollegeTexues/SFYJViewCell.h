//
//  SFYJViewCell.h
//  CollegeTexues
//
//  Created by yuanjianguo on 2017/8/22.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFYJViewCell;
@protocol SFYJViewCellDelegate <NSObject>

@optional
- (void)willRemoveItem:(SFYJViewCell *)cell;

@end

@interface SFYJViewCell : UICollectionViewCell

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIButton *removeBtn;
@property (nonatomic, weak) id <SFYJViewCellDelegate> delegate;

@property (nonatomic, assign)CGFloat removeHeight;

@property (nonatomic, assign)BOOL isEditing;

@property (nonatomic, assign)BOOL isShowAdd;

@property (nonatomic, strong)void (^willRemoveItem)(UIButton *sender);

@end

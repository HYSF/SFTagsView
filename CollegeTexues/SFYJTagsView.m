//
//  SFYJTagsView.m
//  CollegeTexues
//
//  Created by yuanjianguo on 2017/8/22.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#define angelToRandian(x)  ((x)/180.0*M_PI)
#import "SFYJTagsView.h"
#import "SFYJViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"

@interface SFYJTagsView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,SFYJViewCellDelegate>
{
    CGFloat minimumLineSpacing;
    CGFloat minimumInteritemSpacing;
    CGFloat removingHeight;
    CGFloat topPadding;
    CGFloat leadPadding;
    CGSize itemSize;
}

@property (nonatomic, strong)UICollectionViewLeftAlignedLayout *layout;


//长按拖动相关
@property (nonatomic, strong)NSIndexPath *currentIndexPath;

@property (nonatomic, strong)UIView *mappingImageCell;

@property (nonatomic, strong)UILongPressGestureRecognizer *longPress;



@end

@implementation SFYJTagsView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self defaultInnitaial];
        [self initial];
    }
    return self;
}

 -(void)defaultInnitaial
{
    minimumLineSpacing = 5;
    minimumInteritemSpacing = 5;
    removingHeight = 15;
    topPadding = 0;
    leadPadding = 10;
}


- (void)initial
{
    _layout = [[UICollectionViewLeftAlignedLayout alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView  = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[SFYJViewCell class] forCellWithReuseIdentifier:@"SFYJViewCell"];
    [self setUpGestureRecognizers];
}

- (void)setLayoutDirections:(UICollectionViewScrollDirection)layoutDirections
{
    _layoutDirections =  layoutDirections;
    self.layout.scrollDirection = layoutDirections;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFYJViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SFYJViewCell" forIndexPath:indexPath];
    if (self.isEditing) {
        cell.isEditing = YES;
    }else
    {
        cell.isEditing = NO;
    }
    
    cell.titleLabel.text = self.dataSource[indexPath.item];
    cell.delegate = self;
    cell.removeHeight = [self getRemovingHeight];
    return cell;
}


- (void)willRemoveItem:(UICollectionViewCell *)cell
{
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        [self.dataSource removeObjectAtIndex:indexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.dataSource[indexPath.item]);
    
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isAutoItemLength) {
        NSString *stitle = self.dataSource[indexPath.item];
        CGRect rect = [stitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
        return rect.size;
    }
    
    CGSize rectSize = CGSizeMake(80, 60);
    if ([self.delegate respondsToSelector:@selector(sizeWithItemForSFTagsView:)]) {
        rectSize = [self.delegate sizeWithItemForSFTagsView:self];
    }
    
    if (self.layoutDirections == UICollectionViewScrollDirectionHorizontal) {
        if (rectSize.height > self.bounds.size.height - [self getTopAndBottomPadding] * 2 ) {
            rectSize.height = self.bounds.size.height - [self getTopAndBottomPadding] * 2 ;
        }
        rectSize.height -= [self getRemovingHeight]/2.0;
    }
    
    if (self.layoutDirections == UICollectionViewScrollDirectionVertical) {
        if (rectSize.width > (self.bounds.size.width - [self getLeadingAndTrailingPadding] * 2 + [self getRemovingHeight]/2.0)) {
            rectSize.width = self.bounds.size.width - [self getLeadingAndTrailingPadding] * 2 + [self getRemovingHeight]/2.0;
        }
    }
    
    
    return rectSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake([self getTopAndBottomPadding] - [self getRemovingHeight]/2.0 >= 0 ?: 0, [self getLeadingAndTrailingPadding], [self getTopAndBottomPadding] + [self getRemovingHeight]/2.0, [self getLeadingAndTrailingPadding] - [self getRemovingHeight]/2.0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [self getMiniLineSpace];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [self getMiniRowsSpace];
}






- (CGFloat)getMiniLineSpace
{
    if ([self.delegate respondsToSelector:@selector(MinimunLineSpaceForSFTagsView:)]) {
        minimumLineSpacing = [self.delegate MinimunLineSpaceForSFTagsView:self];
    }
    return minimumLineSpacing;
}


- (CGFloat)getMiniRowsSpace
{
    if ([self.delegate respondsToSelector:@selector(MinimumRowsSpaceForSFTagsView:)]) {
        minimumInteritemSpacing = [self.delegate MinimumRowsSpaceForSFTagsView:self];
    }
    return minimumInteritemSpacing;
}

- (CGFloat)getTopAndBottomPadding
{
    if ([self.delegate respondsToSelector:@selector(heightWithTTPaddingForSFTagsView:)]) {
        topPadding = [self.delegate heightWithTTPaddingForSFTagsView:self];
    }
    return topPadding;
}

- (CGFloat)getLeadingAndTrailingPadding
{
    if ([self.delegate respondsToSelector:@selector(heightWithTTPaddingForSFTagsView:)]) {
        leadPadding = [self.delegate heightWithLRPaddingForSFTagsView:self];
    }
    return leadPadding;
}

- (CGFloat)getRemovingHeight
{
    if ([self.delegate respondsToSelector:@selector(heightWithRemoveForSFTagsView:)]) {
        removingHeight = [self.delegate heightWithRemoveForSFTagsView:self];
    }
    return removingHeight;
}


#pragma mark - UILongPressGestureRecognizer

- (void)setUpGestureRecognizers{
    if (self.collectionView == nil) {
        return;
    }
    _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    _longPress.minimumPressDuration = 0.2f;
    _longPress.delegate = self;
    [self.collectionView addGestureRecognizer:_longPress];
}


- (void)handleLongPress:(UILongPressGestureRecognizer*)longPress
{
    if (!self.isCanReArrange) {
        return ;
    }
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [longPress locationInView:self.collectionView];
            NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:location];
            if (!indexPath) return;
            
            self.currentIndexPath = indexPath;
            UICollectionViewCell* targetCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            //得到当前cell的映射(截图)
            UIView* cellView = [targetCell snapshotViewAfterScreenUpdates:YES];
            self.mappingImageCell = cellView;
            self.mappingImageCell.frame = cellView.frame;
            targetCell.hidden = YES;
            [self.collectionView addSubview:self.mappingImageCell];
            
            cellView.center = targetCell.center;
            [self shakeAllCell];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [longPress locationInView:self.collectionView];
            //更新cell的位置
            self.mappingImageCell.center = point;
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath == nil )  return;
            if (![indexPath isEqual:self.currentIndexPath])
            {
                //改变数据源
                [self moveDataItem:self.currentIndexPath toIndexPath:indexPath];
                [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.mappingImageCell.center = cell.center;
            } completion:^(BOOL finished) {
                [self.mappingImageCell removeFromSuperview];
                cell.hidden           = NO;
                self.mappingImageCell = nil;
                self.currentIndexPath = nil;
            }];
            
            [self stopShakeAllCell];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

- (void)shakeAllCell{
    
    CGFloat _shakeLevel = 1.5;
    BOOL _shakeWhenMoveing = YES;
    if (!_shakeWhenMoveing) {
        //没有开启抖动只需要遍历设置个cell的hidden属性
        NSArray *cells = [self.collectionView visibleCells];
        for (UICollectionViewCell *cell in cells) {
            //顺便设置各个cell的hidden属性，由于有cell被hidden，其hidden状态可能被冲用到其他cell上,不能直接利用_originalIndexPath相等判断，这很坑
            BOOL hidden = self.currentIndexPath && [self.collectionView indexPathForCell:cell].item == self.currentIndexPath.item && [self.collectionView indexPathForCell:cell].section == self.currentIndexPath.section;
            cell.hidden = hidden;
        }
        return;
    }
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform.rotation";
    anim.values=@[@(angelToRandian(-_shakeLevel)),@(angelToRandian(_shakeLevel)),@(angelToRandian(-_shakeLevel))];
    anim.repeatCount=MAXFLOAT;
    anim.duration=0.2;
    NSArray *cells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        //        if ([self xwp_indexPathIsExcluded:[self.collectionView indexPathForCell:cell]]) {
        //            continue;
        //        }
        /**如果加了shake动画就不用再加了*/
        if (![cell.layer animationForKey:@"shake"]) {
            [cell.layer addAnimation:anim forKey:@"shake"];
        }
        //顺便设置各个cell的hidden属性，由于有cell被hidden，其hidden状态可能被冲用到其他cell上
        BOOL hidden = self.currentIndexPath && [self.collectionView indexPathForCell:cell].item == self.currentIndexPath.item && [self.collectionView indexPathForCell:cell].section == self.currentIndexPath.section;
        cell.hidden = hidden;
    }
    if (![self.mappingImageCell.layer animationForKey:@"shake"]) {
        [self.mappingImageCell.layer addAnimation:anim forKey:@"shake"];
    }
}

- (void)stopShakeAllCell
{
    NSArray *cells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        [cell.layer removeAllAnimations];
    }
    [self.mappingImageCell.layer removeAllAnimations];
}

- (void)moveDataItem:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *arr = [self.dataSource mutableCopy];
    NSString *str = self.dataSource[fromIndexPath.item];
    [arr removeObjectAtIndex:fromIndexPath.item];
    [arr insertObject:str atIndex:toIndexPath.item];
    self.dataSource = [arr copy];
}

@end

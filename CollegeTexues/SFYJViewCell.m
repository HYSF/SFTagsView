//
//  SFYJViewCell.m
//  CollegeTexues
//
//  Created by yuanjianguo on 2017/8/22.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#import "SFYJViewCell.h"

@implementation SFYJViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial
{
    _backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:_backImageView];
    
    _removeHeight = 10;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _removeHeight/2.0, self.bounds.size.width-_removeHeight/2.0, self.bounds.size.height-_removeHeight/2.0)];
    _titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.layer.borderWidth = 1.0f;
    _titleLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _titleLabel.layer.cornerRadius = 3.0f;
    _titleLabel.clipsToBounds = YES;
    [self addSubview:_titleLabel];
    
    _removeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _removeHeight, _removeHeight)];
    _removeBtn.center = CGPointMake(self.titleLabel.bounds.size.width , _removeHeight/2.0);
    [_removeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    _removeBtn.layer.borderWidth = 0.6;
    _removeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_removeBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [self addSubview:_removeBtn];
    
    self.titleLabel.textColor = [UIColor blackColor];
    [self.removeBtn addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setRemoveHeight:(CGFloat)removeHeight
{
    _removeHeight = removeHeight;
    
    self.removeBtn.frame = CGRectMake(0, 0, _removeHeight, _removeHeight);
    self.removeBtn.center = CGPointMake(self.titleLabel.bounds.size.width , _removeHeight/2.0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isEditing) {
        self.removeBtn.hidden = NO;
    }else
    {
        self.removeBtn.hidden = YES;
    }
    
    if (self.isShowAdd) {
        self.backImageView.hidden = NO;
    }else
    {
        self.backImageView.hidden = YES;
    }
}


- (void)removeAction:(UIButton *)sender
{
    if (self.willRemoveItem) {
        self.willRemoveItem(sender);
    }
    
    if ([self.delegate respondsToSelector:@selector(willRemoveItem:)]) {
        [self.delegate willRemoveItem:self];
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGPoint myPoint = [self convertPoint:point toView:self.removeBtn];
//    if (CGRectContainsPoint(self.removeBtn.bounds, myPoint)) {
//        return self.removeBtn;
//    }
//    
//    return [super hitTest:point withEvent:event];
//}


//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    
//    if (view == nil) {
//        for (UIView *subView in self.subviews) {
//            CGPoint myPoint = [subView convertPoint:point fromView:self];
//            if (CGRectContainsPoint(subView.bounds, myPoint)) {
//                
//                return subView;
//            }
//        }
//    }
//    
//    return view;
//}

@end

//
//  ViewController.m
//  CollegeTexues
//
//  Created by yuanjianguo on 2017/8/7.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#define screenWidth self.view.bounds.size.width
#define angelToRandian(x)  ((x)/180.0*M_PI)

#import "ViewController.h"
#import "SFYJTagsView.h"


@interface ViewController ()<SFYJTagsViewDelegate>

@property (nonatomic, strong)SFYJTagsView *tagsView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    _tagsView = [[SFYJTagsView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 180)];
    _tagsView.delegate = self;
    [self.view addSubview:_tagsView];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 360, self.view.bounds.size.width, 40)];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)onTap:(UIButton *)sender
{
    _tagsView.dataSource = [NSMutableArray arrayWithArray:@[@"KFC",@"发哈",@"就发",@"锐的",@"书法",@"KFC",@"发哈哈",@"就发了激发",@"锐欧去我家的",@"女，女警爱看书法",@"KFC",@"发哈哈",@"就发了激发",@"锐欧去我家的",@"女，女警爱看书法",@"KFC",@"发哈哈",@"就发了激发",@"锐欧去我家的",@"女，女警爱看书法",@"KFC",@"发哈哈",@"就发了激发",@"锐欧去我家的",@"女，女警爱看书法",@"KFC",@"发哈哈",@"就发了激发",@"锐欧去我家的"]];
}




- (void)willRemoveItem:(UICollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.tagsView.collectionView indexPathForCell:cell];
    [self.tagsView.dataSource removeObjectAtIndex:indexPath.item];
    [self.tagsView.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (CGSize)sizeWithItemForSFTagsView:(SFYJTagsView *)tagsView
{
    return CGSizeMake(295/3.0, 35);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

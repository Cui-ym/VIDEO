//
//  VIDHomeView.m
//  VIDEO
//
//  Created by 崔一鸣 on 2018/6/7.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "VIDHomeView.h"
#import "VIDHomeViewCollectionViewCell.h"

#define kHeight self.frame.size.height
#define kWidth self.frame.size.width

@interface VIDHomeView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *homeView;

@property (nonatomic, strong) UICollectionView *videoCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *viewFlowLayout;

@end

@implementation VIDHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:_homeView];
        self.viewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _viewFlowLayout.itemSize = CGSizeMake((kWidth - 20) / 2 - 20, (kWidth - 20) / 2 - 20);
        _viewFlowLayout.minimumLineSpacing = 20;
        _viewFlowLayout.minimumInteritemSpacing = 20;
        _viewFlowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        _viewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.videoCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:_viewFlowLayout];
        [self.videoCollectionView registerClass:[VIDHomeViewCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.videoCollectionView.backgroundColor = [UIColor whiteColor];
        self.videoCollectionView.delegate = self;
        self.videoCollectionView.dataSource = self;
        [self addSubview:_videoCollectionView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - collectionViewDataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VIDHomeViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.timeLabel.text = @"03:33";
    cell.titleLabel.text = @"广播体操";
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

#pragma mark - collectionViewDelegate




@end

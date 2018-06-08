//
//  VIDHomeView.m
//  VIDEO
//
//  Created by 崔一鸣 on 2018/6/7.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "VIDHomeView.h"

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
        
        self.videoCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:_viewFlowLayout];
        [self addSubview:_videoCollectionView];
        
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
}

@end

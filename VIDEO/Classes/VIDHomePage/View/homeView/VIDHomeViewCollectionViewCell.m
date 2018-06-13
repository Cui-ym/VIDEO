//
//  VIDHomeViewCollectionViewCell.m
//  VIDEO
//
//  Created by 崔一鸣 on 2018/6/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "VIDHomeViewCollectionViewCell.h"
#import "Masonry.h"

@implementation VIDHomeViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.coverImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverImageView];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.7);
    }];
    self.coverImageView.backgroundColor = [UIColor yellowColor];
    [self.coverImageView setImage:[UIImage imageNamed:@"wwdc.jpeg"]];
    self.coverImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.coverImageView).offset(-5);
//        make.height.and.width.equalTo(self.coverImageView).multipliedBy(0.3);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.layer.borderWidth = 1;
    self.timeLabel.layer.cornerRadius = 5;
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom);
        make.left.and.bottom.and.right.equalTo(self.contentView);
    }];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

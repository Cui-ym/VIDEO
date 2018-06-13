//
//  VIDVideoPlayView.m
//  VIDEO
//
//  Created by 崔一鸣 on 2018/6/12.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "VIDVideoPlayView.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface VIDVideoPlayView ()


//@property (nonatomic, strong) AVPlayer

@end

@implementation VIDVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        self.playButton = [[UIButton alloc] init];
        [self addSubview:_playButton];
        
        self.cancelButton = [[UIButton alloc] init];
        [self addSubview:_cancelButton];
        
        self.exchangeButton = [[UIButton alloc] init];
        [self addSubview:_exchangeButton];
        
        self.timeLabel = [[UILabel alloc] init];
        [self addSubview:_timeLabel];
        
//        self.focusCursor = [[UIImageView alloc] init];
//        [self addSubview:_focusCursor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.and.height.mas_equalTo(60);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-20);
    }];
    self.playButton.layer.masksToBounds = YES;
    self.playButton.layer.cornerRadius = 30;
    self.playButton.backgroundColor = [UIColor blackColor];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.playButton.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.text = @"00:00";
    self.timeLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    self.timeLabel.textColor = [UIColor orangeColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).mas_offset(30);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self.exchangeButton setBackgroundImage:[UIImage imageNamed:@"exchange.png"] forState:UIControlStateNormal];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(30);
        make.left.equalTo(self.mas_left).mas_offset(20);
        make.width.and.height.mas_equalTo(20);
    }];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    
}

@end

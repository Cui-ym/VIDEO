//
//  VIDHomeView.h
//  VIDEO
//
//  Created by 崔一鸣 on 2018/6/7.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VIDHomeViewDelegate <NSObject>

// 视频教学
- (void)videoPlay;

@end

@interface VIDHomeView : UIView

@property (nonatomic, weak) id<VIDHomeViewDelegate> delegate;

@property (nonatomic, strong) UIView *view;

@end

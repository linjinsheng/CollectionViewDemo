//
//  FSWebShowCell.m
//  FSIPM
//
//  Created by eddy_Mac on 2019/3/27.
//  Copyright © 2019年 nickwong. All rights reserved.
//

#import "FSWebShowCell.h"
#import "UIView+SDAutoLayout.h"

@implementation FSWebShowCell

+ (CGSize)cellSize
{
    static dispatch_once_t once;
    static CGSize size;
    
    dispatch_once(&once, ^{
        
        CGFloat width = (FSScreenWidth - 80)/3.0;
        
        size = CGSizeMake(width, 55);
    });
    
    return size;
}

- (UILabel *)titleLb
{
    if (_titleLb == nil)
    {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.font = [UIFont systemFontOfSize:15];
        _titleLb.textColor = [Tools getColor:@"96A1AF" isSingleColor:YES];
        _titleLb.backgroundColor = [Tools getColor:@"F7F7F7" isSingleColor:YES];
        
        [self.contentView addSubview:_titleLb];
    }
    
    return _titleLb;
}

@end


@implementation FSShowingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.titleLb.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(self.contentView, 15)
        .bottomEqualToView(self.contentView);
    }
    
    return self;
}

- (UIButton *)closeBtn
{
    if (_closeBtn == nil)
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//        _closeBtn.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_closeBtn];

        _closeBtn.sd_layout
        .heightIs(40)
        .widthIs(40)
        .leftSpaceToView(self.titleLb, -20)
        .bottomSpaceToView(self.titleLb, -20);
    }
    
    return _closeBtn;
}

@end


@implementation FSNotShowingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.titleLb.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(self.contentView, 15)
        .bottomEqualToView(self.contentView);
    }
    
    return self;
}

@end


//
@implementation WebTagCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (UILabel *)nameLb
{
    if (_nameLb == nil)
    {
        _nameLb = [[UILabel alloc] init];
        _nameLb.font = ProMainFont;
        _nameLb.textAlignment = NSTextAlignmentLeft;
        _nameLb.textColor = [Tools getColor: @"000000"isSingleColor:YES];
        
        [self addSubview:_nameLb];
        
        _nameLb.sd_layout
        .leftSpaceToView(self, FSHorzMargin)
        .rightEqualToView(self)
        .heightIs(30)
        .bottomSpaceToView(self, 0);
    }
    
    return _nameLb;
}

@end

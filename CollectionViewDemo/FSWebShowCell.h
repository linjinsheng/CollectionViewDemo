//
//  FSWebShowCell.h
//  FSIPM
//
//  Created by eddy_Mac on 2019/3/27.
//  Copyright © 2019年 nickwong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSWebShowCell : UICollectionViewCell

+ (CGSize)cellSize;

@property (nonatomic, strong) UILabel *titleLb;

@end


@interface FSShowingCell : FSWebShowCell

@property (nonatomic, strong) UIButton *closeBtn;

@end

@interface FSNotShowingCell : FSWebShowCell

@end

//section header
@interface WebTagCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *nameLb;

@end

NS_ASSUME_NONNULL_END

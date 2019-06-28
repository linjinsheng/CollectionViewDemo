//
//  FSWebTagModel.h
//  FSIPM
//
//  Created by targetios on 2019/3/28.
//  Copyright © 2019年 nickwong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSWebTagModel : NSObject

@property (nonatomic, assign) BOOL deleteBtnHiden;

@property (nonatomic, copy)   NSString *tagName;

@property (nonatomic, copy)   NSString *tagId;

@end

NS_ASSUME_NONNULL_END

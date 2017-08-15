//
//  HStartSelectView.h
//  HStartSelectViewDemo
//
//  Created by yyh on 2017/5/19.
//  Copyright © 2017年 yyh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnBlock) (NSString *score);

@interface HStartSelectView : UIView

@property (nonatomic, copy) NSString *score;

- (instancetype)initWithFrame:(CGRect)frame
                        block:(returnBlock)block
                       enable:(BOOL)enable;

@end

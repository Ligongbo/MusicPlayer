//
//  HStartSelectView.m
//  HStartSelectViewDemo
//
//  Created by yyh on 2017/5/19.
//  Copyright © 2017年 yyh. All rights reserved.
//

#import "HStartSelectView.h"

@interface HStartSelectView ()

@property (nonatomic, copy) returnBlock block;
@property (nonatomic, strong) NSMutableArray *starts;

@end

@implementation HStartSelectView

- (instancetype)initWithFrame:(CGRect)frame
                        block:(returnBlock)block
                       enable:(BOOL)enable {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.block = block;
        self.starts = [NSMutableArray arrayWithCapacity:0];
        CGFloat space = (frame.size.width - frame.size.height * 5) / 4;
        
        for (int i = 0; i < 5; i ++) {
            
            UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [startButton setFrame:CGRectMake((space + frame.size.height) * i, 0, frame.size.height, frame.size.height)];
            startButton.tag = i + 1;
            startButton.userInteractionEnabled = enable;
            [startButton setBackgroundImage:[UIImage imageNamed:@"ico_startgray"] forState:UIControlStateNormal];
            [startButton setBackgroundImage:[UIImage imageNamed:@"ico_startyellow"] forState:UIControlStateHighlighted];
            [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:startButton];
            
            [self.starts addObject:startButton];
        }
    }
    
    return self;
}

- (void)buttonClick:(UIButton *)button {
    
    self.score = [NSString stringWithFormat:@"%ld", button.tag];
    
    if (self.block) {
        
        self.block([NSString stringWithFormat:@"%ld", button.tag]);
    }
}

- (void)setScore:(NSString *)score {
    
    int intNum = [score intValue];
    float floatNum = [score floatValue] - intNum;
    
    intNum = MIN((int)self.starts.count, intNum);
    
    for (int i = 0; i < intNum; i ++) {
        
        UIButton *fullButton = self.starts[i];
        [fullButton setBackgroundImage:[UIImage imageNamed:@"ico_startyellow"] forState:UIControlStateNormal];
    }
    
    if (floatNum > 0 && intNum < self.starts.count) {
        
        UIButton *halfButton = self.starts[intNum];
        [halfButton setBackgroundImage:[UIImage imageNamed:@"ico_starthalf"] forState:UIControlStateNormal];
        
        for (int i = intNum + 1; i < self.starts.count; i ++) {
            
            UIButton *nullButton = self.starts[i];
            [nullButton setBackgroundImage:[UIImage imageNamed:@"ico_startgray"] forState:UIControlStateNormal];
        }
    }else {
        
        for (int i = intNum; i < self.starts.count; i ++) {
            
            UIButton *nullButton = self.starts[i];
            [nullButton setBackgroundImage:[UIImage imageNamed:@"ico_startgray"] forState:UIControlStateNormal];
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

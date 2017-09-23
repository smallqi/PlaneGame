//
//  Gift.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "Gift.h"

@implementation Gift


-(id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if(self) {
        //设置大小,初始位置
        _size = [image size];
        _LUposition = CGPointMake(0, 0);
        [self setFrame:CGRectMake(_LUposition.x, _LUposition.y, _size.width, _size.height)];
        
        //设置默认属性
        _collider = _size;
        _giftType = 1;
        _stayTime = 100;
    }
    return self;
}
//设置位置
-(void)setPosition:(CGPoint)position {
    [self setFrame:CGRectMake(position.x, position.y, self.size.width, self.size.height)];
    _LUposition = position;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

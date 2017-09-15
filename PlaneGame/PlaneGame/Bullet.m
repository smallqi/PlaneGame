//
//  Bullet.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet


-(id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if(self) {
        //设置大小,初始位置
        _size = [image size];
        _LUposition = CGPointMake(0, 0);
        [self setFrame:CGRectMake(_LUposition.x, _LUposition.y, _size.width, _size.height)];
        
        //设置默认属性
        self.power = 1;
        _speed = 1;
        _collider = _size;
    }
    return self;
}
//设置位置
-(void)setPosition:(CGPoint)position {
    [self setFrame:CGRectMake(position.x, position.y, self.size.width, self.size.height)];
    _LUposition = position;
}
//移动
-(void)moveWithDirect:(CGPoint)point{
    self.position = CGPointMake(self.LUposition.x + self.speed*point.x, self.LUposition.y + self.speed*point.y);
    [self setPosition:self.LUposition];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

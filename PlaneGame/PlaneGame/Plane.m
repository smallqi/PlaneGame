//
//  Hero.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "Plane.h"

@implementation Plane
{
    CGSize _size;
    NSMutableArray* _flyImages;
    NSMutableArray* _hitImages;
    NSMutableArray* _deadImages;
}
-(id)initWithFlyAnima:(NSMutableArray*)flys WithHitAnima:(NSMutableArray*)hits WithDeadAnima:(NSMutableArray*)deads;
{
    self = [super init];
    if(self) {
        
        //设置大小,初始位置
        _size = [[flys firstObject] size];
        _LUposition = CGPointMake(0, 0);
        [self setFrame:CGRectMake(_LUposition.x, _LUposition.y, _size.width, _size.height)];
        
        //设置动画
        _flyImages = flys;
        _hitImages = hits;
        _deadImages = deads;
        
        //设置默认属性
        _hp = 2;
        _speed = 1;
        _collider = _size;
        _myframes = 0;
        
        [self playFly];
    }
    return self;
}

//播放动画
-(void)playFly {
    if(self.animating)
       [self stopAnimating];
    if([self isDead])
        return;
    self.animationImages = _flyImages;
    self.animationRepeatCount = -1;
    self.animationDuration = 0.1;
    [self startAnimating];
}
-(void)playHit {
    if(self.animating)
        [self stopAnimating];
    
    self.animationImages = _hitImages;
    self.animationRepeatCount = 1;
    self.animationDuration = 0.05;
    [self startAnimating];
}
-(void)playDead {
    if(self.animating)
        [self stopAnimating];
    
    self.animationImages = _deadImages;
    self.animationRepeatCount = 1;
    self.animationDuration = 0.1;
    [self startAnimating];
}

//设置位置
-(void)setPosition:(CGPoint)position {
    [self setFrame:CGRectMake(position.x, position.y, self.size.width, self.size.height)];
    _LUposition = position;
}
//开火 need override
-(Bullet*)fireWithGameFrames:(int)gameFrames {
    return nil;
}
//受到攻击
-(void)getHitWithPower:(int)power {
    /*
    //被打动画
    [self playHit];
    //播放飞行
    [self playFly];
    */
     //减少hp
    _hp -= power;
    if(_hp <= 0) {
        _hp = 0;
    }
}
//是否死亡
-(BOOL)isDead {
    if (_hp <= 0) {
        return true;
    }
    return false;
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

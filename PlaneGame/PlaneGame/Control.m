//
//  Control.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "Control.h"
#import "GameData.h"

@implementation Control
{
    UILabel* _scoreLabel;
    UILabel* _timeLabel;
    UILabel* _bombLabel;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.score = 0;
        self.bombNum = 1;
        self.frames = 0;
        
        
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        float width = (frame.size.width - 20)/3;
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, width, 44)];
        _scoreLabel.text = @"Score:0";
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        _scoreLabel.adjustsFontSizeToFitWidth = true;
        [self addSubview:_scoreLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + width, 20, width, 44)];
        _timeLabel.text = @"00:00";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.adjustsFontSizeToFitWidth = true;
        [self addSubview:_timeLabel];
        
        _bombLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + width*2, 20, width, 44)];
        _bombLabel.text = @"Bomb:1";
        _bombLabel.textAlignment = NSTextAlignmentRight;
        _bombLabel.adjustsFontSizeToFitWidth = true;
        [self addSubview:_bombLabel];
        
    }
    return self;
}

-(void)updateScoreLabel {
    _scoreLabel.text = [NSString stringWithFormat:@"Score:%d", self.score];
}
-(void)updateTimeLabel {
    //超时重新开始
    int second = self.frames * [GameData shareWithLevel:1]->game.gameLoopTime;
    if(second > 3600) {
        second = 0;
        self.frames = 0;
    }
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", second/60, second%60];
}
-(void)updateBombLabel {
    _bombLabel.text = [NSString stringWithFormat:@"%d", self.bombNum];
}

@end

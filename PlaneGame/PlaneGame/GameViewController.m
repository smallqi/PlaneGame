//
//  GameViewController.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "GameViewController.h"
#import "ImageSource.h"
#import "AudioSource.h"
#import "GameData.h"

#import "Hero.h"
#import "Enemy.h"
#import "Bullet.h"
#import "Gift.h"

#import "Control.h"

#define Screen_Width self.view.frame.size.width
#define Screen_Height self.view.frame.size.height

@interface GameViewController ()

//游戏时间循环
@property(strong, nonatomic) NSTimer* timer;
@property int frame;
//游戏设置参数
@property(strong, nonatomic) GameData* gameData;
//背景
@property CALayer* bgLayer1;
@property CALayer* bgLayer2;
//英雄
@property(strong, nonatomic) Hero* hero;
//子弹
@property(strong, nonatomic) NSMutableArray* bullets;
//敌人
@property(strong, nonatomic) NSMutableArray* enemys;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载资源
    [self loadSource];
    //初始化资源
    [self initSource];
    //开始游戏
    [self startGame];
}

//加载资源
-(void)loadSource {
    //初始化游戏设置参数
    self.gameData = [[GameData alloc]initWithLevel:1];
    
    //加载背景
    self.bgLayer1 = [CALayer layer];
    self.bgLayer1.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.bgLayer1.contents = (__bridge id)([[ImageSource shareImageSource]getImageWithImageType:Bg].CGImage);
    [self.view.layer addSublayer:self.bgLayer1];
    
    self.bgLayer2 = [CALayer layer];
    self.bgLayer2.frame = CGRectMake(0, -Screen_Height, Screen_Width, Screen_Height);
    self.bgLayer2.contents = (__bridge id)([[ImageSource shareImageSource]getImageWithImageType:Bg].CGImage);
    [self.view.layer insertSublayer:self.bgLayer2 below:self.bgLayer1];
    
    //加载英雄
    self.hero = [[Hero alloc]initWithFlyAnima:[[ImageSource shareImageSource]getImagesWithImagesType:HeroFly] WithHitAnima:[[ImageSource shareImageSource]getImagesWithImagesType:HeroHit] WithDeadAnima:[[ImageSource shareImageSource]getImagesWithImagesType:HeroDead]];
    [self.view addSubview:self.hero];
    
    //子弹
    self.bullets = [[NSMutableArray alloc]init];
    //敌人
    self.enemys = [[NSMutableArray alloc]init];
}
//初始化资源
-(void)initSource {
    self.frame = 0;
    //设置背景
    self.bgLayer1.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.bgLayer2.frame = CGRectMake(0, -Screen_Height, Screen_Width, Screen_Height);
    //设置英雄
    self.hero.hp = self.gameData->hero.hp;
    self.hero.speed = self.gameData->hero.speed;
    self.hero.collider = self.gameData->hero.collider;
    self.hero.fireTimeFrame = self.gameData->hero.fireTimeFrame;
    [self.hero setPosition:CGPointMake((Screen_Width-self.hero.size.width)/2, Screen_Height-self.hero.size.height)];
}
//开始游戏
-(void)startGame {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.gameData->game.gameLoopTime target:self selector:@selector(mainLoop) userInfo:nil repeats:true];
}

//游戏主循环
-(void)mainLoop {
    self.frame++;
    //移动背景
    [self moveBg];
    //碰撞检测
    [self checkCollision];
    //敌人移动
    [self moveEnemys];
    //子弹移动
    [self moveBullets];
    //创建敌人
    if(self.frame%self.gameData->game.enemyCreatFrame == 0){
        [self createEnemy];
    }
    //创建子弹
    if(self.frame%self.hero.fireTimeFrame == 0){
        Bullet* bullet = [self.hero fire];
        [self.view insertSubview:bullet belowSubview:self.hero];
        [self.bullets addObject:bullet];
    }
    
    //防止溢出
    if(self.frame > 1000) {
        self.frame = 0;
    }
}
//背景移动
-(void)moveBg {
    [self.bgLayer1 setFrame:CGRectOffset(self.bgLayer1.frame, 0, self.gameData->game.bgSpeed)];
    [self.bgLayer2 setFrame:CGRectOffset(self.bgLayer2.frame, 0, self.gameData->game.bgSpeed)];
    //判断是否出界
    if(self.bgLayer1.frame.origin.y >= Screen_Height) {
        //由于最上层的图画直接移动会造成抖动的视觉效果，所以需要先剔除，再加入最下层
        [self.bgLayer1 removeFromSuperlayer];
        [self.bgLayer1 setFrame:CGRectMake(0, self.bgLayer2.frame.origin.y - Screen_Height, Screen_Width, Screen_Height)];
        [self.view.layer insertSublayer:self.bgLayer1 below:self.bgLayer2];
    }
    if(self.bgLayer2.frame.origin.y >= Screen_Height) {
        [self.bgLayer2 removeFromSuperlayer];
        [self.bgLayer2 setFrame:CGRectMake(0, self.bgLayer1.frame.origin.y - Screen_Height, Screen_Width, Screen_Height)];
        [self.view.layer insertSublayer:self.bgLayer2 below:self.bgLayer1];
    }
}
//碰撞检测
-(void)checkCollision {
    //Sa+Sb < a+b;否则可能发生穿透问题
    //便利敌机
    for(int i=0; i<self.enemys.count; i++) {
        Enemy* enemy = [self.enemys objectAtIndex:i];
        //敌机是否与主角碰撞
        CGRect enemyRect = CGRectMake(enemy.LUposition.x, enemy.LUposition.y, enemy.collider.width, enemy.collider.height);
        CGRect heroRect = CGRectMake(self.hero.LUposition.x, self.hero.LUposition.y, self.hero.collider.width,  self.hero.collider.height);
        if(CGRectIntersectsRect(enemyRect, heroRect)) {
            [self.hero getHitWithPower:1];
            if(self.hero.isDead){
                //音乐
                //[self.audioSoucre playHeroDead];
                //[self gameOver];
                //break;
            }
            [enemy getHitWithPower:1];
            if(enemy.isDead){
                //得分
                //[self.control addScore:10];
                //播放音乐
                //[self.audioSoucre playExploreMusic];
                //移除敌人
                [enemy removeFromSuperview];
                [self.enemys removeObject:enemy];
                //数组大小发生变化
                i--;
                //敌机已死，不可能发生子弹碰撞
                continue;
            }
        }
        //敌机是否与任意一颗子弹发生碰撞
        for(int j=0; j<self.bullets.count; j++) {
            Bullet* bullet = [self.bullets objectAtIndex:j];
            CGRect bulletRect = CGRectMake(bullet.LUposition.x, bullet.LUposition.y, bullet.collider.width, bullet.collider.height);
            if(CGRectIntersectsRect(bulletRect, enemyRect)) {
                //移除子弹
                [bullet removeFromSuperview];
                [self.bullets removeObject:bullet];
                j--;
                //敌人受伤
                [enemy getHitWithPower:bullet.power];
                if(enemy.isDead) {
                    //得分
                    //[self.control addScore:10];
                    //播放音乐
                    //[self.audioSoucre playExploreMusic];
                    //移除敌人
                    [enemy removeFromSuperview];
                    [self.enemys removeObject:enemy];
                    //数组大小发生变化
                    i--;
                    break;
                }
            }
        }
    }
}
//创建敌人
-(void)createEnemy {
    int num = self.gameData->game.enemyCreatNum;
    for(int i=0; i<num; i++) {
        //创建
        Enemy* enemy = [[Enemy alloc]initWithFlyAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy1_Fly] WithHitAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy1_Hit] WithDeadAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy1_Dead]];
        //设置默认值
        enemy.hp = self.gameData->enemy1.hp;
        enemy.speed = self.gameData->enemy1.speed;
        enemy.collider = self.gameData->enemy1.collider;
        //设置随机位置
        int x = rand()%(int)(Screen_Width - enemy.size.width);
        [enemy setPosition:CGPointMake(x, -40)];
        //加入场景
        [self.view insertSubview:enemy belowSubview:self.hero];
        [self.enemys addObject:enemy];    }
}
//移动敌人
-(void)moveEnemys {
    for(int i=0; i<self.enemys.count; i++) {
        //NSLog(@"%d", i);
        Bullet* enemy = [self.enemys objectAtIndex:i];
        [enemy moveWithDirect:CGPointMake(0, 1)];
        //判断是否出界
        if(enemy.LUposition.y > Screen_Height) {
            [enemy removeFromSuperview];
            [self.enemys removeObject:enemy];
            //数组变小
            i--;
        }
    }
}
//子弹移动
-(void)moveBullets {
    for(int i=0; i<self.bullets.count; i++) {
        //NSLog(@"%d", i);
        Bullet* bullet = [self.bullets objectAtIndex:i];
        [bullet moveWithDirect:CGPointMake(0, -1)];
        //判断是否出界
        if(bullet.LUposition.y < -bullet.size.height) {
            [bullet removeFromSuperview];
            [self.bullets removeObject:bullet];
            //数组变小
            i--;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override
//手指一动控制飞机移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint newPoint = [touch locationInView:self.view];
    CGPoint oldPoint = [touch previousLocationInView:self.view];
    CGPoint offsetPoint = CGPointMake(newPoint.x - oldPoint.x, newPoint.y - oldPoint.y);

    CGPoint newPosition = CGPointMake(self.hero.LUposition.x + offsetPoint.x, self.hero.LUposition.y + offsetPoint.y);
    //出界判断
    if(newPosition.x < 0)
        newPosition.x = 0;
    else if(newPosition.x > Screen_Width - self.hero.size.width)
        newPosition.x = Screen_Width - self.hero.size.width;
    if(newPosition.y < 0)
        newPosition.y = 0;
    else if(newPosition.y > Screen_Height - self.hero.size.height)
        newPosition.y = Screen_Height - self.hero.size.height;
    //英雄移动
    [self.hero moveWithDirect:CGPointMake(newPosition.x - self.hero.LUposition.x, newPosition.y - self.hero.LUposition.y)];
}

@end

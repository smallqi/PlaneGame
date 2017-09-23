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
//游戏记录
@property(strong, nonatomic) Control* control;
//背景
@property CALayer* bgLayer1;
@property CALayer* bgLayer2;
//英雄
@property(strong, nonatomic) Hero* hero;
//子弹
@property(strong, nonatomic) NSMutableArray* bullets;
//敌人
@property(strong, nonatomic) NSMutableArray* enemys;
//敌人子弹
@property(strong, nonatomic) NSMutableArray* enemysBullets;
//道具
@property(strong, nonatomic) NSMutableArray* gifts;

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
    //[self.view insertSubview:self.hero belowSubview:self.control];
    [self.view addSubview:self.hero];
    //加载游戏记录
    self.control = [[Control alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.control];
    //子弹
    self.bullets = [[NSMutableArray alloc]init];
    //敌人
    self.enemys = [[NSMutableArray alloc]init];
    //敌人子弹
    self.enemysBullets = [[NSMutableArray alloc]init];
    //道具
    self.gifts = [[NSMutableArray alloc]init];
}
//初始化资源
-(void)initSource {
    //游戏记录
    self.control.frames = 0;
    self.control.score = 0;
    self.control.bombNum = 1;
    //设置背景
    self.bgLayer1.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.bgLayer2.frame = CGRectMake(0, -Screen_Height, Screen_Width, Screen_Height);
    //设置英雄
    self.hero.hp = [GameData shareWithLevel:1]->hero.hp;
    self.hero.speed = [GameData shareWithLevel:1]->hero.speed;
    self.hero.collider = [GameData shareWithLevel:1]->hero.collider;
    self.hero.myframes = 0;
    self.hero.bulletType = 1;
    self.hero.fireTimeFrame = [GameData shareWithLevel:1]->hero.fireTimeFrame;
    [self.hero setPosition:CGPointMake((Screen_Width-self.hero.size.width)/2, Screen_Height-self.hero.size.height)];
    [self.hero playFly];
    //背景音乐
    [[AudioSource share]playBGMusic];
}
//开始游戏
-(void)startGame {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[GameData shareWithLevel:1]->game.gameLoopTime target:self selector:@selector(mainLoop) userInfo:nil repeats:true];
}

//游戏主循环
-(void)mainLoop {
    self.control.frames++;
    [self.control updateTimeLabel];
    //移动背景
    [self moveBg];
    //碰撞检测
    [self checkCollision];
    //敌人移动
    [self moveEnemys];
    //子弹移动
    [self moveBullets];
    //敌人子弹移动
    [self moveEnemyBullets];
    
    Game gameSetData = [GameData shareWithLevel:1]->game;//游戏设置数据
    //创建敌人1
    if(self.control.frames%gameSetData.enemy1CreatFrame == 0){
        [self createEnemyWithType:EnemyType1];
    }
    //大于20s后开始创建敌人2和敌人子弹
    if(self.control.frames * gameSetData.gameLoopTime >= 10) {
        //是否能够创建
        if(self.control.frames % gameSetData.enemy2CreatFrame == 0)
            [self createEnemyWithType:EnemyType2];
        //创建敌人子弹
        [self createEnemyBullets];

    }
    //创建hero子弹
    [self createHeroBullets];
    //更新子弹面板
    self.control.bombNum = self.hero.bulletNum;
    [self.control updateBombLabel];
}
//背景移动
-(void)moveBg {
    [self.bgLayer1 setFrame:CGRectOffset(self.bgLayer1.frame, 0, [GameData shareWithLevel:1]->game.bgSpeed)];
    [self.bgLayer2 setFrame:CGRectOffset(self.bgLayer2.frame, 0, [GameData shareWithLevel:1]->game.bgSpeed)];
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
    //主角碰撞体
    CGRect heroRect = CGRectMake(self.hero.LUposition.x, self.hero.LUposition.y, self.hero.collider.width,  self.hero.collider.height);
    //便利敌机
    for(int i=0; i<self.enemys.count; i++) {
        Enemy* enemy = [self.enemys objectAtIndex:i];
        //敌机是否与主角碰撞
        CGRect enemyRect = CGRectMake(enemy.LUposition.x, enemy.LUposition.y, enemy.collider.width, enemy.collider.height);
        if(CGRectIntersectsRect(enemyRect, heroRect)) {
            [self.hero getHitWithPower:1];
            if(self.hero.isDead){
                [self deadDealWithHero];
                break;
            }
            [enemy getHitWithPower:1];
            if(enemy.isDead){
                [self deadDealWithEnemy:enemy];
                [self.enemys removeObject:enemy];
                //数组大小发生变化
                i--;
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
                    [self deadDealWithEnemy:enemy];
                    [self.enemys removeObject:enemy];
                    //数组大小发生变化
                    i--;
                    continue;
                    break;
                }
            }
        }
    }
    //遍历敌人子弹是否与主角碰撞
    for(int j=0; j<self.enemysBullets.count; j++) {
        Bullet* bullet = [self.enemysBullets objectAtIndex:j];
        CGRect bulletRect = CGRectMake(bullet.LUposition.x, bullet.LUposition.y, bullet.collider.width, bullet.collider.height);
        if(CGRectIntersectsRect(bulletRect, heroRect)) {
            //移除子弹
            [bullet removeFromSuperview];
            [self.bullets removeObject:bullet];
            j--;
            //英雄受伤
            [self.hero getHitWithPower:bullet.power];
            if(self.hero.isDead){
                [self deadDealWithHero];
                break;
            }
        }
    }
    //遍历道具是否被主角吸收
    for(int i=0; i<self.gifts.count; i++) {
        Gift *gift = [self.gifts objectAtIndex:i];
        CGRect giftRect = CGRectMake(gift.LUposition.x, gift.LUposition.y, gift.collider.width, gift.collider.height);
        if(CGRectIntersectsRect(giftRect, heroRect)) {
            //加强主角子弹
            [self.hero updateBulllet];
            //移除道具
            [gift removeFromSuperview];
            [self.gifts removeObject:gift];
            i--;
        }else {
            //减少道具滞留时间
            gift.stayTime--;
            if(gift.stayTime <= 0) {
                //移除道具
                [gift removeFromSuperview];
                [self.gifts removeObject:gift];
                i--;

            }
        }
    }
}
//创建敌人
-(void)createEnemyWithType:(EnemyType)enemyType {
    int num;
    PlaneData enemySetData; //敌机设置数据
    if(enemyType == EnemyType1) {//敌机1
        num = arc4random()%[GameData shareWithLevel:1]->game.enemy1CreatNum;
        enemySetData = [GameData shareWithLevel:1]->enemy1;
    }else {//敌机2
        num = arc4random()%[GameData shareWithLevel:1]->game.enemy2CreatNum;
        enemySetData = [GameData shareWithLevel:1]->enemy2;
    }
    
    for(int i=0; i<num; i++) {
        //创建
        Enemy* enemy;
        if(enemyType == EnemyType1) {//敌机1
            enemy = [[Enemy alloc]initWithFlyAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy1_Fly] WithHitAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy1_Hit] WithDeadAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy1_Dead]];

        }else {//敌机2
            enemy = [[Enemy alloc]initWithFlyAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy2_Fly] WithHitAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy2_Hit] WithDeadAnima:[[ImageSource shareImageSource]getImagesWithImagesType:Enemy2_Dead]];
        }
        //设置默认值
        enemy.type = enemyType;
        enemy.hp = enemySetData.hp;
        int speedOffset = enemySetData.maxSpeed - enemySetData.minSpeed;
        enemy.speed = arc4random()%speedOffset + enemySetData.minSpeed;
        enemy.collider = enemySetData.collider;
        //设置随机位置
        int x = arc4random()%(int)(Screen_Width - enemy.size.width);
        [enemy setPosition:CGPointMake(x, -40)];
        //加入场景
        [self.view insertSubview:enemy belowSubview:self.hero];
        [self.enemys addObject:enemy];    }
}
//敌人死亡处理
-(void)deadDealWithEnemy:(Enemy*)enemy {
    //得分
    self.control.score += 10;
    [self.control updateScoreLabel];
    //播放音乐
    [[AudioSource share]playExploreMusic];
    //移除敌人
    [enemy playDead];
    [self performSelector:@selector(removeViewFromGame:) withObject:enemy afterDelay:0.5];
    //是否掉落道具
    if(enemy.type == EnemyType2 && arc4random()%10 >= 10-[GameData shareWithLevel:1]->game.dropGiftChance) {
        Gift *gift = [[Gift alloc]initWithImage:[[ImageSource shareImageSource]getImageWithImageType:Gift1]];
        [gift setPosition:enemy.LUposition];
        //加入视图
        [self.view insertSubview:gift belowSubview:self.hero];
        [self.gifts addObject:gift];
    }
}
//英雄死亡处理
-(void)deadDealWithHero {
    //音乐
    [[AudioSource share]playHeroDead];
    //动画
    [self.hero playDead];
    [self gameOver];
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
//创建敌人子弹
-(void)createEnemyBullets{
    for(Enemy *enemy in self.enemys) {
        if(enemy.type == EnemyType2) {
            Bullet *enemyBullet = [enemy fireWithGameFrames:self.control.frames];
            //加入图层
            if(enemyBullet != nil) {
                [self.view insertSubview:enemyBullet belowSubview:self.hero];
                [self.enemysBullets addObject:enemyBullet];
            }
        }
    }
}
//创建英雄的子弹
-(void)createHeroBullets {
    
    NSMutableArray* bullets = [self.hero fireWithGameFrames:self.control.frames];
    for(Bullet* bullet in bullets) {
        //音乐
        [[AudioSource share]playShootMusic];
        [self.view insertSubview:bullet belowSubview:self.hero];
        [self.bullets addObject:bullet];
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
//敌人子弹移动
-(void)moveEnemyBullets {
    for(int i=0; i<self.enemysBullets.count; i++) {
        //NSLog(@"%d", i);
        Bullet* bullet = [self.enemysBullets objectAtIndex:i];
        [bullet moveWithDirect:CGPointMake(0, 1)];
        //判断是否出界
        if(bullet.LUposition.y > Screen_Height) {
            [bullet removeFromSuperview];
            [self.enemysBullets removeObject:bullet];
            //数组变小
            i--;
        }
    }
}

//游戏结束
-(void)gameOver {
    NSLog(@"GameOver");
    //停止计时器
    if(self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    //停止背景音乐
    [[AudioSource share]stopBGMusic];
    //创建警告框
    NSString* socreStr = [NSString stringWithFormat:@"得分：%d", self.control.score];
    UIAlertController* alertContoller = [UIAlertController alertControllerWithTitle:@"GameOver" message:socreStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* restratAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [self restartGame];
    }];
    [alertContoller addAction:restratAction];
    UIAlertAction* exitAction = [UIAlertAction actionWithTitle:@"退出游戏" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
        exit(0);
    }];
    [alertContoller addAction:exitAction];
    [self presentViewController:alertContoller animated:true completion:nil];
    
}

//开始游戏
-(void)restartGame {
    //从场景中删除现有的子弹和敌人
    while (self.bullets.count > 0) {
        Bullet* bullet = [self.bullets objectAtIndex:0];
        [bullet removeFromSuperview];
        [self.bullets removeObject:bullet];
    }
    while (self.enemys.count > 0) {
        Bullet* enemy = [self.enemys objectAtIndex:0];
        [enemy removeFromSuperview];
        [self.enemys removeObject:enemy];
    }
    while (self.enemysBullets.count > 0) {
        Bullet* bullet = [self.enemysBullets objectAtIndex:0];
        [bullet removeFromSuperview];
        [self.enemysBullets removeObject:bullet];
    }
    while (self.gifts.count > 0) {
        Gift *gift = [self.gifts objectAtIndex:0];
        [gift removeFromSuperview];
        [self.gifts removeObject:gift];
    }
    //重新初始化资源设置
    [self initSource];
    [self startGame];
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
-(void)removeViewFromGame:(UIView*)view {
    [view removeFromSuperview];
}
@end

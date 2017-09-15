//
//  StartViewController.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "StartViewController.h"
#import "ImageSource.h"
#import "AudioSource.h"
#import "GameViewController.h"

@interface StartViewController ()

@property(strong, nonatomic)UIImageView* loadingView;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置黑色背景
    self.view.backgroundColor = [UIColor blackColor];
    //初始化加载动画
    [self initloadingView];
    
    // Do any additional setup after loading the view.
}

//OverRide
-(void)viewDidAppear:(BOOL)animated {
    //加载资源
    [ImageSource shareImageSource];
    [AudioSource share];
    dispatch_async(dispatch_get_main_queue(), ^(){
        [NSThread sleepForTimeInterval:1];
        //进入游戏s
        [self presentViewController:[[GameViewController alloc]init] animated:true completion:nil];
    });
}

//初始化加载动画
-(void)initloadingView {
    //加载动画图片
    NSMutableArray* loadingImages = [[NSMutableArray alloc]init];
    for(int i=0; i<4; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png", i]];
        [loadingImages addObject:image];
    }
    
    self.loadingView = [[UIImageView alloc]init];
    [self.view addSubview:self.loadingView];
    //设置大小位置
    [self.loadingView setFrame:CGRectMake((self.view.frame.size.width-120) / 2, self.view.frame.size.height - 120, 120, 25)];
    //设置动画
    self.loadingView.animationImages = loadingImages;
    self.loadingView.animationRepeatCount = -1;//循环播放
    self.loadingView.animationDuration = 1;
    [self.loadingView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

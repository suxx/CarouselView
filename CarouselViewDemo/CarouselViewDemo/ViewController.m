//
//  ViewController.m
//  CarouselViewDemo
//
//  Created by suxx on 16/3/18.
//  Copyright © 2016年 suxx. All rights reserved.
//

#import "ViewController.h"
#import "CarouselView/CarouselView.h"

@interface ViewController ()<CarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CarouselView *carouselView = [[CarouselView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 200)];
    carouselView.delegate = self;
    carouselView.pics = [@[[UIImage imageNamed:@"homeView_slide1"],[UIImage imageNamed:@"homeView_slide2"],[UIImage imageNamed:@"homeView_slide3"]]mutableCopy];
    [self.view addSubview:carouselView];
}

#pragma mark---轮播图点击 delegate
-(void)clickedScrollAds:(NSDictionary *)adsInfo
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  CarouselView.h
//  DaoJiaApp
//
//  Created by suxx on 16/3/17.
//  
//  轮播图

#import "CarouselView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define VIEWHEIGHT 360/750.0*SCREEN_WIDTH

@implementation CarouselView

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

//-(instancetype)init
//{
//    if ([super init]) {
//        [self initUI];
//    }
//    return self;
//}

-(void)initUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, self.bounds.size.height)];
    _scrollView.backgroundColor = [UIColor greenColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];

    UITapGestureRecognizer *tapAds = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedAds)];
    [_scrollView addGestureRecognizer:tapAds];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, _scrollView.frame.size.height - 10.0f, SCREEN_WIDTH, 8.0f)];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:7/255.0 blue:7/255.0 alpha:1];
    [self addSubview:_pageControl];
}

#pragma mark - 轮播图点击事件
-(void)clickedAds
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedScrollAds:)]) {
        [self.delegate clickedScrollAds:self.pics[_pageControl.currentPage]];
    }
}

#pragma mark - 图片数据
-(void)setPics:(NSMutableArray *)pics
{
    if (_pics != pics) {
        _pics = pics;
    }
    [self setScrollData];//设置scrollview&pageControl
}
-(void)setScrollData
{
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*(self.pics.count+2), 0);
    _pageControl.numberOfPages = self.pics.count;
    for (int i=0; i<self.pics.count+2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i , 0, SCREEN_WIDTH, _scrollView.bounds.size.width)];
        //将要加载的图片放入imageView 中
//        NSDictionary *adsInfo = [NSDictionary dictionary];
        UIImage *image = nil;
        if(i==0)
        {
            if ([[self.pics lastObject]isKindOfClass:[UIImage class]]) {
                image = [self.pics lastObject];
            }
        }else if(i==self.pics.count+1)
        {
            if ([self.pics[0]isKindOfClass:[UIImage class]]) {
                image = self.pics[0];
            }
        }
        else
        {
            if ([[self.pics lastObject]isKindOfClass:[UIImage class]]) {
                image = self.pics[i-1];
            }
        }
        imageView.image = image;
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",image]];
//        [imageView sd_setImageWithURL:url placeholderImage:kImageNamed(@"banner_default.jpg") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);//从第二张开始播
    [self addTimer];//设置定时器
}

#pragma mark - 定时器
-(void)addTimer
{
    if (![self.scrollTimer isValid]) {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage:) userInfo:nil repeats:YES];
    }
}
-(void)removeTimer
{
    if ([self.scrollTimer isValid]) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

-(void)nextImage:(NSTimer *)timer
{
    //循环轮播 根据真实页码判断
    int realPage = (int)floor(_scrollView.contentOffset.x / SCREEN_WIDTH);
    if ( realPage == self.pics.count ) {
        [UIView animateWithDuration:0.5f animations:^{
            _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * (realPage + 1), 0.0f);
        } completion:^(BOOL f){
            _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0.0f);
        }];
    }else{
        [UIView animateWithDuration:0.5f animations:^{
            _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * (realPage + 1), 0.0f);
        }];
    }
}

#pragma mark - scrollview delegate
// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int realPage = (int)(scrollView.contentOffset.x / SCREEN_WIDTH) ;
    if (realPage==self.pics.count+1) {
        _pageControl.currentPage = 0;
    }else if(realPage==0)
    {
        _pageControl.currentPage = self.pics.count-1;
    }
    else
    {
        _pageControl.currentPage = realPage-1;
    }

}
// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    [self removeTimer];

}
//停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
//拖拽完手指抬起
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int realPage = (int)floor(_scrollView.contentOffset.x / SCREEN_WIDTH);
    if ( realPage == self.pics.count+1 ) {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0.0f);
    }else if (realPage == 0) {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * self.pics.count, 0.0f);
    } else{
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * (realPage), 0.0f);
    }
}
@end

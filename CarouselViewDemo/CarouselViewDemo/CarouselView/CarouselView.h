//
//  CarouselView.h
//  DaoJiaApp
//
//  Created by suxx on 16/3/17.
//  
//  轮播图

#import <UIKit/UIKit.h>

@protocol CarouselViewDelegate <NSObject>
-(void)clickedScrollAds:(NSDictionary *)adsInfo;
@end

@interface CarouselView : UIView <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@property (nonatomic,strong) NSMutableArray *pics;//轮播内容
@property (nonatomic,weak) NSTimer *scrollTimer;
@property (nonatomic,assign) id<CarouselViewDelegate> delegate;

-(void)addTimer;
-(void)removeTimer;

@end

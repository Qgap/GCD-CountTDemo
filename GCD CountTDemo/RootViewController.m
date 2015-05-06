//
//  RootViewController.m
//  GCD CountTDemo
//
//  Created by jerry_zhao on 15-4-30.
//  Copyright (c) 2015年 gq. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
    dispatch_source_t timer;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *begainBtn;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isPause;
@property (nonatomic) BOOL isCreat;
@property (nonatomic,assign) int timeCount;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _timeCount = 0;
 }
   
/**
 *  点击开启定时器，再点停止
 *
 *  @param sender
 */
- (IBAction)startCount:(UIButton *)sender {
    if (!_isStart) {
        [self startToCountTime];
        _isPause = NO;
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    
    }else
    {
        dispatch_suspend(timer);
        _isPause = YES;
       [sender setTitle:@"继续" forState:UIControlStateNormal];
    }
    
    _isStart = !_isStart;
    
}

/**
 *  结束定时器前，一定要先将suspend 的dispatch 先resume ，再cancel---
 *
 *  @param sender
 */
- (IBAction)endCount:(UIButton *)sender {
if (_isCreat){
    if (_isPause == YES) {
        dispatch_resume(timer);

    }
    dispatch_source_cancel(timer);
    [_begainBtn setTitle:@"开始" forState:UIControlStateNormal];
    _timeLabel.text = @"00:00:00";
    _isStart = NO;
    _timeCount = 0;
    _isCreat = NO;
    }
}
/**
 *  <#Description#>
 */
- (void)startToCountTime
{
    if ([_begainBtn.titleLabel.text isEqualToString:@"开始"]) {
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
        _isCreat = YES;
    }

//    每秒执行一次
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        int hours = _timeCount / 3600;
        int minutes = (_timeCount - (3600*hours)) / 60;
        int seconds = _timeCount%60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minutes,seconds];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//           ======在这根据自己的需求去刷新UI==============
            _timeLabel.text = strTime;
            
        });
        _timeCount ++;
    });
    
    dispatch_resume(timer);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

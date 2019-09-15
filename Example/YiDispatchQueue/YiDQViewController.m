//
//  YiDQViewController.m
//  YiDispatchQueue
//
//  Created by coderyi on 09/15/2019.
//  Copyright (c) 2019 coderyi. All rights reserved.
//

#import "YiDQViewController.h"
#import "YiDispatchQueue.h"
@interface YiDQViewController ()
@property (nonatomic, strong) YiDispatchQueue *queue;
@end


@implementation YiDQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _queue = [[YiDispatchQueue alloc] init];
    [_queue dispatch:^{
        NSLog(@"hello, this is test queue");
    }];
    
    [[YiDispatchQueue concurrentDefaultQueue] dispatch:^{
        NSLog(@"hello, this is test concurrent queue");
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

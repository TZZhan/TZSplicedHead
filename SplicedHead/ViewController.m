//
//  ViewController.m
//  SplicedHead
//
//  Created by Tzhan on 15/7/23.
//  Copyright (c) 2015年 XiaoJian. All rights reserved.
//

#import "ViewController.h"
#import "TZSplicedHead.h"

@interface ViewController () <TZSplicedHeadDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic, strong) TZSplicedHead *spliceHead;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {
    NSArray *imageArr = @[
                          @"http://ltzmaxwell.qiniudn.com/FgiowZRjp1bKNRQs0ZH0XjpdHMG5",
                          @"http://ltzmaxwell.qiniudn.com/FrSGBGb9AiT6VN-nU_Y8taPpaKpV",
                          @"http://ltzmaxwell.qiniudn.com/Fl1VVm41wb-0A-iZFzru7OIwUj66",
                          @"http://ltzmaxwell.qiniudn.com/FrAdFtCUyhC14k9rgpEZNVF4hHy4",
                          @"http://ltzmaxwell.qiniudn.com/FniRkhwAAsNcGz9G8kP3zgUQc9p2",
                          @"http://ltzmaxwell.qiniudn.com/Fuv3_bFw3uVPf4IswWZS0ey2jGnb",
                          @"http://ltzmaxwell.qiniudn.com/FpCtGp8IgXOjqFG-ofuWo19MRg3f",
                          @"http://ltzmaxwell.qiniudn.com/Fs8c3szyH0i16F5JBRoFnhpSC8Lc",
                          @"http://ltzmaxwell.qiniudn.com/Fgnq9Jjv8edbomcG3VlsBunmLwBG"
                          ];
    TZSplicedHead *splicedHead = [[TZSplicedHead alloc] init];
    self.spliceHead = splicedHead;
    splicedHead.delegate = self;
    [splicedHead spliceHeadWithImageArr:imageArr];
}

- (void)splicedHead:(TZSplicedHead *)splicedHead headImage:(UIImage *)headImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headImageView.image = headImage;
    });
}

@end

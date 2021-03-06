//
//  WWRecordedDetailsViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/5.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWRecordedDetailsViewController.h"
#import "WWRecordedIntroducedTableViewCell.h"
#import "WWTabBarView.h"
#import "WWPayView.h"
#import "WWUtils.h"
#import "KRVideoPlayerController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "Pingpp.h"
#import "WWRecordedDetailsServices.h"
#import "SVProgressHUD.h"
#import "NSUserDefaults+Signin.h"
#import "WWLiveMenberTableViewCell.h"
#import "WWLiveDetailsFootView.h"
#import "WWRecordedVideoImageView.h"
#import "WWPlayerView.h"
#import "WWPromptView.h"
#import "WWVideoService.h"


#define COLOR_GREEN     UIColorFromRGB(0x0AC653);

typedef enum : NSUInteger {
    kVideoTypeFree = 0,
    kVideoTypeFee,
} kVideoType;

typedef enum : NSUInteger {
    kPlayTypesLive = 0,
    kPlayTypesRecorded,
} kPlayTypes;

//static const NSInteger kPayStatusDidnBuy = 0;


@interface WWRecordedDetailsViewController () <UITableViewDelegate, UITableViewDataSource, PayViewDelegate, KRVideoPlayerDelegate, WWPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelVideoType;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayCount;
@property (strong, nonatomic) UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic) CGSize size;
@property (nonatomic, strong) KRVideoPlayerController *videoController;
@property (nonatomic, strong) WWTabBarView *tabBarView;
@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;

@property (strong, nonatomic) WWLiveDetailsFootView *footView;
@property (strong, nonatomic) WWPlayerView *playerView;
@property (nonatomic, strong) WWRecordedVideoImageView *recordedVideoImageView;
@property (nonatomic, strong) UILabel *tipsShowLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation WWRecordedDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD show];
    __weak __block typeof(self) weakSelf = self;
    [WWVideoService requestVideoDetail:self.video.aid resultBlock:^(WWVideoModel *videoModel, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            weakSelf.video = videoModel;
            [weakSelf initialize];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取视频详情失败"];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [WWRecordedDetailsServices postLeave:self.video.aid resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - KRVideoPlayer Delegate

- (void)videoFullScreenButtonClick {
    self.btnBack.hidden = YES;
}

- (void)videoShrinkScreenButtonClick {
    self.btnBack.hidden = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)liveVideoFullScreenButtonClick {
    self.btnBack.hidden = YES;
    self.tabBarView.hidden = YES;
}

- (void)liveVideoShrinkScreenButtonClick {
    self.btnBack.hidden = NO;
    self.tabBarView.hidden = NO;
}

#pragma mark - PayView Delegate
//支付方式和金额
- (void)choicePaymentClick:(kPayment)payment andMoney:(NSString *)money andMethod:(kMethod)method {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(self.video.activityType) forKey:@"payType"];
    [dic setObject:money forKey:@"amount"];
    [dic setObject:self.video.aid forKey:@"aid"];
    
    if (payment == kPaymentAliPay) {
        [dic setObject:@"alipay" forKey:@"channel"];
    } else {
        [dic setObject:@"wx" forKey:@"channel"];
    }
    __weak __block typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [WWRecordedDetailsServices requestPay:dic resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        if (!error) {
            [Pingpp createPayment:baseModel.data
                   viewController:self
                     appURLScheme:@"test"
                   withCompletion:^(NSString *result, PingppError *error) {
                       if ([result isEqualToString:@"success"]) {
                           //购买成功变更按钮为打赏
                           [self.tabBarView setRightButtonTitle:@"打赏红包" andBackgroundImageString:@"btn_reward"];
                           [self.tabBarView.rightButton addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
                           //支付成功弹窗提示
                           WWPromptView *promptView = [WWPromptView loadFromNib];
                           if (method == kMethodATip) {
                               [promptView showPromptType:MyPromptATip];
                           } else {
                               [promptView showPromptType:MyPromptSuccess];
                           }
                           [weakSelf.view addSubview:promptView];
                           [SVProgressHUD dismiss];
                           //成功后刷新下视频详情
                           __weak __block typeof(self) weakSelf = self;
                           [WWVideoService requestVideoDetail:self.video.aid resultBlock:^(WWVideoModel *videoDetail, NSError *error) {
                               if (!error) {
                                   weakSelf.video = videoDetail;
                                   weakSelf.playerView.video = videoDetail;
//                                   [weakSelf.view updateConstraintsIfNeeded];
                               }
                           }];
                           
                           if (self.video.streamType == kPlayTypesLive) {
                               [self addPlayerView];
                           } else {
                               [self playVideoWithURL:[NSURL URLWithString:self.video.videoPath]];
                           }
                           [self.recordedVideoImageView removeAllSubviews];
                           [self.view addSubview:self.btnBack];
                       } else {
                           // 支付失败或取消
                           NSLog(@"Error: code=%zd msg=%@", error.code, [error getMsg]);
                           [SVProgressHUD showErrorWithStatus:[error getMsg]];
                       }
                   }];
        } else {
            [SVProgressHUD showErrorWithStatus:baseModel.msg];
        }
    }];
}

#pragma mark - Private Method
- (void)initialize {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(SCREEN_WIDTH*(9.0/16.0), 0, 49, 0);
    }];
    self.labelTitle.text = self.video.title;
    self.labelTime.text = [NSString stringWithFormat:@"时间：%@",self.video.date];
    self.labelPlayCount.text = [NSString stringWithFormat:@"播放：%zd次",self.video.playCount];
    self.tableView.estimatedRowHeight = 137;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.labelVideoType.text = self.video.owner.nickname;
    [self.ownerImageView setImageURL:[NSURL URLWithString:self.video.owner.avatar]];
    
    [self addTabBarView];
    [self initTipsView];
    [self postPlayHistory];
    [self.view addSubview:self.videoController.view];
    
    //最后加上避免挡住
    [self addButtonBack];
    
    [WWRecordedDetailsServices postJoin:self.video.aid resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        
    }];
    [self.tableView reloadData];
}

- (void)showmenberList:(NSArray *)menberList menberCount:(NSNumber *)menberCount {
    if (menberList.count < 5) {
        self.footView = [[WWLiveDetailsFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115) names:menberList menberCount:menberCount];
    } else {
        self.footView = [[WWLiveDetailsFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215) names:menberList menberCount:menberCount];
    }
    [self.tableView setTableFooterView:self.footView];
}

//不同类型视频展示预约或购买人数
- (void)initTipsView {

    
    if (self.video.streamType == kPlayTypesLive) {
        if (self.video.activityType == kVideoTypeFee) {

            UILabel *tipsShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-220, 40, 200, 24)];
            tipsShowLabel.textAlignment = NSTextAlignmentRight;
            tipsShowLabel.textColor = UIColorFromRGB(0x0AC653);
            tipsShowLabel.font = [UIFont systemFontOfSize:20];
            
            NSString *str = [NSString stringWithFormat:@"¥%.2lf", self.video.price / 100];
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
            [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
            tipsShowLabel.attributedText = attriString;
            [self.topView addSubview:tipsShowLabel];
        }
    } else {

        if (self.video.activityType == kVideoTypeFee) {
            UILabel *tipsShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-220, 40, 200, 24)];
            tipsShowLabel.textAlignment = NSTextAlignmentRight;
            tipsShowLabel.textColor = UIColorFromRGB(0x0AC653);
            tipsShowLabel.font = [UIFont systemFontOfSize:20];
            
            NSString *str = [NSString stringWithFormat:@"¥%.2lf", self.video.price / 100];
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
            [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
            tipsShowLabel.attributedText = attriString;
            [self.topView addSubview:tipsShowLabel];
            
        }
    }
}

- (UILabel *)tipsShowLabel {
    if (!_tipsShowLabel) {
        _tipsShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-220, 80, 200, 24)];
        _tipsShowLabel.textAlignment = NSTextAlignmentRight;
        _tipsShowLabel.font = [UIFont systemFontOfSize:14];
        _tipsShowLabel.textColor = UIColorFromRGB(0xA0A0A0);
    }
    return _tipsShowLabel;
}

- (void)addLabelType:(NSInteger)type {
    
    NSString *string;
    NSString *str;
    
    if (type == 0) {
        string = [NSString stringWithFormat:@"%zd",self.video.appointmentCount];
        str = [NSString stringWithFormat:@"已有 %@ 人预约",string];
    } else {
        string = [NSString stringWithFormat:@"%zd",self.video.onlineCount];
        str = [NSString stringWithFormat:@"在线 %@ 人",string];
    }
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
    [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3,string.length)];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4A90E2) range:NSMakeRange(3, string.length)];
    self.tipsShowLabel.attributedText = attriString;
    [self.topView addSubview:self.tipsShowLabel];
}

- (void)addPlayerView {
    self.playerView = [[WWPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (9.0/16.0)) VideoModel:self.video];
    self.playerView.delegate = self;
    [self.view addSubview:self.playerView];
}

- (void)addRecordedVideoImageView {
    __weak __block typeof(self) weakSelf = self;
    self.recordedVideoImageView = [[WWRecordedVideoImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (9.0/16.0)) imageURL:weakSelf.video.frontCover isButton:YES clickBlock:^{
        if (weakSelf.video.payState == 0) {
            if ([NSUserDefaults standardUserDefaults].userToken.length == 0) {
                [WWUtils showLoginVCWithTargetVC:self];
                return;
            }
            
            [self showPayViewMethod:kMethodBuy andPayAmount:[NSString stringWithFormat:@"%.2lf",self.video.price / 100]];
        }
    }];
    self.recordedVideoImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.recordedVideoImageView];
}

- (void)addVideoImageViewType:(NSInteger)type {
    __weak __block typeof(self) weakSelf = self;
    WWRecordedVideoImageView *recordedVideoImageView = [[WWRecordedVideoImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (9.0/16.0)) imageURL:weakSelf.video.frontCover isButton:NO clickBlock:^{
        if (type == 0) {
            [WWUtils showTipAlertWithTitle:@"敬请期待" message:@"直播尚未开始"];
        } else if (type == 1) {
            [WWUtils showTipAlertWithTitle:@"直播结束" message:@""];
        }
    }];
    recordedVideoImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:recordedVideoImageView];
}

+ (NSMutableAttributedString *)stringConversionAttributedString:(NSString *)string {
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(3,4)];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x878787) range:NSMakeRange(3, 4)];
    return attriString;
}

//根据不同类型视频底部展示预约或者购买
- (void)addTabBarView {
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
    self.tabBarView = [WWTabBarView loadFromNib];
    self.tabBarView.frame = frame;
    
    if (self.video.streamType == kPlayTypesLive) {
        
        switch (self.video.activityState) {
            case 0:
                [self addVideoImageViewType:0];
                if (self.video.appoinState == 0) {
                    [self.tabBarView setRightButtonTitle:@"预约" andBackgroundImageString:@"btn_reservation"];
                    [self.tabBarView.rightButton addTarget:self action:@selector(appointmentClick) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    [self.tabBarView setRightButtonTitle:@"已预约" andBackgroundImageString:@"btn_done"];
                    self.tabBarView.rightButton.userInteractionEnabled = NO;
                }
                [self addLabelType:0];
                break;
            case 1: {
                if (self.video.activityType == kVideoTypeFree) {
                    [self.tabBarView setRightButtonTitle:@"打赏红包" andBackgroundImageString:@"btn_reward"];
                    [self addPlayerView];
                } else {
                    if (self.video.payState == 0) {
                        [self.tabBarView setRightButtonTitle:@"购买观看" andBackgroundImageString:@"btn_buy"];
                        [self addRecordedVideoImageView];
                    } else {
                        [self.tabBarView setRightButtonTitle:@"打赏红包" andBackgroundImageString:@"btn_reward"];
                        [self addPlayerView];
                    }
                }
                [self.tabBarView.rightButton addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addLabelType:1];
                
                self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(refreshMemberList) userInfo:nil repeats:YES];
                
                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            }
                break;
            case 2:
                [self addVideoImageViewType:1];
                [self.tabBarView setRightButtonTitle:@"已结束" andBackgroundImageString:@"btn_done"];
                self.tabBarView.rightButton.userInteractionEnabled = NO;
                break;
                
            default:
                break;
        }
    } else {//点播
        [self checkPayment];
    }
    
    NSNumber *isRelease = [[NSUserDefaults standardUserDefaults] objectForKey:kIsRelase];
    if ([isRelease boolValue]) {
        return;
    }
    
    [self.tabBarView.btnShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tabBarView];
}

- (void)refreshMemberList {
    [WWRecordedDetailsServices postMemberList:self.video.aid resultBlock:^(NSArray *menberList, NSError *error) {
        if (!error) {
            if (menberList != nil && ![menberList isKindOfClass:[NSNull class]] && menberList.count != 0) {
                NSString *string = [NSString stringWithFormat:@"%zd",menberList.count];
                NSString *str = [NSString stringWithFormat:@"在线 %@ 人",string];
                NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
                [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3,string.length)];
                [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4A90E2) range:NSMakeRange(3, string.length)];
                self.tipsShowLabel.attributedText = attriString;
            }
        }
    }];
}

- (void)checkPayment {
    
    if (self.video.activityType == kVideoTypeFee) {
        if (self.video.payState == 0) {
            [self.tabBarView setRightButtonTitle:@"购买观看" andBackgroundImageString:@"btn_buy"];
                [self addRecordedVideoImageView];
        } else {
            [self.tabBarView setRightButtonTitle:@"打赏红包" andBackgroundImageString:@"btn_reward"];
            [self playVideoWithURL:[NSURL URLWithString:self.video.videoPath]];
        }
    } else {
        [self.tabBarView setRightButtonTitle:@"打赏红包" andBackgroundImageString:@"btn_reward"];
        [self playVideoWithURL:[NSURL URLWithString:self.video.videoPath]];
    }
    [self.tabBarView.rightButton addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
}
//录播播放器
- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0)) video:self.video];
        self.videoController.delegate = self;
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController showInWindow];
        [self.videoController.view addSubview:self.btnBack];
    }
    self.videoController.contentURL = url;
}

- (void)addButtonBack {
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(5, 13, 48, 48)];
    [self.btnBack setImage:[UIImage imageNamed:@"ic_back_detail"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnBack];
}

- (void)popVC {

    [self.videoController dismiss];
    self.videoController = nil;
    [self.playerView shutdown];
    [self.playerView removeAllSubviews];
    self.playerView = nil;
    [self.timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postPlayHistory {
    [WWRecordedDetailsServices requestPlayHistory:self.video.aid resultBlock:^(NSError *error) {
        
    }];
}

#pragma mark - IBActions
- (void)showPayViewMethod:(kMethod)method andPayAmount:(NSString *)payAmount {
    WWPayView *payView = [WWPayView loadFromNib];
    [payView selectMethodOfPayment:method andPayAmount:payAmount];
    payView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    payView.delegate = self;
    [self.view addSubview:payView];
}

- (void)shareClick {
    NSArray* imageArray = @[self.video.frontCover];
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSString *share = [NSString stringWithFormat:@"http://www.weiwanglive.com/share.html?aid=%@&icode=%@",self.video.aid, [[NSUserDefaults standardUserDefaults] inviteCode]];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.video.desc
                                         images:imageArray
                                            url:[NSURL URLWithString:share]
                                          title:self.video.title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}

- (void)appointmentClick {
    
    if ([NSUserDefaults standardUserDefaults].userToken.length == 0) {
        [WWUtils showTipAlertWithMessage:@"请先登录"];
        [WWUtils showLoginVCWithTargetVC:self];
        return;
    }
    [SVProgressHUD show];
    __weak __block typeof(self) weakSelf = self;
    [WWRecordedDetailsServices requestAppointment:self.video.aid resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            if (baseModel.ret == KERN_SUCCESS) {
                [weakSelf.tabBarView setRightButtonTitle:@"已预约" andBackgroundImageString:@"btn_done"];
                weakSelf.tabBarView.rightButton.userInteractionEnabled = NO;
                WWPromptView *promptView = [WWPromptView loadFromNib];
                [promptView showPromptType:MyPromptAppointment];
                [weakSelf.view addSubview:promptView];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
}

- (void)aTipClick {
    //打赏金额传nil
    [self showPayViewMethod:kMethodATip andPayAmount:nil];
}

- (void)buyClick:(UIButton *)button {
    if ([NSUserDefaults standardUserDefaults].userToken.length == 0) {
        [WWUtils showLoginVCWithTargetVC:self];
        return;
    }
    if ([button.titleLabel.text isEqualToString:@"打赏红包"]) {
        [self showPayViewMethod:kMethodATip andPayAmount:nil];
    } else if ([button.titleLabel.text isEqualToString:@"购买观看"]) {
        [self showPayViewMethod:kMethodBuy andPayAmount:[NSString stringWithFormat:@"%.2lf",self.video.price / 100]];
    }
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    if (indexPath.section == 0) {
        WWRecordedIntroducedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Details Introduced" forIndexPath:indexPath];
        [cell autoLayoutHeight:self.video.desc];
        return cell;
//    } else {
//        WWLiveMenberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Menber Cell" forIndexPath:indexPath];
//        [cell setMenber:self.menberList];
//        return cell;
//    }
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

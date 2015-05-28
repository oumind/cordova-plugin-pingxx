#import "OUMPingxx.h"
#import "Pingpp.h"

@implementation OUMPingxx


- (void)createPayment:(CDVInvokedUrlCommand*)command
{

    NSString* data = [[command arguments] objectAtIndex:0];
    NSLog(@"%@", data);
    
    UIViewController * __weak weakSelf = self.viewController;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Pingpp createPayment:data viewController:weakSelf
                appURLScheme:@"oumind"
                withCompletion:^(NSString* result, PingppError* error) {
            //渠道为银联、百度钱包或者渠道为支付宝但未安装支付宝钱包时，从此返回
            NSLog(@"completion block: %@", result);

            [self finishPay:result error:error];
        }];
    });
}

//渠道为微信、支付宝且安装了支付宝钱包或者测试模式时，从此返回
- (void)handleOpenURL:(NSNotification*)notification
{
    NSURL* url = [notification object];
    
    NSLog(@"handleOpenURL: %@", [url description]);
    
    if (![url isKindOfClass:[NSURL class]]) {
        return;
    }
    
    [Pingpp handleOpenURL:url withCompletion:^(NSString* result, PingppError* error) {
        [self finishPay:result error:error];
    }];
}

/**
 ** result : success, fail, cancel, invalid
 **/
- (void) finishPay:(NSString*)result error:(PingppError*) error
{
    if (error == nil) {
        NSLog(@"PingppError is nil");
    } else {
        NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
    }
    
    NSString* jsString = [NSString stringWithFormat:@"%@('%@',%lu,'%@');",
                          @"cordova.require('io.oumind.cordova.pingxx.pingxx')._finishPay",
                          result,
                          (unsigned long)error.code,
                          [error getMsg]
                          ];
    [self.commandDelegate evalJs:jsString];
}
@end

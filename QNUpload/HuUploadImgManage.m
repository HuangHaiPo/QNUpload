//
//  HuUploadImgManage.m
//  HuPersonalCenterKit
//
//  Created by Leon on 2019/4/18.
//

#import "HuUploadImgManage.h"
#import "QiniuSDK.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"


@implementation HuUploadImgManage

//获取当前手机时间
+ (NSString *)currtenDateTimeStr{
    NSDateFormatter *formatter;
    NSString *dateStr;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [formatter stringFromDate:[NSDate date]];
    return dateStr;
}
//获取随机字符串，用于生成文件名称
+ (NSString*)randomStringWithLength:(int)len{
    NSString * letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString * randomString = [NSMutableString stringWithCapacity:len];
    for(int i = 0; i < len; i++){
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}
//传进去获取token的yURL 找后台要
+ (void)qiNiuUploadToken:(NSString *)aTokenUrl{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:aTokenUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
+ (void)uploadSingleImage:(NSData *)imageDate token:(NSString *)token success:(successBlock)success failure:(failureBlock)failure{

    if (!imageDate) {
        if (failure) {
            failure(@"图片不存在");
        }
        return;
    }
    //生成文件名称，调用上面的时间函数，和随机字符串函数
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.png",[HuUploadImgManage currtenDateTimeStr],[HuUploadImgManage randomStringWithLength:8]];
    QNUploadManager *qnManager = [[QNUploadManager alloc]init];
    [qnManager putData:imageDate key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.isOK) {
            //成功后返回图片URL
            NSString *url = [NSString stringWithFormat:@"%@/%@",@"链接需要自己拼接好传给后台",resp[@"key"]];
            if (success) {
                success(url);
            }
        }else{
            if (failure) {
                failure(@"");
            }

        }
    } option:nil];
}
+ (void)uploadMuchImage:(NSArray *)imageArrayDate view:(UIView *)view token:(NSString *)token success:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = NSLocalizedString(@"上传中...", @"HUD loading title");
    NSString *tempStr = [NSString stringWithFormat:@"图片\n(%lu/0)",(unsigned long)imageArrayDate.count];
    hud.detailsLabelText = NSLocalizedString(tempStr, @"HUD title");
    
    __block NSUInteger currentIndex = 0;
    NSMutableArray * qnImgArray = @[].mutableCopy;
    HuUploadImgTool * uploadTool = [HuUploadImgTool sharedHuUploadImgTool];
    __weak typeof(uploadTool) weakTool = uploadTool;
    weakTool.uploadImgSuccessBlock = ^(NSString * _Nonnull qnUrl) {
        [qnImgArray addObject:qnUrl];
        currentIndex++;
        NSString *tempStr = [NSString stringWithFormat:@"图片\n(%lu/%lu)",(unsigned long)imageArrayDate.count,(unsigned long)currentIndex];
        hud.detailsLabelText = NSLocalizedString(tempStr, @"HUD title");
        if([qnImgArray count] == [imageArrayDate count]) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                });
            });
            success([qnImgArray copy]);
            return;
        }else{
            [HuUploadImgManage uploadSingleImage:imageArrayDate[currentIndex] token:token success:weakTool.uploadImgSuccessBlock failure:weakTool.uploadImgFailureBlock];
        }
    };
    weakTool.uploadImgFailureBlock = ^(NSString * _Nonnull message) {
        failure(@"上传失败!");
        return ;
    };
    [HuUploadImgManage uploadSingleImage:imageArrayDate[0] token:token success:weakTool.uploadImgSuccessBlock failure:weakTool.uploadImgFailureBlock];
}





 + (void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token keys:(void(^)(NSMutableArray *keys))keys{
     NSMutableArray *imgKeys = @[].mutableCopy;
     __block NSInteger imageIndex = index;
     NSData *data = images[index];
     NSString *fileName = [NSString stringWithFormat:@"%@_%@.png",[HuUploadImgManage currtenDateTimeStr],[HuUploadImgManage randomStringWithLength:8]];
     QNUploadManager *qnManager = [[QNUploadManager alloc]init];
     [qnManager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
         if (info.isOK) {
             NSString *url = [NSString stringWithFormat:@"%@/%@",@"链接需要自己拼接好传给后台",resp[@"key"]];
             [imgKeys addObject:url];
             imageIndex++;
             if (imageIndex >= images.count) {
                 keys(imgKeys);
             }else{
                 [self uploadImages:images atIndex:imageIndex token:token keys:nil];
             }
         }
     } option:nil];

 }
 

@end


@implementation HuUploadImgTool

singleton_implementation(HuUploadImgTool)



@end

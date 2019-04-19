//
//  HuUploadImgManage.h
//  HuPersonalCenterKit
//
//  Created by Leon on 2019/4/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "singleton.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^successBlock)(NSString *imgUrl);
typedef void(^failureBlock)(NSString *message);


@class HuUploadImgTool;

@interface HuUploadImgManage : NSObject


/**
 获取七牛token

 @param aTokenUrl 获取token的URL
 */
+ (void)qiNiuUploadToken:(NSString *)aTokenUrl;



/**
 单张上传图片

 @param imageDate 图片
 @param token token
 @param success 上传成功
 @param failure 上传失败
 */
+ (void)uploadSingleImage:(NSData *)imageDate token:(NSString *)token success:(successBlock)success failure:(failureBlock)failure;

/**
 多张图片上传

 @param imageArrayDate 图片数组
 @param view 把进度显示到View上
 @param token token
 @param success 上传成功
 @param failure 上传失败
 */
+ (void)uploadMuchImage:(NSArray *)imageArrayDate view:(UIView *)view token:(NSString *)token success:(void(^)(NSArray *imgArrayUrl))success failure:(void(^)(NSString *message))failure;

+ (void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token keys:(void(^)(NSMutableArray *keys))keys;


@end

@interface HuUploadImgTool : NSObject

singleton_interface(HuUploadImgTool)

@property(copy,nonatomic) void(^uploadImgSuccessBlock)(NSString *qnUrl);

@property(copy,nonatomic) void(^uploadImgFailureBlock)(NSString *message);


@end




NS_ASSUME_NONNULL_END

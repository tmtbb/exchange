//
//  UUID.m
//  wp
//
//  Created by sum on 2017/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

#import "UUID.h"
#import "KeyChainStore.h"
#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define  KEY_USERNAME @"deviceKeyId"
#define  KEY_PASSWORD @"deviceKey"

@implementation UUID

+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[KeyChainStore load:@"com.company.app.usernamepassword"];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}
+(NSString *)getData:(NSString *)withKey{
    
    NSString * str = (NSString *)[KeyChainStore load:withKey];
    return str;

}
+(void)saveUUID :(NSString *)deviceID withKey:(NSString *)withKey
{
     [KeyChainStore save:withKey data:deviceID];
}
+(void)saveDataWith:(NSString *)data{

}
//判断本地是否有deciceid
+(BOOL)cheDevivce:(NSString *)key{

    NSString * strUUID = (NSString *)[KeyChainStore load:key];
    if ([strUUID isEqualToString:@""] || !strUUID){
    
        return  NO;
    }

    return YES;

}



@end

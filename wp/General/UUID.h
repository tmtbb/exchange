//
//  UUID.h
//  wp
//
//  Created by sum on 2017/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUID : NSObject
+(NSString *)getUUID;
+(void)saveUUID :(NSString *)deviceID withKey:(NSString *)withKey;

+(BOOL)cheDevivce:(NSString *)key;
+(NSString *)getData:(NSString *)withKey;
@end

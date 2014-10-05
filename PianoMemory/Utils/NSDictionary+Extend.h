//
//  NSDictionary+Extend.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-9-23.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extend)

/**
 *	@brief	返回非 NSNull 的值（若为 NSNull，则返回 nil）
 *
 *	@param 	key 	key
 *
 *	@return	key 对应的值
 */
- (id)zb_objectForKeyNotNull:(id)key;

@end

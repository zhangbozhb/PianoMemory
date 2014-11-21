//
//  HCObject.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCRKProtocol <NSObject>

@required
/*restkit object mapping*/
+ (id)rkObjectMapping;
+ (id)rkObjectMappingWithPropertyNames:(NSArray *)propertyNames;

/* 返回 reskit 响应 descriptors*/
+ (NSArray *)rkResponseDescriptors;
/* 返回 reskit 请求 descriptors*/
+ (NSArray *)rkRequestDescriptors;

@optional
/* reskit 解析 jsondata ，返回相关类型*/
+ (id)rkParseJsonData:(NSData*)jsonData;
/* reskit 序列化对象*/
- (NSData *)rkToJsonData;

@end

@protocol HCSyncProtocol <NSObject>

@required
- (NSString *)syncLocalId;
- (NSString *)syncRemoteId;
- (NSInteger )syncVersion;

- (void )setSyncLocalId:(NSString *)localId;
- (void )setSyncRemoteId:(NSString *)remoteId;
- (void)setSyncVersion:(NSInteger)version;

@optional
- (NSString *)syncCreateLocalId;

@end

@interface HCObject : NSObject <NSCoding, NSCopying, HCRKProtocol, HCSyncProtocol>

/**
 * 获取对象inspection 结果
 * 返回 propertyName:  inspection(dictionary)
 **/
+ (NSDictionary*)classPropertyInspections;          //所有 property
+ (NSDictionary*)classMutablePropertyInspections;   //只返回可修改的

+ (NSArray*)classPropertyNames;          //所有 property
+ (NSArray*)classMutablePropertyNames;   //只返回可修改的
/* 将propertyName 做适当的转化，用于 mapping 映射（默认是返回本身，该函数通常需要 override）*/
+ (NSString *)convertPropertyName:(NSString *)string;
/* 获取列表中未转换前的 propertyName（如果对应的 propertyName 不存在，则不放回该 propertyName） */
+ (NSArray *)propertyNamesBeforeConvert:(NSArray*)convertedPropetyNames;


/*将 property 转化为 restkit 使用的 mapping dict*/
+ (NSDictionary *)convertToRestKitMappingDictionary:(NSArray *)properties isRequest:(BOOL)isRequest;
/*将 property 转化为 restkit 使用的 mapping dict, 只返回 array 中的，如果 array 为空则返回全部*/
+ (NSDictionary *)restkitMappingDictionaryForRequestFromRequestParams:(NSArray *)params;

/**
 *	@brief	浅复制 object 的属性到自身
 *
 *	@param 	obj     输入的 object
 */
- (void)shallowCopyValue:(HCObject *)obj;

/**
 *	@brief	浅复制 object 的属性到自身
 *
 *	@param 	obj 	输入的 object
 *	@param 	copyClass 	object 指定类型
 */
- (void)shallowCopyValue:(HCObject *)obj copyClass:(Class)copyClass;

/**
 *	@brief	更新同步信息
 *
 *	@param 	obj 	同步后的信息
 */
- (void)updateSyncedInfo:(HCObject*)obj;

@end

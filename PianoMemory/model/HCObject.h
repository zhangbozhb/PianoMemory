//
//  HCObject.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HCInspectProtocol <NSObject>

@required
+ (NSArray*)propertyNamesOfThisClass;             //所有 property
+ (NSArray*)mutablePropertyNamesOfThisClass;      //只返回可修改的

@optional
+ (Class)propertyClassOfPropertyName:(NSString*)propertyName;   //返回 property 的 class
@end

@protocol HCRKProtocol <NSObject>

@required
+ (NSDictionary*)rkSpecialPropertyNameRKNameMapping;            //特殊的属性名和 rk 映射
+ (NSString *)rkNameForPropertyName:(NSString *)propertyName;   //属性对应的rkname
+ (NSArray *)propertyNamesOfRKNames:(NSArray*)rkNames;          //rk 对应的属性名称

/**
 *	@brief	reskit 用于解析的 mapping
 *
 *	@return	reskit 用于解析的 mapping
 */
+ (id)rkObjectMapping;

/**
 *	@brief	 reskit 用于解析的 mapping，只解析指定 propertyName
 *
 *	@param 	propertyNames 	只解析指定的 property,如果为 nil，则解析所有非只读的property
 *
 *	@return	reskit 用于解析的 mapping
 */
+ (id)rkObjectMappingWithPropertyNames:(NSArray *)propertyNames;


/* 返回 reskit 响应 descriptors*/
+ (NSArray *)rkResponseDescriptors;
/* 返回 reskit 请求 descriptors*/
+ (NSArray *)rkRequestDescriptors;

@optional
/**
 *	@brief	返回 用于 restkit mapping 使用的 dictionary
 *
 *	@param 	properties   属性名称. 如果为 nil，则默认使用所有的可修改的 property
 *	@param 	isDecode 	 是否是解析(YES: dict-> object  NO: object -> dictionary)
 *
 *	@return	返回 用于 restkit mapping 使用的 dictionary
 */
+ (NSDictionary *)rkMappingDictionaryWithProperties:(NSArray *)properties isDecode:(BOOL)isDecode;

/**
 *	@brief	返回 用于请求restkit mapping 使用的 dictionary
 *
 *  内部调用的是  rkMappingDictionaryWithProperties:isDecode:
 *
 *	@param 	rkNames 	请求使用的名称列表:如果为 nil，则默认使用所有的可修改的 property
 *
 *	@return	返回 用于请求restkit mapping 使用的 dictionary
 */
+ (NSDictionary *)rkRequestMappingDictionaryWthRKNames:(NSArray *)rkNames;



/**
 *	@brief	从 jsondata 中解析为对象
 *
 *	@param 	jsonData 	jsonData
 *
 *	@return	返回解析的对象
 */
+ (id)rkParseJsonData:(NSData*)jsonData;

/**
 *	@brief	将对象序列化 jsondata
 *
 *	@return	jsondata
 */
- (NSData *)rkToJsonData;
@end

@protocol HCCodingProtocol <NSObject>

@required
+ (NSArray *)encodePropertyNames;           //序列化的属性列表
+ (NSArray *)dencodePropertyNames;          //反序列化的属性列表
@end

@protocol HCCopyingProtocol <NSObject>

@required
/**
 *	@brief	待拷贝的 property
 *
 *	@return	 待拷贝的 property
 */
+ (NSArray *)copyingPropertyNames;

@optional
/**
 *	@brief	浅复制 object 的属性到自身
 *
 *	@param 	obj     输入的 object
 */
- (void)shallowCopyValue:(NSObject *)obj;

/**
 *	@brief	浅复制 object 的属性到自身
 *
 *	@param 	obj 	输入的 object
 *	@param 	copyClass 	object 指定类型
 */
- (void)shallowCopyValue:(NSObject *)obj copyClass:(Class)copyClass;
@end

@protocol HCSyncProtocol <NSObject>

@required
- (NSString *)syncLocalId;
- (NSString *)syncRemoteId;
- (NSInteger )syncVersion;

- (void)setSyncLocalId:(NSString *)localId;
- (void)setSyncRemoteId:(NSString *)remoteId;
- (void)setSyncVersion:(NSInteger)version;

/**
 *	@brief	更新同步信息
 *
 *	@param 	obj 	同步后的信息
 */
- (void)updateSyncedInfo:(NSObject*)obj;

@optional
- (NSString *)generateUUID;

@end

@interface HCObject : NSObject <HCInspectProtocol, HCRKProtocol,
                                NSCoding, HCCodingProtocol,
                                NSCopying, HCCopyingProtocol,
                                HCSyncProtocol>

@end

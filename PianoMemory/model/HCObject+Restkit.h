//
//  HCObject+Restkit.h
//  PianoMemory
//
//  Created by 张 波 on 14/12/19.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "HCObject.h"
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

@interface HCObject (Restkit) <HCRKProtocol>

@end

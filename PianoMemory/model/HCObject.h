//
//  HCObject.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCObject : NSObject
@end


#pragma extend inspect
@protocol HCInspectProtocol <NSObject>

@required
+ (NSArray*)propertyNamesOfThisClass;             //所有 property
+ (NSArray*)mutablePropertyNamesOfThisClass;      //只返回可修改的

@optional
+ (Class)propertyClassOfPropertyName:(NSString*)propertyName;   //返回 property 的 class
@end


@interface HCObject (Inspect) <HCInspectProtocol>

@end


#pragma extend coding
@protocol HCCodingProtocol <NSObject>

@required
+ (NSArray *)encodePropertyNames;           //序列化的属性列表
+ (NSArray *)dencodePropertyNames;          //反序列化的属性列表
@end

@interface HCObject (Coding) <NSCoding, HCCodingProtocol>

@end




#pragma extend copying
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


@interface HCObject (Copying) <NSCopying, HCCopyingProtocol>

@end



#pragma extend sync
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

@interface HCObject (Sync) <HCSyncProtocol>

@end


//
//  NSArray+LEDFoundation.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LEDFoundation)

/**
*  Apply BLOCK to each element serially.
*
*  @param block block to be applied to elements, it passes an element and its index as parameters
*/
- (void)sak_each:(void (^)(id object, NSUInteger index))block;

/**
 *  Apply BLOCK to each element concurrently.
 *
 *  Enumeration will occur on appropriate background queues. This
 *  will have a noticeable speed increase, especially on dual-core
 *  devices, but you *must* be aware of the thread safety of the
 *  objects you message from within the block. Be aware that the
 *  order of objects is not necessarily the order each block will
 *  be called in.
 *
 *  @param block block to be applied to elements, it passes an element and its index as parameters
 */
- (void)sak_apply:(void (^)(id object, NSUInteger index))block;

/**
 *  Apply BLOCK to each element and collect the results into a new array.
 *
 *  @param block block to be applied to elements, it passes an element and its index as parameters
 *
 *  @return a new array containing the results
 */
- (NSArray *)sak_map:(id (^)(id object, NSUInteger index))block;

/**
 *  Apply BLOCK to first two elements, get the result, then apply block to the result and the next element and so on.
 *
 *  @param block block to be applied to elements, it passes the last result and the current element as parameters
 *
 *  @return a result object
 */
- (id)reduce:(id (^)(id accumulated, id object))block;

/**
 *  Find the first object with which BLOCK takes as parameter and returns YES.
 *
 *  @param block block to be tested on elements
 *
 *  @return the first object passes testing
 */
- (id)match:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Apply BLOCK to each element and collect the ones passes testing by performed by BLOCK.
 *
 *  @param block block to be tested on elements
 *
 *  @return a new array containing objects pass the testisg
 */
- (NSArray *)filter:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Apply BLOCK to each element and select the ones passes testing by performed by BLOCK.
 *
 *  The same as - (NSArray *)filter:(BOOL (^)(id object, NSUInteger index))block;
 *  filter confuse us. select is easy to understand
 *
 *  @param block block to be tested on elements
 *
 *  @return a new array containing objects pass the testisg
 */
- (NSArray *)sak_select:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Apply BLOCK to each element and reject the ones passes testing by performed by BLOCK.
 *
 *  @param block block to be tested on elements
 *
 *  @return a new array !!!NOT containing objects pass the testisg
 */
- (NSArray *)sak_reject:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Determine whether each element passes testing.
 *
 *  @param block block to be tested on elements
 *
 *  @return YES if every elements pass the testing, NO otherwise. If array is empty, returns YES
 */
- (BOOL)every:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Determine whether any element passes testing.
 *
 *  @param block block to be tested on elements
 *
 *  @return YES if there is at least one element passes the testing, NO otherwise. If array is empty, returns NO
 */
- (BOOL)some:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Determine whether no elements pass the testing.
 *
 *  @param block block to be tested on elements
 *
 *  @return YES if there is no elements pass the testing, YES otherwise. If array is empty, returns YES.
 */
- (BOOL)notAny:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Determine whether any element doesn't pass the testing.
 *
 *  @param block block to be tested on elements
 *
 *  @return YES if there is at least one element doesn't pass the testing, NO otherwise. If array is empty, returns NO
 */
- (BOOL)notEvery:(BOOL (^)(id object, NSUInteger index))block;

@end

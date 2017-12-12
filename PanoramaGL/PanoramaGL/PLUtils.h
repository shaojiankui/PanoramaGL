/*
 * PanoramaGL library
 * Version 0.1
 * Copyright (c) 2010 Javier Baez <javbaezga@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import <Foundation/Foundation.h>
@interface PLUtils : NSObject 

#pragma mark -
#pragma mark swap methods

+ (void)swapFloatValues:(float *)firstValue :(float *)secondValue;
+ (void)swapIntValues:(int *)firstValue :(int *)secondValue;
///尺寸必须是2的N次方，convertUpDimension为YES向上转换，convertUpDimension为NO向下转换
+(int)convertValidValueForDimension:(int)dimension ifNoPowerOfTwoConvertUpDimension:(BOOL)convertUpDimension;
//向上转换
+ (int)convertUpValidValueForDimension:(int)dimension;
//向下转换
+ (int)convertDownValidValueForDimension:(int)dimension;

@end

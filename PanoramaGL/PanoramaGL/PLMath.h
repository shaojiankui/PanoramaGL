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

#import "PLStructs.h"

@interface PLMath : NSObject

#pragma mark -
#pragma mark distance methods

+(float)distanceBetweenPoints:(CGPoint)point1 :(CGPoint)point2;

#pragma mark -
#pragma mark range methods

+(float)valueInRange:(float)value range:(PLRange)range;

#pragma mark -
#pragma mark normalize methods

+(float)normalizeAngle:(float)angle range:(PLRange)range;
+(float)normalizeFov:(float)fov range:(PLRange)range;

#pragma mark -
#pragma mark pow methods

+(BOOL)isPowerOfTwo:(int)value;

@end

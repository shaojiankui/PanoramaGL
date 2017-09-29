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

#import "PLMath.h"

@implementation PLMath

#pragma mark -
#pragma mark init methods

-(id)init
{
	return nil;
}

#pragma mark -
#pragma mark distance methods

+(float)distanceBetweenPoints:(CGPoint)point1 :(CGPoint)point2;
{
	return sqrt(((point2.x - point1.x) * (point2.x - point1.x)) + ((point2.y - point1.y) * (point2.y - point1.y)));
}

#pragma mark -
#pragma mark range methods

+(float)valueInRange:(float)value range:(PLRange)range
{
	return MAX(range.min, MIN(value, range.max));
}

#pragma mark -
#pragma mark normalize methods

+(float)normalizeAngle:(float)angle range:(PLRange)range;
{	
	float result = angle;
    if(range.min < 0.0f)
	{
        while(result <= -180.0f) result += 360.0f;
        while(result > 180.0f) result -= 360.0f;
    } 
	else 
	{
        while(result < 0.0f) result += 360.0f;
        while(result >= 360.0f) result -= 360.0f;
    }
	return [PLMath valueInRange:result range:range];
}

+(float)normalizeFov:(float)fov range:(PLRange)range
{
	return [PLMath valueInRange:fov range:range];
}

#pragma mark -
#pragma mark pow methods
//判断是否是2的乘方
+(BOOL)isPowerOfTwo:(int)value
{
	while(!(value & 1))
		value = value >> 1;
	return (value == 1);
}

@end

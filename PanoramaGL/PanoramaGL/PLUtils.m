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

#import "PLUtils.h"

@implementation PLUtils

#pragma mark -
#pragma mark init methods

-(id)init
{
	return nil;
}

#pragma mark -
#pragma mark swap methods

+(void)swapFloatValues:(float *)firstValue :(float *)secondValue
{
	float swapValue = *firstValue;
	*firstValue = *secondValue;
	*secondValue = swapValue;
}

+(void)swapIntValues:(int *)firstValue :(int *)secondValue
{
	*firstValue = *firstValue ^ *secondValue;
	*secondValue = *secondValue ^ *firstValue;
	*firstValue = *firstValue ^ *secondValue;
}
#pragma mark -
#pragma mark utility methods
+(int)convertValidValueForDimension:(int)dimension ifNoPowerOfTwoConvertUpDimension:(BOOL)convertUpDimension{
    if (convertUpDimension) {
       return [self convertUpValidValueForDimension:dimension];
    }else{
      return  [self convertDownValidValueForDimension:dimension];
    }
}

+(int)convertUpValidValueForDimension:(int)dimension
{
    if(dimension <= 4)
        return 4;
    else if(dimension <= 8)
        return 8;
    else if(dimension <= 16)
        return 16;
    else if(dimension <= 32)
        return 32;
    else if(dimension <= 64)
        return 64;
    else if(dimension <= 128)
        return 128;
    else if(dimension <= 256)
        return 256;
    else if(dimension <= 512)
        return 512;
    else if(dimension <= 1024)
        return 1024;
    else if(dimension <= 2048)
        return 2048;
    else if(dimension <= 4096)
        return 4096;
    else if(dimension <= 8192)
        return 8192;
    else if(dimension <= 16384)
        return 16384;
    else
        return 2048;
}

//向下转换
+ (int)convertDownValidValueForDimension:(int)dimension{
    if(dimension <= 4)
        return 4;
    else if(dimension < 8)
        return 4;
    else if(dimension < 16)
        return 8;
    else if(dimension < 32)
        return 16;
    else if(dimension < 64)
        return 32;
    else if(dimension < 128)
        return 64;
    else if(dimension < 256)
        return 128;
    else if(dimension < 512)
        return 256;
    else if(dimension < 1024)
        return 512;
    else if(dimension < 2048)
        return 1024;
    else if(dimension < 4096)
        return 2048;
    else if(dimension < 8192)
        return 4096;
    else if(dimension < 16384)
        return 8192;
    else
        return 2048;
}
@end

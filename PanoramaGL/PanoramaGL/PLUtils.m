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

@end

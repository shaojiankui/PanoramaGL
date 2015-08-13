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

/*
 * This class is a port from C++ to Objective-C of CVec3 class in
 * "Demonstration of a line mesh intersection test (Sample1-Mesh_Line_Intersection.zip)" 
 * example by Jonathan Kreuzer http://www.3dkingdoms.com/weekly. 
 * See vec3.h.
 */

#import "PLVector3.h"

@implementation PLVector3

@synthesize x, y, z;

#pragma mark -
#pragma mark init methods

-(id)init
{
	if(self = [super init])
		x = y = z = 0.0f;
	return self;
}

-(id)initWithX:(float) xValue y:(float) yValue z:(float) zValue
{
	if(self = [super init])
	{
		x = xValue;
		y = yValue;
		z = zValue;
	}
	return self;
}

-(id)initWithVertex:(PLVertex)vertex
{
	return [self initWithX:vertex.x y:vertex.y z:vertex.z];
}

-(id)initWithPosition:(PLPosition)position
{
	return [self initWithX:position.x y:position.y z:position.z];
}

-(id)initWithVector3:(PLVector3 *)vector3
{
	return [self initWithX:vector3.x y:vector3.y z:vector3.z];
}

+(PLVector3 *)vector3
{
	return [[[PLVector3 alloc] init] autorelease];
}

+(PLVector3 *)vector3WithX:(float) x y:(float) y z:(float) z
{
	return [[[PLVector3 alloc] initWithX:x y:y z:z] autorelease];
}

+(PLVector3 *)vector3WithVertex:(PLVertex)vertex
{
	return [[[PLVector3 alloc] initWithVertex:vertex] autorelease];
}

+(PLVector3 *)vector3WithPosition:(PLPosition)position
{
	return [[[PLVector3 alloc] initWithPosition:position] autorelease];
}

+(PLVector3 *)vector3WithVector3:(PLVector3 *)vector3
{
	return [[[PLVector3 alloc] initWithVector3:vector3] autorelease];
}

#pragma mark -
#pragma mark property methods

-(PLPosition)getPosition
{
	return PLPositionMake(x, y, z);
}

-(void)setValuesWithX:(float)xValue y:(float)yValue z:(float)zValue
{
	x = xValue;
	y = yValue;
	z = zValue;
}

-(void)setValuesWithPosition:(PLPosition)position
{
	x = position.x;
	y = position.y;
	z = position.z;
}

-(void)setValues:(float *)values
{
	x = values[0];
	y = values[1];
	z = values[2];
}

#pragma mark -
#pragma mark vector methods

-(BOOL)equals:(PLVector3 *)value
{
	return (x == value.x && y == value.y && z == value.z);
}

-(PLVector3 *)add:(PLVector3 *)value
{
	return [PLVector3 vector3WithX:x+value.x y:y+value.y z:z+value.z];
}

-(PLVector3 *)sub:(PLVector3 *)value
{	
	return [PLVector3 vector3WithX:x-value.x y:y-value.y z:z-value.z];
}

-(PLVector3 *)minus
{
	return [PLVector3 vector3WithX:-x y:-y z:-z];
}

-(PLVector3 *)div:(PLVector3 *)value
{
	return [PLVector3 vector3WithX:x/value.x y:y/value.y z:z/value.z];
}

-(PLVector3 *)divf:(float)value
{
	float invert = 1.0f / value;
	return [PLVector3 vector3WithX:x*invert y:y*invert z:z*invert];
}

-(PLVector3 *)mult:(PLVector3 *)value
{
	return [PLVector3 vector3WithX:x*value.x y:y*value.y z:z*value.z];
}

-(PLVector3 *)multf:(float)value
{
	return [PLVector3 vector3WithX:x*value y:y*value z:z*value];
}

-(float)dot:(PLVector3 *)value
{
	return x*value.x + y*value.y + z*value.z;
}

-(PLVector3 *)crossProduct:(PLVector3 *)value
{
	return [PLVector3 vector3WithX:y * value.z - z * value.y
								 y:z * value.x - x * value.z
								 z:x * value.y - y * value.x];
}

-(float)magnitude
{
	return sqrtf(x*x + y*y + z*z);
}

-(float)distance:(PLVector3 *)value
{
	return [[self sub:value] magnitude];
}

-(void)normalize
{
	float mag = (x*x + y*y + z*z);
	if (mag == 0)
		return;
	float mult = 1.0f / sqrtf(mag);            
	x *= mult;
	y *= mult;
	z *= mult;
}

#pragma mark -
#pragma mark clone methods

-(PLVector3 *)clone
{
	return [PLVector3 vector3WithVector3:self];
}

@end
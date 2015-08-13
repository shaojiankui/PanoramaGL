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

#import "PLStructs.h"

@interface PLVector3 : NSObject
{
    #pragma mark -
    #pragma mark member variables
@private
	float x, y, z;
}

#pragma mark -
#pragma mark properties

@property(nonatomic, assign) float x,y,z;
@property(nonatomic, readonly, getter=getPosition) PLPosition position;

#pragma mark -
#pragma mark init methods

-(id)initWithVertex:(PLVertex)vertex;
-(id)initWithPosition:(PLPosition)position;
-(id)initWithX:(float)x y:(float)y z:(float)z;
-(id)initWithVector3:(PLVector3 *)vector3;

+(id)vector3;
+(id)vector3WithX:(float)x y:(float)y z:(float)z;
+(id)vector3WithVertex:(PLVertex)vertex;
+(id)vector3WithPosition:(PLPosition)position;
+(id)vector3WithVector3:(PLVector3 *)vector3;

#pragma mark -
#pragma mark property methods

-(PLPosition)getPosition;

-(void)setValuesWithX:(float)x y:(float)y z:(float)z;
-(void)setValuesWithPosition:(PLPosition)position;
-(void)setValues:(float *)values;

#pragma mark -
#pragma mark vector methods

-(BOOL)equals:(PLVector3 *)value;

-(PLVector3 *)add:(PLVector3 *)value;
-(PLVector3 *)sub:(PLVector3 *)value;
-(PLVector3 *)minus;
-(PLVector3 *)div:(PLVector3 *)value;
-(PLVector3 *)divf:(float)value;
-(PLVector3 *)mult:(PLVector3 *)value;
-(PLVector3 *)multf:(float)value;

-(float)dot:(PLVector3 *)value;
-(PLVector3 *)crossProduct:(PLVector3 *)value;

-(float)magnitude;
-(float)distance:(PLVector3 *)value;
-(void)normalize;

#pragma mark -
#pragma mark clone methods

-(PLVector3 *)clone;

@end
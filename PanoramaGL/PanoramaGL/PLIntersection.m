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
 * This functions are a port from C++ to Objective-C of 
 * "Demonstration of a line mesh intersection test (Sample1-Mesh_Line_Intersection.zip)" 
 * example by Jonathan Kreuzer http://www.3dkingdoms.com/weekly. 
 * See checkLineBoxWithRay.h and checkLineBoxWithRay.cpp.
 */

#import "PLIntersection.h"

@interface PLIntersection(Private)

+(BOOL)getIntersectionWithDistance1:(float)distance1 distance2:(float)distance2 ray:(PLVector3 **)ray hitPoint:(PLVector3 **)hitPoint;
+(BOOL)inBoxWithHitPoint:(PLVector3 *)hitPoint startBound:(PLVector3 *)startBound endBound:(PLVector3 *)endBound axis:(int)axis;
+(BOOL)evalSideIntersectionWithDistance1:(float)distance1 distance2:(float)distance2 ray:(PLVector3 **)ray hitPoint:(PLVector3 **)hitPoint startBound:(PLVector3 *)startBound endBound:(PLVector3 *)endBound axis:(int)axis;

@end

@implementation PLIntersection

#pragma mark -
#pragma mark init methods

-(id)init
{
	return nil;
}

#pragma mark -
#pragma mark internal check methods

+(BOOL)getIntersectionWithDistance1:(float)distance1 distance2:(float)distance2 ray:(PLVector3 **)ray hitPoint:(PLVector3 **)hitPoint
{
	if(distance1 * distance2 >= 0.0f || distance1 == distance2)
		return NO;
	PLVector3 *sub = [ray[1] sub:ray[0]];
	PLVector3 *mult = [sub multf:-distance1/(distance2-distance1)];
	*hitPoint = [mult add:ray[0]];
	return YES;
}

+(BOOL)inBoxWithHitPoint:(PLVector3 *)hitPoint startBound:(PLVector3 *)startBound endBound:(PLVector3 *)endBound axis:(int)axis 
{
	if(axis == 1 && hitPoint.z > startBound.z && hitPoint.z < endBound.z && hitPoint.y > startBound.y && hitPoint.y < endBound.y) return YES;
	if(axis == 2 && hitPoint.z > startBound.z && hitPoint.z < endBound.z && hitPoint.x > startBound.x && hitPoint.x < endBound.x) return YES;
	if(axis == 3 && hitPoint.x > startBound.x && hitPoint.x < endBound.x && hitPoint.y > startBound.y && hitPoint.y < endBound.y) return YES;
	return NO;
}

+(BOOL)evalSideIntersectionWithDistance1:(float)distance1 distance2:(float)distance2 ray:(PLVector3 **)ray hitPoint:(PLVector3 **)hitPoint startBound:(PLVector3 *)startBound endBound:(PLVector3 *)endBound axis:(int)axis
{	
	if([PLIntersection getIntersectionWithDistance1:distance1 distance2:distance2 ray:ray hitPoint:hitPoint]) 
	{
		if(![PLIntersection inBoxWithHitPoint:*hitPoint startBound:startBound endBound:endBound axis:axis])
			return NO;
		return YES;
	}
	return NO;
}

#pragma mark -
#pragma mark check methods

+(BOOL)checkLineBoxWithRay:(PLVector3 **)ray startBound:(PLVector3 *)startBound endBound:(PLVector3 *)endBound hitPoint:(PLVector3 **)hitPoint
{
	*hitPoint = nil;
	
	//Check for a quick exit if ray is completely to one side of the box
	if(
	   (ray[1].x < startBound.x && ray[0].x < startBound.x) ||
	   (ray[1].x > endBound.x   && ray[0].x > endBound.x  ) ||
	   (ray[1].y < startBound.y && ray[0].y < startBound.y) ||
	   (ray[1].y > endBound.y   && ray[0].y > endBound.y  ) ||
	   (ray[1].z < startBound.z && ray[0].z < startBound.z) ||
	   (ray[1].z > endBound.z   && ray[0].z > endBound.z  )
	)
		return NO;
	
	//Check if ray originates in the box
	if(ray[0].x > startBound.x && ray[0].x < endBound.x && ray[0].y > startBound.y && ray[0].y < endBound.y && ray[0].z > startBound.z && ray[0].z < endBound.z)
	{
		*hitPoint = [ray[0] clone];
		return YES;
	}
	
	//Check for a ray intersection with each side of the box
	if(
	   ([PLIntersection evalSideIntersectionWithDistance1:ray[0].x-startBound.x distance2:ray[1].x-startBound.x ray:ray hitPoint:hitPoint startBound:startBound endBound:endBound axis:1]) ||
	   ([PLIntersection evalSideIntersectionWithDistance1:ray[0].y-startBound.y distance2:ray[1].y-startBound.y ray:ray hitPoint:hitPoint startBound:startBound endBound:endBound axis:2]) ||
	   ([PLIntersection evalSideIntersectionWithDistance1:ray[0].z-startBound.z distance2:ray[1].z-startBound.z ray:ray hitPoint:hitPoint startBound:startBound endBound:endBound axis:3]) ||
	   ([PLIntersection evalSideIntersectionWithDistance1:ray[0].x-endBound.x   distance2:ray[1].x-endBound.x   ray:ray hitPoint:hitPoint startBound:startBound endBound:endBound axis:1]) ||
	   ([PLIntersection evalSideIntersectionWithDistance1:ray[0].y-endBound.y   distance2:ray[1].y-endBound.y   ray:ray hitPoint:hitPoint startBound:startBound endBound:endBound axis:2]) ||
	   ([PLIntersection evalSideIntersectionWithDistance1:ray[0].z-endBound.z   distance2:ray[1].z-endBound.z   ray:ray hitPoint:hitPoint startBound:startBound endBound:endBound axis:3]) 
	)
		return YES;
	
	return NO;
}

+(BOOL)checkLineBoxWithRay:(PLVector3 **)ray point1:(PLVector3 *)point1 point2:(PLVector3 *)point2 point3:(PLVector3 *)point3 point4:(PLVector3 *)point4 hitPoint:(PLVector3 **)hitPoint
{
	if(
	   [PLIntersection checkLineBoxWithRay:ray startBound:point1 endBound:point4 hitPoint:hitPoint] ||
	   [PLIntersection checkLineBoxWithRay:ray startBound:point4 endBound:point1 hitPoint:hitPoint] ||
	   [PLIntersection checkLineBoxWithRay:ray startBound:point2 endBound:point3 hitPoint:hitPoint] ||
	   [PLIntersection checkLineBoxWithRay:ray startBound:point3 endBound:point2 hitPoint:hitPoint] ||
	   [PLIntersection checkLineBoxWithRay:ray startBound:point1 endBound:point3 hitPoint:hitPoint] ||
	   [PLIntersection checkLineBoxWithRay:ray startBound:point3 endBound:point1 hitPoint:hitPoint] ||
	   [PLIntersection checkLineBoxWithRay:ray startBound:point1 endBound:point2 hitPoint:hitPoint] ||
	   [PLIntersection checkLineBoxWithRay:ray startBound:point2 endBound:point1 hitPoint:hitPoint]
	)
		return YES;
	return NO;
}

+(BOOL)checkLineTriangleWithRay:(PLVector3 **)ray firstVertex:(PLVector3 *)firstVertex secondVertex:(PLVector3 *)secondVertex thirdVertex:(PLVector3 *)thirdVertex hitPoint:(PLVector3 **)hitPoint
{
	*hitPoint = nil;
	
	//Calculate triangle normal
	PLVector3 *normal = [[secondVertex sub:firstVertex] crossProduct:[thirdVertex sub:firstVertex]];
	[normal normalize];
	
	//Find distance from ray to the plane defined by the triangle
	float distance1 = [[ray[0] sub:firstVertex] dot:normal];
	float distance2 = [[ray[1] sub:firstVertex] dot:normal];
	
	if((distance1 * distance2 >= 0.0f) ||	//Ray doesn't cross the triangle.
	   (distance1 == distance2))			//Ray and plane are parallel.
		return NO;
	
	//Find point on the ray that intersects with the plane
	PLVector3 *intersect = [ray[0] add:[[ray[1] sub:ray[0]] multf:-distance1/(distance2-distance1)]];
	
	//Find if the intersection point lies inside the triangle by testing it against all edges
	if([[normal crossProduct:[secondVertex sub:firstVertex]] dot:[intersect sub:firstVertex]] < 0.0f)
		return NO;
	
	if([[normal crossProduct:[thirdVertex sub:secondVertex]] dot:[intersect sub:secondVertex]] < 0.0f)
		return NO;

	if([[normal crossProduct:[firstVertex sub:thirdVertex]] dot:[intersect sub:firstVertex]] < 0.0f)
		return NO;
	
	*hitPoint = intersect;
	return YES;
}

@end
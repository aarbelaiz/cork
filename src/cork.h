// +-------------------------------------------------------------------------
// | cork.h
// | 
// | Author: Gilbert Bernstein
// +-------------------------------------------------------------------------
// | COPYRIGHT:
// |    Copyright Gilbert Bernstein 2013
// |    See the included COPYRIGHT file for further details.
// |    
// |    This file is part of the Cork library.
// |
// |    Cork is free software: you can redistribute it and/or modify
// |    it under the terms of the GNU Lesser General Public License as
// |    published by the Free Software Foundation, either version 3 of
// |    the License, or (at your option) any later version.
// |
// |    Cork is distributed in the hope that it will be useful,
// |    but WITHOUT ANY WARRANTY; without even the implied warranty of
// |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// |    GNU Lesser General Public License for more details.
// |
// |    You should have received a copy 
// |    of the GNU Lesser General Public License
// |    along with Cork.  If not, see <http://www.gnu.org/licenses/>.
// +-------------------------------------------------------------------------
#pragma once

#include "export.h"

#ifndef uint
typedef unsigned int uint;
#endif

// if a mesh is taken as input, the client must manage the memory
// if a mesh is given as output, please use the provided
// function to free the allocated memory.
struct CORK_API CorkTriMesh
{
    uint    n_triangles;
    uint    n_vertices;
    uint    *triangles;
    float   *vertices;
};

void CORK_API freeCorkTriMesh(CorkTriMesh *mesh);

// the inputs to Boolean operations must be "solid":
//  -   closed (aka. watertight; see comment at bottom)
//  -   non-self-intersecting
// additionally, inputs should use a counter-clockwise convention
// for triangle facing.  If the triangles are presented in clockwise
// orientation, the object is interpreted as its unbounded complement

// This function will test whether or not a mesh is solid
bool CORK_API isSolid(CorkTriMesh mesh);

// Boolean operations follow
// result = A U B
void CORK_API computeUnion(CorkTriMesh in0, CorkTriMesh in1, CorkTriMesh *out);

// result = A - B
void CORK_API computeDifference(CorkTriMesh in0, CorkTriMesh in1, CorkTriMesh *out);

// result = A ^ B
void CORK_API computeIntersection(CorkTriMesh in0, CorkTriMesh in1, CorkTriMesh *out);

// result = A XOR B
void CORK_API computeSymmetricDifference(
                        CorkTriMesh in0, CorkTriMesh in1, CorkTriMesh *out);

// Not a Boolean operation, but related:
//  No portion of either surface is deleted.  However, the
//  curve of intersection between the two surfaces is made explicit,
//  such that the two surfaces are now connected.
void CORK_API resolveIntersections(CorkTriMesh in0, CorkTriMesh in1, CorkTriMesh *out);

// Not a Boolean operation, returns an open surface with the in0 mesh intersected by in1
void CORK_API computeIntersectionOpen(CorkTriMesh in0, CorkTriMesh in1, CorkTriMesh* out);
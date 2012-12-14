//
//  CRGeometry.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//
//  Remember that opengl coordinates are measured from bottom left

#ifndef Cancer_CRGeometry_h
#define Cancer_CRGeometry_h



//Each Vertex maps a coordinate in space to a coordinate in a texture
typedef struct {
    CGPoint spaceCoordinate;
    CGPoint textureCoordinate; //values from 0.0 to 1.0
} TexturedVertex;

//This structure is a triangle strip that forms a 4-sided shape
//to map the whole texture to space, the texture coordinates are just (0, 0); (0, 1); (1, 0); (1, 1)
typedef struct {
    TexturedVertex bl; //bottom left
    TexturedVertex br; //bottom right
    TexturedVertex tl;  //top left
    TexturedVertex tr;  //top right
} TexturedQuad;


typedef struct {
    CGPoint spaceCoordinate;
    float Color[4];
} ColoredVertex;

typedef struct {
    ColoredVertex bl; //bottom left
    ColoredVertex br; //bottom right
    ColoredVertex tl;  //top left
    ColoredVertex tr;  //top right
} ColoredQuad;

#endif

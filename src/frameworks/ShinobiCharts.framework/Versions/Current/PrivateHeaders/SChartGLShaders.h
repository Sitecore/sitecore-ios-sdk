//
//  SChartGLShaders.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#ifndef SChart_SChartGLShaders_h
#define SChart_SChartGLShaders_h

static const char GLVertexShader[] = 

"attribute vec4 a_position;"
"attribute vec4 a_colour;"
"varying vec4 v_colour;"

"uniform float minX, minY;"
"uniform float zoomX, zoomY;"

"void main(void)"
"{"
"    v_colour = a_colour;"
"    gl_Position = a_position;" // need to copy the extra members, not just x and y
"    gl_Position.x = -1.0 + (gl_Position.x - minX) / zoomX;"
"    gl_Position.y = -1.0 + (gl_Position.y - minY) / zoomY;"
"}";

static const char GLVertexShaderAnimate[] = 

"attribute vec4 a_position;"
"attribute vec4 a_colour;"
"varying vec4 v_colour;"

"uniform float minX, minY;"
"uniform float zoomX, zoomY;"
"uniform float scaleX, scaleY;"
"uniform float refPointX, refPointY;"

"void main(void)"
"{"
"    v_colour = a_colour;"
"    gl_Position = a_position;" // need to copy the extra members, not just x and y
"    gl_Position.x = refPointX + (gl_Position.x - refPointX) * scaleX;"
"    gl_Position.y = refPointY + (gl_Position.y - refPointY) * scaleY;"
"    gl_Position.x = -1.0 + (gl_Position.x - minX) / zoomX;"
"    gl_Position.y = -1.0 + (gl_Position.y - minY) / zoomY;"
"}";

static const char GLVertexShaderDisplaceRotate[] = 

"attribute vec4 a_position;"
"attribute vec4 a_colour;"
"varying vec4 v_colour;"

"uniform float displace;"
"uniform mat2 projMat;"

"void main(void)"
"{"
"    v_colour = a_colour;"
"    gl_Position = a_position;" // need to copy the extra members, not just x and y
"    gl_Position.x += displace;"
"    gl_Position.xy *= projMat;"
"}";

static const char GLVertexShaderDisplaceRotateTexture[] = 

"attribute vec4 a_position;"
"attribute vec4 a_colour;"
"attribute vec2 a_uv;"
"varying vec4 v_colour;"
"varying mediump vec2 texcoord;"

"uniform float displace;"
"uniform mat2 projMat;"

"void main(void)"
"{"
"    v_colour = a_colour;"
"    gl_Position = a_position;" // need to copy the extra members, not just x and y
"    gl_Position.x += displace;"
"    gl_Position.xy *= projMat;"
"    texcoord = a_uv;"
"}";

static const char GLVertexShaderOffset[] = 

"attribute vec4 a_position;"
"attribute vec4 a_colour;"
"attribute vec2 offset;"
"varying vec4 v_colour;"

"uniform float minX, minY;"
"uniform float zoomX, zoomY;"
"uniform float pixelWidth, pixelHeight;"

"void main(void)"
"{"
"    v_colour = a_colour;"
"    gl_Position = a_position;" // need to copy the extra members, not just x and y
"    gl_Position.x = -1.0 + (gl_Position.x - minX) / zoomX + offset.x * pixelWidth;"
"    gl_Position.y = -1.0 + (gl_Position.y - minY) / zoomY + offset.y * pixelHeight;"
"}";

static const char GLVertexShaderOffsetThickLine[] = 

"attribute vec4 a_position;"
"attribute vec4 a_colour;"
"attribute vec2 offset;"
"varying vec4 v_colour;"

"uniform float minX, minY;"
"uniform float zoomX, zoomY;"
"uniform float pixelWidth, pixelHeight;"
"uniform float lineHalfWidth;"

"void main(void)"
"{"
"    v_colour = a_colour;"
"    vec2 offsetScreen = offset;"
"    offsetScreen.x /= zoomX * pixelWidth;"
"    offsetScreen.y /= zoomY * pixelHeight;"
"    offsetScreen = normalize(offsetScreen);"
"    gl_Position = a_position;" // need to copy the extra members, not just x and y
"    gl_Position.x = -1.0 + (gl_Position.x - minX) / zoomX + lineHalfWidth * -offsetScreen.y * pixelWidth;"
"    gl_Position.y = -1.0 + (gl_Position.y - minY) / zoomY + lineHalfWidth * offsetScreen.x * pixelHeight;"
"}";

static const char GLFragmentShaderTexture[] = 

"uniform sampler2D tex0;"
"varying mediump vec2 texcoord;"

"void main(void)"
"{"
"   gl_FragColor = texture2D(tex0, texcoord);"
"}";


static const char GLFragmentShader[] = 

"varying lowp vec4 v_colour;"

"void main(void)"
"{"
    "gl_FragColor = v_colour;"
"}";


static const char GLVertexShaderPoint[] =

"attribute vec4 a_position;"
"attribute vec4 a_colour;"
"varying vec4 v_colour;"

"uniform float minX, minY;"
"uniform float zoomX, zoomY;"
"uniform float pointSize;"

"void main(void)"
"{"
"    v_colour = a_colour;"
"    gl_Position = a_position;" // need to copy the extra members, not just x and y
"    gl_Position.x = -1.0 + (gl_Position.x - minX) / zoomX;"
"    gl_Position.y = -1.0 + (gl_Position.y - minY) / zoomY;"
"    gl_PointSize = pointSize;"
"}";

static const char GLVertexShaderPointWithRadius[] =

"attribute vec4 a_position;"
"attribute vec4 a_colour;"
"attribute float a_pointSize;"
"varying vec4 v_colour;"

"uniform float minX, minY;"
"uniform float zoomX, zoomY;"

"void main(void)"
"{"
"    v_colour = a_colour;"
"    gl_Position = a_position;" // need to copy the extra members, not just x and y
"    gl_Position.x = -1.0 + (gl_Position.x - minX) / zoomX;"
"    gl_Position.y = -1.0 + (gl_Position.y - minY) / zoomY;"
"    gl_PointSize = a_pointSize;"
"}";

static const char GLFragmentShaderPoint[] = 

"uniform sampler2D tex0;"
"varying lowp vec4 v_colour;"

"void main(void)"
"{"
"   gl_FragColor = texture2D(tex0, gl_PointCoord) * v_colour;"
"}";

static const char GLFragmentShaderThickLine[] = 

"uniform sampler2D tex0;"
"varying lowp vec4 v_colour;"

"void main(void)"
"{"
"   gl_FragColor = texture2D(tex0, gl_PointCoord) * v_colour;"
"   if (gl_FragColor.a < v_colour.a * 0.9) discard;"
"}";



#endif

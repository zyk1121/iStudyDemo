#import "GLTools.h"

#define iglPi                     3.14159265358979323846

void gluPerspective_igl(GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar)
{
    GLfloat m[4][4];
    GLfloat sine, cotangent, deltaZ;
    GLfloat radians=(GLfloat)(fovy/2.0f*iglPi/180.0f);
    
    deltaZ=zFar-zNear;
    sine=(GLfloat)sin(radians);
    if ((deltaZ==0.0f) || (sine==0.0f) || (aspect==0.0f))
    {
        return;
    }
    cotangent=(GLfloat)(cos(radians)/sine);
    
    __gluMakeIdentityf_igl(&m[0][0]);
    m[0][0] = cotangent / aspect;
    m[1][1] = cotangent;
    m[2][2] = -(zFar + zNear) / deltaZ;
    m[2][3] = -1.0f;
    m[3][2] = -2.0f * zNear * zFar / deltaZ;
    m[3][3] = 0;
    glMultMatrixf(&m[0][0]);
}

static void __gluMakeIdentityf_igl(GLfloat m[16])
{
    m[0+4*0] = 1; m[0+4*1] = 0; m[0+4*2] = 0; m[0+4*3] = 0;
    m[1+4*0] = 0; m[1+4*1] = 1; m[1+4*2] = 0; m[1+4*3] = 0;
    m[2+4*0] = 0; m[2+4*1] = 0; m[2+4*2] = 1; m[2+4*3] = 0;
    m[3+4*0] = 0; m[3+4*1] = 0; m[3+4*2] = 0; m[3+4*3] = 1;
}


static void normalize_igl(GLfloat v[3])
{
    GLfloat r;
    
    r=(GLfloat)sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
    if (r==0.0f)
    {
        return;
    }
    
    v[0]/=r;
    v[1]/=r;
    v[2]/=r;
}

static void cross_igl(GLfloat v1[3], GLfloat v2[3], GLfloat result[3])
{
    result[0] = v1[1]*v2[2] - v1[2]*v2[1];
    result[1] = v1[2]*v2[0] - v1[0]*v2[2];
    result[2] = v1[0]*v2[1] - v1[1]*v2[0];
}


void gluLookAt_igl(GLfloat eyex, GLfloat eyey, GLfloat eyez, GLfloat centerx,
                 GLfloat centery, GLfloat centerz, GLfloat upx, GLfloat upy,
                 GLfloat upz)
{
    GLfloat forward[3], side[3], up[3];
    GLfloat m[4][4];
    
    forward[0] = centerx - eyex;
    forward[1] = centery - eyey;
    forward[2] = centerz - eyez;
    
    up[0] = upx;
    up[1] = upy;
    up[2] = upz;
    
    normalize_igl(forward);
    
    /* Side = forward x up */
    cross_igl(forward, up, side);
    normalize_igl(side);
    
    /* Recompute up as: up = side x forward */
    cross_igl(side, forward, up);
    
    __gluMakeIdentityf_igl(&m[0][0]);
    m[0][0] = side[0];
    m[1][0] = side[1];
    m[2][0] = side[2];
    
    m[0][1] = up[0];
    m[1][1] = up[1];
    m[2][1] = up[2];
    
    m[0][2] = -forward[0];
    m[1][2] = -forward[1];
    m[2][2] = -forward[2];
    
    glMultMatrixf(&m[0][0]);
    glTranslatef(-eyex, -eyey, -eyez);
}

static void __gluMultMatrixVecf_igl(const GLfloat matrix[16], const GLfloat in[4],
                                GLfloat out[4])
{
    int i;
    
    for (i=0; i<4; i++)
    {
        out[i] = in[0] * matrix[0*4+i] +
        in[1] * matrix[1*4+i] +
        in[2] * matrix[2*4+i] +
        in[3] * matrix[3*4+i];
    }
}

GLint gluProject_igl(GLfloat objx, GLfloat objy, GLfloat objz,
           const GLfloat modelMatrix[16],
           const GLfloat projMatrix[16],
           const GLint viewport[4],
           GLfloat* winx, GLfloat* winy, GLfloat* winz)
{
    GLfloat in[4];
    GLfloat out[4];
    
    in[0]=objx;
    in[1]=objy;
    in[2]=objz;
    in[3]=1.0;
    __gluMultMatrixVecf_igl(modelMatrix, in, out);
    __gluMultMatrixVecf_igl(projMatrix, out, in);
    if (in[3] == 0.0)
    {
        return(GL_FALSE);
    }
    
    in[0]/=in[3];
    in[1]/=in[3];
    in[2]/=in[3];
    /* Map x, y and z to range 0-1 */
    in[0]=in[0]*0.5f+0.5f;
    in[1]=in[1]*0.5f+0.5f;
    in[2]=in[2]*0.5f+0.5f;
    
    /* Map x,y to viewport */
    in[0]=in[0] * viewport[2] + viewport[0];
    in[1]=in[1] * viewport[3] + viewport[1];
    
    *winx=in[0];
    *winy=in[1];
    *winz=in[2];
    
    return(GL_TRUE);
}

GLuint iglGetTextureIDFrom(unsigned char *imageData, GLsizei width, GLsizei height)
{
    // 外部释放imageData
    if (imageData == NULL) {
        return 0;
    }
    
    GLuint textureId = 0;
    
    glGenTextures(1, &textureId);
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width,  (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glDisable(GL_TEXTURE_2D);
    
//     printf("######----%p  %d\n",imageData,textureId);
    
    return textureId;
}

void   iglDelTextureID(GLsizei n, GLuint *textureIDs)
{
    if (n > 0) {
        for (int i = 0; i < n; i++) {
            GLuint textureID = textureIDs[i];
        }
        glDeleteTextures(n, textureIDs);
    }
}

float  iglNormalizedPitch(float pitch)
{
    float temp = pitch;
    if (temp > 90) {
        temp = 90;
    }
    if (temp < -90) {
        temp = -90;
    }
    return temp;
}
float  iglNormalizedYaw(float yaw)
{
    float temp = yaw;
    while (temp > 360) {
        temp = temp - 360;
    }
    while (temp < 0) {
        temp = temp + 360;
    }
    return temp;
}
float  iglNormalizedZoom(float zoom)
{
    float temp = zoom;
    if (temp > 5) {
        temp = 5;
    }
    if (temp < 1) {
        temp = 1;
    }
    return temp;
}

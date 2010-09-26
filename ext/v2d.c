#include "v2d.h"
#include <ruby.h>
#include <math.h>

#define DBL_EPSILON (1e-9)

V2D * v2d_new() {
    V2D *res = (V2D*)xmalloc(sizeof(V2D));
    res->x = 0;
    res->y = 0;
    return res;
}

void v2d_delete(V2D * v) {
    xfree(v);
}

V2D * v2d_clone(V2D * v) {
    return v2d_assign(v2d_new(), v);
}

V2D * v2d_assign(V2D * dest, V2D * src) {
    dest->x = src->x;
    dest->y = src->y;
    return dest;
}

V2D * v2d_add_to(V2D * v1, V2D * v2) {
    v1->x += v2->x;
    v1->y += v2->y;
    return v1;
}

V2D v2d_add(V2D * v1, V2D * v2) {
    V2D temp;
    v2d_add_to(v2d_assign(&temp, v1), v2);
    return temp;
}

V2D * v2d_sub_from(V2D * v1, V2D * v2) {
    v1->x -= v2->x;
    v1->y -= v2->y;
    return v1;
}

V2D v2d_sub(V2D * v1, V2D * v2) {
    V2D temp;
    v2d_sub_from(v2d_assign(&temp, v1), v2);
    return temp;
}

V2D * v2d_mul_by(V2D * v, double multiplier) {
    v->x *= multiplier;
    v->y *= multiplier;
    return v;
}

V2D v2d_mul(V2D * v, double multiplier) {
    V2D temp;
    v2d_mul_by(v2d_assign(&temp, v), multiplier);
    return temp;
}

V2D * v2d_div_by(V2D * v, double divisor) {
    v->x /= divisor;
    v->y /= divisor;
    return v;
}

V2D v2d_div(V2D * v, double divisor) {
    V2D temp;
    v2d_div_by(v2d_assign(&temp, v), divisor);
    return temp;
}

double v2d_abs(V2D * v) {
    return sqrt(v->x*v->x + v->y*v->y);
}

int v2d_equals(V2D * v1, V2D * v2) {
    return fabs(v1->x - v2->x) < DBL_EPSILON &&
           fabs(v1->y - v2->y) < DBL_EPSILON;
}


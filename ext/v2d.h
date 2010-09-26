#pragma once

typedef struct _V2D {
    double x, y;
} V2D;

/* Allocates a new zero-vector */
V2D * v2d_new();

/* Deletes +v+ */
void v2d_delete(V2D * v);

/* Allocates a new vector equal to +v+ */
V2D * v2d_clone(V2D * v);

/* Assigns +src+ to +dest+, returns +dest+ */
V2D * v2d_assign(V2D * dest, V2D * src);

/* Adds +v2+ to +v1+ and returns +v1+ */
V2D * v2d_add_to(V2D * v1, V2D * v2);

/* Returns the sum of +v1+ and +v2+ (via stack) */
V2D v2d_add(V2D * v1, V2D * v2);

/* Subs +v2+ from +v1+ and returns +v1+ */
V2D * v2d_sub_from(V2D * v1, V2D * v2);

/* Returns the diff of +v1+ and +v2+ (via stack) */
V2D v2d_sub(V2D * v1, V2D * v2);

/* Multiplies +v+ by +multiplier+ and returns +v+ */
V2D * v2d_mul_by(V2D * v, double multiplier);

/* Returns the product of +v+ and +multiplier+ (via stack) */
V2D v2d_mul(V2D * v, double multiplier);

/* Divdides +v+ by +multiplier+ and returns +v+ */
V2D * v2d_div_by(V2D * v, double divisor);

/* Returns the quotient of +v1+ and +divisor+ */
V2D v2d_div(V2D * v, double divisor);

/* Returns absolute value of +v+ */
double v2d_abs(V2D * v);

/* Checks whether +v1+ equals to +v2+ */
int v2d_equals(V2D * v1, V2D * v2);


#pragma once

typedef struct _V2D {
    double x, y;
} V2D;

/* Allocates a new zero-vector */
V2D * v2d_new();

/* Delete vector */
void v2d_delete(V2D * v);

/* Allocates new vector equals to +v+ */
V2D * v2d_clone(V2D * v);

/* Assigns +src+ to +dest+ */
V2D * v2d_assign(V2D * dest, V2D * src);

/* Add +v2+ to +v1+ and return +v1+ */
V2D * v2d_add_to(V2D * v1, V2D * v2);

/* Return sum of +v1+ and +v2+ */
V2D * v2d_add(V2D * v1, V2D * v2);

/* Sub +v2+ from +v1+ and return +v1+ */
V2D * v2d_sub_from(V2D * v1, V2D * v2);

/* Return diff of +v1+ and +v2+ */
V2D * v2d_sub(V2D * v1, V2D * v2);

/* Mul +v+ by +multiplier+ and return +v+ */
V2D * v2d_mul_by(V2D * v, double multiplier);

/* Return product of +v1+ and +multiplier+ */
V2D * v2d_mul(V2D * v, double multiplier);

/* Div +v+ by +multiplier+ and return +v+ */
V2D * v2d_div_by(V2D * v, double divisor);

/* Return quotient of +v1+ and +divisor+ */
V2D * v2d_div(V2D * v, double divisor);

/* Return absolute value of +v+ */
double v2d_abs(V2D * v);

/* Return whether +v1+ equals to +v2+ */
int v2d_equals(V2D * v1, V2D * v2);


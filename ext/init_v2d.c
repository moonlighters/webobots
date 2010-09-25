#include <ruby.h>
#include "v2d.h"
#include "helpers.h"

VALUE cV2D;

// DEFINITIONS

DEFINE_UNWRAPPER(V2D, v2d);
DEFINE_WRAPPER(cV2D, V2D, v2d);

/* Allocate memory */
VALUE rb_v2d_alloc(VALUE klass);

/* Return new with initialized x and y */
VALUE rb_v2d_initialize_with_x_and_y(VALUE self, VALUE x, VALUE y);

/* Return <tt>V2D.new(x, y)</tt> */
VALUE rb_v2d_square_brackets(VALUE klass, VALUE x, VALUE y);

/* Set or return x */
ATTR_ACCESSOR_FLOAT(v2d, x);

/* Set or return y */
ATTR_ACCESSOR_FLOAT(v2d, y);

/* Return sum with +other+ */
VALUE rb_v2d_add(VALUE self, VALUE other);

/* Return diff with +other+ */
VALUE rb_v2d_sub(VALUE self, VALUE other);

/* Return product with +multiplier+ */
VALUE rb_v2d_mul(VALUE self, VALUE multiplier);

/* Return quotient with +divisor+ */
VALUE rb_v2d_div(VALUE self, VALUE divisor);

/* Return absolute value */
VALUE rb_v2d_abs(VALUE self);

/* Return whether equals to +other+ */
VALUE rb_v2d_equals(VALUE self, VALUE other);


void Init_v2d() {
    /* 2D vector */
    cV2D = rb_define_class("V2D", rb_cObject);

    rb_define_alloc_func(cV2D, rb_v2d_alloc);
    rb_define_method(cV2D, "initialize", rb_v2d_initialize_with_x_and_y, 2);
    rb_define_singleton_method(cV2D, "[]", rb_v2d_square_brackets, 2);
    DEFINE_ATTR_ACCESSOR(cV2D, v2d, x);
    DEFINE_ATTR_ACCESSOR(cV2D, v2d, y);
    rb_define_method(cV2D, "+", rb_v2d_add, 1);
    rb_define_method(cV2D, "-", rb_v2d_sub, 1);
    rb_define_method(cV2D, "*", rb_v2d_mul, 1);
    rb_define_method(cV2D, "/", rb_v2d_div, 1);
    rb_define_method(cV2D, "abs", rb_v2d_abs, 0);
    rb_define_method(cV2D, "==", rb_v2d_equals, 1);
}

// IMPLEMENTATIONS

VALUE rb_v2d_alloc(VALUE klass) {
    V2D *v = v2d_new();
    return Data_Wrap_Struct(klass, NULL, v2d_delete, v);
}

VALUE rb_v2d_initialize_with_x_and_y(VALUE self, VALUE x, VALUE y) {
    V2D *v = _v2d_unwrap(self);
    v->x = NUM2DBL(x);
    v->y = NUM2DBL(y);
    return self;
}

VALUE rb_v2d_square_brackets(VALUE klass, VALUE x, VALUE y) {
    VALUE args[] = {x, y};
    return rb_class_new_instance(2, args, cV2D);
}

VALUE rb_v2d_add(VALUE self, VALUE other) {
    V2D *v1 = _v2d_unwrap(self);
    V2D *v2 = _v2d_unwrap(other);
    return _v2d_wrap( v2d_add(v1, v2) );
}

VALUE rb_v2d_sub(VALUE self, VALUE other) {
    V2D *v1 = _v2d_unwrap(self);
    V2D *v2 = _v2d_unwrap(other);
    return _v2d_wrap( v2d_sub(v1, v2) );
}

VALUE rb_v2d_mul(VALUE self, VALUE multiplier) {
    V2D *v = _v2d_unwrap(self);
    double m = NUM2DBL(multiplier);
    return _v2d_wrap( v2d_mul(v, m) );
}

VALUE rb_v2d_div(VALUE self, VALUE divisor) {
    V2D *v = _v2d_unwrap(self);
    double d = NUM2DBL(divisor);
    return _v2d_wrap( v2d_div(v, d) );
}

VALUE rb_v2d_abs(VALUE self) {
    return rb_float_new( v2d_abs( _v2d_unwrap(self) ) );
}

VALUE rb_v2d_equals(VALUE self, VALUE other) {
    V2D *v1 = _v2d_unwrap(self);
    V2D *v2 = _v2d_unwrap(other);
    return v2d_equals(v1, v2) ? Qtrue : Qfalse;
}


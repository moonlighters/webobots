#pragma once

/* Defines a method _`prefix`_unwrap: VALUE -> pointer to struct
 * EXAMPLE: the code
 *            DEFINE_UNWRAPPER(Apple, apple);
 *          defines
 *            Apple * _apple_unwrap(VALUE) { ... }
 */
#define DEFINE_UNWRAPPER(type, prefix)\
    type * _##prefix##_unwrap(VALUE self)\
    {\
        type *temp;\
        Data_Get_Struct(self, type, temp);\
        return temp;\
    }

/* A pair for DEFINE_UNWRAPPER */
#define DECLARE_UNWRAPPER(type, prefix)\
    type * _##prefix##_unwrap(VALUE self);

/* Defines a method _`prefix`_wrap: pointer to struct -> VALUE 
 * NOTE: assumes that ruby class variable is c`type`
 * NOTE: this version of wrapper doesn't copy the struct, so if it is
 *       allocated in temporary location (e.g. on stack), do NOT use
 *       the unwrapper defined by this macro, see DEFINE_CLONE_WRAPPER
 * EXAMPLE: having
 *            VALUE cApple;
 *            void apple_delete(Apple *);
 *          the code
 *            DEFINE_WRAPPER(Apple, apple)
 *          defines
 *            VALUE _apple_wrap(Apple *p) { ... }
 */
#define DEFINE_WRAPPER(type, prefix)\
    VALUE _##prefix##_wrap(type *p)\
    {\
        return Data_Wrap_Struct(c##type, NULL, NULL, p);\
    }

/* A pair for DEFINE_WRAPPER */
#define DECLARE_WRAPPER(type, prefix)\
    VALUE _##prefix##_wrap(type *p);

/* Same as DEFINE_WRAPPER, but defines method named _`prefix`_wrap_clone,
 * which allocates a copy of the struct on heap before wrapping.
 * NOTE: it creates absolutely new object, so if you want to wrap some struct
 *       so that to have write access (e.g. a field of another struct),
 *       do NOT use the unwrapper defined by this macro, see DEFINE_WRAPPER
 * NOTE: requires methods `prefix`_clone and `prefix`_delete declared
 */
#define DEFINE_CLONE_WRAPPER(type, prefix)\
    VALUE _##prefix##_wrap_clone(type *p)\
    {\
        return Data_Wrap_Struct(c##type, NULL, prefix##_delete, prefix##_clone(p));\
    }

/* A pair for DEFINE_CLONE_WRAPPER */
#define DECLARE_CLONE_WRAPPER(type, prefix)\
    VALUE _##prefix##_wrap(type *p);

/* Defines acessor methods `prefix`_get_`attribute` and `prefix`_set_`attribute`
 * for attribute of float type
 * NOTE: requires an unwrapper to be defined (see DEFINE_UNWRAPPER)
 * NOTE: assumes that a struct, returned by an unwrapper, has a field named `attribute` of type double
 * EXAMPLE: having
 *            typedef struct _Apple {
 *              double color;
 *            } Apple;
 *            DEFINE_UNWRAPPER(Apple, apple);
 *          the code
 *            ATTR_ACCESSOR_FLOAT(apple, color)
 *          defines
 *            VALUE apple_get_color(VALUE self) { ... }
 *            VALUE apple_set_color(VALUE self, VALUE value) { ... }
 */
#define ATTR_ACCESSOR_FLOAT(prefix, attribute) \
    VALUE prefix##_get_##attribute(VALUE self)\
    {\
        return rb_float_new( _##prefix##_unwrap(self)->attribute );\
    }\
    VALUE prefix##_set_##attribute(VALUE self, VALUE value)\
    {\
        _##prefix##_unwrap(self)->attribute = NUM2DBL(value);\
        return value;\
    }

/* Defines acessor methods `prefix`_get_`attribute` and `prefix`_set_`attribute`
 * NOTE: requires an unwrapper to be defined (see DEFINE_UNWRAPPER)
 * NOTE: assumes that a struct, returned by an unwrapper, has a field named `attribute` of pointer to some struct type
 * NOTE: requires both wrapper and unwrapper defined for the type of that field (see DEFINE_WRAPPER and DEFINE_UNWRAPPER)
 * EXAMPLE: having
 *            typedef struct _Point { ... } Point;
 *            DEFINE_WRAPPER(Point, point);
 *            DEFINE_UNWRAPPER(Point, point);
 *
 *            typedef struct _Apple {
 *              Point position;
 *            } Apple;
 *            DEFINE_UNWRAPPER(Apple, apple);
 *          the code
 *            ATTR_ACCESSOR_STRUCT(apple, point, position)
 *          defines
 *            VALUE apple_get_position(VALUE self) { ... }
 *            VALUE apple_set_position(VALUE self, VALUE value) { ... }
 */
#define ATTR_ACCESSOR_STRUCT(self_prefix, attr_prefix, attribute) \
    VALUE self_prefix##_get_##attribute(VALUE self)\
    {\
        return _##attr_prefix##_wrap( _##self_prefix##_unwrap(self)->attribute );\
    }\
    VALUE self_prefix##_set_##attribute(VALUE self, VALUE value)\
    {\
        _##self_prefix##_unwrap(self)->attribute = _##attr_prefix##_unwrap(value);\
        return value;\
    }

/* Registers accessor methods `attribute` and `attribute`= to ruby class
 * NOTE: requires accessor methods to be defined (see ATTR_ACCESSOR_FLOAT or ATTR_ACCESSOR_STRUCT)
 * EXAMPLE: having all the stuff needed for ATTR_ACCESSOR_FLOAT
 *          and
 *            VALUE cApple;
 *            ATTR_ACCESSOR_FLOAT(apple, color)
 *          the code (being placed inside Init_* function)
 *            DEFINE_ATTR_ACCESSOR(cApple, apple, color);
 *          adds methods
 *            Apple#color
 *            Apple#color=
 *          to ruby class Apple
 */
#define DEFINE_ATTR_ACCESSOR(klass, prefix, attribute)\
    do\
    {\
        rb_define_method(klass, #attribute, prefix##_get_##attribute, 0);\
        rb_define_method(klass, #attribute "=", prefix##_set_##attribute, 1);\
    }\
    while(0)


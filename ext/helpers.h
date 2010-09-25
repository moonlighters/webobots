#pragma once

#define DECLARE_UNWRAPPER(type, prefix)\
    type * _##prefix##_unwrap(VALUE self);

#define DEFINE_UNWRAPPER(type, prefix)\
    type * _##prefix##_unwrap(VALUE self)\
    {\
        type *temp;\
        Data_Get_Struct(self, type, temp);\
        return temp;\
    }

#define DECLARE_WRAPPER(type, prefix)\
    VALUE _##prefix##_wrap(type *p);

#define DEFINE_WRAPPER(type, prefix)\
    VALUE _##prefix##_wrap(type *p)\
    {\
        return Data_Wrap_Struct(c##type, NULL, prefix##_delete, p);\
    }

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

#define DEFINE_ATTR_ACCESSOR(klass, prefix, attribute)\
    do\
    {\
        rb_define_method(klass, #attribute, prefix##_get_##attribute, 0);\
        rb_define_method(klass, #attribute "=", prefix##_set_##attribute, 1);\
    }    \
    while(0)

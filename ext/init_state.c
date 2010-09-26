#include <ruby.h>
#include "state.h"
#include "init_v2d.h"
#include "helpers.h"

/* Class */

VALUE cState;

/* State methods declaration */

VALUE rb_state_alloc(VALUE klass);
VALUE rb_state_initialize(VALUE self, VALUE pos, VALUE angle);
VALUE rb_state_get_angle(VALUE self);
VALUE rb_state_set_angle(VALUE self, VALUE value);
VALUE rb_state_cosa(VALUE self);
VALUE rb_state_sina(VALUE self);
VALUE rb_state_correct(VALUE self);
VALUE rb_state_speed_mode(VALUE self);

/* Internal helpers declaration */

DEFINE_UNWRAPPER(State, state);
ATTR_ACCESSOR_FLOAT(state, radians);
ATTR_ACCESSOR_FLOAT(state, speed);
ATTR_ACCESSOR_FLOAT(state, desired_speed);
ATTR_ACCESSOR_FLOAT(state, health);
ATTR_ACCESSOR_STRUCT(state, v2d, pos);

VALUE _state_speed_modes[3];

/* Init */

void Init_state()
{
    VALUE cBot = rb_define_class_under(rb_define_module_under(rb_define_module("EmulationSystem"), "Emulation"), "Bot", rb_cObject);
    
    cState = rb_define_class_under(cBot, "State", rb_cObject);
    rb_define_alloc_func(cState, rb_state_alloc);
    rb_define_method(cState, "initialize", rb_state_initialize, 2);
    rb_define_method(cState, "angle", rb_state_get_angle, 0);
    rb_define_method(cState, "angle=", rb_state_set_angle, 1);
    DEFINE_ATTR_ACCESSOR(cState, state, radians);
    DEFINE_ATTR_ACCESSOR(cState, state, speed);
    DEFINE_ATTR_ACCESSOR(cState, state, desired_speed);
    DEFINE_ATTR_ACCESSOR(cState, state, health);
    DEFINE_ATTR_ACCESSOR(cState, state, pos);
    rb_define_method(cState, "cosa", rb_state_cosa, 0);
    rb_define_method(cState, "sina", rb_state_sina, 0);
    rb_define_method(cState, "correct", rb_state_correct, 0);
    rb_define_method(cState, "speed_mode", rb_state_speed_mode, 0);

    _state_speed_modes[SM_ACCELERATED] = ID2SYM(rb_intern("accelerated"));
    _state_speed_modes[SM_DECELERATED] = ID2SYM(rb_intern("decelerated"));
    _state_speed_modes[SM_UNIFORM] = ID2SYM(rb_intern("uniform"));
}

/* Implementation */

VALUE rb_state_alloc(VALUE klass)
{
    State *state = state_new();
    return Data_Wrap_Struct(klass, NULL, state_delete, state);
}

VALUE rb_state_initialize(VALUE self, VALUE pos, VALUE angle)
{
    State *state = _state_unwrap(self);
    state->radians = _degrees2radians( NUM2DBL(angle) );
    v2d_assign(state->pos, _v2d_unwrap(pos));
    return self;
}

VALUE rb_state_get_angle(VALUE self)
{
    return rb_float_new( _radians2degrees( _state_unwrap(self)->radians ) );
}

VALUE rb_state_set_angle(VALUE self, VALUE value)
{
    _state_unwrap(self)->radians = _degrees2radians( NUM2DBL(value) );
    return value;
}

VALUE rb_state_cosa(VALUE self)
{
    return rb_float_new( state_cosa(_state_unwrap(self)) );
}

VALUE rb_state_sina(VALUE self)
{
    return rb_float_new( state_sina(_state_unwrap(self)) );
}

VALUE rb_state_correct(VALUE self)
{
    state_correct(_state_unwrap(self));
    return self;
}

VALUE rb_state_speed_mode(VALUE self)
{
    SpeedMode sm = state_speed_mode( _state_unwrap(self) );
    return _state_speed_modes[sm];
}


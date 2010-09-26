#include "state.h"
#include <math.h>
#include <ruby.h>

double _radians2degrees(double angle)
{
    return angle/M_PI*180;
}

double _degrees2radians(double angle)
{
    return angle*M_PI/180;
}
#define CORRECT_VALUE(val, min, max) val = (val < min) ? min : (val > max ? max : val)

State * state_new()
{
    State * s = (State *)xmalloc(sizeof(State));
    s->health = WORLD_MAX_HEALTH;
    s->speed = s->desired_speed = 0;
    s->pos = v2d_new();
    return s;
}

void state_delete(State * s)
{
    v2d_delete(s->pos);
    xfree(s);
}

double state_cosa(State * s)
{
    return cos( s->radians );
}

double state_sina(State * s)
{
    return sin( s->radians );
}

void state_correct(State * s)
{
    CORRECT_VALUE(s->pos->x, WORLD_BOT_RADIUS, WORLD_FIELD_SIZE - WORLD_BOT_RADIUS);
    CORRECT_VALUE(s->pos->y, WORLD_BOT_RADIUS, WORLD_FIELD_SIZE - WORLD_BOT_RADIUS);
    CORRECT_VALUE(s->speed, 0, WORLD_MAX_SPEED);
    CORRECT_VALUE(s->health, 0, WORLD_MAX_HEALTH);
}

SpeedMode state_speed_mode(State *s)
{
    if(s->speed > s->desired_speed)
        return SM_DECELERATED;
    else if(s->speed < s->desired_speed)
        return SM_ACCELERATED;
    else
        return SM_UNIFORM;
}


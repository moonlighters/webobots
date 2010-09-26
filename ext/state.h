#pragma once

#include "v2d.h"

/* Struct */

typedef struct _State
{
    V2D * pos;
    double radians;
    double speed;
    double desired_speed;
    double health;
} State;

typedef enum _SpeedMode
{
    SM_ACCELERATED,
    SM_DECELERATED,
    SM_UNIFORM
} SpeedMode;

// TODO: normal access to world constants!
#define WORLD_FIELD_SIZE 1000.0
#define WORLD_MAX_HEALTH 100.0
#define WORLD_MAX_SPEED 100.0
#define WORLD_BOT_RADIUS 30.0

/* Methods */

/* Convert +angle+ in radians into degrees */
double _radians2degrees(double angle);

/* Convert +angle+ in degrees into radians */
double _degrees2radians(double angle);

/* Allocates a new State struct with default values */
State * state_new();

/* Delete State */
void state_delete(State * s);

/* Returns cosine of angle of Bot */
double state_cosa(State * s);

/* Returns sine of angle of Bot */
double state_sina(State * s);

/* Corrects fields of State, that are out of bounds */
void state_correct(State * s);

/* Corrects fields of State, that are out of bounds */
SpeedMode state_speed_mode(State *s);


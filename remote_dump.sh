#!/bin/sh
cap dump:remote:create TABLES=-match_replays
cap dump:remote:download
rake dump:restore

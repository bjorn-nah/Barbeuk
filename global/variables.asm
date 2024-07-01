;first 3bytes used by famitone
  .rsset $0003  ;;start variables at ram location 03

;unrle variables
RLE_LOW		.rs 1
RLE_HIGH	.rs 1
RLE_TAG		.rs 1
RLE_BYTE	.rs 1

;rand8 seed
r_seed		.rs 1	;07

time		.rs 1	;08
buttons		.rs 1	;09
gamestate	.rs 1	;0A
substate	.rs 1	;0B
igPPUCTRL	.rs 1	;0C
cameraX		.rs 1	;0D
cameraY		.rs 1	;0E
PosX		.rs 1	;0F
PosY		.rs 1	;10
VectorX		.rs 1	;11
VectorDecX	.rs 1	;12
VectorY		.rs 1	;13
VectorDecY	.rs 1	;14
jump_vector .rs 1	;15
speed		.rs 1	;16
direction	.rs 1	;17
rotation	.rs 1	;18
scroll		.rs 1	;19
frame		.rs 1	;1A
tilePFrame	.rs 1	;1B
counter		.rs 1	

player_state	.rs 1	;1C
player_stp	.rs 1	;1D
player_tics	.rs 1	;1E
state_tics	.rs 1	;1F

arg1		.rs 1	;20
arg2		.rs 1	;21

charPosLo	.rs 1	;22
charPosHi	.rs 1	;23
charSide	.rs 1	;24

printLong	.rs 1	;25
printStart	.rs 1	;26
pointerLo	.rs 1	;27
pointerHi	.rs 1	;28
pointer1Lo	.rs 1	;29
pointer1Hi	.rs 1	;2A
pointerBCurrLo	.rs 1	;2B
pointerBCurrHi	.rs 1	;2C
pointerBLastLo	.rs 1	;2D
pointerBLastHi	.rs 1	;2E
pointerPPULo	.rs 1	;2F
pointerPPUHi	.rs 1	;30
pointerNMILo	.rs 1	;31
pointerNMIHi	.rs 1	;32
pointerBufferW	.rs 1	;33
pointerBufferL	.rs 1	;34
temp		.rs 1	;35
temp1		.rs 1	;36
temp2		.rs 1	;37

timeframe	.rs 1	;38

texttics	.rs 1
textpos		.rs 1
textwait	.rs 1
texterrase	.rs 1


nmiStatus	.rs 1	;39
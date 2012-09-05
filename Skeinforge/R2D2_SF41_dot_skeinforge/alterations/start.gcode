G21 (Set units to mm)
G90 (Absolute coordinates)
G28 (--Home all Axis ---)
G92 X0 Y0 Z0 E0 (-- Current position is 0,0,0 ---)
;-- Go up 5mm and then go to the center
G1 Z5.0 F300.0
G1 X100 Y100 Z0.72 F2000.0


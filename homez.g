; homez.g
; called to home the Z axis
;

; ============= PRE-HOMING =====================

; Ignore Machine boundaries
;M564 H0 S0

; Turn off bed leveling during homing
G29 S2 ; Does the same as M561!
G29 S2 ; Do it twice because once just isn't enough

; Switch to Origin Tool
T0

; Center XY for Z-Probe
;G1 X200 Y200 F1500 S1



; ============ HOME Z ==============

G91              ; relative positioning
G1 Z15 F6000 S2  ; lift Z relative to current position
G90              ; absolute positioning
M401 ; Deploy Probe!
G30 P0 X20 Y50 Z-99999 ; Probe the bed at X20 Y50 and save the XY coordinates and the height error as point 0
;G30 P1 X20 Y50 Z-99999 ; Probe the bed at X20 Y50 and save the XY coordinates and the height error as point 1
;G30 P2 X20 Y50 Z-99999 ; Probe the bed at X20 Y50 and save the XY coordinates and the height error as point 2
;G30 P3 X180 Y180 Z-99999 S4 ; Probe the bed at X180 Y180, save the XY coordinates and the height error as point 3 and calculate 4-point compensation or calibration
M402 ; Retract probe!

; Uncomment the following lines to lift Z after probing
G91             ; relative positioning
G1 S2 Z15 F100  ; lift Z relative to current position
G90             ; absolute positioning

; ============ Post-Homing ==============

; Re-enable mesh leveling
G29 S1

;M98 Pmachine_axisdimension.g ; Set Axes Limits

; Stop movement across limits, enable boundaries, homing requirement
;M564 H1 S1

; CONFIGURATION FILE for Duet Maestro
; Compound Nozzle

; Executed by the firmware on start-up

; Headers within parenthesis are headings in Duet3D documentation=https://duet3d.com/wiki/Configuring_RepRapFirmware_for_a_Cartesian_printer
; Visit https://reprap.org/wiki/G-code for an explanation of G-code commands

; --- SECTION: GENERAL PREFERENCES ( ) ---

M564 S1 H1 ; Enables Homing Requirement For Motor Activation and set axes limits

; --- SECTION: Z-PROBE & MESH COMPENSATION ---
; Determine the Probe Z Offset:
;  1. Heat the bed to 60C and the nozzle to 150C
;  2. Move the head near the center with G1 X200 Y200
;  3. Move the bed near the nozzle with G1 Z20
;  4. Disable the bed mesh with G29 S2, do this twice
; ---- DISABLE AXIS LIMITS M564 S0
;  5. Move the bed in small steps so it just touches the nozzle, 1mm steps first, then 0.1mm steps
;  6. Set the Z0 position with G92 Z0
;  7. Move the bed back to Z20, with G1 Z20
;  8. Deploy the probe if necessary
;  9. Get the Z Probe value with G30 S-1
; 10. Note the Z value in the Web UI and update it in the G31 Z parameter below
; 11. Put the Z probe away if necessary
M574 Z2 S2                                         ; Set endstops controlled by probe
M558 P1 H5 F120 T6000                              ; Set Z probe type to unmodulated and the dive height + speeds
G31 P500 X30.4 Y30.7 Z0.327                            ; Set Z probe trigger value, offset and trigger height
M557 X15:368 Y15:373 S20                           ; Define mesh grid

M557 X0:340 Y35:380 S48 ; Define heightmap mesh
M376 H25 ; Define height(mm) over which to taper off heightmap compensation

G29 S1 ; Load heightmap after power cycle

; --- SECTION: DRIVES (MOVEMENT SECTION) & ENDSTOPS ---

M667 S1  ; Enable coreXY mode
M569 P0 S0 ; Drive 0 goes forwards, CoreXY_1
M569 P1 S1 ; Drive 1 goes forwards, CoreXY_2
M569 P2 S1 ; Drive 2 goes backwards, Z Motor --- MODIFIED FOR MY SETUP!
M569 P3 S0 ; Drive 3 goes forwards, Left Extruder
M569 P4 S1 ; Drive 4 goes forwards, Right Extruder

; Use this if you have an optical Z endstop
;M574 X2 Y2 S0 ; Set xy end-stops types (S0 is active low, applied to XY)
;M574 Z2 S1 ; Set z end-stops types (S1 is active high, applied to Z)

; Use this if you have a mechanical XY endstop (and an IR Probe)
M574 X2 Y2 S0 ; Set xy end-stops types (S0 is active low, applied to XY)

M906 X680 Y680 Z600 E350:350 I60; Set motor currents (mA) and idle current percentage

M201 X500 Y500 Z75 E250:250 ; Set accelerations (mm/s^2)
M203 X4200 Y4200 Z2300 E5000:5000 ; Set maximum linear speeds
M566 X400 Y400 Z40 E300:300 ; Set maximum instantaneous speed changes (mm/min)

M208 X0 Y0 Z-0.5 S1    ; Set axis minima
M208 X383 Y388 Z377 S0 ; Set axis maxima

M92 X79.8 Y79.8 Z282.6961 ; Set axis steps/mm
M350 X32 Y32 Z32          ; Setting microstepping to 1/32.

M92 E180.4:180.4 ; Extruder Steps/mm
M350 E128:128    ; Setting microstepping to 1/128.

G21 ; Work in millimetres
G90 ; Set to absolute coordinates...
M84 S1 ; Set idle timeout

; --- SECTION: HEATERS, BED & THERMISTOR ---
; H0 is bed
; H1 is left heater
; H2 is right heater

M570 H0 P25 T30                           ; Allow heater to be off by as much as 30C for 25 seconds
M570 H1 P15 T30                           ; Allow heater to be off by as much as 30C for 15 seconds
M570 H2 P15 T30                           ; Allow heater to be off by as much as 30C for 15 seconds
M305 P0 T100000 B4138 C0 R2200            ; Set thermistor + ADC parameters for heater 0, For heated Bed thermistor
M305 P1 X501 R2200                        ; Define left side extruder PT1000
M305 P2 X502 R2200                        ; Define right side extruder PT1000
M307 H0 A78.9 C265.2 D9.5 S1.00 V24.0 B0  ; Forcing heated bed PID control after power-cycle. Basic bed heating auto-tune
M307 H1 A241.4 C104.5 D3.5 S1.00 V23.9 B0 ; Set PID values use M303 auto-tune calibration settings
M302 P1                                   ; Allow Cold extrudes

M143 H0 S120 ; Set maximum bed temperature to 120 C
M143 H1 S320 ; Set maximum heater temperature to 320C for hot end 1
M143 H2 S320 ; Set maximum heater temperature to 320C for hot end 2

; --- SECTION: FANS ( ) ---

M106 P0 S0 I0 F4 H-1 L0.3 ; Set fan 0 value, PWM signal inversion and frequency. Thermostatic control is turned off, Minimum fan value 0.3, Speed 100%
M106 P1 S0 I0 F4 H-1 L0.3 ; Set fan 1 value, PWM signal inversion and frequency. Thermostatic control is turned off, Minimum fan value 0.3, Speed 100%
M106 P2 S0 I0 F4 H-1 L0.3 ; Set fan 1 value, PWM signal inversion and frequency. Thermostatic control is turned off, Minimum fan value 0.3, Speed 100%

; --- SECTION: TOOLS ( ) ---

; Comment: Remember! H0 is the heated bed!
; Comment: D0 is the first driver after movement (X, Y and Z) drives, which is left extruder
; D1 is right extruder

; Mixing Tool T0
M563 P0 D0:1 H2 F2 S"Mixing" ; Define mixing tool
G10 P0 X0 Y0 Z0 ; Set axis offsets
G10 P0 R0 S0 ; Set active (S0) & standby temp (R0) at 0.
M567 P0 E0.5:0.5 ; Set tool mix ratios for extruder
M568 P0 S1 ; Turn on tool mixing for the extruder

; Left Only T1
M563 P1 D0 H2 F2 S"Mixing as Single Left" ; mixing nozzle only using left extruder motor
M568 P1 S0 ; Turn off tool mixing
G10 P1 X0 Y0 Z0 ; Set axis offsets
G10 P1 R0 S0 ; Set active (S0) & standby temp (R0) at 0.

; Right Only T2
M563 P2 D1 H2 F2 S"Mixing as Single Right" ; mixing nozzle only using right extruder motor
M568 P2 S0 ; Turn off tool mixing
G10 P2 X0 Y0 Z0 ; Set axis offsets
G10 P2 R0 S0 ; Set active (S0) & standby temp (R0) at 0.

T0 ; Automatic tool select

; --- SECTION: NETWORKS (PROLOGUE & COMMUNCATIONS SECTION) ---
M98 Pmachine_access.g ; set machine name and IP
M586 P0 S1 ; Enable HTTP
M586 P1 S0 ; Disable FTP
M586 P2 S0 ; Disable Telnet

; --- SECTION: MISCELLANEOUS ---

M572 D0:1 S0.07 ; Extruder Pressure Advance

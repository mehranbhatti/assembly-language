#include "ECE332_assembly_includes_00.inc" 
#include <xc.inc>

PSECT udata_acs                           ; Define a program section for uninitialized data in access RAM
GLOBAL Valx                               ; Declare Valx as a global variable, making it accessible across different files
Valx: DS 1                                ; Reserve 1 byte of storage for the variable Valx
PSECT resetVec,class=CODE,reloc=2  
PSECT code                                ; Define a section for code, where the program instructions will reside

; Define memory locations for variables
DELAY_COUNTER1   EQU 0x21                 ; Assign memory address 0x21 to DELAY_COUNTER1
DELAY_COUNTER2   EQU 0x22                 ; Assign memory address 0x22 to DELAY_COUNTER2
PATTERN_SELECT   EQU 0x23                 ; Assign memory address 0x23 to PATTERN_SELECT
VAR1 EQU 0x24                             ; Assign memory address 0x24 to VAR1
VAR2 EQU 0x25                             ; Assign memory address 0x25 to VAR2
VAR3 EQU 0x26                             ; Assign memory address 0x26 to VAR3
VAR4 EQU 0x27                             ; Assign memory address 0x27 to VAR4
 
; Define bit masks for patterns
PATTERN1 EQU 0x01                         ; Define PATTERN1 as 0x01 (binary 00000001)
PATTERN2 EQU 0x02                         ; Define PATTERN2 as 0x02 (binary 00000010)
PATTERN3 EQU 0x04                         ; Define PATTERN3 as 0x04 (binary 00000100)
PATTERN4 EQU 0x08                         ; Define PATTERN4 as 0x08 (binary 00001000)
PATTERN5 EQU 0x10                         ; Define PATTERN5 as 0x10 (binary 00010000)
PATTERN6 EQU 0x20                         ; Define PATTERN6 as 0x20 (binary 00100000)
PATTERN7 EQU 0x40                         ; Define PATTERN7 as 0x40 (binary 01000000)
PATTERN8 EQU 0x80                         ; Define PATTERN8 as 0x80 (binary 10000000)
 
; Initialize PORTB and PORTD
ORG 0x00                                  ; Set the program counter to address 0x00
CLRF PORTB                                ; Clear PORTB register, setting all its bits to 0
CLRF PORTD                                ; Clear PORTD register, setting all its bits to 0
MOVLW 0x00                                ; Load the W register with the literal value 0x00
MOVWF TRISB                               ; Move the value from W register to TRISB, configuring PORTB as output
MOVLW 0xFF                                ; Load the W register with the literal value 0xFF
MOVWF TRISD                               ; Move the value from W register to TRISD, configuring PORTD as input
MOVLW 0x01
MOVWF VAR1                                ; Move 0x01 to VAR1
MOVLW 0x02
MOVWF VAR2                                ; Move 0x02 to VAR2
MOVLW 0x03
MOVWF VAR3                                ; Move 0x03 to VAR3
MOVLW 0x04
MOVWF VAR4                                ; Move 0x04 to VAR4
MOVLW 0x00
MOVWF PATTERN_SELECT                      ; Initialize PATTERN_SELECT with 0x00
GOTO LOOP1                            ; Jump to the MAIN_LOOP label
    
LOOP1:
BTFSS PORTD, 0                            ; Test bit 0 of PORTD, skip next instruction if set
GOTO LOOP1                            ; Stay in LOOP1 if bit 0 of PORTD is not set
GOTO CHECK_FLAG                           ; Jump to CHECK_FLAG if bit 0 of PORTD is set
    
LOOP2:
CALL DELAY1
BTFSS PORTD, 0                            ; Test bit 0 of PORTD, skip next instruction if set
GOTO DISPLAY_SEQUENCE1                            ; JUMP to DISPLAY_SEQUENCE1 if bit 0 of PORTD is not set
GOTO CHECK_FLAG                           ; Jump to CHECK_FLAG if bit 0 of PORTD is set
    
LOOP3:
CALL DELAY1
BTFSS PORTD, 0                            ; Test bit 0 of PORTD, skip next instruction if set
GOTO DISPLAY_SEQUENCE1                            ; JUMP to DISPLAY_SEQUENCE1 if bit 0 of PORTD is not set
GOTO CHECK_FLAG                           ; Jump to CHECK_FLAG if bit 0 of PORTD is set
    
LOOP4:
CALL DELAY1
BTFSS PORTD, 0                            ; Test bit 0 of PORTD, skip next instruction if set
GOTO DISPLAY_SEQUENCE1                           ; JUMP to DISPLAY_SEQUENCE1 if bit 0 of PORTD is not set
GOTO CHECK_FLAG                           ; Jump to CHECK_FLAG if bit 0 of PORTD is set

LOOP5:
CALL DELAY1
BTFSS PORTD, 0                            ; Test bit 0 of PORTD, skip next instruction if set
GOTO DISPLAY_SEQUENCE1                           ; JUMP to DISPLAY_SEQUENCE1 if bit 0 of PORTD is not set
GOTO LOOP1                           ; Jump to CHECK_FLAG if bit 0 of PORTD is set
    
    
CHECK_FLAG:
INCF PATTERN_SELECT, F                    ; Increment the value of PATTERN_SELECT
GOTO DISPLAY_SEQUENCE1                    ; Jump to DISPLAY_SEQUENCE1

DISPLAY_SEQUENCE1:
MOVF PATTERN_SELECT, W                    ; Move the value of PATTERN_SELECT to W register
CPFSEQ VAR1                               ; Compare the value in W register with VAR1, skip next instruction if equal
GOTO DISPLAY_SEQUENCE2                    ; Jump to DISPLAY_SEQUENCE2 if not equal
GOTO PATTERN_OFF                          ; Jump to PATTERN_OFF if equal

DISPLAY_SEQUENCE2:
MOVF PATTERN_SELECT, W                    ; Move the value of PATTERN_SELECT to W register
CPFSEQ VAR2                               ; Compare the value in W register with VAR2, skip next instruction if equal
GOTO DISPLAY_SEQUENCE3                    ; Jump to DISPLAY_SEQUENCE3 if not equal
GOTO PATTERN_SLOW                         ; Jump to PATTERN_SLOW if equal
    
DISPLAY_SEQUENCE3:
MOVF PATTERN_SELECT, W                    ; Move the value of PATTERN_SELECT to W register
CPFSEQ VAR3                               ; Compare the value in W register with VAR3, skip next instruction if equal
GOTO DISPLAY_SEQUENCE4                    ; Jump to DISPLAY_SEQUENCE4 if not equal
GOTO PATTERN_MEDIUM                       ; Jump to PATTERN_MEDIUM if equal
    
DISPLAY_SEQUENCE4:
MOVF PATTERN_SELECT, W                    ; Move the value of PATTERN_SELECT to W register
CPFSEQ VAR4                               ; Compare the value in W register with VAR4, skip next instruction if equal
GOTO END_SEQUENCE                         ; Jump to END_SEQUENCE if equal
GOTO PATTERN_FAST                         ; Jump to PATTERN_FAST if not equal   

; Pattern display routine
PATTERN_OFF:
CLRF PORTB                                ; Clear PORTB (turn off all LEDs)
CALL DELAY1                               ; Call the DELAY1 subroutine for a delay
GOTO LOOP2                            ; Go back to MAIN_LOOP

PATTERN_SLOW:
    MOVLW PATTERN1                           ; Load the value defined by PATTERN1 into the Working register (WREG)
MOVWF PORTB                              ; Move the value from WREG to PORTB (likely controlling LEDs or similar ;output)
CALL DELAY1                              ; Call the DELAY1 subroutine, which introduces a delay (for pacing the ;pattern display)

MOVLW PATTERN2                           ; Load the value defined by PATTERN2 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (updating the output to the next ;pattern)
CALL DELAY1                              ; Call the DELAY1 subroutine again for a consistent delay between pattern ;changes

MOVLW PATTERN3                           ; Load the value defined by PATTERN3 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the third pattern)
CALL DELAY1                              ; Call DELAY1 to maintain the timing between the pattern displays

MOVLW PATTERN4                           ; Load the value defined by PATTERN4 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the fourth pattern)
CALL DELAY1                              ; Invoke DELAY1 for a timed delay before showing the next pattern

MOVLW PATTERN5                           ; Load the value defined by PATTERN5 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the fifth pattern)
CALL DELAY1                              ; Call the DELAY1 subroutine for a delay before the next pattern

MOVLW PATTERN6                           ; Load the value defined by PATTERN6 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the sixth pattern)
CALL DELAY1                              ; Call DELAY1 for a timed delay, maintaining the rhythm of pattern display

MOVLW PATTERN7                           ; Load the value defined by PATTERN7 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the seventh pattern)
CALL DELAY1                              ; Invoke DELAY1 to introduce a delay before the final pattern

MOVLW PATTERN8                           ; Load the value defined by PATTERN8 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the eighth and final ;pattern)
CALL DELAY1                              ; Call DELAY1 for the last time in this sequence to introduce the final delay

GOTO LOOP3                           ; Jump back to the MAIN_LOOP label, likely to restart the pattern ;sequence or check for input


PATTERN_MEDIUM:
    MOVLW PATTERN1                           ; Load the value defined by PATTERN1 into the Working register (WREG)
MOVWF PORTB                              ; Move the value from WREG to PORTB (likely controlling LEDs or similar ;output)
CALL DELAY2                              ; Call the DELAY1 subroutine, which introduces a delay (for pacing the ;pattern display)

MOVLW PATTERN2                           ; Load the value defined by PATTERN2 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (updating the output to the next ;pattern)
CALL DELAY2                              ; Call the DELAY1 subroutine again for a consistent delay between pattern ;changes

MOVLW PATTERN3                           ; Load the value defined by PATTERN3 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the third pattern)
CALL DELAY2                              ; Call DELAY1 to maintain the timing between the pattern displays

MOVLW PATTERN4                           ; Load the value defined by PATTERN4 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the fourth pattern)
CALL DELAY2                              ; Invoke DELAY1 for a timed delay before showing the next pattern

MOVLW PATTERN5                           ; Load the value defined by PATTERN5 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the fifth pattern)
CALL DELAY2                              ; Call the DELAY1 subroutine for a delay before the next pattern

MOVLW PATTERN6                           ; Load the value defined by PATTERN6 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the sixth pattern)
CALL DELAY2                              ; Call DELAY1 for a timed delay, maintaining the rhythm of pattern display

MOVLW PATTERN7                           ; Load the value defined by PATTERN7 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the seventh pattern)
CALL DELAY2                              ; Invoke DELAY1 to introduce a delay before the final pattern

MOVLW PATTERN8                           ; Load the value defined by PATTERN8 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the eighth and final ;pattern)
CALL DELAY2                              ; Call DELAY1 for the last time in this sequence to introduce the final delay

GOTO LOOP4                           ; Jump back to the MAIN_LOOP label, likely to restart the pattern ;sequence or check for input
    

PATTERN_FAST:
    MOVLW PATTERN1                           ; Load the value defined by PATTERN1 into the Working register ;(WREG)
MOVWF PORTB                              ; Move the value from WREG to PORTB (likely controlling LEDs or similar ;output)
CALL DELAY3                              ; Call the DELAY1 subroutine, which introduces a delay (for pacing the ;pattern display)

MOVLW PATTERN2                           ; Load the value defined by PATTERN2 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (updating the output to the next ;pattern)
CALL DELAY3                              ; Call the DELAY1 subroutine again for a consistent delay between pattern ;changes

MOVLW PATTERN3                           ; Load the value defined by PATTERN3 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the third pattern)
CALL DELAY3                              ; Call DELAY1 to maintain the timing between the pattern displays

MOVLW PATTERN4                           ; Load the value defined by PATTERN4 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the fourth pattern)
CALL DELAY3                              ; Invoke DELAY1 for a timed delay before showing the next pattern

MOVLW PATTERN5                           ; Load the value defined by PATTERN5 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the fifth pattern)
CALL DELAY3                              ; Call the DELAY1 subroutine for a delay before the next pattern

MOVLW PATTERN6                           ; Load the value defined by PATTERN6 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the sixth pattern)
CALL DELAY3                              ; Call DELAY1 for a timed delay, maintaining the rhythm of pattern display

MOVLW PATTERN7                           ; Load the value defined by PATTERN7 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the seventh pattern)
CALL DELAY3                              ; Invoke DELAY1 to introduce a delay before the final pattern

MOVLW PATTERN8                           ; Load the value defined by PATTERN8 into WREG
MOVWF PORTB                              ; Move the value from WREG to PORTB (display the eighth and final ;pattern)
CALL DELAY3                              ; Call DELAY1 for the last time in this sequence to introduce the final delay

GOTO LOOP5                           ; Jump back to the MAIN_LOOP label, likely to restart the pattern ;sequence or check for input


END_SEQUENCE:
    CLRF PATTERN_SELECT
    GOTO LOOP1
    
DELAY1:
    MOVLW   0xFF                          ; Load the literal value 0xFF (255 in decimal) into the Working register ;(WREG)
    MOVWF   DELAY_COUNTER1                ; Move the value from WREG to DELAY_COUNTER1, ;initializing the first delay counter

DELAY1_LOOP1:
    MOVLW   0xFF                          ; Load the literal value 0xFF into WREG again
    MOVWF   DELAY_COUNTER2                ; Move the value from WREG to DELAY_COUNTER2, ;initializing the second delay counter

DELAY1_LOOP2:
    DECFSZ  DELAY_COUNTER2, 1             ; Decrement DELAY_COUNTER2 by 1, skip the next instruction ;if it becomes zero
    GOTO    DELAY1_LOOP2                  ; If DELAY_COUNTER2 is not zero, loop back to DELAY1_LOOP2
    DECFSZ  DELAY_COUNTER1, 1             ; Decrement DELAY_COUNTER1 by 1, skip the next instruction ;if it becomes zero
    GOTO    DELAY1_LOOP1                  ; If DELAY_COUNTER1 is not zero, loop back to DELAY1_LOOP1
    RETURN                                ; Return from the subroutine when both counters have decremented to zero                                

DELAY2:
    MOVLW   0x7F                          ; Load the literal value 0x7F (127 in decimal) into the Working register ;(WREG)
    MOVWF   DELAY_COUNTER1                ; Move the value from WREG to DELAY_COUNTER1, ;initializing the first delay counter with a medium value

DELAY2_LOOP1:
    MOVLW   0xFF                          ; Load the literal value 0xFF (255 in decimal) into WREG
    MOVWF   DELAY_COUNTER2                ; Move the value from WREG to DELAY_COUNTER2, ;initializing the second delay counter with its maximum value

DELAY2_LOOP2:
    DECFSZ  DELAY_COUNTER2, 1             ; Decrement DELAY_COUNTER2 by 1, skip the next instruction ;if it becomes zero
    GOTO    DELAY2_LOOP2                  ; If DELAY_COUNTER2 is not zero, loop back to DELAY2_LOOP2
    DECFSZ  DELAY_COUNTER1, 1             ; Decrement DELAY_COUNTER1 by 1, skip the next instruction ;if it becomes zero
    GOTO    DELAY2_LOOP1                  ; If DELAY_COUNTER1 is not zero, loop back to DELAY2_LOOP1
    RETURN                                ; Return from the subroutine when both counters have decremented to zero                                
    
DELAY3:
    MOVLW   0x1F                          ; Load the literal value 0x1F (31 in decimal) into the Working register ;(WREG)
    MOVWF   DELAY_COUNTER1                ; Move the value from WREG to DELAY_COUNTER1, ;initializing the first delay counter with a smaller value

DELAY3_LOOP1:
    MOVLW   0xFF                          ; Load the literal value 0xFF (255 in decimal) into WREG
    MOVWF   DELAY_COUNTER2                ; Move the value from WREG to DELAY_COUNTER2, ;initializing the second delay counter with its maximum value

DELAY3_LOOP2:
    DECFSZ  DELAY_COUNTER2, 1             ; Decrement DELAY_COUNTER2 by 1, skip the next instruction ;if it becomes zero
    GOTO    DELAY3_LOOP2                  ; If DELAY_COUNTER2 is not zero, loop back to DELAY3_LOOP2
    DECFSZ  DELAY_COUNTER1, 1             ; Decrement DELAY_COUNTER1 by 1, skip the next instruction ;if it becomes zero
    GOTO    DELAY3_LOOP1                  ; If DELAY_COUNTER1 is not zero, loop back to DELAY3_LOOP1
    RETURN                                ; Return from the subroutine when both counters have decremented to zero                                 
    
    END                                  

; Team Members: Destiny T, Victor Q, Saul R
; Program: Test Score Calculator
;Description: Create an LC-3 program that displays ;the minimum, maximum,
; and average grade of 5 test scores and display the ;letter grade 
; associated with the test scores. 
; Input: The user is prompted to input the test scores.
;Output: Display the Minimum, Average, & ;Maximum score with appropriate letter grade.

; Letter Grading Criteria:
;(0~59 == F, 60~69 == D, 70~79 == C, 80~89 == B, 90~100 == A)


.ORIG x3000

; MAIN

LEA R0, WEL  ; Load effective address of welcome message
PUTS                 ; Print message
WEL .STRINGZ "Enter 5 scores (0 - 99): "  ;  message

LD R0, NEWLINE       ; Load newline character
OUT                  ; Output newline

; Loop to get 5 grades, store in SCORES array, and convert to letters
LEA R6, SCORES       ; Load effective address of SCORES array into R6
LD R1, NUM_TESTS     ; Load number of tests into R1

LOOP_GET_SCORES
    JSR GET_SCORE    ; Jump to subroutine to get a score from the user
    STR R3, R6, #0    ; Store the grade in SCORES array
    JSR GET_LETTER   ; Jump to subroutine to convert the grade to a letter
    ADD R6, R6, #1   ; Move to the next position in the SCORES array
    JSR POP          ; Jump to subroutine to clear register
    LD R0, NEWLINE   ; Load newline character
    OUT              ; Output newline
    ADD R1, R1, #-1  ; Decrement counter for remaining tests
    BRp LOOP_GET_SCORES  ; Branch to LOOP_GET_SCORES if more tests remaining




; Calculate maximum score

CALCULATE_MAX
    LD R1, NUM_TESTS ; Load number of tests into R1
    LEA R2, SCORES   ; Load effective address of SCORES array into R2
    LDR R4, R2, #0   ; Load first grade into R4
    ST R4, MAX_SCORE ; Store the first grade as maximum score
    ADD R2, R2, #1   ; Move to the next position in the SCORES array


LOOP_MAX
    LDR R5, R2, #0   ; Load next score into R5
    NOT R4, R4       ; Negate R4
    ADD R4, R4, #1   ; Increment R4
    ADD R5, R5, R4   ; Add R4 to R5
    BRp NEXT_MAX     ; Branch to NEXT_MAX if R5 is positive
    LD R4, R5        ; Update maximum score if R5 is greater
NEXT_MAX
    ST R4, MAX_SCORE ; Store the maximum score
    ADD R2, R2, #1   ; Move to the next position in the SCORES array
    ADD R1, R1, #-1  ; Decrement counter for remaining tests
    BRp LOOP_MAX     ; Branch to LOOP_MAX if more tests remaining

    LEA R0, MAX      ; Load effective address of "MAX" message
    PUTS             ; Print "MAX" message
    LD R3, MAX_SCORE ; Load maximum grade
    JSR BREAK_INT    ; Jump to subroutine to break integer into ASCII characters
    LD R0, SPACE     ; Load space character
    OUT              ; Output space

LD R0, NEWLINE       ; Load newline character
OUT                  ; Output newline
JSR CLEAR_REG        ; Jump to subroutine to clear registers



; Calculate minimum score

CALCULATE_MIN
    LD R1, NUM_TESTS ; Load number of tests into R1
    LEA R2, SCORES   ; Load effective address of SCORES array into R2
    LDR R4, R2, #0   ; Load first grade into R4
    ST R4, MIN_SCORE ; Store the first score as minimum score
    ADD R2, R2, #1   ; Move to the next position in the SCORES array

LOOP_MIN
    LDR R5, R2, #0   ; Load next score into R5
    NOT R4, R4       ; Negate R4
    ADD R4, R4, #1   ; Increment R4
    ADD R5, R5, R4   ; Add R4 to R5
    BRn NEXT_MIN     ; Branch to NEXT_MIN if R5 is negative
    LD R4, R5        ; Update minimum grade if R5 is smaller
NEXT_MIN
    ST R4, MIN_SCORE ; Store the minimum score
    ADD R2, R2, #1   ; Move to the next position in the SCORES array
    ADD R1, R1, #-1  ; Decrement counter for remaining tests
    BRp LOOP_MIN     ; Branch to LOOP_MIN if more tests remaining

    LEA R0, MIN      ; Load effective address of "MIN" message
    PUTS             ; Print "MIN" message
    LD R3, MIN_SCORE ; Load minimum grade
    JSR BREAK_INT    ; Jump to subroutine to break integer into ASCII characters
    LD R0, SPACE     ; Load space character
    OUT              ; Output space

JSR CLEAR_REG        ; Jump to subroutine to clear registers
LD R0, NEWLINE       ; Load newline character
OUT                  ; Output newline

; Calculate average score

CALC_AVG
    LD R1, NUM_TESTS ; Load number of tests into R1
    LEA R2, SCORES   ; Load effective address of SCORES array into R2

    AND R3, R3, #0   ; Clear R3 (accumulator for sum of scores)

LOOP_SUM
    LDR R4, R2, #0   ; Load grade into R4
    ADD R3, R3, R4   ; Add grade to accumulator
    ADD R2, R2, #1   ; Move to the next position in the SCORES array
    ADD R1, R1, #-1  ; Decrement counter for remaining tests
    BRp LOOP_SUM     ; Branch to LOOP_SUM if more tests remaining

    LD R1, NUM_TESTS ; Load number of tests into R1
    NOT R1, R1       ; Negate R1
    ADD R1, R1, #1   ; Increment R1

LOOP_DIV
    ADD R4, R3, R1   ; Add 1 to sum of scores
    BRn DONE_AVG     ; Branch to DONE_AVG if sum is negative
    ADD R6, R6, #1   ; Increment counter for number of tests
    BRp LOOP_DIV     ; Branch to LOOP_DIV if sum is positive

DONE_AVG
    ST R6, AVERAGE_SCORE  ; Store number of tests in AVERAGE_SCORE
    LEA R0, AVG      ; Load effective address of "AVG" message
    PUTS             ; Print "AVG" message
    AND R3, R3, #0   ; Clear R3 (accumulator)
    AND R1, R1, #0   ; Clear R1
    AND R4, R4, #0   ; Clear R4
    ADD R3, R3, R6   ; Add number of tests
    JSR BREAK_INT

;END CALCULATE AVERAGE 

JSR RESTART_PROG
HALT


; GLOBAL VARIABLES 1

NEWLINE .FILL xA	; Newline char ASCII code 
SPACE .FILL x20	; Space char ASCII code
DECODE_DEC .FILL #-48	; For decoding ASCII digit→ Decimal #’s
DECODE_SYM .FILL #48	; For decoding ASCII symbols → Decimal #’s
NUM_TESTS .FILL 5		; # of tests constant
RESTART2 .FILL x3000	; address at x3000  to restart program exec

MAX_SCORE .BLKW 1	; Max score var declaration
MIN_SCORE .BLKW 1	; Min score var declaration
AVERAGE_SCORE .BLKW 1	; Avg score var declaration

GRADES .BLKW 5	; array for Scores

MIN .STRINGZ "MIN "		; Min output string
MAX .STRINGZ "MAX "	; Max output string
AVG .STRINGZ "AVG "	; Avg output string


; SUBROUTINES

RESTART_PROG
    ST R7, SAVELOC1		; saving return address
    LD R1, LOWER_Y		; loading low bounds for Input Validation
    LD R3, UPPER_Y		; loading upper bounds for input validation
    LD R2, ORIGIN		; loading origin address for restarting 
    LD R0, NEWLINE		; load newline char
    OUT
    LEA R0, RESTARTPROG_STR	; load Restart msg address
    PUTS		; Output restart msg to console
    LD R0, NEWLINE	; 
    OUT
    GETC	; Getting users input
    ADD R1, R1, R0	; Determine if input is in lower bound 
    BRz RESTART_TRUE	; if input  is in lower bound, restart
    ADD R3, R3, R0		; Determine if input is in upper bound
    BRz RESTART_TRUE	; if input is in upper bound, restart
    HALT

RESTART_TRUE	; restart program branch
    JMP R2	; origin address jump

RESTARTPROG_STR .STRINGZ "PROGRAM FINISHED, DO YOU WANT TO RUN THIS PROGRAM AGAIN? Y/N "
LOWER_Y .FILL xFF87	      ; lower bounds input validation (Y)
UPPER_Y .FILL xFFA7    	; upper bounds input validation (N)
ORIGIN .FILL x3000		    ; origin address for restarting

SAVELOC1 .FILL x0		; storing for return address 


; SUBROUTINE GET_SCORE


GET_SCORE		; getting 1 score from user for subroutine 
    ST R7, SAVELOC1		; saving returnaddress
    JSR CLEAR_REG	
    LD R4, DECODE_DEC	; loading const for decoding Ascii Digits → Decimal #’s
    GETC
    JSR VALIDA	; user input validation
    OUT		; outputting user input 
    ADD R1, R0, R4	; ASCII → Decimal conversion 
    ADD R3, R3, R1	; Totaling user score
    ADD R3, R3, #10	; Next digit position
    GETC	; Get nxt digit from user 
    JSR VALIDA	; User input validation
    OUT	
    ADD R0, R0, R4	; ASCII → Decimal conversion
    ADD R3, R3, R0	; Totaling user score
    LD R0, SPACE	
    OUT
    LD R7, SAVELOC1		; restoring our return address
RET


; SUBROUTINE BREAK_INT


BREAK_INT	; breaking our integer into corresponding their digits
    ST R7, SAVELOC1		; saving ret address 
    LD R5, DECODE_SYM	; loading const for decoding ASCII symbol(s) → Decimal #’s
    ADD R4, R3, #0	; Copy int
    AND R1, R1, #0	; digit initialization 

DIV1
    ADD R1, R1, #1	; incrementing digits counter 
    ADD R4, R4, #-10	;  -10 from integer
    BRp DIV1		; if (+)  result, continue looping
    ADD R1, R1, #-1
    ADD R4, R4, #10	; +10 to integer
    ST R1, Q		; storing how much digits
    ST R4, R		; storing remainder
    LD R0, Q
    ADD R0, R0, R5	; to ASCII conversion
    OUT
    LD R0, R
    ADD R0, R0, R5	; to ASCII conversion
    OUT
    LD R7, SAVELOC1		; return address restoration
RET

R .FILL x0
Q .FILL x0

; SUBROUTINE PUSH

PUSH
    ST R7, SAVELOC2		; saving return address
    JSR CLEAR_REG
    LD R6, POINTER		; loading pointer for stack 
    ADD R6, R6, #-1		;  negative decrement stack pointer by one
    STR R0, R6, #0		; store its value to stack
    ST R6, POINTER	; updating stack pointer
    LD R7, SAVELOC2
RET

POINTER .FILL x4000	; memory address for pointer

; SUBROUTINE POP

POP
    LD R6, POINTER	; loading stack pointer 
    LDR R0, R6, #0	; loading value of stack 
    ADD R6, R6, #1	; positive increment stack pointer by one 
    ST R6, POINTER
    LD R7, SAVELOC4
RET

; SUBROUTINE GET_LETTER

GET_LETTER
    AND R2, R2, #0

A_GRADE		; determine if score is within ‘A’ criteria
    LD R0, A_NUM	; loading ‘A’ num required  values 
    LD R1, A_LET	; loading ‘A’ in ASCII 
    ADD R2, R3, R0	; Checking ‘A’ upper/lower threshold 
    BRzp STR_GRADE	; If meets criteria, convert to ‘A’ 

B_GRADE		  ; REPEAT STEPS for B-D grades
    AND R2, R2, #0
    LD R0, B_NUM
    LD R1, B_LET
    ADD R2, R3, R0
    BRzp STR_GRADE

C_GRADE		; REPEAT
    AND R2, R2, #0
    LD R0, C_NUM
    LD R1, C_LET
    ADD R2, R3, R0
    BRzp STR_GRADE
		
D_GRADE		; REPEAT 
    AND R2, R2, #0
    LD R0, D_NUM
    LD R1, D_LET
    ADD R2, R3, R0
    BRzp STR_GRADE

F_GRADE		; REPEAT 
    AND R2, R2, #0
    LD R0, F_NUM
    LD R1, F_LET
    ADD R2, R3, R0
    BRzp STR_GRADE

STR_GRADE		;outputting letter grade to console 
    LD R0, SPACE
    OUT
    LD R0, R1
    OUT
    RET

A_NUM .FILL #-90
B_NUM .FILL #-80
C_NUM .FILL #-70
D_NUM .FILL #-60
F_NUM .FILL #0
A_LET .FILL x41
B_LET .FILL x42
C_LET .FILL x43
D_LET .FILL x44
F_LET .FILL x46

; SUBROUTINE VALIDA

VALIDA		; User input validation subroutine
    LD R5, DECODE_DEC	; decode ASCII digit → decimal #’s 
    LD R6, CHECK_VALID	; const for checking if valid input
    NOT R6, R6
    ADD R6, R6, R0	; Determining if input is valid or not
    BRzp LOOP_VAL	; If it is, branch to additional validation 
    ADD R6, R6, R5	; If not valid catcher 
LOOP_VAL	; Additional validation
    ADD R6, R6, #-10
    BRzp RET_VAL

    LD R0, NEWLINE
    OUT
    LEA R0, ILE
    PUTS
    LD R0, NEWLINE	;loading newline
    OUT
    GETC
    JSR VALIDA

ILE .STRINGZ "INVALID LETTER ENTERED!"        ; ERROR msg to console if input not valid
CHECK_VALID .FILL xB
RET_VAL
    RET

; SUBROUTINE CLEAR_REG

CLEAR_REG		; clearing all registers subroutine
    AND R1, R1, #0
    AND R2, R2, #0
    AND R3, R3, #0
    AND R4, R4, #0
    AND R5, R5, #0
    AND R6, R6, #0
    AND R7, R7, #0
    RET

; GLOBAL VARIABLES 2

ASCII_X .FILL x30
HUNDO .FILL #100
ONE .FILL x1
TEN .FILL xA

.END





.ORIG x3d00
LEA R0, MSG-WELCOME         ; Load address of MSG-WELCOME into R0
PUTS                        ; Output message in console
LOOP                        ; The LOOP function begins
	LEA R0, MSG-INPUT       ; Load address of MSG-INPUT into R0
    PUTS                    ; Outputs message in console
    JSR readS               ; Calls the readS function
    JSR isPrime             ; Call the isPrime function
    JSR resultS             ; Call the resultS function
    JSR LOOP                ; Call the LOOP function
	HALT                    ; Halt the program

	                        ; Messages
MSG-INPUT   .STRINGZ "Input a decimal number with 1-5 digits and finish with enter:\n>"
MSG-WELCOME .STRINGZ "WELCOME TO PRIME CALCULATOR DELUXE. \nIT CAN'T CALCULATE PRIMES, BUT IT CAN TELL YOU IF A NUMBER IS A PRIME\n(as long as it is less than 30.000)\n\n"
.END

.ORIG x4000
                            ; Checks if number is prime
                            ; If number is prime R0 is set to 1, else 0
isPrime                     ; The isPrime function begins

    ST R1, SAVE2REG1        ; Store register R1
    ST R2, SAVE2REG2        ; Store register R2
    ST R3, SAVE2REG3        ; Store register R3
    ST R4, SAVE2REG4        ; Store register R4 (R4 gets overwritten in divide subroutine)
    ST R5, SAVE2REG5        ; Store register R5
    ST R7, RETURNADDRESS    ; Store register R7 (We need to save return address because we overwrite it in our call to JSR divide)

                            ; Check if number is 2. If it is two we return that it is prime.
    ADD R1, R0, x-2         ; Subtracts 1 from R1
    BRz PRIME               ; Branch to PRIME if R1 is zero

                            ; Check if number is odd
    AND R1, R0, x1          ; Bitwise AND operation between input and "1"
    BRz NOTPRIME            ; Branch to NOTPRIME if AND oparation is zero (input is an even number)

                            ; We have an odd number larger than 2. We now need to check if it is prime.
                            ; We know R1 is x1 from AND statment few lines before.
                            ; We will loop for all odd numbers from 3 up to our number to test in R0, and see if they ever are evenly divisible.
                            ; If they are not evenly divisible we have a prime number.
                            ; We start at x3, so we add x2 to R1

    AND R2, R2, x0          ; CLear R2
    ADD R2, R2, x-1         ; Subtract 1 from R2

                            ; R2 is the negative inverse of the counter that goes 3, 5, 7...
                            ; R2 goes -3, -5, -7... We use that to check when  we reach R0, the number we are testing for

                            ; This saves us one operation per loop lap. Else we would need to calculate the inverse by first -
                            ; using NOT on R1, and then ADD R1, R1, x1.

ODD ADD R2, R2, x-2         ; Subtract 2 from R2
    ADD R3, R0, R2          ; Subtract R2 from input number
    BRz PRIME               ; Branch to PRIME if zero
    ADD R1, R1, x2          ; Add 2 to R1

                            ; We divide R0, with R1
    JSR DIVIDE              ; Call DIVIDE function

    NOT R5, R5              ; We use NOT twice to check if number is positive or zero.
    NOT R5, R5
    BRnp ODD                ; Branch to ODD if negative or positive. If zero we don't have a prime number

NOTPRIME                    ; The NOTPRIME function begins
    AND R0, R0, x0          ; Clear R0
    BRnzp RESTOREREG        ; Branch to RESTOREREG function

PRIME                       ; The PRIME function begins
    AND R0, R0, x0          ; Clear R0
    ADD R0, R0, x1          ; Add 1 to R0 (indicating the number is a prime number)
RESTOREREG
    LD R1, SAVE2REG1        ; Restore register R1.
    LD R2, SAVE2REG2        ; Restore register R2.
    LD R3, SAVE2REG3        ; Restore register R3.
    LD R4, SAVE2REG4        ; Restore register R4.
    LD R5, SAVE2REG5        ; Restore register R5.
    LD R7, RETURNADDRESS    ; Restore register R7.
    RET                     ; Return from subroutine

                            ; resultS takes a value as argument stored in R0. If the value in
                            ; R0 is not zero then the function displays the message: “The number is prime"
                            ; If R0 is 0 it displays the message “The number is not prime”.

resultS                     ; The resultS function begins
    NOT R0, R0              ; Double NOT to see if R0 is positive or zero
    NOT R0, R0
    BRz SKIP                ; Branch to SKIP if R0 is zero
    LEA R0, MSG-IS-PRIME    ; Load address of message "MSG-IS-PRIME" into R0
    PUTS                    ; Output message to console
    RET                     ; Return from subroutine
SKIP
    LEA R0, MSG-IS-NOT-PRIME; Load address of message "MSG-IS-NOT-PRIME" into R0
    PUTS                    ; Output message to console
    RET                     ; Return from subroutine

                            ; MESSAGES
MSG-IS-PRIME        .STRINGZ "The number is prime.\n"
MSG-IS-NOT-PRIME    .STRINGZ "The number is not prime.\n"

RETURNADDRESS   .BLKW 1     ; Reserve memory for RETURNADDRESS
SAVE2REG1       .BLKW 1     ; Reserve memory for SAVE2REG1
SAVE2REG2       .BLKW 1     ; Reserve memory for SAVE2REG2
SAVE2REG3       .BLKW 1     ; Reserve memory for SAVE2REG3
SAVE2REG4       .BLKW 1     ; Reserve memory for SAVE2REG4
SAVE2REG5       .BLKW 1     ; Reserve memory for SAVE2REG5

                            ; Puts result in R4 and quotient in R5
                            ; Input is R0, number to divide and R1, divisor

DIVIDE                      ; The DIVIDE function begins
        ST R0, SAVEREG1     ; Store register R0
        ST R1, SAVEREG2     ; Store register R1
        ST R2, SAVEREG3     ; Store register R2

        AND R4, R4, x0      ; Clear R4
        NOT R2, R1          ; Performs bitwise NOT of R1 and stores in R2
        ADD R2, R2, x1      ; Add 1 to R2 (R1 = -R2)

SUB     ADD R4, R4, x1      ; Add 1 to R4
        ADD R0, R0, R2      ; Add R2 to R0 (Subtracts R1 from input until negative(R4 counts))
        BRzp SUB            ; Branch to SUB if RO is zero or positive

        ADD R4, R4, x-1     ; Subtract 1 from R4
        AND R5, R5, x0      ; Clear R5
        ADD R5, R0, R1      ; Add R0 and R1 to R5 (R5=R1+R0)

        LD R0, SAVEREG1     ; Restore registers R0
        LD R1, SAVEREG2     ; Restore registers R1
        LD R2, SAVEREG3     ; Restore registers R2
        RET                 ; Return from subroutine

                            ; Recieve two digit number and save it to R0

readS                       ; The readS function begins
    ST R1, SAVEREG1         ; Store register R1
    ST R2, SAVEREG2         ; Store register R2
    ST R3, SAVEREG3         ; Store register R3
    ST R4, SAVEREG4         ; Store register R4
    ST R5, SAVEREG5         ; Store register R5
    ST R7, SAVEREG7         ; Store register R7

    AND R1, R1, x0          ; Clear R1
    LD R3, NEWLINE          ; Load R3 with "NEWLINE"
    NOT R3, R3              ; Bitwise NOT of R3
    ADD R3, R3, x1          ; Use R3 to check if char is newline
    ADD R1, R1, x5          ; Loop counter
    LD R4, ASCII-TO-NUM     ; Conversion
    LEA R5, DIGITS          ; Pointer to where we save DIGITS

GETNUM                      ; The GETNUM function begins
    GETC                    ; Reads single ASCII from keyboard into R0
    ADD R2, R0, R3          ; Add R0 and R3 to R2
    BRz LEAVE               ; Branch to LEAVE if zero
    OUT                     ; Print digit to console
    ADD R0, R0, R4          ; Convert ASCII to numeric
    STR R0, R5, x0          ; Store digit
    ADD R5, R5, x1          ; Move pointer to DIGIT one.
    ADD R1, R1, x-1         ; Subtract 1 from R1
    BRp GETNUM              ; Branch to GETNUM if positive

LEAVE                       ; The LEAVE function begins
    LD R0, NEWLINE          ; Loads NEWLINE into R0
    OUT                     ; Prints the empty line

                            ; We now have 5 digits in DIGITS
    NOT R1, R1              ; Negates R1
    ADD R1, R1, x1          ; Add 1 to R1
    ADD R1, R1, x5          ; Add 5 to R1
                            ; R1 contains number of digits we have recieved
    LEA R5, DIGITS          ; Load address of DIGITS into R5
    AND R0, R0, x0          ; Clear R0

FOR-EACH-DIGIT              ; The FOR-EACH-DIGIT function begins
    LDR R3, R5, x0          ; Load first value pointed at by R5
    ADD R2, R1, x-1         ; Subtract 1 from R1 and store in R2

FOR-SIZE-OF-DIGIT           ; The FOR-SIZE-OF-DIGIT function begins
                            ;Branch to LEAVE-INNER-DIGIT-LOOP if negative or zero
    BRnz LEAVE-INNER-DIGIT-LOOP
    JSR MULTIPLY-BY-TEN     ; Call MULTIPLY-BY-TEN function
    ADD R2, R2, x-1         ; Subtract 1 from R2
    BRnzp FOR-SIZE-OF-DIGIT ; Branch to FOR-SIZE-OF-DIGIT

LEAVE-INNER-DIGIT-LOOP      ; The FOR-INNER-DIGIT-LOOP function begins
    ADD R0, R0, R3          ; Add R3 to R0
    ADD R5, R5, x1          ; Add 1 to R5
    ADD R1, R1, x-1         ; Subtract 1 from R1
    BRp FOR-EACH-DIGIT      ; Branch to FOR-EACH-DIGIT if positive

    LD R1, SAVEREG1        ; Restore register R1.
    LD R2, SAVEREG2        ; Restore register R2.
    LD R3, SAVEREG3        ; Restore register R3.
    LD R4, SAVEREG4        ; Restore register R4.
    LD R5, SAVEREG5        ; Restore register R5.
    LD R7, SAVEREG7        ; Restore register R7.
    RET


MULTIPLY-BY-TEN             ; The MULTIPLY-BY-TEN function begins (Multiplies R3 by ten)
    ST R1, REG1SAVE         ; Store register R1
    ADD R1, R3, R3          ; Double R3 into R1
    ADD R1, R1, R3          ; Add R3 to R1
    ADD R1, R1, R3          ; Add R3 to R1
    ADD R1, R1, R3          ; Add R3 to R1
    ADD R3, R1, R1          ; Double R1 into R3
    LD R1, REG1SAVE         ; Restore register R1
    RET                     ; Return from subroutine


SAVEREG1        .BLKW 1     ; Reserve memory for SAVEREG1
SAVEREG2        .BLKW 1     ; Reserve memory for SAVEREG2
SAVEREG3        .BLKW 1     ; Reserve memory for SAVEREG3
SAVEREG4        .BLKW 1     ; Reserve memory for SAVEREG4
SAVEREG5        .BLKW 1     ; Reserve memory for SAVEREG5
SAVEREG7        .BLKW 1     ; Reserve memory for SAVEREG7
DIGITS          .BLKW 5     ; Reserve 5 words of memory for storing digits
ASCII-TO-NUM    .FILL #-48  ; Fill memory with -48 (used for converting ASCII digits to decimal)
REG1SAVE        .BLKW 1     ; Reserve memory for REG1SAVE
NEWLINE         .FILL xA    ; ASCII code for a new line

.END

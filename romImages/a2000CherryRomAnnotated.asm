; Clock speed is 6 Mhz
; One tick is 32 / 6,000,000 = 5.3 us
	
; Activating the Reset line of the processor causes the first
; instruction to be fetched from location 0.
; $0000
	jmp  $0010                ; 2 bytes
	nop                       ; 1 byte  3 total  0 + 3 = 3   $0003
	
; Interrupt Handler
; $0003
	stop tcnt                 ; Stop Count for Event Counter.  1 byte       01100101    65
	jmp  $030F                ; 2 bytes
	nop                       ; 1 byte  4 total  3 + 4 = 7   $0007
	
; timer/counter Interrupt Handler
; $0007
	call $0321                ; Call designated Subroutine 2 bytes
	sel  rb1                  ; Select Bank 1 (locations 24 – 31) of Data Memory. 1 byte   11010101   D5
	mov  r2,a                 ; Move Accumulator contents into r2  1 byte
	mov  a,#$E7               ; Move 231 into Accumulator  2 bytes
	mov  t,a                  ; Move 231 in Accumulator into register T. 255 - 231 = 24 ticks  148 us  1 byte
	jmp  $0407                ; 2 bytes  9 total   7 + 9 = 16   $0010

; $0010
	dis  i                    ; Disable the external Interrupt input.   1 byte    00010101   15
	stop tcnt                 ; Stop Count for Event Counter.   1 byte
	clr  a                    ; CLEAR the contents of the Accumulator.  1 byte
	outl p1,a                 ; Output 0 to p1   1 byte
	mov  psw,a                ; Move 0 into the Program Status Word.  1 byte
	mov  a,#$C0               ; Move 192 into the Accumulator   2 bytes
	outl p2,a                 ; Output 192 to p2   1 byte
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.  1 byte
	sel  mb0                  ; Select Bank 0 (locations 0 – 2047) of Program Memory. 1 byte 10
	call $0321                ; Call designated Subroutine    2 bytes
	call $0321                ; Call designated Subroutine again   2 bytes
	mov  r0,#$7C              ; Move $007C (124) into r0   2 bytes
	mov  a,#$AA               ; Move 170 into the Accumulator   2 bytes
	xrl  a,@r0                ; Logical xor Address $007C ( in r0 ) with Accumulator   1 byte 9
	jnz  $0039                ; Jump to $0039 if Accumulator is non-zero.    2 bytes
	inc  r0                   ; Increment r0 ( to $007D )  1 byte
	mov  a,#$55               ; Move $55 ( 85 ) into the Accumulator   2 bytes
	xrl  a,@r0                ; Logical xor Address $007D ( in r0 ) with Accumulator   1 byte
	jnz  $0039                ; Jump to $0039 if Accumulator is non-zero.    2 bytes
	inc  r0                   ; Increment r0 ( to $007E )  1 byte 9
	mov  a,#$33               ; Move $33 ( 51 ) into the Accumulator   2 bytes
	xrl  a,@r0                ; Logical xor Address $007E ( in r0 ) with Accumulator   1 byte 
	jnz  $0039                ; Jump to $0039 if Accumulator is non-zero.    2 bytes
	inc  r0                   ; Increment r0 ( to $007F )  1 byte
	mov  a,#$CC               ; Move $CC ( 204 ) into the Accumulator   2 bytes
	xrl  a,@r0                ; Logical xor Address $007F ( in r0 ) with Accumulator   1 byte 9
	jnz  $0039                ; Jump to $0039 if Accumulator is non-zero.    2 bytes
	jmp  $015F                ; 2 bytes   4  41 total   16 + 41 = 57  $0039

; $0039
	mov  r0,#$7C              ; Move $7C (124) into r0   2 bytes               10111000   B8
	mov  @r0,#$AA             ; Move $AA ( 170 ) into Address $007C  2 bytes
	inc  r0                   ; Increment r0 ( to $007D )  1 byte
	mov  @r0,#$55             ; Move $55 ( 85 ) into Address $007D  2 bytes
	inc  r0                   ; Increment r0 ( to $007E )  1 byte
	mov  @r0,#$33             ; Move $33 ( 51 ) into Address $007E  2 bytes
	inc  r0                   ; Increment r0 ( to $007F )  1 byte
	mov  @r0,#$CC             ; Move $CC ( 204 ) into Address $007F  2 bytes
	clr  a                    ; CLEAR the contents of the Accumulator  1 byte
	mov  psw,a                ; Move 0 into the Program Status Word.  1 byte
	clr  f1                   ; Clear content of Flag 1 to 0.   1 byte
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.  1 byte
	clr  a                    ; CLEAR the contents of the Accumulator  1 byte
	mov  r6,a                 ; CLEAR r6   1 byte
	mov  r7,a                 ; CLEAR r7   1 byte
	mov  r0,a                 ; CLEAR r0   1 byte
	movp a,@a                 ; Move data in the current page into the Accumulator.   1 byte
	call $071A                ; Call designated Subroutine  2 bytes
	jnz  $004E                ; Jump to $004E if Accumulator is non-zero.    2 bytes
	jmp  $0158                ; 2 bytes   total 28   57 + 28 = 85  $0055

; $0055
	mov  r0,#$AA              ; Move $AA (179) into r0   2 bytes      10111000   B8
	mov  a,r0                 ; Move the contents of r0 (179)  into the Accumulator.   1 byte
	xrl  a,#$AA               ; a Logical xor #$AA (179) with Accumulator.    2 bytes
	jz   $005E                ; Jump to specified address if Accumulator is 0.   2 bytes
	clr  f0                   ; Clear content of Flag 0 to 0.   1 byte
	cpl  f0                   ; Set F0 to 1  1 byte   total 9   85 + 9 = 94   $005E

; $005E
	mov  r0,#$55              ; Move $55 (85) into r0   2 bytes      10111000   B8
	mov  a,r0                 ; Move the contents of r0 (85)  into the Accumulator.   1 byte
	xrl  a,#$55               ; a Logical xor #$AA (179) with Accumulator.    2 bytes
	jz   $0067                ; Jump to specified address if Accumulator is 0.   2 bytes
	clr  f0                   ; Clear content of Flag 0 to 0.   1 byte
	cpl  f0                   ; Set F0 to 1  1 byte   total 9   94 + 9 = 103  $0067

; $0067
	mov  r0,#$1               ; Move $01 (1) into r0   2 bytes      10111000   B8

; $0069
	mov  @r0,#$AA             ; Move $AA (170) into Address 1 ?   2 bytes    10110000   B0
	mov  a,@r0                ; Move contents of Address 1 into Accumulator   1 byte
	xrl  a,#$AA               ; a Logical xor #$AA (179) with Accumulator.    2 bytes
	jz   $0072                ; Jump to specified address if Accumulator is 0.   2 bytes
	clr  f0                   ; Clear content of Flag 0 to 0.   1 byte
	cpl  f0                   ; Set F0 to 1  1 byte   total 11   103 + 11 = 114  $0072  

; $0072
	mov  @r0,#$55             ; Move $55 (85) into Address 1 ?   2 bytes     10110000   B0
	mov  a,@r0                ; Move contents of Address 1 into Accumulator   1 byte
	xrl  a,#$55               ; a Logical xor #$55 (85) with Accumulator.    2 bytes
	jz   $007B                ; Jump to specified address if Accumulator is 0.   2 bytes
	clr  f0                   ; Clear content of Flag 0 to 0.   1 byte
	cpl  f0                   ; Set F0 to 1  1 byte   total 9   114 + 9 = 123  $007B

; $007B
	mov  a,r0                 ; Move the contents of r0 into Accumulator   1 byte    11111000    F8
	mov  @r0,a                ; Move the contents of the Accumulator into the memory location pointed to by r0   1 byte
	mov  a,@r0                ; Move back the other way, from memory location pointed to by r0 to the Accumulator  1 byte
	xrl  a,r0                 ; Logical xor r0 with Accumulator.  1 byte
	jz   $0083                ; Jump to specified address if Accumulator is 0.   2 bytes
	clr  f0                   ; Clear content of Flag 0 to 0.   1 byte
	cpl  f0                   ; Set F0 to 1  1 byte   total 8   123 + 8 = 131  $0083

; $0083
	mov  a,r0                 ; Move the contents of r0 into Accumulator   1 byte    11111000    F8
	cpl  a                    ; Complement the contents of the Accumulator.  1 byte
	mov  @r0,a                ; Move the contents of the Accumulator into the memory location pointed to by r0   1 byte
	mov  a,@r0                ; Move back the other way, from memory location pointed to by r0 to the Accumulator  1 byte
	cpl  a                    ; Complement the contents of the Accumulator.  1 byte
	xrl  a,r0                 ; Logical xor r0 with Accumulator.  1 byte
	jz   $008D                ; Jump to specified address if Accumulator is 0.   2 bytes
	clr  f0                   ; Clear content of Flag 0 to 0.   1 byte
	cpl  f0                   ; Set F0 to 1  1 byte   total 10   131 + 10 = 141  $008D

; $008D
	inc  r0                   ; Increment r0    1 byte                  00011000    18
	mov  a,r0                 ; Move the contents of r0 into Accumulator   1 byte
	clr  c                    ; Clear content of carry bit to 0.  1 byte
	add  a,#$84               ; Add $84 ( 132 ) to the Accumulator   2 bytes
	jnc  $0069                ; Jump to $0069 if the carry flag is low   2 bytes
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.   1 byte
	mov  r0,#$7B              ; Move $7B (123) into r0   2 bytes   10
	clr  a                    ; CLEAR the contents of the Accumulator.  1 byte
	mov  @r0,a                ; Move the contents of the Accumulator into the memory location pointed to by r0   1 byte
	djnz r0,$0098             ; Decrement r0 and test contents against $98 ( 152 )   2 bytes
	orl  p2,#$20              ; Logical or $20 (32) with designated p2   2 bytes
	mov  r4,#$55              ; Move $55 (85) into r4   2 bytes
	sel  rb1                  ; Select Bank 1 (locations 24 – 31) of Data Memory   1 byte   9 
	mov  r3,#$FF              ; Move $FF (255) into r3   2 bytes
	mov  r7,#$1               ; Move $1 (1) into r7   2 bytes
	mov  r6,#$1               ; Move $1 (1) into r6   2 bytes
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.  1 byte
	mov  a,#$FF               ; Move $FF (255) into Accumulator  2 bytes
	mov  t,a                  ; Move contents of Accumulator ( 255 ) into Timer/Counter.   1 byte   10
	en   tcnti                ; Enable internal interrupt Flag for Timer/Counter output.   1 byte   
	mov  r0,#$24              ; Move $24 ( 36 ) into r0   2 bytes
	jf1  $00BA                ; Jump to specified address if Flag F1 is set    2 bytes
	jf0  $00BE                ; Jump to specified address if Flag F0 is set.   2 bytes
	clr  f1                   ; Clear content of Flag 1 to 0.    1 byte
	cpl  f1                   ; Complement content of Flag F1.   1 byte   9
	mov  r2,#$FD              ; Move $FD ( 253 ) into r2   2 bytes  
	call $0544                ; Call designated Subroutine.  2 bytes  
	strt t                    ; Start Count for Timer.  1 byte
	jmp  $015F                ; Direct Jump to specified address  2 bytes  7  total 45   141 + 45 = 186   $00BA

; $00BA
	mov  @r0,#$2              ; Move $2 ( 2 ) into Address in r0  2 bytes    10110000   B0
	jmp  $00C0                ; Direct Jump to specified address within the 2K address block.   2 bytes
	mov  @r0,#$1              ; Move 12 ( 1 ) into Address in r0  2 bytes

; $00C0
	clr  f1                   ; Clear content of Flag 1 to 0.   1 byte      10100101    A5
	cpl  f1                   ; Complement content of Flag F1.   1 byte
	sel  rb1                  ; Select Bank 1 (locations 24 – 31) of Data Memory. 1 byte
	mov  a,#$FC               ; Move $FC (252) into Accumulator  2 bytes
	rl   a                    ; Rotate Accumulator left by 1-bit without carry.   1 byte
	mov  r4,a                 ; Move Accumulator contents into r4  1 byte
	mov  r5,#$18              ; Move $18 ( 24 ) into r5  2 bytes
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.  1 byte
	strt t                    ; Start Count for Timer.  1 byte

; $00CB
	jmp  $00CB                ; Direct Jump to specified address  2 bytes     00000100  04

; $00CD
	jmp  $00CD                ; Direct Jump to specified address  2 bytes     00000100  04

; $00CF
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       ; 49 nops    207 + 49 = 256    $0100

; $0100
	movd a,p5                 ; Move contents of designated port p5 into Accumulator.       1 byte
	inc  @r1                  ; Increment indirect by 1 the contents of memory location.    1 byte
	dis  i                    ; Disable the external Interrupt input.                       1 byte
	inc  r1                   ; Increment by 1 contents of designated register.             1 byte
	inc  r5                   ; Increment by 1 contents of designated register.             1 byte
	xch  a,@r1                ; Exchange indirect contents of Accumulator and memory.       1 byte
	en   tcnti                ; Enable internal interrupt Flag for Timer/Counter output.    1 byte
	xch  a,r1                 ; Exchange the Accumulator and r1                             1 byte
	xchd a,@r0                ; Exchange indirect 4-bit Accumulator and memory.             1 byte   total 9 265 - 9 = 256   $0100

; $0109
	.db   0x38                ; 1 byte  Undocumented instruction?                           1 byte    38
	orl  a,@r0                ; Logical or memory pointed to by r0 with Accumulator.        1 byte
	orl  a,r0                 ; Logical or r0 with Accumulator.                             1 byte
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.       1 byte
	mov  a,#$1                ; Move $1  ( 00000001 ) into the Accumulator.                 2 byte                             
	jmp  $012B                ; Direct Jump to specified address                            2 bytes   273 - 8 = 265  $0109

; $0111
	mov  a,#$2                ; Move $2  ( 00000010 ) into the Accumulator.                 2 bytes   00100011  23
	jmp  $012B                ; Direct Jump to specified address                            2 bytes   277 - 4 = 273   $0111

; $0115
	mov  a,#$4                ; Move $4  ( 00000100 ) into the Accumulator.                 2 bytes   00100011  23
	jmp  $012B                ; Direct Jump to specified address                            2 bytes   281 - 4 = 277   $0115

; $0119
	mov  a,#$8                ; Move $8  ( 00001000 ) into the Accumulator.                 2 bytes   00100011  23
	jmp  $012B                ; Direct Jump to specified address                            2 bytes   285 - 4 = 281   $0119

; $011D
	mov  a,#$10               ; Move $10 ( 00010000 ) into the Accumulator.                 2 bytes   00100011  23
	jmp  $012B                ; Direct Jump to specified address                            2 bytes   289 - 4 = 285   $011D

; $0121
	mov  a,#$20               ; Move $20 ( 00100000 ) into the Accumulator.                 2 bytes   00100011  23
	jmp  $012B                ; Direct Jump to specified address                            2 bytes   293 - 4 = 289   $0121

; $0125
	mov  a,#$40               ; Move $40 ( 01000000 ) into the Accumulator.                 2 byte    00100011  23
	jmp  $012B                ; Direct Jump to specified address                            2 bytes   297 - 4 = 293   $0125

; $0129
	mov  a,#$80               ; Move $80 ( 10000000 ) into the Accumulator.                 2 byte    00100011  23
	anl  p2,#$E0              ; Logical and $E0 ( 11100000 ) with designated p2             2 bytes   301 - 4 = 297   $0129

; $012D
	outl p1,a                 ; Output contents of Accumulator to port 1                    1 byte    00111001    39
	jmp  $0187                ; Direct Jump to specified address                            2 bytes   304 - 3 = 301    $012D

; $0130
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )       2 bytes   10011001    99
	anl  p2,#$F0              ; Logical and $F0 ( 11110000 ) with port 2                    2 bytes
	orl  p2,#$10              ; Logical or $10 ( 00010000 ) with designated port 2          2 bytes
	jmp  $0187                ; Direct Jump to specified address                            2 bytes   312 - 8 = 304    $0130

; $0138
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )       2 bytes   10011001    99
	anl  p2,#$E8              ; Logical and $E8 ( 11101000 ) with port 2                    2 bytes
	orl  p2,#$8               ; Logical or $8   ( 00001000 ) with port 2                    2 bytes
	jmp  $0187                ; Direct Jump to specified address                            2 bytes   320 - 8 = 312   $0138

; $0140
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )       2 bytes   10011001    99
	anl  p2,#$E4              ; Logical and $E4 ( 11100100 ) with port 2                    2 bytes
	orl  p2,#$4               ; Logical or $4   ( 00000100 ) with port 2                    2 bytes
	jmp  $0187                ; Direct Jump to specified address                            2 bytes   328 - 8 = 320   $0140

; $0148
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )       2 bytes   10011001    99
	anl  p2,#$E2              ; Logical and $E2 ( 11100010 ) with port 2                    2 bytes
	orl  p2,#$2               ; Logical or $2   ( 00000010 ) with port 2                    2 bytes
	jmp  $0187                ; Direct Jump to specified address                            2 bytes   336 - 8 = 328   $0148

; $0150
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )       2 bytes   10011001    99
	anl  p2,#$E1              ; Logical and $E1 ( 11100001 ) with port 2                    2 bytes
	orl  p2,#$1               ; Logical or  $01 ( 00000001 ) with port 2                    2 bytes
	jmp  $0187                ; Direct Jump to specified address                            2 bytes   344 - 8 = 336   $0150

; $0158
	movp a,@a                 ; Move data in the current page into the Accumulator          1 byte    10100011  A3
	call $071A                ; Call designated Subroutine.                                 2 bytes
	jnz  $0158                ; Jump to specified address if Accumulator is non-zero.       2 bytes
	jmp  $0200                ; Direct Jump to specified address                            2 bytes   351 - 7 = 344   $0158

; $015F
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.             1 byte    11000101   C5
	sel  mb0                  ; Select Bank 0 (locations 0 – 2047) of Program Memory.       1 byte
	clr  a                    ; CLEAR the contents of the Accumulator                       1 byte
	mov  psw,a                ; Move contents of Accumulator into the Program Status Word.  1 byte
	call $0321                ; Call designated Subroutine.                                 2 bytes
	jtf  $0169                ; Jump to specified address if Timer Flag is set to 1.        2 bytes
	en   tcnti                ; Enable internal interrupt Flag for Timer/Counter output.    1 byte
	strt t                    ; Start Count for Timer.                                      1 byte
	mov  a,r5                 ; Move register r5 into the Accumulator.                      1 byte
	jz   $0170                ; Jump to specified address if Accumulator is 0.              2 bytes
	anl  p2,#$DF              ; Logical and $DF ( 11011111 ) with designated p2             2 bytes
	jmp  $0172                ; Direct Jump to specified address                            2 bytes   total 17   368 - 17 = 351  $015F

; $0170
	orl  p2,#$20              ; Logical or immediate specified data with port p2  2 bytes    10001010  8A
	mov  r3,#$0               ; Move $0 ( 00000000 ) into r3                      2 bytes
	mov  a,r3                 ; Move r3 ( 00000000 ) into the Accumulator.        1 byte
	anl  a,#$7                ; Logical and $7 ( 00000111 ) with Accumulator.     2 bytes  total 7   375 - 7 = 368  $0170

; $0177
	movp3 a,@a                ; Move Program data in Page 3 into the Accumulator   1 byte    11100011  E3
	mov  r2,a                 ; Move Accumulator contents into r2                  1 byte    total 2   377 - 2 = 375   $0177

; $0179
	mov  a,r3                 ; Move the contents of r3 into the Accumulator.    1 byte    11111011  FB
	anl  a,#$78               ; Logical and $78 ( 01111000 ) with Accumulator.   2 bytes
	rl   a                    ; Rotate Accumulator left by 1-bit without carry.  1 byte
	swap a                    ; Swap the 2 4-bit nibbles in the Accumulator      1 byte
	mov  r1,a                 ; Move Accumulator contents into r1                1 byte
	rl   a                    ; Rotate Accumulator left by 1-bit without carry.  1 byte
	add  a,#$60               ; Add $60 ( 01100000 ) to the Accumulator          2 bytes
	mov  r0,a                 ; Move Accumulator contents into r1                1 byte
	clr  f0                   ; Clear content of Flag 0 to 0                     1 byte
	cpl  f0                   ; Complement content of Flag F0.                   1 byte
	mov  a,r1                 ; Move contents of r1 into the Accumulator.        1 byte
	jmpp @a                   ; Jump indirect to specified address within address page   1 byte   total 14    391 - 14 = 377   $0179

; $0187
	jnt0 $018C                ; Jump to specified address if Test 0 is low.           2 bytes     00100110    38   26
	movx a,@r0                ; Move data pointed to by r0 into the Accumulator.      1 byte
	jmp  $018D                ; Direct Jump to specified address                      2 bytes     total 5   396 - 5 = 391   $0187

; $018C
	ins  a,bus                ; Input strobed BUS data into Accumulator.                 1 byte     00001000   8   8

; $018D
	anl  a,r2                 ; Logical and contents of r2 with Accumulator              1 byte     01011010   90  5A
	jz   $01A2                ; Jump to specified address if Accumulator is zero         2 bytes
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.    1 byte
	inc  r0                   ; Increment r0                                             1 byte
	jnz  $019A                ; Jump to specified address if Accumulator is non-zero     2 bytes
	mov  a,r2                 ; Move contents of r2 into the Accumulator.                1 byte
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.    1 byte
	jz   $019A                ; Jump to specified address if Accumulator is zero         2 bytes
	dec  r0                   ; Decrement r0                                             1 byte
	clr  f0                   ; Clear content of Flag f0 to 0.                           1 byte
	mov  a,r2                 ; Move contents of r2 into the Accumulator.                1 byte
	orl  a,@r0                ; Logical or memory pointed to by r0 with Accumulator.     1 byte
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0        1 byte
	jf0  $01B4                ; Jump to specified address if Flag F0 is set.             2 bytes
	cpl  f0                   ; Complement content of Flag F0.                           1 byte   
	jmp  $0207                ; Direct Jump to specified address                         2 bytes   total   22   418 - 22 = 396  $018C

; $01A2
	mov  a,r2                 ; Move contents of r2 into the Accumulator.                1 byte    11111010  250  FA
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.    1 byte
	inc  r0                   ; Increment r0                                             1 byte
	jz   $01AC                ; Jump to specified address if Accumulator is zero         2 bytes
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.    1 byte
	jnz  $01AC                ; Jump to specified address if Accumulator is non-zero     2 bytes
	dec  r0                   ; Decrement r0                                             1 byte
	clr  f0                   ; Clear content of Flag f0 to 0.                           1 byte
	mov  a,r2                 ; Move contents of r2 into the Accumulator.                1 byte
	cpl  a                    ; Complement the contents of the Accumulator.              1 byte
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.    1 byte
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0        1 byte
	jf0  $01B4                ; Jump to specified address if Flag F0 is set.             2 bytes
	jmp  $0207                ; Direct Jump to specified address                         2 bytes  total 18   436 - 18 = 418   $01A2

; $01B4
	inc  r3                   ; Increment r3                                             1 byte       00011011   27   1B
	clr  c                    ; Clear content of carry bit to 0.                         1 byte
	mov  a,r3                 ; Move contents of r3 into the Accumulator.                1 byte
	add  a,#$98               ; Add $98 ( 10011000 ) to the Accumulator                  2 bytes
	jnc  $0174                ; Jump to $0174 if the carry flag is low                   2 bytes
	mov  a,r4                 ; Move contents of r4 into the Accumulator.                1 byte
	xrl  a,#$55               ; Logical xor #$55 ( 01010101 ) with Accumulator.          2 bytes
	jnz  $01C4                ; Jump to specified address if Accumulator is non-zero     2 bytes
	mov  r4,#$AA              ; Move $AA ( 10101010 ) into r4                            2 bytes
	jmp  $015F                ; Direct Jump to specified address                         2 bytes      total 16   452 - 16 =  436  $01B4

; $01C4
	mov  a,r4                 ; Move contents of r4 into the Accumulator.                1 byte       252  FC
	mov  r4,#$0               ; Move $00 ( 00000000 ) into r4                            2 bytes
	xrl  a,#$AA               ; Logical xor #$AA ( 10101010 ) with Accumulator.          2 bytes
	jnz  $015F                ; Jump to specified address if Accumulator is non-zero     2 bytes
	mov  r2,#$FE              ; Move $FE ( 11111110 ) into r2                            2 bytes
	call $0544                ; Call designated Subroutine.                              2 bytes
	jmp  $015F                ; Direct Jump to specified address                         2 bytes      13 total   465 - 13 = 452  

; $01D1
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       
	nop                       

; $0200
	movp a,@a                 ; Move data in the current page into the Accumulator.      1 byte     10100011    A3
	call $071A                ; Call designated Subroutine.                              2 bytes
	jnz  $0200                ; Jump to specified address if Accumulator is non-zero     2 bytes
	jmp  $0308                ; Direct Jump to specified address                         2 bytes      7 total   512 + 7 = 519   $0207

; $0207
	mov  a,r4                 ; Move contents of r4 into the Accumulator.                1 byte       252  FC
	xrl  a,#$55               ; Logical xor #$55 ( 01010101 ) with Accumulator.          2 bytes
	jz   $0259                ; Jump to specified address if Accumulator is zero         2 bytes
	mov  a,r3                 ; Move contents of r3 into the Accumulator.                1 byte
	clr  c                    ; Clear content of carry bit to 0.                         1 byte
	add  a,#$98               ; Add $98 ( 10011000 ) to the Accumulator                  2 bytes
	jc   $0259                ; Jump to specified address if carry flag is set.          2 bytes
	mov  r0,#$7               ; Move $7 ( 00000111 ) into r0                             2 bytes
	mov  a,r3                 ; Move contents of r3 into the Accumulator.                1 byte
	xrl  a,#$3D               ; Logical xor #$3D ( 00111101 ) with Accumulator.          2 bytes
	jnz  $0222                ; Jump to specified address if Accumulator is non-zero     2 bytes
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator          1 byte
	orl  a,#$80               ; Logical or $80 ( 10000000 ) with Accumulator.            2 bytes
	jf0  $023C                ; Jump to specified address if Flag F0 is set.             2 bytes
	anl  a,#$7F               ; Logical and $7F ( 01111111 ) with Accumulator.           2 bytes
	jmp  $023C                ; Direct Jump to specified address                         2 bytes      27 total   519 + 27 = 546   $0222

; $0222
mov  a,r3
; $0223
xrl  a,#$3E
; $0225
jnz  $0230
; $0227
mov  a,@r0
; $0228
orl  a,#$40
; $022A
jf0  $023C
; $022C
anl  a,#$BF
; $022E
jmp  $023C
; $0230
mov  a,r3
; $0231
xrl  a,#$62
; $0233
jnz  $023D
; $0235
mov  a,@r0
; $0236
orl  a,#$20
; $0238
jf0  $023C
; $023A
anl  a,#$DF
; $023C
mov  @r0,a
; $023D
mov  a,r3
; $023E
add  a,#$7
; $0240
call $066F
; $0242
mov  r2,a
; $0243
xrl  a,#$FF
; $0245
jz   $0259
; $0247
jf0  $025B
; $0249
mov  a,r3
; $024A
xrl  a,#$1E
; $024C
jz   $0259
; $024E
mov  a,r4
; $024F
xrl  a,#$AA
; $0251
jz   $0259
; $0253
mov  a,r2
; $0254
orl  a,#$80
; $0256
mov  r2,a
; $0257
call $0544
; $0259
jmp  $01B4
; $025B
call $0544
; $025D
jmp  $01B4
; $025F
nop
; $0260
nop
; $0261
nop
; $0262
nop
; $0263
nop
; $0264
nop
; $0265
nop
; $0266
nop
; $0267
nop
; $0268
nop
; $0269
nop
; $026A
nop
; $026B
nop
; $026C
nop
; $026D
nop
; $026E
nop
; $026F
nop
; $0270
nop
; $0271
nop
; $0272
nop
; $0273
nop
; $0274
nop
; $0275
nop
; $0276
nop
; $0277
nop
; $0278
nop
; $0279
nop
; $027A
nop
; $027B
nop
; $027C
nop
; $027D
nop
; $027E
nop
; $027F
nop
; $0280
nop
; $0281
nop
; $0282
nop
; $0283
nop
; $0284
nop
; $0285
nop
; $0286
nop
; $0287
nop
; $0288
nop
; $0289
nop
; $028A
nop
; $028B
nop
; $028C
nop
; $028D
nop
; $028E
nop
; $028F
nop
; $0290
nop
; $0291
nop
; $0292
nop
; $0293
nop
; $0294
nop
; $0295
nop
; $0296
nop
; $0297
nop
; $0298
nop
; $0299
nop
; $029A
nop
; $029B
nop
; $029C
nop
; $029D
nop
; $029E
nop
; $029F
nop
; $02A0
nop
; $02A1
nop
; $02A2
nop
; $02A3
nop
; $02A4
nop
; $02A5
nop
; $02A6
nop
; $02A7
nop
; $02A8
nop
; $02A9
nop
; $02AA
nop
; $02AB
nop
; $02AC
nop
; $02AD
nop
; $02AE
nop
; $02AF
nop
; $02B0
nop
; $02B1
nop
; $02B2
nop
; $02B3
nop
; $02B4
nop
; $02B5
nop
; $02B6
nop
; $02B7
nop
; $02B8
nop
; $02B9
nop
; $02BA
nop
; $02BB
nop
; $02BC
nop
; $02BD
nop
; $02BE
nop
; $02BF
nop
; $02C0
nop
; $02C1
nop
; $02C2
nop
; $02C3
nop
; $02C4
nop
; $02C5
nop
; $02C6
nop
; $02C7
nop
; $02C8
nop
; $02C9
nop
; $02CA
nop
; $02CB
nop
; $02CC
nop
; $02CD
nop
; $02CE
nop
; $02CF
nop
; $02D0
nop
; $02D1
nop
; $02D2
nop
; $02D3
nop
; $02D4
nop
; $02D5
nop
; $02D6
nop
; $02D7
nop
; $02D8
nop
; $02D9
nop
; $02DA
nop
; $02DB
nop
; $02DC
nop
; $02DD
nop
; $02DE
nop
; $02DF
nop
; $02E0
nop
; $02E1
nop
; $02E2
nop
; $02E3
nop
; $02E4
nop
; $02E5
nop
; $02E6
nop
; $02E7
nop
; $02E8
nop
; $02E9
nop
; $02EA
nop
; $02EB
nop
; $02EC
nop
; $02ED
nop
; $02EE
nop
; $02EF
nop
; $02F0
nop
; $02F1
nop
; $02F2
nop
; $02F3
nop
; $02F4
nop
; $02F5
nop
; $02F6
nop
; $02F7
nop
; $02F8
nop
; $02F9
nop
; $02FA
nop
; $02FB
nop
; $02FC
nop
; $02FD
nop
; $02FE
nop
; $02FF
nop
; $0300
.db   0x01
; $0301
outl bus,a
; $0302
jmp  $0008
; $0304
inc  @r0
; $0305
xch  a,@r0
; $0306
orl  a,@r0
; $0307
movx a,@r0
; $0308
movp a,@a
; $0309
call $071A
; $030B
jnz  $0308
; $030D
jmp  $0400
; $030F
sel  rb1
; $0310
jni  $0314
; $0312
jmp  $0320
; $0314
mov  r1,#$9
; $0316
djnz r1,$0316
; $0318
jni  $031C
; $031A
jmp  $0320
; $031C
clr  f1
; $031D
mov  r3,#$0
; $031F
dis  i
; $0320
strt t
; $0321
retr
; $0322
jni  $0346
; $0324
mov  r0,#$9
; $0326
mov  a,r5
; $0327
anl  a,#$F7
; $0329
mov  r5,a
; $032A
clr  f1
; $032B
jmp  $0337
; $032D
orl  p2,#$40
; $032F
jnc  $0348
; $0331
anl  p2,#$BF
; $0333
mov  r4,a
; $0334
nop
; $0335
anl  p2,#$7F
; $0337
mov  a,r4
; $0338
rlc  a
; $0339
orl  p2,#$80
; $033B
djnz r0,$032D
; $033D
orl  p2,#$40
; $033F
mov  a,r5
; $0340
jb4  $034A
; $0342
jb1  $0346
; $0344
cpl  f1
; $0345
en   i
; $0346
jmp  $0437
; $0348
jmp  $0333
; $034A
mov  r5,#$C0
; $034C
jmp  $0437
; $034E
nop
; $034F
nop
; $0350
nop
; $0351
nop
; $0352
nop
; $0353
nop
; $0354
nop
; $0355
nop
; $0356
nop
; $0357
nop
; $0358
nop
; $0359
nop
; $035A
nop
; $035B
nop
; $035C
nop
; $035D
nop
; $035E
nop
; $035F
nop
; $0360
nop
; $0361
nop
; $0362
nop
; $0363
nop
; $0364
nop
; $0365
nop
; $0366
nop
; $0367
nop
; $0368
nop
; $0369
nop
; $036A
nop
; $036B
nop
; $036C
nop
; $036D
nop
; $036E
nop
; $036F
nop
; $0370
nop
; $0371
nop
; $0372
nop
; $0373
nop
; $0374
nop
; $0375
nop
; $0376
nop
; $0377
nop
; $0378
nop
; $0379
nop
; $037A
nop
; $037B
nop
; $037C
nop
; $037D
nop
; $037E
nop
; $037F
nop
; $0380
nop
; $0381
nop
; $0382
nop
; $0383
nop
; $0384
nop
; $0385
nop
; $0386
nop
; $0387
nop
; $0388
nop
; $0389
nop
; $038A
nop
; $038B
nop
; $038C
nop
; $038D
nop
; $038E
nop
; $038F
nop
; $0390
nop
; $0391
nop
; $0392
nop
; $0393
nop
; $0394
nop
; $0395
nop
; $0396
nop
; $0397
nop
; $0398
nop
; $0399
nop
; $039A
nop
; $039B
nop
; $039C
nop
; $039D
nop
; $039E
nop
; $039F
nop
; $03A0
nop
; $03A1
nop
; $03A2
nop
; $03A3
nop
; $03A4
nop
; $03A5
nop
; $03A6
nop
; $03A7
nop
; $03A8
nop
; $03A9
nop
; $03AA
nop
; $03AB
nop
; $03AC
nop
; $03AD
nop
; $03AE
nop
; $03AF
nop
; $03B0
nop
; $03B1
nop
; $03B2
nop
; $03B3
nop
; $03B4
nop
; $03B5
nop
; $03B6
nop
; $03B7
nop
; $03B8
nop
; $03B9
nop
; $03BA
nop
; $03BB
nop
; $03BC
nop
; $03BD
nop
; $03BE
nop
; $03BF
nop
; $03C0
nop
; $03C1
nop
; $03C2
nop
; $03C3
nop
; $03C4
nop
; $03C5
nop
; $03C6
nop
; $03C7
nop
; $03C8
nop
; $03C9
nop
; $03CA
nop
; $03CB
nop
; $03CC
nop
; $03CD
nop
; $03CE
nop
; $03CF
nop
; $03D0
nop
; $03D1
nop
; $03D2
nop
; $03D3
nop
; $03D4
nop
; $03D5
nop
; $03D6
nop
; $03D7
nop
; $03D8
nop
; $03D9
nop
; $03DA
nop
; $03DB
nop
; $03DC
nop
; $03DD
nop
; $03DE
nop
; $03DF
nop
; $03E0
nop
; $03E1
nop
; $03E2
nop
; $03E3
nop
; $03E4
nop
; $03E5
nop
; $03E6
nop
; $03E7
nop
; $03E8
nop
; $03E9
nop
; $03EA
nop
; $03EB
nop
; $03EC
nop
; $03ED
nop
; $03EE
nop
; $03EF
nop
; $03F0
nop
; $03F1
nop
; $03F2
nop
; $03F3
nop
; $03F4
nop
; $03F5
nop
; $03F6
nop
; $03F7
nop
; $03F8
nop
; $03F9
nop
; $03FA
nop
; $03FB
nop
; $03FC
nop
; $03FD
nop
; $03FE
nop
; $03FF
nop
; $0400
movp a,@a
; $0401
call $071A
; $0403
jnz  $0400
; $0405
jmp  $0500
; $0407
mov  a,r5
; $0408
jb7  $0439
; $040A
jb1  $0452
; $040C
mov  r0,#$7
; $040E
mov  a,@r0
; $040F
anl  a,#$E0
; $0411
xrl  a,#$E0
; $0413
jz   $04AF
; $0415
jf1  $0486
; $0417
dis  i
; $0418
mov  a,r5
; $0419
jb3  $0431
; $041B
jb0  $0426
; $041D
mov  r0,#$6
; $041F
mov  a,@r0
; $0420
jnz  $0437
; $0422
call $0507
; $0424
jz   $0437
; $0426
mov  a,r5
; $0427
anl  a,#$FE
; $0429
orl  a,#$8
; $042B
mov  r5,a
; $042C
mov  r0,#$20
; $042E
mov  a,@r0
; $042F
rl   a
; $0430
mov  r4,a
; $0431
mov  r7,#$48
; $0433
mov  r6,#$1
; $0435
jmp  $0322
; $0437
mov  a,r2
; $0438
retr
; $0439
dis  i
; $043A
djnz r7,$0437
; $043C
mov  r7,#$FA
; $043E
djnz r6,$0437
; $0440
mov  r0,#$24
; $0442
mov  a,@r0
; $0443
mov  r6,a
; $0444
mov  a,r5
; $0445
xrl  a,#$40
; $0447
mov  r5,a
; $0448
jb6  $044E
; $044A
orl  p2,#$20
; $044C
jmp  $0437
; $044E
anl  p2,#$DF
; $0450
jmp  $0437
; $0452
dis  i
; $0453
mov  a,r5
; $0454
jb2  $0472
; $0456
anl  p2,#$7F
; $0458
djnz r7,$0437
; $045A
mov  r7,#$AA
; $045C
djnz r6,$0437
; $045E
mov  r6,#$2
; $0460
mov  r0,#$7
; $0462
mov  a,@r0
; $0463
anl  a,#$E0
; $0465
xrl  a,#$E0
; $0467
jz   $047D
; $0469
stop tcnt
; $046A
mov  r0,#$7C
; $046C
mov  @r0,#$0
; $046E
call $0321
; $0470
jmp  $0000
; $0472
mov  r4,#$FB
; $0474
jni  $0437
; $0476
mov  r5,#$2
; $0478
mov  a,#$22
; $047A
mov  t,a
; $047B
jmp  $0324
; $047D
orl  p2,#$80
; $047F
mov  a,#$CC
; $0481
mov  t,a
; $0482
mov  r5,#$6
; $0484
jmp  $0437
; $0486
djnz r7,$0437
; $0488
mov  r7,#$48
; $048A
djnz r6,$0437
; $048C
mov  r6,#$1
; $048E
dis  i
; $048F
jf1  $0493
; $0491
jmp  $0437
; $0493
jni  $04AC
; $0495
anl  p2,#$BF
; $0497
orl  a,#$0
; $0499
anl  p2,#$7F
; $049B
orl  a,#$0
; $049D
orl  p2,#$80
; $049F
orl  a,#$0
; $04A1
orl  p2,#$40
; $04A3
mov  a,r3
; $04A4
jnz  $04AC
; $04A6
mov  r4,#$F3
; $04A8
mov  a,r5
; $04A9
orl  a,#$9
; $04AB
mov  r5,a
; $04AC
en   i
; $04AD
jmp  $0437
; $04AF
dis  i
; $04B0
mov  r5,#$2
; $04B2
mov  r7,#$AA
; $04B4
mov  r6,#$2
; $04B6
anl  p2,#$7F
; $04B8
jmp  $0437
; $04BA
nop
; $04BB
nop
; $04BC
nop
; $04BD
nop
; $04BE
nop
; $04BF
nop
; $04C0
nop
; $04C1
nop
; $04C2
nop
; $04C3
nop
; $04C4
nop
; $04C5
nop
; $04C6
nop
; $04C7
nop
; $04C8
nop
; $04C9
nop
; $04CA
nop
; $04CB
nop
; $04CC
nop
; $04CD
nop
; $04CE
nop
; $04CF
nop
; $04D0
nop
; $04D1
nop
; $04D2
nop
; $04D3
nop
; $04D4
nop
; $04D5
nop
; $04D6
nop
; $04D7
nop
; $04D8
nop
; $04D9
nop
; $04DA
nop
; $04DB
nop
; $04DC
nop
; $04DD
nop
; $04DE
nop
; $04DF
nop
; $04E0
nop
; $04E1
nop
; $04E2
nop
; $04E3
nop
; $04E4
nop
; $04E5
nop
; $04E6
nop
; $04E7
nop
; $04E8
nop
; $04E9
nop
; $04EA
nop
; $04EB
nop
; $04EC
nop
; $04ED
nop
; $04EE
nop
; $04EF
nop
; $04F0
nop
; $04F1
nop
; $04F2
nop
; $04F3
nop
; $04F4
nop
; $04F5
nop
; $04F6
nop
; $04F7
nop
; $04F8
nop
; $04F9
nop
; $04FA
nop
; $04FB
nop
; $04FC
nop
; $04FD
nop
; $04FE
nop
; $04FF
nop
; $0500
movp a,@a
; $0501
call $071A
; $0503
jnz  $0500
; $0505
jmp  $0600
; $0507
mov  r0,#$21
; $0509
mov  a,@r0
; $050A
jz   $0539
; $050C
dec  a
; $050D
mov  @r0,a
; $050E
clr  c
; $050F
add  a,#$CE
; $0511
jc   $0539
; $0513
mov  r0,#$22
; $0515
mov  a,@r0
; $0516
clr  c
; $0517
add  a,#$CE
; $0519
jc   $0539
; $051B
mov  a,@r0
; $051C
add  a,#$28
; $051E
mov  r0,a
; $051F
mov  a,#$FF
; $0521
xch  a,@r0
; $0522
mov  r0,a
; $0523
xrl  a,#$FF
; $0525
jz   $0539
; $0527
mov  a,r0
; $0528
mov  r0,#$20
; $052A
mov  @r0,a
; $052B
mov  r0,#$22
; $052D
inc  @r0
; $052E
mov  a,@r0
; $052F
clr  c
; $0530
add  a,#$CE
; $0532
jnc  $0536
; $0534
mov  @r0,#$0
; $0536
mov  a,#$55
; $0538
ret
; $0539
clr  a
; $053A
mov  r0,#$21
; $053C
mov  @r0,a
; $053D
mov  r0,#$23
; $053F
mov  @r0,a
; $0540
mov  r0,#$22
; $0542
mov  @r0,a
; $0543
ret
; $0544
mov  r0,#$6
; $0546
mov  @r0,#$FF
; $0548
mov  r0,#$21
; $054A
mov  a,@r0
; $054B
clr  c
; $054C
add  a,#$CE
; $054E
jnc  $0558
; $0550
mov  a,@r0
; $0551
clr  c
; $0552
add  a,#$CD
; $0554
jc   $0592
; $0556
jmp  $058A
; $0558
mov  a,@r0
; $0559
clr  c
; $055A
add  a,#$CF
; $055C
jnc  $0560
; $055E
mov  r2,#$FA
; $0560
inc  @r0
; $0561
mov  r0,#$23
; $0563
mov  a,@r0
; $0564
clr  c
; $0565
add  a,#$CE
; $0567
jc   $0592
; $0569
mov  a,@r0
; $056A
add  a,#$28
; $056C
mov  r1,a
; $056D
mov  a,r2
; $056E
xrl  a,#$62
; $0570
jnz  $057A
; $0572
mov  a,r5
; $0573
xrl  a,#$FF
; $0575
mov  r5,a
; $0576
jnz  $057A
; $0578
mov  r2,#$E2
; $057A
mov  a,r2
; $057B
mov  @r1,a
; $057C
inc  @r0
; $057D
mov  a,@r0
; $057E
clr  c
; $057F
add  a,#$CE
; $0581
jnc  $0585
; $0583
mov  @r0,#$0
; $0585
mov  r0,#$6
; $0587
mov  @r0,#$0
; $0589
ret
; $058A
mov  r0,#$23
; $058C
mov  r1,#$22
; $058E
mov  a,@r0
; $058F
xrl  a,@r1
; $0590
jz   $0585
; $0592
mov  r0,#$23
; $0594
mov  @r0,#$0
; $0596
mov  r0,#$22
; $0598
mov  @r0,#$0
; $059A
mov  r0,#$21
; $059C
mov  @r0,#$0
; $059E
jmp  $0585
; $05A0
nop
; $05A1
nop
; $05A2
nop
; $05A3
nop
; $05A4
nop
; $05A5
nop
; $05A6
nop
; $05A7
nop
; $05A8
nop
; $05A9
nop
; $05AA
nop
; $05AB
nop
; $05AC
nop
; $05AD
nop
; $05AE
nop
; $05AF
nop
; $05B0
nop
; $05B1
nop
; $05B2
nop
; $05B3
nop
; $05B4
nop
; $05B5
nop
; $05B6
nop
; $05B7
nop
; $05B8
nop
; $05B9
nop
; $05BA
nop
; $05BB
nop
; $05BC
nop
; $05BD
nop
; $05BE
nop
; $05BF
nop
; $05C0
nop
; $05C1
nop
; $05C2
nop
; $05C3
nop
; $05C4
nop
; $05C5
nop
; $05C6
nop
; $05C7
nop
; $05C8
nop
; $05C9
nop
; $05CA
nop
; $05CB
nop
; $05CC
nop
; $05CD
nop
; $05CE
nop
; $05CF
nop
; $05D0
nop
; $05D1
nop
; $05D2
nop
; $05D3
nop
; $05D4
nop
; $05D5
nop
; $05D6
nop
; $05D7
nop
; $05D8
nop
; $05D9
nop
; $05DA
nop
; $05DB
nop
; $05DC
nop
; $05DD
nop
; $05DE
nop
; $05DF
nop
; $05E0
nop
; $05E1
nop
; $05E2
nop
; $05E3
nop
; $05E4
nop
; $05E5
nop
; $05E6
nop
; $05E7
nop
; $05E8
nop
; $05E9
nop
; $05EA
nop
; $05EB
nop
; $05EC
nop
; $05ED
nop
; $05EE
nop
; $05EF
nop
; $05F0
nop
; $05F1
nop
; $05F2
nop
; $05F3
nop
; $05F4
nop
; $05F5
nop
; $05F6
nop
; $05F7
nop
; $05F8
nop
; $05F9
nop
; $05FA
nop
; $05FB
nop
; $05FC
nop
; $05FD
nop
; $05FE
nop
; $05FF
nop
; $0600
movp a,@a
; $0601
call $071A
; $0603
jnz  $0600
; $0605
jmp  $0702
; $0607
strt t
; $0608
anl  a,r1
; $0609
in   a,p2
; $060A
.db   0x06
; $060B
jt0  $0625
; $060D
inc  r1
; $060E
dis  i
; $060F
jb2  $0641
; $0611
mov  a,r7
; $0612
en   i
; $0613
dis  tcnti
; $0614
jmp  $0144
; $0616
call $0051
; $0618
mov  a,r7
; $0619
mov  a,r7
; $061A
outl bus,a
; $061B
jb1  $0621
; $061D
mov  a,r7
; $061E
inc  @r1
; $061F
strt cnt
; $0620
mov  a,r7
; $0621
xchd a,@r0
; $0622
.db   0x01
; $0623
xchd a,@r1
; $0624
xch  a,@r0
; $0625
mov  t,a
; $0626
inc  @r0
; $0627
call $02FF
; $0629
orl  a,@r0
; $062A
add  a,#$33
; $062C
.db   0x22
; $062D
stop tcnt
; $062E
jb0  $065D
; $0630
anl  a,r4
; $0631
movd p7,a
; $0632
orl  a,r2
; $0633
orl  a,#$1F
; $0635
anl  a,r6
; $0636
xch  a,r7
; $0637
anl  a,r2
; $0638
anl  a,r3
; $0639
movd p6,a
; $063A
movd p5,a
; $063B
inc  r6
; $063C
inc  r5
; $063D
xch  a,r6
; $063E
xch  a,r5
; $063F
anl  a,@r0
; $0640
mov  a,r7
; $0641
jmp  $0300
; $0643
add  a,@r0
; $0644
.db   0x63
; $0645
.db   0x66
; $0646
mov  a,t
; $0647
anl  a,r7
; $0648
jnt1 $064C
; $064A
orl  a,r6
; $064B
movd p4,a
; $064C
movd a,p7
; $064D
orl  a,r7
; $064E
orl  a,r5
; $064F
da   a
; $0650
mov  a,r7
; $0651
outl p2,a
; $0652
dec  a
; $0653
cpl  a
; $0654
jnt0 $0629
; $0656
jtf  $0658
; $0658
.db   0x0b
; $0659
inc  r2
; $065A
in   a,p1
; $065B
outl p1,a
; $065C
xch  a,r0
; $065D
xch  a,r2
; $065E
inc  r0
; $065F
jt1  $060C
; $0661
inc  r3
; $0662
ins  a,bus
; $0663
.db   0x38
; $0664
clr  a
; $0665
xch  a,r3
; $0666
inc  a
; $0667
anl  a,#$D
; $0669
rrc  a
; $066A
jmp  $0034
; $066C
mov  a,#$61
; $066E
addc a,#$A3
; $0670
ret
; $0671
nop
; $0672
nop
; $0673
nop
; $0674
nop
; $0675
nop
; $0676
nop
; $0677
nop
; $0678
nop
; $0679
nop
; $067A
nop
; $067B
nop
; $067C
nop
; $067D
nop
; $067E
nop
; $067F
nop
; $0680
nop
; $0681
nop
; $0682
nop
; $0683
nop
; $0684
nop
; $0685
nop
; $0686
nop
; $0687
nop
; $0688
nop
; $0689
nop
; $068A
nop
; $068B
nop
; $068C
nop
; $068D
nop
; $068E
nop
; $068F
nop
; $0690
nop
; $0691
nop
; $0692
nop
; $0693
nop
; $0694
nop
; $0695
nop
; $0696
nop
; $0697
nop
; $0698
nop
; $0699
nop
; $069A
nop
; $069B
nop
; $069C
nop
; $069D
nop
; $069E
nop
; $069F
nop
; $06A0
nop
; $06A1
nop
; $06A2
nop
; $06A3
nop
; $06A4
nop
; $06A5
nop
; $06A6
nop
; $06A7
nop
; $06A8
nop
; $06A9
nop
; $06AA
nop
; $06AB
nop
; $06AC
nop
; $06AD
nop
; $06AE
nop
; $06AF
nop
; $06B0
nop
; $06B1
nop
; $06B2
nop
; $06B3
nop
; $06B4
nop
; $06B5
nop
; $06B6
nop
; $06B7
nop
; $06B8
nop
; $06B9
nop
; $06BA
nop
; $06BB
nop
; $06BC
nop
; $06BD
nop
; $06BE
nop
; $06BF
nop
; $06C0
nop
; $06C1
nop
; $06C2
nop
; $06C3
nop
; $06C4
nop
; $06C5
nop
; $06C6
nop
; $06C7
nop
; $06C8
nop
; $06C9
nop
; $06CA
nop
; $06CB
nop
; $06CC
nop
; $06CD
nop
; $06CE
nop
; $06CF
nop
; $06D0
nop
; $06D1
nop
; $06D2
nop
; $06D3
nop
; $06D4
nop
; $06D5
nop
; $06D6
nop
; $06D7
nop
; $06D8
nop
; $06D9
nop
; $06DA
nop
; $06DB
nop
; $06DC
nop
; $06DD
nop
; $06DE
nop
; $06DF
nop
; $06E0
nop
; $06E1
nop
; $06E2
nop
; $06E3
nop
; $06E4
nop
; $06E5
nop
; $06E6
nop
; $06E7
nop
; $06E8
nop
; $06E9
nop
; $06EA
nop
; $06EB
nop
; $06EC
nop
; $06ED
nop
; $06EE
nop
; $06EF
nop
; $06F0
nop
; $06F1
nop
; $06F2
nop
; $06F3
nop
; $06F4
nop
; $06F5
nop
; $06F6
nop
; $06F7
nop
; $06F8
nop
; $06F9
nop
; $06FA
nop
; $06FB
nop
; $06FC
nop
; $06FD
nop
; $06FE
nop
; $06FF
nop
; $0700
jc   $0785
; $0702
mov  r0,#$2
; $0704
mov  a,r0
; $0705
movp a,@a
; $0706
call $071A
; $0708
jnz  $0705
; $070A
mov  a,#$0
; $070C
movp a,@a
; $070D
xrl  a,r7
; $070E
jnz  $0716
; $0710
mov  a,#$1
; $0712
movp a,@a
; $0713
xrl  a,r6
; $0714
jz   $0718
; $0716
clr  f1
; $0717
cpl  f1
; $0718
jmp  $0055
; $071A
sel  rb0
; $071B
clr  c
; $071C
add  a,r6
; $071D
mov  r6,a
; $071E
clr  a
; $071F
addc a,r7
; $0720
mov  r7,a
; $0721
inc  r0
; $0722
mov  a,r0
; $0723
ret
; $0724
nop
; $0725
nop
; $0726
nop
; $0727
nop
; $0728
nop
; $0729
nop
; $072A
nop
; $072B
nop
; $072C
nop
; $072D
nop
; $072E
nop
; $072F
nop
; $0730
nop
; $0731
nop
; $0732
nop
; $0733
nop
; $0734
nop
; $0735
nop
; $0736
nop
; $0737
nop
; $0738
nop
; $0739
nop
; $073A
nop
; $073B
nop
; $073C
nop
; $073D
nop
; $073E
nop
; $073F
nop
; $0740
nop
; $0741
nop
; $0742
nop
; $0743
nop
; $0744
nop
; $0745
nop
; $0746
nop
; $0747
nop
; $0748
nop
; $0749
nop
; $074A
nop
; $074B
nop
; $074C
nop
; $074D
nop
; $074E
nop
; $074F
nop
; $0750
nop
; $0751
nop
; $0752
nop
; $0753
nop
; $0754
nop
; $0755
nop
; $0756
nop
; $0757
nop
; $0758
nop
; $0759
nop
; $075A
nop
; $075B
nop
; $075C
nop
; $075D
nop
; $075E
nop
; $075F
nop
; $0760
nop
; $0761
nop
; $0762
nop
; $0763
nop
; $0764
nop
; $0765
nop
; $0766
nop
; $0767
nop
; $0768
nop
; $0769
nop
; $076A
nop
; $076B
nop
; $076C
nop
; $076D
nop
; $076E
nop
; $076F
nop
; $0770
nop
; $0771
nop
; $0772
nop
; $0773
nop
; $0774
nop
; $0775
nop
; $0776
nop
; $0777
nop
; $0778
nop
; $0779
nop
; $077A
nop
; $077B
nop
; $077C
nop
; $077D
nop
; $077E
nop
; $077F
nop
; $0780
nop
; $0781
nop
; $0782
nop
; $0783
nop
; $0784
nop
; $0785
nop
; $0786
nop
; $0787
nop
; $0788
nop
; $0789
nop
; $078A
nop
; $078B
nop
; $078C
nop
; $078D
nop
; $078E
nop
; $078F
nop
; $0790
nop
; $0791
nop
; $0792
nop
; $0793
nop
; $0794
nop
; $0795
nop
; $0796
nop
; $0797
nop
; $0798
nop
; $0799
nop
; $079A
nop
; $079B
nop
; $079C
nop
; $079D
nop
; $079E
nop
; $079F
nop
; $07A0
nop
; $07A1
nop
; $07A2
nop
; $07A3
nop
; $07A4
nop
; $07A5
nop
; $07A6
nop
; $07A7
nop
; $07A8
nop
; $07A9
nop
; $07AA
nop
; $07AB
nop
; $07AC
nop
; $07AD
nop
; $07AE
nop
; $07AF
nop
; $07B0
nop
; $07B1
nop
; $07B2
nop
; $07B3
nop
; $07B4
nop
; $07B5
nop
; $07B6
nop
; $07B7
nop
; $07B8
nop
; $07B9
nop
; $07BA
nop
; $07BB
nop
; $07BC
nop
; $07BD
nop
; $07BE
nop
; $07BF
nop
; $07C0
nop
; $07C1
nop
; $07C2
nop
; $07C3
nop
; $07C4
nop
; $07C5
nop
; $07C6
nop
; $07C7
nop
; $07C8
nop
; $07C9
nop
; $07CA
nop
; $07CB
nop
; $07CC
nop
; $07CD
nop
; $07CE
nop
; $07CF
nop
; $07D0
nop
; $07D1
nop
; $07D2
nop
; $07D3
nop
; $07D4
nop
; $07D5
nop
; $07D6
nop
; $07D7
nop
; $07D8
nop
; $07D9
nop
; $07DA
nop
; $07DB
nop
; $07DC
nop
; $07DD
nop
; $07DE
nop
; $07DF
nop
; $07E0
nop
; $07E1
nop
; $07E2
nop
; $07E3
nop
; $07E4
nop
; $07E5
nop
; $07E6
nop
; $07E7
nop
; $07E8
nop
; $07E9
nop
; $07EA
nop
; $07EB
nop
; $07EC
nop
; $07ED
nop
; $07EE
nop
; $07EF
nop
; $07F0
nop
; $07F1
nop
; $07F2
nop
; $07F3
nop
; $07F4
nop
; $07F5
nop
; $07F6
nop
; $07F7
nop
; $07F8
nop
; $07F9
nop
; $07FA
nop
; $07FB
nop
; $07FC
nop
; $07FD
nop
; $07FE
jmp  $0000

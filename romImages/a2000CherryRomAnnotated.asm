; Clock speed is 6 Mhz
; One tick is 32 / 6,000,000 = 5.3 us
	
; Activating the Reset line of the processor causes the first
; instruction to be fetched from location 0.
; $0000
	jmp  $0010                ; Direct Jump to specified address
	nop                       ; 
	
; Interrupt Handler
; $0003
	stop tcnt                 ; Stop Count for Event Counter.
	jmp  $030F                ; Direct Jump to specified address
	nop                       ; 
	
; timer/counter Interrupt Handler
; $0007
	call $0321                ; Call designated Subroutine
	sel  rb1                  ; Select Bank 1 (locations 24 – 31) of Data Memory. 11010101   D5
	mov  r2,a                 ; Move Accumulator contents into r2
	mov  a,#$E7               ; Move 231 into Accumulator
	mov  t,a                  ; Move 231 in Accumulator into register T. 255 - 231 = 24 ticks  148 us
	jmp  $0407                ; Direct Jump to specified address

; $0010
	dis  i                    ; Disable the external Interrupt input.
	stop tcnt                 ; Stop Count for Event Counter.
	clr  a                    ; CLEAR the contents of the Accumulator.
	outl p1,a                 ; Output 0 to p1
	mov  psw,a                ; Move 0 into the Program Status Word.
	mov  a,#$C0               ; Move 192 into the Accumulator
	outl p2,a                 ; Output 192 to p2
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.
	sel  mb0                  ; Select Bank 0 (locations 0 – 2047) of Program Memory.
	call $0321                ; Call designated Subroutine
	call $0321                ; Call designated Subroutine again
	mov  r0,#$7C              ; Move $007C (124) into r0
	mov  a,#$AA               ; Move 170 into the Accumulator
	xrl  a,@r0                ; Logical xor Address $007C ( in r0 ) with Accumulator
	jnz  $0039                ; Jump to $0039 if Accumulator is non-zero.
	inc  r0                   ; Increment r0 ( to $007D )
	mov  a,#$55               ; Move $55 ( 85 ) into the Accumulator
	xrl  a,@r0                ; Logical xor Address $007D ( in r0 ) with Accumulator
	jnz  $0039                ; Jump to $0039 if Accumulator is non-zero.
	inc  r0                   ; Increment r0 ( to $007E )
	mov  a,#$33               ; Move $33 ( 51 ) into the Accumulator
	xrl  a,@r0                ; Logical xor Address $007E ( in r0 ) with Accumulator
	jnz  $0039                ; Jump to $0039 if Accumulator is non-zero.
	inc  r0                   ; Increment r0 ( to $007F )
	mov  a,#$CC               ; Move $CC ( 204 ) into the Accumulator

; $0034
	xrl  a,@r0                ; Logical xor Address $007F ( in r0 ) with Accumulator
	jnz  $0039                ; Jump to $0039 if Accumulator is non-zero.
	jmp  $015F                ; Direct Jump to specified address

; $0039
	mov  r0,#$7C              ; Move $7C (124) into r0
	mov  @r0,#$AA             ; Move $AA ( 170 ) into Address $007C
	inc  r0                   ; Increment r0 ( to $007D )
	mov  @r0,#$55             ; Move $55 ( 85 ) into Address $007D
	inc  r0                   ; Increment r0 ( to $007E )
	mov  @r0,#$33             ; Move $33 ( 51 ) into Address $007E
	inc  r0                   ; Increment r0 ( to $007F )
	mov  @r0,#$CC             ; Move $CC ( 204 ) into Address $007F
	clr  a                    ; CLEAR the contents of the Accumulator
	mov  psw,a                ; Move 0 into the Program Status Word.
	clr  f1                   ; Clear content of Flag 1 to 0.
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.
	clr  a                    ; CLEAR the contents of the Accumulator
	mov  r6,a                 ; CLEAR r6
	mov  r7,a                 ; CLEAR r7
	mov  r0,a                 ; CLEAR r0

; $004E
	movp a,@a                 ; Move data in the current page into the Accumulator.
	call $071A                ; Call designated Subroutine

; $0051
	jnz  $004E                ; Jump to $004E if Accumulator is non-zero.
	jmp  $0158                ; Direct Jump to specified address

; $0055
	mov  r0,#$AA              ; Move $AA (179) into r0
	mov  a,r0                 ; Move the contents of r0 (179) into the Accumulator.
	xrl  a,#$AA               ; a Logical xor #$AA (179) with Accumulator.
	jz   $005E                ; Jump to specified address if Accumulator is 0.
	clr  f0                   ; Clear content of Flag 0 to 0.
	cpl  f0                   ; Set F0 to 1 

; $005E
	mov  r0,#$55              ; Move $55 (85) into r0
	mov  a,r0                 ; Move the contents of r0 (85)  into the Accumulator.
	xrl  a,#$55               ; a Logical xor #$AA (179) with Accumulator.
	jz   $0067                ; Jump to specified address if Accumulator is 0.
	clr  f0                   ; Clear content of Flag 0 to 0.
	cpl  f0                   ; Set F0 to 1

; $0067
	mov  r0,#$1               ; Move $01 (00000001) into r0

; $0069
	mov  @r0,#$AA             ; Move $AA (170) into Address 1 ?
	mov  a,@r0                ; Move contents of Address 1 into Accumulator
	xrl  a,#$AA               ; a Logical xor #$AA (179) with Accumulator.
	jz   $0072                ; Jump to specified address if Accumulator is 0.
	clr  f0                   ; Clear content of Flag 0 to 0.
	cpl  f0                   ; Set F0 to 1

; $0072
	mov  @r0,#$55             ; Move $55 (85) into Address 1 ?
	mov  a,@r0                ; Move contents of Address 1 into Accumulator
	xrl  a,#$55               ; a Logical xor #$55 (85) with Accumulator.
	jz   $007B                ; Jump to specified address if Accumulator is 0.
	clr  f0                   ; Clear content of Flag 0 to 0.
	cpl  f0                   ; Set F0 to 1

; $007B
	mov  a,r0                 ; Move the contents of r0 into Accumulator
	mov  @r0,a                ; Move the contents of the Accumulator into the memory location pointed to by r0
	mov  a,@r0                ; Move back the other way, from memory location pointed to by r0 to the Accumulator
	xrl  a,r0                 ; Logical xor r0 with Accumulator.
	jz   $0083                ; Jump to specified address if Accumulator is 0.
	clr  f0                   ; Clear content of Flag 0 to 0.
	cpl  f0                   ; Set F0 to 1

; $0083
	mov  a,r0                 ; Move the contents of r0 into Accumulator
	cpl  a                    ; Complement the contents of the Accumulator.
	mov  @r0,a                ; Move the contents of the Accumulator into the memory location pointed to by r0
	mov  a,@r0                ; Move back the other way, from memory location pointed to by r0 to the Accumulator
	cpl  a                    ; Complement the contents of the Accumulator.
	xrl  a,r0                 ; Logical xor r0 with Accumulator.
	jz   $008D                ; Jump to specified address if Accumulator is 0.
	clr  f0                   ; Clear content of Flag 0 to 0.
	cpl  f0                   ; Set F0 to 1

; $008D
	inc  r0                   ; Increment r0
	mov  a,r0                 ; Move the contents of r0 into Accumulator
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$84               ; Add $84 ( 132 ) to the Accumulator
	jnc  $0069                ; Jump to $0069 if the carry flag is low
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.
	mov  r0,#$7B              ; Move $7B (123) into r0   10
	clr  a                    ; CLEAR the contents of the Accumulator.

; $0098
	mov  @r0,a                ; Move the contents of the Accumulator into the memory location pointed to by r0
	djnz r0,$0098             ; Decrement the specified register and test contents.
	orl  p2,#$20              ; Logical or $20 (32) with designated p2
	mov  r4,#$55              ; Move $55 (85) into r4
	sel  rb1                  ; Select Bank 1 (locations 24 – 31) of Data Memory
	mov  r3,#$FF              ; Move $FF (255) into r3
	mov  r7,#$1               ; Move $1 (1) into r7
	mov  r6,#$1               ; Move $1 (1) into r6
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.
	mov  a,#$FF               ; Move $FF (255) into Accumulator
	mov  t,a                  ; Move contents of Accumulator ( 255 ) into Timer/Counter.
	en   tcnti                ; Enable internal interrupt Flag for Timer/Counter output.   
	mov  r0,#$24              ; Move $24 ( 36 ) into r0
	jf1  $00BA                ; Jump to specified address if Flag F1 is set
	jf0  $00BE                ; Jump to specified address if Flag F0 is set.
	clr  f1                   ; Clear content of Flag 1 to 0.
	cpl  f1                   ; Complement content of Flag F1.
	mov  r2,#$FD              ; Move $FD ( 253 ) into r2  
	call $0544                ; Call designated Subroutine.  
	strt t                    ; Start Count for Timer.
	jmp  $015F                ; Direct Jump to specified address

; $00BA
	mov  @r0,#$2              ; Move $2 ( 2 ) into Address in r0
	jmp  $00C0                ; Direct Jump to specified address
	mov  @r0,#$1              ; Move 1 ( 1 ) into Address in r0

; $00C0
	clr  f1                   ; Clear content of Flag 1 to 0.
	cpl  f1                   ; Complement content of Flag F1.
	sel  rb1                  ; Select Bank 1 (locations 24 – 31) of Data Memory.
	mov  a,#$FC               ; Move $FC (252) into Accumulator
	rl   a                    ; Rotate Accumulator left by 1-bit without carry.
	mov  r4,a                 ; Move Accumulator contents into r4
	mov  r5,#$18              ; Move $18 ( 24 ) into r5
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.
	strt t                    ; Start Count for Timer.

; $00CB
	jmp  $00CB                ; Direct Jump to specified address

; $00CD
	jmp  $00CD                ; Direct Jump to specified address

.org $0100
	movd a,p5                 ; Move contents of designated port p5 into Accumulator.
	inc  @r1                  ; Increment indirect by 1 the contents of memory location.
	dis  i                    ; Disable the external Interrupt input.
	inc  r1                   ; Increment by 1 contents of designated register.
	inc  r5                   ; Increment by 1 contents of designated register.
	xch  a,@r1                ; Exchange indirect contents of Accumulator and memory.
	en   tcnti                ; Enable internal interrupt Flag for Timer/Counter output.
	xch  a,r1                 ; Exchange the Accumulator and r1
	xchd a,@r0                ; Exchange indirect 4-bit Accumulator and memory.

; $0109
	.db   0x38                ; Undocumented instruction?
	orl  a,@r0                ; Logical or memory pointed to by r0 with Accumulator.
	orl  a,r0                 ; Logical or r0 with Accumulator.
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.
	mov  a,#$1                ; Move $1  ( 00000001 ) into the Accumulator.
	jmp  $012B                ; Direct Jump to specified address

; $0111
	mov  a,#$2                ; Move $2  ( 00000010 ) into the Accumulator.
	jmp  $012B                ; Direct Jump to specified address

; $0115
	mov  a,#$4                ; Move $4  ( 00000100 ) into the Accumulator.
	jmp  $012B                ; Direct Jump to specified address

; $0119
	mov  a,#$8                ; Move $8  ( 00001000 ) into the Accumulator.
	jmp  $012B                ; Direct Jump to specified address

; $011D
	mov  a,#$10               ; Move $10 ( 00010000 ) into the Accumulator.
	jmp  $012B                ; Direct Jump to specified address

; $0121
	mov  a,#$20               ; Move $20 ( 00100000 ) into the Accumulator.
	jmp  $012B                ; Direct Jump to specified address

; $0125
	mov  a,#$40               ; Move $40 ( 01000000 ) into the Accumulator.
	jmp  $012B                ; Direct Jump to specified address

; $0129
	mov  a,#$80               ; Move $80 ( 10000000 ) into the Accumulator.
	anl  p2,#$E0              ; Logical and $E0 ( 11100000 ) with designated p2

; $012D
	outl p1,a                 ; Output contents of Accumulator to port 1
	jmp  $0187                ; Direct Jump to specified address

; $0130
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )
	anl  p2,#$F0              ; Logical and $F0 ( 11110000 ) with port 2
	orl  p2,#$10              ; Logical or $10 ( 00010000 ) with designated port 2
	jmp  $0187                ; Direct Jump to specified address

; $0138
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )
	anl  p2,#$E8              ; Logical and $E8 ( 11101000 ) with port 2
	orl  p2,#$8               ; Logical or $8   ( 00001000 ) with port 2
	jmp  $0187                ; Direct Jump to specified address

; $0140
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )
	anl  p2,#$E4              ; Logical and $E4 ( 11100100 ) with port 2

; $0144
	orl  p2,#$4               ; Logical or $4   ( 00000100 ) with port 2
	jmp  $0187                ; Direct Jump to specified address

; $0148
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )
	anl  p2,#$E2              ; Logical and $E2 ( 11100010 ) with port 2
	orl  p2,#$2               ; Logical or $2   ( 00000010 ) with port 2
	jmp  $0187                ; Direct Jump to specified address

; $0150
	anl  p1,#$0               ; Logical and $0 with designated port 1 ( Clearing it )
	anl  p2,#$E1              ; Logical and $E1 ( 11100001 ) with port 2
	orl  p2,#$1               ; Logical or  $01 ( 00000001 ) with port 2
	jmp  $0187                ; Direct Jump to specified address

; $0158
	movp a,@a                 ; Move data in the current page into the Accumulator
	call $071A                ; Call designated Subroutine.
	jnz  $0158                ; Jump to specified address if Accumulator is non-zero.
	jmp  $0200                ; Direct Jump to specified address

; $015F
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.
	sel  mb0                  ; Select Bank 0 (locations 0 – 2047) of Program Memory.
	clr  a                    ; CLEAR the contents of the Accumulator
	mov  psw,a                ; Move contents of Accumulator into the Program Status Word.
	call $0321                ; Call designated Subroutine.
	jtf  $0169                ; Jump to specified address if Timer Flag is set to 1.
	en   tcnti                ; Enable internal interrupt Flag for Timer/Counter output.
	strt t                    ; Start Count for Timer.
	mov  a,r5                 ; Move register r5 into the Accumulator.
	jz   $0170                ; Jump to specified address if Accumulator is 0.
	anl  p2,#$DF              ; Logical and $DF ( 11011111 ) with designated p2
	jmp  $0172                ; Direct Jump to specified address

; $0170
	orl  p2,#$20              ; Logical or immediate specified data with port p2
	mov  r3,#$0               ; Move $0 ( 00000000 ) into r3
	mov  a,r3                 ; Move r3 ( 00000000 ) into the Accumulator.
	anl  a,#$7                ; Logical and $7 ( 00000111 ) with Accumulator.

; $0177
	movp3 a,@a                ; Move Program data in Page 3 into the Accumulator
	mov  r2,a                 ; Move Accumulator contents into r2

; $0179
	mov  a,r3                 ; Move the contents of r3 into the Accumulator.
	anl  a,#$78               ; Logical and $78 ( 01111000 ) with Accumulator.
	rl   a                    ; Rotate Accumulator left by 1-bit without carry.
	swap a                    ; Swap the 2 4-bit nibbles in the Accumulator
	mov  r1,a                 ; Move Accumulator contents into r1
	rl   a                    ; Rotate Accumulator left by 1-bit without carry.
	add  a,#$60               ; Add $60 ( 01100000 ) to the Accumulator
	mov  r0,a                 ; Move Accumulator contents into r0
	clr  f0                   ; Clear content of Flag 0 to 0
	cpl  f0                   ; Complement content of Flag F0.
	mov  a,r1                 ; Move contents of r1 into the Accumulator.
	jmpp @a                   ; Jump indirect to specified address within address page

; $0187
	jnt0 $018C                ; Jump to specified address if Test 0 is low.
	movx a,@r0                ; Move data pointed to by r0 into the Accumulator.
	jmp  $018D                ; Direct Jump to specified address

; $018C
	ins  a,bus                ; Input strobed BUS data into Accumulator.

; $018D
	anl  a,r2                 ; Logical and contents of r2 with Accumulator
	jz   $01A2                ; Jump to specified address if Accumulator is zero
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.
	inc  r0                   ; Increment r0
	jnz  $019A                ; Jump to specified address if Accumulator is non-zero
	mov  a,r2                 ; Move contents of r2 into the Accumulator.
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.
	jz   $019A                ; Jump to specified address if Accumulator is zero
	dec  r0                   ; Decrement r0
	clr  f0                   ; Clear content of Flag f0 to 0.
	mov  a,r2                 ; Move contents of r2 into the Accumulator.
	orl  a,@r0                ; Logical or memory pointed to by r0 with Accumulator.
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0
	jf0  $01B4                ; Jump to specified address if Flag F0 is set.
	cpl  f0                   ; Complement content of Flag F0.   
	jmp  $0207                ; Direct Jump to specified address

; $01A2
	mov  a,r2                 ; Move contents of r2 into the Accumulator.
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.
	inc  r0                   ; Increment r0
	jz   $01AC                ; Jump to specified address if Accumulator is zero
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.
	jnz  $01AC                ; Jump to specified address if Accumulator is non-zero
	dec  r0                   ; Decrement r0
	clr  f0                   ; Clear content of Flag f0 to 0.
	mov  a,r2                 ; Move contents of r2 into the Accumulator.
	cpl  a                    ; Complement the contents of the Accumulator.
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0
	jf0  $01B4                ; Jump to specified address if Flag F0 is set.
	jmp  $0207                ; Direct Jump to specified address

; $01B4
	inc  r3                   ; Increment r3
	clr  c                    ; Clear content of carry bit to 0.
	mov  a,r3                 ; Move contents of r3 into the Accumulator.
	add  a,#$98               ; Add $98 ( 10011000 ) to the Accumulator
	jnc  $0174                ; Jump to $0174 if the carry flag is low
	mov  a,r4                 ; Move contents of r4 into the Accumulator.
	xrl  a,#$55               ; Logical xor #$55 ( 01010101 ) with Accumulator.
	jnz  $01C4                ; Jump to specified address if Accumulator is non-zero
	mov  r4,#$AA              ; Move $AA ( 10101010 ) into r4
	jmp  $015F                ; Direct Jump to specified address

; $01C4
	mov  a,r4                 ; Move contents of r4 into the Accumulator.
	mov  r4,#$0               ; Move $00 ( 00000000 ) into r4
	xrl  a,#$AA               ; Logical xor #$AA ( 10101010 ) with Accumulator.
	jnz  $015F                ; Jump to specified address if Accumulator is non-zero
	mov  r2,#$FE              ; Move $FE ( 11111110 ) into r2
	call $0544                ; Call designated Subroutine.
	jmp  $015F                ; Direct Jump to specified address

.org $0200
	movp a,@a                 ; Move data in the current page into the Accumulator.
	call $071A                ; Call designated Subroutine.
	jnz  $0200                ; Jump to specified address if Accumulator is non-zero
	jmp  $0308                ; Direct Jump to specified address

; $0207
	mov  a,r4                 ; Move contents of r4 into the Accumulator.
	xrl  a,#$55               ; Logical xor #$55 ( 01010101 ) with Accumulator.
	jz   $0259                ; Jump to specified address if Accumulator is zero
	mov  a,r3                 ; Move contents of r3 into the Accumulator.
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$98               ; Add $98 ( 10011000 ) to the Accumulator
	jc   $0259                ; Jump to specified address if carry flag is set.
	mov  r0,#$7               ; Move $7 ( 00000111 ) into r0
	mov  a,r3                 ; Move contents of r3 into the Accumulator.
	xrl  a,#$3D               ; Logical xor #$3D ( 00111101 ) with Accumulator.
	jnz  $0222                ; Jump to specified address if Accumulator is non-zero
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	orl  a,#$80               ; Logical or $80 ( 10000000 ) with Accumulator.
	jf0  $023C                ; Jump to specified address if Flag F0 is set.
	anl  a,#$7F               ; Logical and $7F ( 01111111 ) with Accumulator.
	jmp  $023C                ; Direct Jump to specified address

; $0222
	mov  a,r3                 ; Move contents of r3 into the Accumulator.
	xrl  a,#$3E               ; Logical xor #$3E ( 00111110 ) with Accumulator.
	jnz  $0230                ; Jump to specified address if Accumulator is non-zero
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	orl  a,#$40               ; Logical or $80 ( 01000000 ) with Accumulator.
	jf0  $023C                ; Jump to specified address if Flag F0 is set.
	anl  a,#$BF               ; Logical and $7F ( 10111111 ) with Accumulator.
	jmp  $023C                ; Direct Jump to specified address

; $0230
	mov  a,r3                 ; Move contents of r3 into the Accumulator.
	xrl  a,#$62               ; Logical xor #$3E ( 01100010 ) with Accumulator.
	jnz  $023D                ; Jump to specified address if Accumulator is non-zero
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	orl  a,#$20               ; Logical or $80 ( 00100000 ) with Accumulator.
	jf0  $023C                ; Jump to specified address if Flag F0 is set.
	anl  a,#$DF               ; Logical and $7F ( 11011111 ) with Accumulator.

; $023C
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0
	mov  a,r3                 ; Move contents of r3 into the Accumulator.
	add  a,#$7                ; Add $7 ( 00000111 ) to the Accumulator
	call $066F                ; Call designated Subroutine.
	mov  r2,a                 ; Move Accumulator contents into r2
	xrl  a,#$FF               ; Logical xor #$FF ( 11111111 ) with Accumulator.
	jz   $0259                ; Jump to specified address if Accumulator is zero
	jf0  $025B                ; Jump to specified address if Flag F0 is set.
	mov  a,r3                 ; Move contents of r3 into the Accumulator.
	xrl  a,#$1E               ; Logical xor #$1E ( 00011110 ) with Accumulator.
	jz   $0259                ; Jump to specified address if Accumulator is zero
	mov  a,r4                 ; Move contents of r4 into the Accumulator.
	xrl  a,#$AA               ; Logical xor #$AA ( 10101010 ) with Accumulator.
	jz   $0259                ; Jump to specified address if Accumulator is zero
	mov  a,r2                 ; Move contents of r2 into the Accumulator.
	orl  a,#$80               ; Logical or $80 ( 00100000 ) with Accumulator.
	mov  r2,a                 ; Move Accumulator contents into r2
	call $0544                ; Call designated Subroutine.
; $0259                       
	jmp  $01B4                ; Direct Jump to specified address

; $025B
	call $0544                ; Call designated Subroutine.
	jmp  $01B4                ; Direct Jump to specified address

.org $0300
	.db   0x01                ; ??
	outl bus,a                ; Output contents of Accumulator onto BUS.
	jmp  $0008                ; ? $0008 contains $21 which is not a valid instruction ?

; $0304
	inc  @r0                  ; the contents of the Memory location addressed by r0 is incremented by 1
	xch  a,@r0                ; Exchange indirect contents of Accumulator and memory.
	orl  a,@r0                ; Logical or memory pointed to by r0 with Accumulator.
	movx a,@r0                ; Move data pointed to by r0 into the Accumulator.

; $0308
	movp a,@a                 ; Move data in the current page into the Accumulator.
	call $071A                ; Call designated Subroutine.
	jnz  $0308                ; Jump to specified address if Accumulator is non-zero
	jmp  $0400                ; Direct Jump to specified address

; $030F                       ; Interrupt Handler
	sel  rb1                  ; Select Bank 1 (locations 24 – 31) of Data Memory.
	jni  $0314                ; Jump to specified address if interrupt is low.
	jmp  $0320                ; Direct Jump to specified address

; $0314
	mov  r1,#$9               ; Move $9 ( 00001001 ) into r1
; $0316
	djnz r1,$0316             ; Decrement the specified register and test contents.
	jni  $031C                ; Jump to specified address if interrupt is low.
	jmp  $0320                ; Direct Jump to specified address

; $031C
	clr  f1                   ; Clear content of Flag 1 to 0.
	mov  r3,#$0               ; Move $0 ( 00000000 ) into r3
	dis  i                    ; Disable the external Interrupt input.

; $0320
	strt t                    ; Start Count for Timer.

; $0321
	retr                      ; Return from Subroutine restoring Program Status Word.

; $0322
	jni  $0346                ; Jump to specified address if interrupt is low.

; $0324
	mov  r0,#$9               ; Move $9 ( 00001001 ) into r0
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	anl  a,#$F7               ; Logical and $F7 ( 11110111 ) with Accumulator.
	mov  r5,a                 ; Move Accumulator contents into r5
	clr  f1                   ; Clear content of Flag 1 to 0.
	jmp  $0337                ; Direct Jump to specified address

; $032D
	orl  p2,#$40              ; Logical or immediate specified data with port p2
	jnc  $0348                ; Jump if the carry flag is low
	anl  p2,#$BF              ; Logical and $DF ( 10111111 ) with port p2

; $0333
	mov  r4,a                 ; Move Accumulator contents into r4
	nop                       
	anl  p2,#$7F              ; Logical and $DF ( 01111111 ) with port p2

; $0337
	mov  a,r4                 ; Move contents of r4 into the Accumulator.
	rlc  a                    ; Rotate Accumulator left by 1-bit through carry.
	orl  p2,#$80              ; Logical or 10000000 with port p2
	djnz r0,$032D             ; Decrement the specified register and test contents.
	orl  p2,#$40              ; Logical or 01000000 with port p2
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	jb4  $034A                ; Jump to specified address if Accumulator bit 4 is set.
	jb1  $0346                ; Jump to specified address if Accumulator bit 1 is set.
	cpl  f1                   ; Complement content of Flag F1.
	en   i                    ; Enable the external Interrupt input

; $0346
	jmp  $0437                ; Direct Jump to specified address

; $0348
	jmp  $0333                ; Direct Jump to specified address

; $034A
	mov  r5,#$C0              ; Move $C0 ( 11000000 ) into r5
	jmp  $0437                ; Direct Jump to specified address

.org $0400
	movp a,@a                 ; Move data in the current page into the Accumulator.
	call $071A                ; Call designated Subroutine.
	jnz  $0400                ; Jump to specified address if Accumulator is non-zero
	jmp  $0500                ; Direct Jump to specified address

; $0407
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	jb7  $0439                ; Jump to specified address if Accumulator bit 7 is set.
	jb1  $0452                ; Jump to specified address if Accumulator bit 1 is set.
	mov  r0,#$7               ; Move $7 ( 00000111 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 ($7) into Accumulator
	anl  a,#$E0               ; Logical and $E0 ( 11100000 ) with Accumulator.
	xrl  a,#$E0               ; Logical xor #$E0 ( 11100000 ) with Accumulator.
	jz   $04AF                ; Jump to specified address if Accumulator is zero
	jf1  $0486                ; Jump to specified address if Flag F1 is set
	dis  i                    ; Disable the external Interrupt input.

; $0418
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	jb3  $0431                ; Jump to specified address if Accumulator bit 3 is set.
	jb0  $0426                ; Jump to specified address if Accumulator bit 1 is set.
	mov  r0,#$6               ; Move $7 ( 00000110 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 ($6) into Accumulator
	jnz  $0437                ; Jump to specified address if Accumulator is zero
	call $0507                ; Call designated Subroutine.
	jz   $0437                ; Jump to specified address if Accumulator is zero

; $0426
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	anl  a,#$FE               ; Logical and $E0 ( 11111110 ) with Accumulator.
	orl  a,#$8                ; Logical or $80 ( 00001000 ) with Accumulator.
	mov  r5,a                 ; Move Accumulator contents into r5
	mov  r0,#$20              ; Move $7 ( 00100000 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 ($6) into Accumulator
	rl   a                    ; Rotate Accumulator left by 1-bit without carry.
	mov  r4,a                 ; Move Accumulator contents into r4

; $0431
	mov  r7,#$48              ; Move $48 ( 01001000 ) into r7
	mov  r6,#$1               ; Move $1 (1) into r6
	jmp  $0322                ; Direct Jump to specified address

; $0437
	mov  a,r2                 ; Move contents of r2 into the Accumulator.
	retr                      ; Return from Subroutine restoring Program Status Word.

; $0439
	dis  i                    ; Disable the external Interrupt input.
	djnz r7,$0437             ; Decrement r7 and test contents.
	mov  r7,#$FA              ; Move $FA ( 11111010 ) into r7
	djnz r6,$0437             ; Decrement r6 and test contents.
	mov  r0,#$24              ; Move $24 ( 00100100 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 ($24) into Accumulator
	mov  r6,a                 ; Move Accumulator contents into r6
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	xrl  a,#$40               ; Logical xor #$40 ( 01000000 ) with Accumulator.
	mov  r5,a                 ; Move Accumulator contents into r5
	jb6  $044E                ; Jump to specified address if Accumulator bit 6 is set.
	orl  p2,#$20              ; Logical or $20 00100000 with port p2
	jmp  $0437                ; Direct Jump to specified address

; $044E
	anl  p2,#$DF              ; Logical and $DF ( 01111111 ) with port p2
	jmp  $0437                ; Direct Jump to specified address

; $0452
	dis  i                    ; Disable the external Interrupt input.
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	jb2  $0472                ; Jump to specified address if Accumulator bit 2 is set.
	anl  p2,#$7F              ; Logical and $7F ( 01111111 ) with port p2
	djnz r7,$0437             ; Decrement r7 and test contents.
	mov  r7,#$AA              ; Move $AA ( 10101010 ) into r7
	djnz r6,$0437             ; Decrement r7 and test contents.
	mov  r6,#$2               ; Move $2 (00000010) into r6
	mov  r0,#$7               ; Move $7 ( 00000111 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 ($7) into Accumulator
	anl  a,#$E0               ; Logical and $E0 ( 11111110 ) with Accumulator.
	xrl  a,#$E0               ; Logical xor #$E0 ( 11100000 ) with Accumulator.
	jz   $047D                ; Jump to specified address if Accumulator is zero
	stop tcnt                 ; Stop Count for Event Counter.
	mov  r0,#$7C              ; Move $7 ( 00000111 ) into r0
	mov  @r0,#$0              ; Move 0 ( 00000000 ) into Address in r0
	call $0321                ; Call designated Subroutine.
	jmp  $0000                ; Direct Jump to specified address

; $0472
	mov  r4,#$FB              ; Move $FB ( 11111011 ) into r4
	jni  $0437                ; Jump to specified address if interrupt is low.
	mov  r5,#$2               ; Move $2 ( 00000010 ) into r5
	mov  a,#$22               ; Move $22 ( 00100010 ) into the Accumulator.
	mov  t,a                  ; Move contents of Accumulator ( 22 ) into Timer/Counter.
	jmp  $0324                ; Direct Jump to specified address

; $047D
	orl  p2,#$80              ; Logical or $80 ( 10000000 ) with port p2
	mov  a,#$CC               ; Move $CC ( 11001100 ) into the Accumulator.
	mov  t,a                  ; Move contents of Accumulator ( CC ) into Timer/Counter.
	mov  r5,#$6               ; Move $6 ( 00000110 ) into r5
	jmp  $0437                ; Direct Jump to specified address

; $0486
	djnz r7,$0437             ; Decrement r7 and test contents.
	mov  r7,#$48              ; Move $48 ( 01001000 ) into r7
	djnz r6,$0437             ; Decrement r6 and test contents.
	mov  r6,#$1               ; Move $1 (00000001) into r6
	dis  i                    ; Disable the external Interrupt input.
	jf1  $0493                ; Jump to specified address if Flag F1 is set
	jmp  $0437                ; Direct Jump to specified address

; $0493
	jni  $04AC                ; Jump to specified address if interrupt is low.
	anl  p2,#$BF              ; Logical and $BF ( 10111111 ) with port p2
	orl  a,#$0                ; Logical or $0 ( 00000000 ) with Accumulator.
	anl  p2,#$7F              ; Logical and $7F ( 01111111 ) with port p2
	orl  a,#$0                ; Logical or $0 ( 00000000 ) with Accumulator.
	orl  p2,#$80              ; Logical and $80 ( 10000000 ) with port p2
	orl  a,#$0                ; Logical or $0 ( 00000000 ) with Accumulator.
	orl  p2,#$40              ; Logical and $40 ( 01000000 ) with port p2
	mov  a,r3                 ; Move contents of r3 into the Accumulator.
	jnz  $04AC                ; Jump to specified address if Accumulator is zero
	mov  r4,#$F3              ; Move $F3 ( 11110011 ) into r4
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	orl  a,#$9                ; Logical or $9 ( 00001001 ) with Accumulator.
	mov  r5,a                 ; Move Accumulator contents into r5

; $04AC
	en   i                    ; Enable the external Interrupt input
	jmp  $0437                ; Direct Jump to specified address

; $04AF
	dis  i                    ; Disable the external Interrupt input.
	mov  r5,#$2               ; Move $2 ( 00000010 ) into r5
	mov  r7,#$AA              ; Move $AA ( 10101010 ) into r7
	mov  r6,#$2               ; Move $2 ( 00000010 ) into r6
	anl  p2,#$7F              ; Logical and $7F ( 01111111 ) with port p2
	jmp  $0437                

.org $0500
	movp a,@a                 ; Move data in the current page into the Accumulator.
	call $071A                ; Call designated Subroutine.
	jnz  $0500                ; Jump to specified address if Accumulator is zero
	jmp  $0600                ; Direct Jump to specified address

; $0507
	mov  r0,#$21              ; Move $21 ( 00100001 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 ($21) into Accumulator
	jz   $0539                ; Jump to specified address if Accumulator is zero
	dec  a                    ; Decrement by 1 the Accumulator's contents.
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$CE               ; Add $CE ( 11001110 ) to the Accumulator
	jc   $0539                ; Jump to specified address if carry flag is set.
	mov  r0,#$22              ; Move $22 ( 00100010 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$CE               ; Add $CE ( 11001110 ) to the Accumulator
	jc   $0539                ; Jump to specified address if carry flag is set.
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	add  a,#$28               ; Add $28 ( 00101000 ) to the Accumulator
	mov  r0,a                 ; Move Accumulator contents into r0
	mov  a,#$FF               ; Move $FF ( 11111111 ) into the Accumulator.
	xch  a,@r0                ; Exchange indirect contents of Accumulator and memory.
	mov  r0,a                 ; Move Accumulator contents into r0
	xrl  a,#$FF               ; Logical xor #$FF ( 11111111 ) with Accumulator.
	jz   $0539                ; Jump to specified address if Accumulator is zero
	mov  a,r0                 ; Move the contents of r0 into Accumulator
	mov  r0,#$20              ; Move $20 ( 00100000 ) into r0
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0
	mov  r0,#$22              ; Move $22 ( 00100010 ) into r0
	inc  @r0                  ; the contents of the Memory location addressed by r0 is incremented by 1
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$CE               ; Add $CE ( 11001110 ) to the Accumulator
	jnc  $0536                ; Jump if the carry flag is low
	mov  @r0,#$0              ; Move 0 ( 00000000 ) into Address in r0

; $0536
	mov  a,#$55               ; Move $55 ( 01010101 ) into the Accumulator.
	ret                       ; Return from Subroutine without restoring Program Status Word.

; $0539
	clr  a                    ; CLEAR the contents of the Accumulator
	mov  r0,#$21              ; Move $21 ( 00100001 ) into r0
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0
	mov  r0,#$23              ; Move $23 ( 00100011 ) into r0
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0
	mov  r0,#$22              ; Move $22 ( 00100010 ) into r0
	mov  @r0,a                ; Move Accumulator into the memory pointed to by r0
	ret                       ; Return from Subroutine without restoring Program Status Word.

; $0544
	mov  r0,#$6               ; Move $6 ( 00000110 ) into r0
	mov  @r0,#$FF             ; Move $FF ( 11111111 ) into Address in r0
	mov  r0,#$21              ; Move $21 ( 00100001 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$CE               ; Add $CE ( 11001110 ) to the Accumulator
	jnc  $0558                ; Jump if the carry flag is low
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$CD               ; Add $CD ( 11001101 ) to the Accumulator
	jc   $0592                ; Jump to specified address if carry flag is set.
	jmp  $058A                ; Direct Jump to specified address

; $0558
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$CF               ; Add $CF ( 11001111 ) to the Accumulator
	jnc  $0560                ; Jump if the carry flag is low
	mov  r2,#$FA              ; Move $FA ( 11111010 ) into r2

; $0560
	inc  @r0                  ; the contents of the Memory location addressed by r0 is incremented by 1
	mov  r0,#$23              ; Move $23 ( 00100011 ) into r0
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$CE               ; Add $CE ( 11001110 ) to the Accumulator
	jc   $0592                ; Jump to specified address if carry flag is set.
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	add  a,#$28               ; Add $28 ( 00101000 ) to the Accumulator
	mov  r1,a                 ; Move Accumulator contents into r1
	mov  a,r2                 ; Move contents of r2 into the Accumulator.
	xrl  a,#$62               ; Logical xor #$62 ( 01100010 ) with Accumulator.
	jnz  $057A                ; Jump to specified address if Accumulator is zero
	mov  a,r5                 ; Move contents of r5 into the Accumulator.
	xrl  a,#$FF               ; Logical xor #$FF ( 11111111 ) with Accumulator.
	mov  r5,a                 ; Move Accumulator contents into r5
	jnz  $057A                ; Jump to specified address if Accumulator is zero
	mov  r2,#$E2              ; Move $E2 ( 11100010 ) into r2

; $057A
	mov  a,r2                 ; Move contents of r2 into the Accumulator.
	mov  @r1,a                ; Move indirect Accumulator contents into data memory location.
	inc  @r0                  ; the contents of the Memory location addressed by r0 is incremented by 1
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	clr  c                    ; Clear content of carry bit to 0.
	add  a,#$CE               ; Add $CE ( 11001110 ) to the Accumulator
	jnc  $0585                ; Jump if the carry flag is low
	mov  @r0,#$0              ; Move 0 ( 00000000 ) into Address in r0

; $0585
	mov  r0,#$6               ; Move $6 ( 00000110 ) into r0
	mov  @r0,#$0              ; Move 0 ( 00000000 ) into Address in r0
	ret                       ; Return from Subroutine without restoring Program Status Word.

; $058A
	mov  r0,#$23              ; Move $23 ( 00100011 ) into r0
	mov  r1,#$22              ; Move $22 ( 00100010 ) into r1
	mov  a,@r0                ; Move contents of Address in r0 into Accumulator
	xrl  a,@r1                ; Logical xor contents of Address in r1 with Accumulator
	jz   $0585                ; Jump to specified address if Accumulator is zero

; $0592
	mov  r0,#$23              ; Move $23 ( 00100011 ) into r0
	mov  @r0,#$0              ; Move 0 ( 00000000 ) into Address in r0
	mov  r0,#$22              ; Move $22 ( 00100010 ) into r0
	mov  @r0,#$0              ; Move 0 ( 00000000 ) into Address in r0
	mov  r0,#$21              ; Move $21 ( 00100001 ) into r0
	mov  @r0,#$0              ; Move 0 ( 00000000 ) into Address in r0
	jmp  $0585                ; Direct Jump to specified address

.org $0600
	movp a,@a                 ; Move data in the current page into the Accumulator.
	call $071A                ; Call designated Subroutine.
	jnz  $0600                ; Jump to specified address if Accumulator is zero
	jmp  $0702                ; Direct Jump to specified address

; $0607
	strt t                    ; Start Count for Timer.
	anl  a,r1                 ; Logical and contents of r1 with Accumulator
	in   a,p2                 ; Input data from designated port (1 – 2) into Accumulator
	.db   0x06                ; ??
	jt0  $0625                ; Jump to specified address if Test 0 is a 1
	inc  r1                   ; Increment by 1 contents of designated register.
	dis  i                    ; Disable the external Interrupt input.
	jb2  $0641                ; Jump to specified address if Accumulator bit 2 is set.
	mov  a,r7                 ; Move contents of r7 into the Accumulator.
	en   i                    ; Enable the external Interrupt input
	dis  tcnti                ; Disable internal interrupt Flag for Timer Counter output.
	jmp  $0144                ; Direct Jump to specified address

; $0616
	call $0051                ; Call designated Subroutine.
	mov  a,r7                 ; Move contents of r7 into the Accumulator.
	mov  a,r7                 ; Move contents of r7 into the Accumulator.  ?? Why twice?
	outl bus,a                ; Output contents of Accumulator onto BUS.
	jb1  $0621                ; Jump to specified address if Accumulator bit 1 is set.
	mov  a,r7                 ; Move contents of r7 into the Accumulator.
	inc  @r1                  ; Increment indirect by 1 the contents of memory location.
	strt cnt                  ; Start Count for Event Counter.
	mov  a,r7                 ; Move contents of r7 into the Accumulator.

; $0621
	xchd a,@r0                ; Exchange indirect 4-bit Accumulator and memory.
	.db   0x01                ; ??
	xchd a,@r1                ; Exchange indirect 4-bit Accumulator and memory.
	xch  a,@r0                ; Exchange indirect contents of Accumulator and memory.

; $0625
	mov  t,a                  ; Move contents of Accumulator into Timer/Counter.
	inc  @r0                  ; the contents of the Memory location addressed by r0 is incremented by 1
	call $02FF                ; Call designated Subroutine. ?? 02FF is a nop

; $0629
	orl  a,@r0                ; Logical or memory pointed to by r0 with Accumulator.
	add  a,#$33               ; Add $33 ( 00110011 ) to the Accumulator
	.db   0x22                ; ??
	stop tcnt                 ; Stop Count for Event Counter.
	jb0  $065D                ; Jump to specified address if Accumulator bit 0 is set.
	anl  a,r4                 ; Logical and contents of r4 with Accumulator
	movd p7,a                 ; Move contents of Accumulator to designated port (4 – 7)
	orl  a,r2                 ; Logical or r2 with Accumulator.
	orl  a,#$1F               ; Logical or $1F ( 00011111 ) with Accumulator.
	anl  a,r6                 ; Logical and contents of r6 with Accumulator
	xch  a,r7                 ; Exchange the Accumulator and r7
	anl  a,r2                 ; Logical and contents of r2 with Accumulator
	anl  a,r3                 ; Logical and contents of r3 with Accumulator
	movd p6,a                 ; Move contents of Accumulator to designated port (4 – 7)
	movd p5,a                 ; Move contents of Accumulator to designated port (4 – 7)
	inc  r6                   ; Increment by 1 contents of designated register.
	inc  r5                   ; Increment by 1 contents of designated register.
	xch  a,r6                 ; Exchange the Accumulator and r6
	xch  a,r5                 ; Exchange the Accumulator and r5
	anl  a,@r0                ; Logical and memory pointed to by r0 with Accumulator.
	mov  a,r7                 ; Move contents of r7 into the Accumulator.

; $0641
	jmp  $0300                ; Direct Jump to specified address

; $0643
	add  a,@r0                ; Add indirect the contents of the data memory location to the Accumulator
	.db   0x63                ; ??
	.db   0x66                ; ??
	mov  a,t                  ; Move contents of Timer/Counter into Accumulator.
	anl  a,r7                 ; Logical and contents of r7 with Accumulator
	jnt1 $064C                ; Jump to specified address if Test 1 is low
	orl  a,r6                 ; Logical or r6 with Accumulator.
	movd p4,a                 ; Move contents of Accumulator to designated port (4 – 7)

; $064C
	movd a,p7                 ; Move contents of designated port p7 into Accumulator.
	orl  a,r7                 ; Logical or r7 with Accumulator.
	orl  a,r5                 ; Logical or r5 with Accumulator.
	da   a                    ; DECIMAL ADJUST the contents of the Accumulator.
	mov  a,r7                 ; Move contents of r7 into the Accumulator.
	outl p2,a                 ; Output contents of Accumulator to port 2
	dec  a                    ; Decrement by 1 the Accumulator's contents
	cpl  a                    ; Complement the contents of the Accumulator.
	jnt0 $0629                ; Jump to specified address if Test 0 is low.
	jtf  $0658                ; Jump to specified address if Timer Flag is set to 1.

; $0658
	.db   0x0b                ; ??
	inc  r2                   ; Increment by 1 contents of designated register.
	in   a,p1                 ; Input data from designated port (1 – 2) into Accumulator.
	outl p1,a                 ; Output contents of Accumulator to port 1
	xch  a,r0                 ; Exchange the Accumulator and r0

; $065D
	xch  a,r2                 ; Exchange the Accumulator and r2
	inc  r0                   ; Increment by 1 contents of designated register.
	jt1  $060C                ; Jump to specified address if Test 1 is a 1. ?? Address is dodgy
	inc  r3                   ; Increment by 1 contents of designated register.
	ins  a,bus                ; Input strobed BUS data into Accumulator.
	.db   0x38                ; ??
	clr  a                    ; CLEAR the contents of the Accumulator
	xch  a,r3                 ; Exchange the Accumulator and r3
	inc  a                    ; Increment by 1 the Accumulator's contents
	anl  a,#$D                ; Logical and $D ( 00001101 ) with Accumulator.
	rrc  a                    ; Rotate Accumulator right by 1-bit through carry.
	jmp  $0034                ; Direct Jump to specified address
	mov  a,#$61               ; Move $61 ( 01100001 ) into the Accumulator.
	addc a,#$A3               ; Add immediate with carry $A3 ( 10100011 ) to the Accumulator.
	ret                       ; Return from Subroutine without restoring Program Status Word.

.org $0700
	jc   $0785                ; Jump to specified address if carry flag is set.

; $0702
	mov  r0,#$2               ; Move $2 ( 00000010 ) into r0
	mov  a,r0                 ; Move the contents of r0 into Accumulator

; $0705
	movp a,@a                 ; Move data in the current page into the Accumulator.
	call $071A                ; Call designated Subroutine.
	jnz  $0705                ; Jump to specified address if Accumulator is zero

; $070A
	mov  a,#$0                ; Move $0 ( 00000000 ) into the Accumulator.
	movp a,@a                 ; Move data in the current page into the Accumulator.
	xrl  a,r7                 ; Logical xor r7 with Accumulator.
	jnz  $0716                ; Jump to specified address if Accumulator is zero
	mov  a,#$1                ; Move $1 ( 00000001 ) into the Accumulator.
	movp a,@a                 ; Move data in the current page into the Accumulator.
	xrl  a,r6                 ; Logical xor r7 with Accumulator.
	jz   $0718                ; Jump to specified address if Accumulator is zero

; $0716
	clr  f1                   ; Clear content of Flag 1 to 0.
	cpl  f1                   ; Complement content of Flag F1.

; $0718
	jmp  $0055                ; Direct Jump to specified address

; $071A
	sel  rb0                  ; Select Bank 0 (locations 0 – 7) of Data Memory.
	clr  c                    ; Clear content of carry bit to 0.
	add  a,r6                 ; Add contents of designated register to the Accumulator.
	mov  r6,a                 ; Move Accumulator contents into r6
	clr  a                    ; CLEAR the contents of the Accumulator
	addc a,r7                 ; Add with carry the contents of the designated register to the Accumulator.
	mov  r7,a                 ; CLEAR r7
	inc  r0                   ; Increment by 1 contents of designated register.
	mov  a,r0                 ; Move the contents of r0 into Accumulator
	ret                       ; Return from Subroutine without restoring Program Status Word.

.org $07FE
	jmp  $0000                ; Direct Jump to specified address

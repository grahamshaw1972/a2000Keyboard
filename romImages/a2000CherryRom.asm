jmp  $0010
nop
stop tcnt
jmp  $030F
nop
call $0321
sel  rb1
mov  r2,a
mov  a,#$E7
mov  t,a
jmp  $0407
dis  i
stop tcnt
clr  a
outl p1,a
mov  psw,a
mov  a,#$C0
outl p2,a
sel  rb0
sel  mb0
call $0321
call $0321
mov  r0,#$7C
mov  a,#$AA
xrl  a,@r0
jnz  $0039
inc  r0
mov  a,#$55
xrl  a,@r0
jnz  $0039
inc  r0
mov  a,#$33
xrl  a,@r0
jnz  $0039
inc  r0
mov  a,#$CC
xrl  a,@r0
jnz  $0039
jmp  $015F
mov  r0,#$7C
mov  @r0,#$AA
inc  r0
mov  @r0,#$55
inc  r0
mov  @r0,#$33
inc  r0
mov  @r0,#$CC
clr  a
mov  psw,a
clr  f1
sel  rb0
clr  a
mov  r6,a
mov  r7,a
mov  r0,a
movp a,@a
call $071A
jnz  $004E
jmp  $0158
mov  r0,#$AA
mov  a,r0
xrl  a,#$AA
jz   $005E
clr  f0
cpl  f0
mov  r0,#$55
mov  a,r0
xrl  a,#$55
jz   $0067
clr  f0
cpl  f0
mov  r0,#$1
mov  @r0,#$AA
mov  a,@r0
xrl  a,#$AA
jz   $0072
clr  f0
cpl  f0
mov  @r0,#$55
mov  a,@r0
xrl  a,#$55
jz   $007B
clr  f0
cpl  f0
mov  a,r0
mov  @r0,a
mov  a,@r0
xrl  a,r0
jz   $0083
clr  f0
cpl  f0
mov  a,r0
cpl  a
mov  @r0,a
mov  a,@r0
cpl  a
xrl  a,r0
jz   $008D
clr  f0
cpl  f0
inc  r0
mov  a,r0
clr  c
add  a,#$84
jnc  $0069
sel  rb0
mov  r0,#$7B
clr  a
mov  @r0,a
djnz r0,$0098
orl  p2,#$20
mov  r4,#$55
sel  rb1
mov  r3,#$FF
mov  r7,#$1
mov  r6,#$1
sel  rb0
mov  a,#$FF
mov  t,a
en   tcnti
mov  r0,#$24
jf1  $00BA
jf0  $00BE
clr  f1
cpl  f1
mov  r2,#$FD
call $0544
strt t
jmp  $015F
mov  @r0,#$2
jmp  $00C0
mov  @r0,#$1
clr  f1
cpl  f1
sel  rb1
mov  a,#$FC
rl   a
mov  r4,a
mov  r5,#$18
sel  rb0
strt t
jmp  $00CB
jmp  $00CD
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
nop
movd a,p5
inc  @r1
dis  i
inc  r1
inc  r5
xch  a,@r1
en   tcnti
xch  a,r1
xchd a,@r0
.db   0x38
orl  a,@r0
orl  a,r0
anl  a,@r0
mov  a,#$1
jmp  $012B
mov  a,#$2
jmp  $012B
mov  a,#$4
jmp  $012B
mov  a,#$8
jmp  $012B
mov  a,#$10
jmp  $012B
mov  a,#$20
jmp  $012B
mov  a,#$40
jmp  $012B
mov  a,#$80
anl  p2,#$E0
outl p1,a
jmp  $0187
anl  p1,#$0
anl  p2,#$F0
orl  p2,#$10
jmp  $0187
anl  p1,#$0
anl  p2,#$E8
orl  p2,#$8
jmp  $0187
anl  p1,#$0
anl  p2,#$E4
orl  p2,#$4
jmp  $0187
anl  p1,#$0
anl  p2,#$E2
orl  p2,#$2
jmp  $0187
anl  p1,#$0
anl  p2,#$E1
orl  p2,#$1
jmp  $0187
movp a,@a
call $071A
jnz  $0158
jmp  $0200
sel  rb0
sel  mb0
clr  a
mov  psw,a
call $0321
jtf  $0169
en   tcnti
strt t
mov  a,r5
jz   $0170
anl  p2,#$DF
jmp  $0172
orl  p2,#$20
mov  r3,#$0
mov  a,r3
anl  a,#$7
movp3 a,@a
mov  r2,a
mov  a,r3
anl  a,#$78
rl   a
swap a
mov  r1,a
rl   a
add  a,#$60
mov  r0,a
clr  f0
cpl  f0
mov  a,r1
jmpp @a
jnt0 $018C
movx a,@r0
jmp  $018D
ins  a,bus
anl  a,r2
jz   $01A2
anl  a,@r0
inc  r0
jnz  $019A
mov  a,r2
anl  a,@r0
jz   $019A
dec  r0
clr  f0
mov  a,r2
orl  a,@r0
mov  @r0,a
jf0  $01B4
cpl  f0
jmp  $0207
mov  a,r2
anl  a,@r0
inc  r0
jz   $01AC
anl  a,@r0
jnz  $01AC
dec  r0
clr  f0
mov  a,r2
cpl  a
anl  a,@r0
mov  @r0,a
jf0  $01B4
jmp  $0207
inc  r3
clr  c
mov  a,r3
add  a,#$98
jnc  $0174
mov  a,r4
xrl  a,#$55
jnz  $01C4
mov  r4,#$AA
jmp  $015F
mov  a,r4
mov  r4,#$0
xrl  a,#$AA
jnz  $015F
mov  r2,#$FE
call $0544
jmp  $015F
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
movp a,@a
call $071A
jnz  $0200
jmp  $0308
mov  a,r4
xrl  a,#$55
jz   $0259
mov  a,r3
clr  c
add  a,#$98
jc   $0259
mov  r0,#$7
mov  a,r3
xrl  a,#$3D
jnz  $0222
mov  a,@r0
orl  a,#$80
jf0  $023C
anl  a,#$7F
jmp  $023C
mov  a,r3
xrl  a,#$3E
jnz  $0230
mov  a,@r0
orl  a,#$40
jf0  $023C
anl  a,#$BF
jmp  $023C
mov  a,r3
xrl  a,#$62
jnz  $023D
mov  a,@r0
orl  a,#$20
jf0  $023C
anl  a,#$DF
mov  @r0,a
mov  a,r3
add  a,#$7
call $066F
mov  r2,a
xrl  a,#$FF
jz   $0259
jf0  $025B
mov  a,r3
xrl  a,#$1E
jz   $0259
mov  a,r4
xrl  a,#$AA
jz   $0259
mov  a,r2
orl  a,#$80
mov  r2,a
call $0544
jmp  $01B4
call $0544
jmp  $01B4
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
.db   0x01
outl bus,a
jmp  $0008
inc  @r0
xch  a,@r0
orl  a,@r0
movx a,@r0
movp a,@a
call $071A
jnz  $0308
jmp  $0400
sel  rb1
jni  $0314
jmp  $0320
mov  r1,#$9
djnz r1,$0316
jni  $031C
jmp  $0320
clr  f1
mov  r3,#$0
dis  i
strt t
retr
jni  $0346
mov  r0,#$9
mov  a,r5
anl  a,#$F7
mov  r5,a
clr  f1
jmp  $0337
orl  p2,#$40
jnc  $0348
anl  p2,#$BF
mov  r4,a
nop
anl  p2,#$7F
mov  a,r4
rlc  a
orl  p2,#$80
djnz r0,$032D
orl  p2,#$40
mov  a,r5
jb4  $034A
jb1  $0346
cpl  f1
en   i
jmp  $0437
jmp  $0333
mov  r5,#$C0
jmp  $0437
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
movp a,@a
call $071A
jnz  $0400
jmp  $0500
mov  a,r5
jb7  $0439
jb1  $0452
mov  r0,#$7
mov  a,@r0
anl  a,#$E0
xrl  a,#$E0
jz   $04AF
jf1  $0486
dis  i
mov  a,r5
jb3  $0431
jb0  $0426
mov  r0,#$6
mov  a,@r0
jnz  $0437
call $0507
jz   $0437
mov  a,r5
anl  a,#$FE
orl  a,#$8
mov  r5,a
mov  r0,#$20
mov  a,@r0
rl   a
mov  r4,a
mov  r7,#$48
mov  r6,#$1
jmp  $0322
mov  a,r2
retr
dis  i
djnz r7,$0437
mov  r7,#$FA
djnz r6,$0437
mov  r0,#$24
mov  a,@r0
mov  r6,a
mov  a,r5
xrl  a,#$40
mov  r5,a
jb6  $044E
orl  p2,#$20
jmp  $0437
anl  p2,#$DF
jmp  $0437
dis  i
mov  a,r5
jb2  $0472
anl  p2,#$7F
djnz r7,$0437
mov  r7,#$AA
djnz r6,$0437
mov  r6,#$2
mov  r0,#$7
mov  a,@r0
anl  a,#$E0
xrl  a,#$E0
jz   $047D
stop tcnt
mov  r0,#$7C
mov  @r0,#$0
call $0321
jmp  $0000
mov  r4,#$FB
jni  $0437
mov  r5,#$2
mov  a,#$22
mov  t,a
jmp  $0324
orl  p2,#$80
mov  a,#$CC
mov  t,a
mov  r5,#$6
jmp  $0437
djnz r7,$0437
mov  r7,#$48
djnz r6,$0437
mov  r6,#$1
dis  i
jf1  $0493
jmp  $0437
jni  $04AC
anl  p2,#$BF
orl  a,#$0
anl  p2,#$7F
orl  a,#$0
orl  p2,#$80
orl  a,#$0
orl  p2,#$40
mov  a,r3
jnz  $04AC
mov  r4,#$F3
mov  a,r5
orl  a,#$9
mov  r5,a
en   i
jmp  $0437
dis  i
mov  r5,#$2
mov  r7,#$AA
mov  r6,#$2
anl  p2,#$7F
jmp  $0437
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
movp a,@a
call $071A
jnz  $0500
jmp  $0600
mov  r0,#$21
mov  a,@r0
jz   $0539
dec  a
mov  @r0,a
clr  c
add  a,#$CE
jc   $0539
mov  r0,#$22
mov  a,@r0
clr  c
add  a,#$CE
jc   $0539
mov  a,@r0
add  a,#$28
mov  r0,a
mov  a,#$FF
xch  a,@r0
mov  r0,a
xrl  a,#$FF
jz   $0539
mov  a,r0
mov  r0,#$20
mov  @r0,a
mov  r0,#$22
inc  @r0
mov  a,@r0
clr  c
add  a,#$CE
jnc  $0536
mov  @r0,#$0
mov  a,#$55
ret
clr  a
mov  r0,#$21
mov  @r0,a
mov  r0,#$23
mov  @r0,a
mov  r0,#$22
mov  @r0,a
ret
mov  r0,#$6
mov  @r0,#$FF
mov  r0,#$21
mov  a,@r0
clr  c
add  a,#$CE
jnc  $0558
mov  a,@r0
clr  c
add  a,#$CD
jc   $0592
jmp  $058A
mov  a,@r0
clr  c
add  a,#$CF
jnc  $0560
mov  r2,#$FA
inc  @r0
mov  r0,#$23
mov  a,@r0
clr  c
add  a,#$CE
jc   $0592
mov  a,@r0
add  a,#$28
mov  r1,a
mov  a,r2
xrl  a,#$62
jnz  $057A
mov  a,r5
xrl  a,#$FF
mov  r5,a
jnz  $057A
mov  r2,#$E2
mov  a,r2
mov  @r1,a
inc  @r0
mov  a,@r0
clr  c
add  a,#$CE
jnc  $0585
mov  @r0,#$0
mov  r0,#$6
mov  @r0,#$0
ret
mov  r0,#$23
mov  r1,#$22
mov  a,@r0
xrl  a,@r1
jz   $0585
mov  r0,#$23
mov  @r0,#$0
mov  r0,#$22
mov  @r0,#$0
mov  r0,#$21
mov  @r0,#$0
jmp  $0585
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
movp a,@a
call $071A
jnz  $0600
jmp  $0702
strt t
anl  a,r1
in   a,p2
.db   0x06
jt0  $0625
inc  r1
dis  i
jb2  $0641
mov  a,r7
en   i
dis  tcnti
jmp  $0144
call $0051
mov  a,r7
mov  a,r7
outl bus,a
jb1  $0621
mov  a,r7
inc  @r1
strt cnt
mov  a,r7
xchd a,@r0
.db   0x01
xchd a,@r1
xch  a,@r0
mov  t,a
inc  @r0
call $02FF
orl  a,@r0
add  a,#$33
.db   0x22
stop tcnt
jb0  $065D
anl  a,r4
movd p7,a
orl  a,r2
orl  a,#$1F
anl  a,r6
xch  a,r7
anl  a,r2
anl  a,r3
movd p6,a
movd p5,a
inc  r6
inc  r5
xch  a,r6
xch  a,r5
anl  a,@r0
mov  a,r7
jmp  $0300
add  a,@r0
.db   0x63
.db   0x66
mov  a,t
anl  a,r7
jnt1 $064C
orl  a,r6
movd p4,a
movd a,p7
orl  a,r7
orl  a,r5
da   a
mov  a,r7
outl p2,a
dec  a
cpl  a
jnt0 $0629
jtf  $0658
.db   0x0b
inc  r2
in   a,p1
outl p1,a
xch  a,r0
xch  a,r2
inc  r0
jt1  $060C
inc  r3
ins  a,bus
.db   0x38
clr  a
xch  a,r3
inc  a
anl  a,#$D
rrc  a
jmp  $0034
mov  a,#$61
addc a,#$A3
ret
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
jc   $0785
mov  r0,#$2
mov  a,r0
movp a,@a
call $071A
jnz  $0705
mov  a,#$0
movp a,@a
xrl  a,r7
jnz  $0716
mov  a,#$1
movp a,@a
xrl  a,r6
jz   $0718
clr  f1
cpl  f1
jmp  $0055
sel  rb0
clr  c
add  a,r6
mov  r6,a
clr  a
addc a,r7
mov  r7,a
inc  r0
mov  a,r0
ret
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
jmp  $0000

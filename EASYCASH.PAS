{=============================================================================

                    EEEEEE  AAAAAA  SSSSSS  YY   YY
                   EE      AA  AA  SS      YY   YY
                  EEEE    AAAAAA  SSSSSS     YY
                 EE      AA  AA      SS     YY
                EEEEEE  AA  AA  SSSSSS     YY

                      CCCCCC  AAAAAA  SSSSSS  HH  HH
                     CC      AA  AA  SS      HH  HH
                    CC      AAAAAA  SSSSSS  HHHHHH
                   CC      AA  AA      SS  HH  HH
                  CCCCCC  AA  AA  SSSSSS  HH  HH


                             Version 1.15


                    Copyright 1995-1996 Marty Anstey
                           All Rights Reserved

==============================================================================


 Security:
 ƒƒƒƒƒƒƒƒƒ

 - The card must must contain a valid CRC, a valid card status (anything less
   than 4 will be considered a demo card and will fail on all transactions)
 - The valid card number must also match a user's name on a database.
 - If either of these functions fail then the card is deemed "Invalid"




 The Card Number:
 ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

 - The card number is composed of 8 digits. This number is composed of three
   groups that can be broken down like this:

   X-XXXX-XXX

 - The first digit is the "card status" - all that this means is that
   there is an unused number which will somehow be implemented for security
   reasons. Any number between 4 and 9 will be accepted.
 - The next four digits are the actual card number. This can be anywhere
   between 0000 and 9999, although this system will only use the numbers
   in the range of 1000 to 9999 to increase complexity. The numbers are
   chosen randomly, and cross-referenced with the database to ensure an
   original number.
 - The final three digits is the card CRC. This is the algorithm to
   calculate the CRC: ([1]*10+[2])+([2]*10+[3])+([3]*10+[4]) where
   [1] is the first digit in the actual number, [2] is the second, and
   so on.

 ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒ card status (4=Preferred, 5=Classic, 6=Premier)
 ≥
 X XXXX  XXX

   ^^^^  ^^^
    ≥     ≥
    ≥     checksum ([1]*10+[2])+([2]*10+[3])+([3]*10+[4])
    ≥
    ≥
    ≥
    ≥
    card number


 Features to Add:
 ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

 [ ] Option to invalidate >previous< transaction

 [ ] Feature "Abort purchase?" after user presses "N" in response
     to "Purchase OK?" will ask for card number AGAIN

 [ ] Networking (novell-compatible: see NOVELL section, interrupt lists)
 
 [ ] Encrypt databases

=============================================================================}

uses dos, crt, printer;
label mainloop, smalljump1, smalljump2, chance;

const
twirl:array[1..8] of char=('ƒ','\','≥','/','ƒ','\','≥','/');
const
TITLESCREEN_WIDTH=80;
TITLESCREEN_DEPTH=25;
TITLESCREEN_LENGTH=755;
TITLESCREEN : array [1..755] of Char = (
#15,#16,#24,#24,#24,#25, #6, #7,'€','ﬂ','€','ﬂ','€','ﬂ','€',' ','€',
'ﬂ','€','ﬂ','€','ﬂ','€',' ','‹','ﬂ','€','ﬂ','€','ﬂ','‹',' ','€','ﬂ',
'€',' ','€','ﬂ','€',' ',' ','€','ﬂ','€','ﬂ','€','ﬂ','€',' ','€','ﬂ',
'€','ﬂ','€','ﬂ','€',' ','‹','ﬂ','€','ﬂ','€','ﬂ','‹',' ','€','ﬂ','€',
' ',' ','€','ﬂ','€',#24,#25, #6, #8,#23,'∞', #0,#17,'≤', #8,#23,'∞',
#16,' ', #7,'ﬂ','ﬂ','ﬂ',' ', #8,#23,'∞', #0,#17,'≤', #8,#23,'∞',#16,
' ',#23,'∞', #0,#17,'≤', #8,#23,'∞',#16,' ',#23,'∞', #0,#17,'≤', #8,
#23,'∞',#16,' ', #7,'ﬂ','ﬂ','ﬂ',' ', #8,#23,'∞', #0,#17,'≤', #8,#23,
'∞',#16,' ',#23,'∞', #0,#17,'≤', #8,#23,'∞',#16,' ',' ',#23,'∞', #0,
#17,'≤', #8,#23,'∞',#16,' ', #7,'ﬂ','ﬂ','ﬂ',' ', #8,#23,'∞', #0,#17,
'≤', #8,#23,'∞',#16,' ',#23,'∞', #0,#17,'≤', #8,#23,'∞',#16,' ',#23,
'∞', #0,#17,'≤', #8,#23,'∞',#16,' ', #7,'ﬂ','ﬂ','ﬂ',' ', #8,#23,'∞',
#0,#17,'≤', #8,#23,'∞',#16,' ',' ',#23,'∞', #0,#17,'≤', #8,#23,'∞',
#24,#16,#25, #6,#23,'±', #0,#17,'±', #8,#23,'±', #7,#16,'ﬂ',#25, #3,
#8,#23,'±', #0,#17,'±', #8,#23,'±', #7,#16,'ﬂ', #8,#23,'±', #0,#17,
'±', #8,#23,'±',#16,' ',#23,'±',#16,'‹',#23,'±', #0,#17,'±', #8,#23,
'±', #7,#16,'ﬂ', #8,#23,'±',#16,' ',#23,'±', #7,#16,'‹', #8,#23,'±',
#7,#16,'‹', #8,#23,'±', #7,#16,'‹', #8,#23,'±',#16,' ',' ',#23,'±',
#0,#17,'±', #8,#23,'±',#16,#25, #4,#23,'±', #0,#17,'±', #8,#23,'±',
#7,#16,'ﬂ', #8,#23,'±', #0,#17,'±', #8,#23,'±',#16,' ',#23,'±',#16,
'‹',#23,'±', #0,#17,'±', #8,#23,'±', #7,#16,'ﬂ', #8,#23,'±',#16,' ',
#23,'±', #0,#17,'±', #8,#23,'±', #7,#16,'ﬂ','ﬂ', #8,#23,'±', #0,#17,
'±', #8,#23,'±',#24,#16,#25, #6,#23,'≤', #0,#17,'∞', #8,#23,'≤',#16,
' ','‹','‹','‹',' ',#23,'≤', #0,#17,'∞', #8,#23,'≤',#16,' ',#23,'≤',
#0,#17,'∞', #8,#23,'≤',#16,' ','‹','‹','‹',' ',#23,'≤', #0,#17,'∞',
#8,#23,'≤',#16,#25, #2,#23,'≤', #0,#17,'∞', #8,#23,'≤',#16,#25, #3,
#23,'≤', #0,#17,'∞', #8,#23,'≤',#16,' ','‹','‹','‹',' ',#23,'≤', #0,
#17,'∞', #8,#23,'≤',#16,' ',#23,'≤', #0,#17,'∞', #8,#23,'≤',#16,' ',
'‹','‹','‹',' ',#23,'≤', #0,#17,'∞', #8,#23,'≤',#16,' ',#23,'≤', #0,
#17,'∞', #8,#23,'≤',#16,' ',' ',#23,'≤', #0,#17,'∞', #8,#23,'≤',#24,
#16,#25, #6,'€',#17,'‹',#16,'€','‹','€',#17,'‹',#16,'€',' ','€',#17,
'‹',#16,'€',' ','€',#17,'‹',#16,'€',' ','ﬂ',#17,'‹',#16,'€','‹','€',
#17,'‹',#16,'ﬂ',#25, #2,'€',#17,'‹',#16,'€',#25, #3,'€',#17,'‹',#16,
'€','‹','€',#17,'‹',#16,'€',' ','€',#17,'‹',#16,'€',' ','€',#17,'‹',
#16,'€',' ','ﬂ',#17,'‹',#16,'€','‹','€',#17,'‹',#16,'ﬂ',' ','€',#17,
'‹',#16,'€',' ',' ','€',#17,'‹',#16,'€',#24,#24,#25,'!',#15,'D','e',
'b','i','t',' ','S','y','s','t','e','m',#24,#24,#25,#20,'B','y',' ',
'M','a','r','t','y',' ','A','n','s','t','e','y',' ','a','n','d',' ',
'A','l','a','s','t','a','i','r',' ','B','r','o','c','k','w','e','l',
'l',#24,#24,#24,#25,#30,'(','C',')',' ','C','o','p','y','r','i','g',
'h','t',' ','1','9','9','5',#24,#25,#28,' ','M','a','r','t','y',' ',
'A','n','s','t','e','y',' ',' ',' ',' ',' ',' ',' ',' ',#24,#25,#29,
'A','l','l',' ','R','i','g','h','t','s',' ','R','e','s','e','r','v',
'e','d',#24,#24,#24,#24,#25,'!','P','r','e','s','s',' ','A',' ','K',
'e','y',#24,#24,#24,#24,#24);

type ScreenType = array [0..3999] of Byte;
var ScreenAddr : ScreenType absolute $B800:$0000;

var
f:file;
f1:text;
i,z,t,b,y,c,maxact,maxitems,maxnames:integer;
n,b1,b2:longint;
s,s1,s2:string;
ch,cn:char;
item:array[1..100] of string[20];
cost:array[1..100,1..4] of char;
num:array[1..2] of char;
name:array[1..255,1..30] of char;
pass:array[1..255,1..8] of char;
xact:array[1..255,1..20] of char;
realcost,sub:real;
match, ok, print, j, flip, invalid:boolean;
pos:integer;                     {made this global for a sneaky trick >:) }
screen:array[1..9999] of byte;



procedure UNCRUNCH (var Addr1,Addr2; BlkLen:Integer);
begin
    inline (
    $1E/               {       PUSH    DS             ;Save data segment.}
    $C5/$B6/ADDR1/     {       LDS     SI,[BP+Addr1]  ;Source Address}
    $C4/$BE/ADDR2/     {       LES     DI,[BP+Addr2]  ;Destination Addr}
    $8B/$8E/BLKLEN/    {       MOV     CX,[BP+BlkLen] ;Length of block}
    $E3/$5B/           {       JCXZ    Done}
    $8B/$D7/           {       MOV     DX,DI          ;Save X coordinate for later.}
    $33/$C0/           {       XOR     AX,AX          ;Set Current attributes.}
    $FC/               {       CLD}
    $AC/               {LOOPA: LODSB                  ;Get next character.}
    $3C/$20/           {       CMP     AL,32          ;If a control character, jump.}
    $72/$05/           {       JC      ForeGround}
    $AB/               {       STOSW                  ;Save letter on screen.}
    $E2/$F8/           {Next:  LOOP    LOOPA}
    $EB/$4C/           {       JMP     Short Done}
    {ForeGround:}
    $3C/$10/           {       CMP     AL,16          ;If less than 16, then change the}
    $73/$07/           {       JNC     BackGround     ;foreground color.  Otherwise jump.}
    $80/$E4/$F0/       {       AND     AH,0F0H        ;Strip off old foreground.}
    $0A/$E0/           {       OR      AH,AL}
    $EB/$F1/           {       JMP     Next}
    {BackGround:}
    $3C/$18/           {       CMP     AL,24          ;If less than 24, then change the}
    $74/$13/           {       JZ      NextLine       ;background color.  If exactly 24,}
    $73/$19/           {       JNC     FlashBitToggle ;then jump down to next line.}
    $2C/$10/           {       SUB     AL,16          ;Otherwise jump to multiple output}
    $02/$C0/           {       ADD     AL,AL          ;routines.}
    $02/$C0/           {       ADD     AL,AL}
    $02/$C0/           {       ADD     AL,AL}
    $02/$C0/           {       ADD     AL,AL}
    $80/$E4/$8F/       {       AND     AH,8FH         ;Strip off old background.}
    $0A/$E0/           {       OR      AH,AL}
    $EB/$DA/           {       JMP     Next}
    {NextLine:}
    $81/$C2/$A0/$00/   {       ADD     DX,160         ;If equal to 24,}
    $8B/$FA/           {       MOV     DI,DX          ;then jump down to}
    $EB/$D2/           {       JMP     Next           ;the next line.}
    {FlashBitToggle:}
    $3C/$1B/           {       CMP     AL,27          ;Does user want to toggle the blink}
    $72/$07/           {       JC      MultiOutput    ;attribute?}
    $75/$CC/           {       JNZ     Next}
    $80/$F4/$80/       {       XOR     AH,128         ;Done.}
    $EB/$C7/           {       JMP     Next}
    {MultiOutput:}
    $3C/$19/           {       CMP     AL,25          ;Set Z flag if multi-space output.}
    $8B/$D9/           {       MOV     BX,CX          ;Save main counter.}
    $AC/               {       LODSB                  ;Get count of number of times}
    $8A/$C8/           {       MOV     CL,AL          ;to display character.}
    $B0/$20/           {       MOV     AL,32}
    $74/$02/           {       JZ      StartOutput    ;Jump here if displaying spaces.}
    $AC/               {       LODSB                  ;Otherwise get character to use.}
    $4B/               {       DEC     BX             ;Adjust main counter.}
    {StartOutput:}
    $32/$ED/           {       XOR     CH,CH}
    $41/               {       INC     CX}
    $F3/$AB/           {       REP STOSW}
    $8B/$CB/           {       MOV     CX,BX}
    $49/               {       DEC     CX             ;Adjust main counter.}
    $E0/$AA/           {       LOOPNZ  LOOPA          ;Loop if anything else to do...}
    $1F);              {Done:  POP     DS             ;Restore data segment.}
end; {UNCRUNCH}

procedure center(row:integer;data:string);
begin
    gotoxy(40-length(data) div 2,row);
    write(data);
end;

procedure wstr(cnt:integer;ch:char);
begin
    while cnt>0 do
    begin
        write(ch);
        dec(cnt);                               { takeoff from ASM programming :) }
    end;
end;

function IntToStr(i: Longint): string;
var
s: string[11];
begin
    Str(i, s);
    IntToStr := s;
end;

function CRC(num:integer;level:byte):integer;
var
n1,n2,n3,n4,n5,n6,n7,n8,t1,b:integer;
s:string;
begin
    s:=inttostr(num);
    {s:=inttostr(level)+s;}
    
    val(s[1],n1,t1);
    val(s[2],n2,t1);
    val(s[3],n3,t1);
    val(s[4],n4,t1);
    
    n5:=n1*10+n2;
    n6:=n2*10+n3;
    n7:=n3*10+n4;
    n8:=n5+n6+n7;
    
    crc:=n8;
end;

procedure init;
begin
    wstr(80,'ƒ');
    gotoxy(1,1);
    write('⁄');
    gotoxy(80,1);
    write('ø');
    gotoxy(1,2);
    wstr(80,'ƒ');
    gotoxy(1,2);
    write('¿');
    gotoxy(80,2);
    write('Ÿ');
    gotoxy(1,20);
    wstr(80,'ƒ');
    textbackground(9);
    textcolor(15);
    center(1,'EasyCash');
    textbackground(0);
end;

procedure setup;
begin
    gotoxy(1,21);
    write('Selection  : ');
    gotoxy(1,22);
    write('Quantity   : ');
    gotoxy(1,23);
    write('Card number: ');
end;

procedure redraw;
begin
    gotoxy(80-38,22);
    write('Item :  ');
    gotoxy(80-38,23);
    write('Card :  ');
    gotoxy(80-38,21);
    write('Total: $');
    textbackground(9);
    write('0       ');
    gotoxy(80-30,22);
    wstr(31,' ');
    gotoxy(80-30,23);
    wstr(31,' ');
    textbackground(0);
    gotoxy(14,21);          { erase "Selection"        }
    wstr(28,' ');
    gotoxy(14,22);          { erase "Quantity"         }
    wstr(28,' ');
    gotoxy(14,23);          { erase "Card number"      }
    wstr(28,' ');
    gotoxy(80-30,24);       { erase "Purchase OK? Y/N" }
    wstr(30,' ');
end;

procedure quitme(x,y:integer);
var
cr:char;
begin
    gotoxy(80-30,24);
    write('                            ');
    gotoxy(80-30,24);
    write('Quit? [Y/N] ');
    repeat
        cr:=readkey;
        cr:=upcase(cr);
    until (cr='Y') or (cr='N');
    
    if cr='Y' then
    begin
        clrscr;
        writeln('SykkoSoft EASYCASH version 1.12');
        writeln('(C) Copyright 1995-1996 Marty Anstey');
        writeln('All Rights Reserved');
        writeln;
        halt;
    end;
    
    gotoxy(80-30,24);
    write('                            ');
    gotoxy(x,y);
end;

procedure restart(x,y:integer);
{$F+}
var
cr:char;
begin
    gotoxy(80-30,24);
    write('                            ');
    gotoxy(80-30,24);
    write('Abort purchase? [Y/N] ');
    repeat
        cr:=readkey;
        cr:=upcase(cr);
    until (cr='Y') or (cr='N');
    if cr='Y' then
    begin
        sub:=0.00;
        realcost:=sub;
        y:=1;
        maxact:=y;
        for i:=1 to 255 do
        for y:=1 to 20 do
        xact[i][y]:=#0;
        flip:=true;
    end;
    gotoxy(80-30,24);
    write('                            ');
    if cr='N' then gotoxy(x,y);
end;


function ReadStr(x,y,len:integer): string;
label xit;
var
ch,ti:char;
{pos:integer;}
tmp:array[1..40] of char;
begin
    for pos:=1 to 255 do readstr[pos]:=#0;
    for pos:=1 to 40 do tmp[pos]:=#0;
    pos:=0;
    repeat
        ch:=readkey;
        if ch=#27 then quitme(wherex,wherey);
        if ch=#59 then
        begin
            restart(wherex,wherey);
            goto xit;
        end;

        if flip=false then
        begin
            
            if (ch=#8) and (pos>0) then
            begin
                dec(pos);
                gotoxy(x+pos,y);
                write(' ');
                gotoxy(x+pos,y);
                tmp[pos+1]:=#0;
            end
            else if (ch>#31) and (pos<len) then
            begin
                gotoxy(x+pos,y);
                write(ch);
                tmp[pos+1]:=ch;
                inc(pos);
            end;
        end;
    until ch=#13;
    ReadStr:=tmp;
    xit:
end;


begin
    clrscr;
    UnCrunch(TITLESCREEN,ScreenAddr[(1*2)+(1*160)-162],TITLESCREEN_LENGTH);
    ch:=readkey;
    print:=false;
    for i:=1 to 255 do
    for z:=1 to 30 do
    name[i][z]:=#0;
    textcolor(15);
    textbackground(0);
    clrscr;
    init;
    i:=0;
    z:=1;
    
    if paramcount>0 then
    begin
        s:=paramstr(1);
        if (s[1]='/') or (s[1]='-') then
        if upcase(s[2])='P' then print:=true;
    end;
    
    
    assign(f,'EASYCASH.DAT');
    reset(f,1);
    
    blockread(f,num,2);
    
    s:=num;
    
    val(copy(s,1,2),n,t);
    
    for i:=1 to n do
    begin
        gotoxy(1,1);
        write(twirl[z]);
        inc(z);
        if z>8 then z:=1;
        delay(100);
        blockread(f,item[i],20);
        blockread(f,cost[i],4);
    end;
    close(f);
    maxitems:=i;
    
    assign(f,'EASYCASH.NAM');
    reset(f,1);
    blockread(f,num,2);
    
    for i:=1 to ord(num[2])-48 do
    begin
        gotoxy(1,1);
        write(twirl[z]);
        inc(z);
        if z>8 then z:=1;
        delay(100);
        
        blockread(f,name[i],30);
        blockread(f,pass[i],8);
    end;
    close(f);
    maxnames:=i;
    gotoxy(1,1);
    write('⁄');
    
    if maxitems>18 then
    begin
        for i:=3 to 19 do
        begin
            gotoxy(40,i);
            write('≥');
        end;
        gotoxy(40,2);
        write('¬');
        gotoxy(40,20);
        write('¡');
    end;
    
    redraw;
    gotoxy(1,3);
    if maxitems>34 then maxitems:=34;                { to prevent screwing up }
    
    for i:=1 to maxitems do
    begin
        if i=18 then
        gotoxy(41,wherey-17);
        if i>18 then
        gotoxy(41,wherey);
        if (i<100) and (i<10) then
        write('  ');
        if (i<100) and (i>=10) then
        write(' ');
        write(i,' ');
        for z:=0 to 19 do write(item[i][z]);
        write('$');
        {for z:=0 to 1 do write(cost[i][z]);
        write('.');
        for z:=2 to 3 do write(cost[i][z]);}
        s:=cost[i];
        val(copy(s,1,4),realcost,z);
        realcost:=realcost / 100;
        write(realcost:4:2);
        writeln;
    end;
    
    sub:=0.00;
    y:=1;
    maxact:=y;
    for i:=1 to 255 do
    for y:=1 to 20 do
    xact[i][y]:=#0;
    invalid:=false;

    mainloop:
    if invalid=true then
    begin
        gotoxy(80-30,24);
        writeln('ØInvalid CardÆ');
    end;
    invalid:=false;
    flip:=false;
    setup;
    redraw;
    gotoxy(80-30,21);
    textbackground(9);
    writeln(sub:4:2);
    textbackground(0);
    
    repeat
        gotoxy(14,21);                                  { Selection }
        s:=readstr(14,21,2);
        if flip=true then goto mainloop;
        val(copy(s,1,pos),i,c);
    until (c=0) and (i>0) and (i<=maxitems);
    
    gotoxy(80-30,22);
    textbackground(9);
    for n:=0 to 19 do write(item[i][n]);
    for n:=0 to 19 do xact[y][n+1]:=item[i][n];     {xfer over to transaction lst}
    inc(y);
    maxact:=y;
    textbackground(0);
    
    repeat
        gotoxy(14,22);                                  { Quantity }
        s:=readstr(14,22,2);
        if flip=true then goto mainloop;
        val(copy(s,1,pos),n,c);
    until (c=0) and (n>=0) and (n<100);
    
    if n=0 then goto mainloop;                      { a cheap, easy way to }
                                                    { abort a purchase     }
    s:=cost[i];
    val(copy(s,1,4),realcost,z);
    realcost:=realcost / 100;
    realcost:=realcost*n;
    sub:=sub+realcost;
    gotoxy(80-30,21);
    textbackground(9);
    writeln(sub:4:2);
    textbackground(0);
    gotoxy(80-30,24);
    write('Make another purchase? [Y/N]');
    repeat
        ch:=readkey;
        ch:=upcase(ch);
    until (ch='Y') or (ch='N');
    gotoxy(80-30,24);
    write('                            ');
    if ch='Y' then goto mainloop;
    if (ch='N') then
    begin
        chance:
        repeat
            gotoxy(14,23);                                  { Card Number }
            write('∞∞∞∞∞∞∞∞');
            gotoxy(14,23);
            s1:=readstr(14,23,8);
            if flip=true then goto mainloop;
            val(copy(s1,1,8),n,c);                          { check if integer }
        until (c=0);
        val(copy(s1,2,4),n,t);
        val(s1[1],z,t);
        b:=crc(n,z);
        val(copy(s1,6,3),n,t);
        if (b=n) and (b>0) then
            ok:=true;
        else
            ok:=false;
        textbackground(9);
        match:=false;
        for z:=1 to maxnames do
        begin
            if pass[z]=copy(s1,1,8) then
            begin
                match:=true;
                gotoxy(80-30,23);
                for n:=1 to 30 do
                write(name[z][n]);
            end;
        end;

        if (match=false) or (ok=false) then
        begin
            gotoxy(80-30,23);
            Writeln('Invalid Card');
            textcolor(15);
            move(mem[$b800:0],screen,9999);
            textbackground(4);
            center(10,'…ÕÕÕÕWARNINGÕÕÕÕÕª');
            center(11,'∫ Invalid Card!! ∫');
            center(12,'»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº');
            ch:=readkey;
            move(screen,mem[$b800:0],9999);
            textcolor(15);
            {invalid:=true;}
            textbackground(0);
            goto chance;
        end;
        textbackground(0);

        if (match=true) and (ok=true) then    { the AND is **VERY** important!!}
        begin
            gotoxy(80-30,24);
            write('                            ');
            gotoxy(80-30,wherey);
            write('Purchase OK? [Y/N]');
            repeat
                ch:=readkey;
                ch:=upcase(ch);
            until (ch='Y') or (ch='N');
            
            if ch='N' then
            begin
                gotoxy(80-30,24);
                write('                            ');
                gotoxy(80-30,wherey);
                write('Abort Purchase [Y/N]');
                repeat
                    ch:=readkey;
                    ch:=upcase(ch);
                until (ch='Y') or (ch='N');
                if ch='N' then goto mainloop;
                sub:=0.00;
                realcost:=sub;
                y:=1;
                maxact:=y;
                for i:=1 to 255 do
                for y:=1 to 20 do
                xact[i][y]:=#0;
                goto mainloop;
            end
            else
            if ch='Y' then
            begin
                assign(f1,'EASYCASH.LOG');
                {$I-}
                reset(f1);
                if ioresult<>0 then             { if file does not exist... }
                begin
                    rewrite(f1);                { create it... }
                end;
                close(f1);                      { close up file }
                append(f1);                     { append to end of file }
                writeln(f1,'PURCHASE');
                writeln(f1,name[z]);
                writeln(f1,pass[z]);
                writeln(f1,'');
                for i:=20 to y do
                begin
                    writeln(f1,xact[i]);
                end;
                writeln(f1,'');
                close(f1);
                
                if print=true then
                begin
                    write(lst,#24+#27+'E');
                    write(lst,#27+'w'+#1+'PURCHASE'+#27+'w'+#0+#13+#10);
                    for i:=1 to 30 do
                    write(lst,name[z][i]);
                    writeln(lst,#13);
                    for i:=1 to 8 do
                    write(lst,pass[z][i]);
                    writeln(lst,#13);
                    for i:=1 to maxact do
                    begin
                        for y:=1 to 20 do
                        write(lst,xact[i][y]);
                        writeln(lst,#13);
                    end;
                    writeln(lst,#27+'F');           { release emphasized }
                end; {print=true}
            end; {ch='Y' }
        end; {match,ok}
    end; {ch=N}
    sub:=0.00;
    realcost:=sub;
    y:=1;
    maxact:=y;
    for i:=1 to 255 do
    for y:=1 to 20 do
    xact[i][y]:=#0;
    {--------------------}
    if s1<>'' then goto mainloop;
    clrscr;
end.

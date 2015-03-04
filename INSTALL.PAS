{$M 8192,0,0}
uses dos, crt;
label testdrive, loopfun;

var
i,x,max:integer;
screen:array[1..9999] of byte;
ch,drv,src,dst:char;
orig,command:string;
source:array[1..50] of string[15];
destin:array[1..50] of string[15];

function Exist(FileName: string): Boolean;
var
f: file;
begin
    {$I-}
    Assign(f, FileName);
    Reset(f);
    Close(f);
    {$I+}
    Exist := (IOResult = 0) and
    (FileName <> '');
end;

procedure center(row:integer;data:string);
begin
    gotoxy(41-length(data) div 2,row);
    write(data);
end;

procedure wstr(cnt:integer;ch:char);
begin
    while cnt>0 do
    begin
        write(ch);
        dec(cnt);
    end;
end;

procedure init;
begin
    wstr(80,'Ä');
    gotoxy(1,1);
    write('Ú');
    gotoxy(80,1);
    write('¿');
    gotoxy(1,2);
    wstr(80,'Ä');
    gotoxy(1,2);
    write('À');
    gotoxy(80,2);
    write('Ù');
    gotoxy(1,20);
    wstr(80,'Ä');
    textbackground(9);
    textcolor(15);
    center(1,'EasyCash Installation');
    textbackground(0);
end;

procedure filecopy(from:string;dest:string);
var
FromF, ToF: file;
NumRead, NumWritten: Word;
buf: array[1..4096] of Char;
begin
    Assign(FromF, from);
    {$i-}
    Reset(FromF, 1);
    if ioresult<>0 then
    begin
        move(mem[$b800:0],screen,9999);
        textcolor(15);
        textbackground(4);
        center(10,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
        center(11,'³ Please insert install diskette in drive and press Enter ³');
        center(12,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
        textcolor(7);
        textbackground(0);
        ch:=readkey;
        if ch=#27 then
        begin
            clrscr;
            writeln('Install failed: Cannot find source file(s).');
            chdir(orig);
            halt;
        end;
        move(screen,mem[$b800:0],9999);
    end;
    
    Assign(ToF, dest);
    Rewrite(ToF, 1);
    repeat
        BlockRead(FromF,buf,SizeOf(buf),NumRead);
        BlockWrite(ToF,buf,NumRead,NumWritten);
    until (NumRead = 0) or
    (NumWritten <> NumRead);
    Close(FromF);
    Close(ToF);
end;




begin
    clrscr;
    init;
    gotoxy(1,6);  wstr(80,'°');
    gotoxy(1,5);  write('Ú'); wstr(78,'Ä'); write('¿');
    gotoxy(1,7);  write('Ã'); wstr(78,'Ä'); write('´');
    gotoxy(1,6);  write('³');
    gotoxy(80,6); write('³');
    center(7,'Â');
    gotoxy(1,8);
    write('0%');
    center(8,'50%');
    gotoxy(80-4,8);
    write('100%');
    center(21,'EASYCASH Install Ver 2.11 (C) Copyright 1996 Marty Anstey, All Rights Reserved');
    
    move(mem[$b800:0],screen,9999);

    textbackground(7);
    textcolor(0);
    center(9,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
    center(10,'³ Please enter the drive you wish to install to ³');
    center(11,'³                                               ³');
    center(12,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    textbackground(0);
    textcolor(7);
    center(11,'   ');
    drv:='C';
    ch:=#0;
    repeat
        center(11,drv);
        ch:=readkey;
        ch:=upcase(ch);
        if (ord(ch)>66) and (ord(ch)<91) then drv:=ch;
    until (ch=#13);
    dst:=drv;
    
    textbackground(7);
    textcolor(0);
    center(9,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
    center(10,'³ Please enter the drive from which you wish to install from ³');
    center(11,'³                                                            ³');
    center(12,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    textbackground(0);
    textcolor(7);
    
    center(11,'   ');
    drv:='A';
    ch:=#0;
    repeat
        center(11,drv);
        ch:=readkey;
        ch:=upcase(ch);
        if (ch='A') or (ch='B') then drv:=ch;
    until (ch=#13);
    src:=drv;
    
    move(screen,mem[$b800:0],9999);
    
    getdir(0,orig);
    {$I-}
    testdrive:
    chdir(src+':');                               { -> to prevent problems with }
    if ioresult<>0 then                           { mapped network drives,      }
    begin                                         { don't specify a src+':\'    }
        move(mem[$b800:0],screen,9999);
        textcolor(15);
        textbackground(4);
        center(10,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
        center(11,'³ Drive not ready! ³');
        center(12,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
        textcolor(7);
        textbackground(0);
        ch:=readkey;
        if ch=#27 then
        begin
            clrscr;
            writeln('Install failed: Drive not ready.');
            chdir(orig);
            halt;
        end;
        move(screen,mem[$b800:0],9999);
        goto testdrive;
    end;
    {$I+}

	{ -- }    
    
    {$I-}
    chdir(dst+':');
    if ioresult<>0 then
    begin
        clrscr;
        writeln('Install failed: Destination drive does not exist.');
        chdir(orig);
        halt;
    end;
    chdir(dst+':\EASYCASH');
    if ioresult<>0 then
    begin
        mkdir(dst+':\EASYCASH');
        chdir(dst+':\EASYCASH');
    end;
    {$I+}
    {*
    This is where the source & destination filenames are specified. The
    "max" variable indicates the maximum number of filenames specified.
    *}
    max:=5;
    source[1]:='README._';     destin[1]:='README.';
    source[2]:='EASYCASH.EX_'; destin[2]:='EASYCASH.EXE';
    source[3]:='CREDIT.DA_';   destin[3]:='CREDIT.DAT';
    source[4]:='CREDIT.NA_';   destin[4]:='CREDIT.NAM';
    source[5]:='README.CO_';   destin[5]:='HELP.COM';
    gotoxy(2,6);
    x:=0;
    repeat
        inc(x);
        {loopfun:
        if not exist(src+':\'+source[x]) then
        begin
            move(mem[$b800:0],screen,9999);
            textcolor(15);
            textbackground(4);
            center(10,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
            center(11,'³ Please insert install diskette in drive and press Enter ³');
            center(12,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
            textcolor(7);
            textbackground(0);
            ch:=readkey;
            if ch=#27 then
            begin
                clrscr;
                writeln('Install failed: Cannot find source file(s).');
                chdir(orig);
                halt;
            end;
            move(screen,mem[$b800:0],9999);
        end;
        goto loopfun;}
        wstr(round(79 div max),'Û');
        filecopy(src+':\'+source[x],dst+':\EASYCASH\'+destin[x]);
    until x=max;
    
    for i:=2 to 79 do
    begin
        gotoxy(i,6);
        write('Û');
    end;
    
    textcolor(0);
    textbackground(7);
    center(9,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
    center(10,'³ Install complete. ³');
    center(11,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    ch:=readkey;
    textcolor(7);
    textbackground(0);
    clrscr;
    
    Command:='HELP';
    Command := '/C ' + Command;
    SwapVectors;
    Exec(GetEnv('COMSPEC'), Command);
    SwapVectors;
    if DosError <> 0 then
    WriteLn('Could not execute COMMAND.COM');
    
end.

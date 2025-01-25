

 Program ColMus;
 uses Music,dos,crt,graph,globmap,markmap,infilmapgraph,printer;
 type mas=array[1..1000] of byte;
      pp=pointer;
 var f:file;
     s:string;
     k,k1,k2,k3,l:longint;
     i,x,y,hscr,wscr:integer;
     masmus:mas;
     p:pp;
  GraphDriver : integer;  { The Graphics device driver }
  GraphMode   : integer;  { The Graphics mode value }
  MaxX, MaxY  : word;     { The maximum resolution of the screen }
  ErrorCode   : integer;  { Reports any graphics errors }
  MaxColor    : word;     { The maximum color value available }
  OldExitProc : Pointer;  { Saves exit procedure address }

{$F+}
function DetectVGA256 : integer;
{ Detects VGA or MCGA video cards }
var
  DetectedDriver : integer;
  SuggestedMode  : integer;
begin
  DetectGraph(DetectedDriver, SuggestedMode);
  if (DetectedDriver = VGA) or (DetectedDriver = MCGA) then
    DetectVGA256 := 0        { Default video mode = 0 }
  else
    DetectVGA256 := grError; { Couldn't detect hardware }
end; { DetectVGA256 }
{$F-}

var
  AutoDetectPointer : pointer;

procedure Initialize;
{ Initialize graphics and report any errors that may occur }
var
  InGraphicsMode : boolean; { Flags initialization of graphics mode }
  PathToDriver   : string;  { Stores the DOS path to *.BGI & *.CHR }
begin
  { when using Crt and graphics, turn off Crt's memory-mapped writes }
  DirectVideo := true;
  PathToDriver := '';
  repeat

    AutoDetectPointer := @DetectVGA256;   { Point to detection routine }
    GraphDriver := InstallUserDriver('VGA256', AutoDetectPointer);
    GraphDriver := Detect;

    InitGraph(GraphDriver, GraphMode, PathToDriver);
    ErrorCode := GraphResult;             { preserve error return }
    if ErrorCode <> grOK then             { error? }
    begin
      Writeln('Graphics error: ', GraphErrorMsg(ErrorCode));
      if ErrorCode = grFileNotFound then  { Can't find driver file }
      begin
        Writeln('Enter full path to BGI driver or type <Ctrl-Break> to quit:');
        Readln(PathToDriver);
        Writeln;
      end
      else
        Halt(1);                          { Some other error: terminate }
    end;
  until ErrorCode = grOK;
  Randomize;                { init random number generator }
  MaxColor := GetMaxColor;  { Get the maximum allowable drawing color }
  MaxX := GetMaxX;          { Get screen resolution values }
  MaxY := GetMaxY;
end; { Initialize }
{-------------------------------------------}
Procedure infilmen(ext:namestr;var codret:integer);
Label 1,2;
begin
    codret:=0;
    SetLineStyle(0,0,1);
    Size := ImageSize(xmen,ymen-6*hs,xmen+30*ws,ymen+hmen*hs+hs);
    GetMem(Pu, Size); { Get memory from heap }
    GetImage(xmen,ymen-6*hs,xmen+30*ws,ymen+hmen*hs+hs,Pu^);
1:  SetFillStyle(1,1);
{    bar(xmen,ymen,xmen+30*ws,ymen-2*hs);
    SetColor(0);
    Rectangle(xmen,ymen,xmen+30*ws,ymen-2*hs);
    SetColor(11);
    OutTextXY (xmen,ymen-1*hs+3,'    ÇÎ°•‡®‚• ÇïéÑçéâ ‰†©´ ');}
    infilegp(xmen,ymen,hmen,wmen,path,ext,datastr,codret);
    if codret=1 then goto 2;
    if datastr.name='<UNUSED>    ' then goto 1;
    fulnami:=path+'\'+datastr.name;
    fulnamo:=fulnami;
2:  PutImage(xmen,ymen-6*hs,Pu^,NormalPut);
    FreeMem(Pu, Size);
end;
{-------------------------------------------}
Procedure fileinp;
Label 1;
Var i:integer;
Begin
    bubu(1,50);
    infilmen('*.mus',i);
    if i<>0 then goto 1;
    i:=1;
    assign(f,fulnami);
    reset(f,1);
    l:=FileSize(f);
    BlockRead(f,masmus,word(l));
    Close(f);
1:
    bubu(1,50);
end;
{-------------------------------------------}

 begin
   path:='';
   d:=0;
   Getdir(d,path);
   ext:='*.dat';
{  x:=Detect;
  DetectGraph (x,y);
  InitGraph (x,y,'');}
  Initialize;

  monitor:=x;
  xmen:=1;
  ymen:=1;
  hmen:=8;
  wmen:=3;
  hs:=14;ws:=8;
  wscr:=GetMaxX;
  hscr:=GetMaxY;
  SetFillStyle(1,1);
  SetLineStyle(0,0,1);
  SetColor(14);
  Bar(0,0,wscr-1,hscr-1);
  Rectangle(0,0,wscr,hscr);
 ch:=#0;
 while ch<>#27 do
 begin
 fileinp;
 p:=addr(masmus);
 SetMusic(p^);
 RunMusic(1,SizeMusic);
   SetFillStyle(1,0);
   Bar(1,1,wscr-1,hscr-1);
 repeat
   i:=WhereMusic+17;
   k:=masmus[i*2+1]*4;
   k1:=k div 128+1;
   k2:=k div 64+1;
   k3:=k div 16+1;
   SetRGBPalette(0,k*k1+1,k*k2+1,k*k3+1);
 until (WhereMusic=0) or keypressed;
 HaltMusic;
 GraphDefaults;
 ch:=#0;
 while not keypressed do;
 ch:=readkey;
 end;
 closegraph;
 restorecrtmode;
 end.
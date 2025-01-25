 {$A+,B-,F+,I-,N-,O-,R-,S-,V-}
 unit Music;
 Interface
  Procedure Nosound;
  Procedure Sound(Hz:word);

  Procedure OpenMusic;
  Function  TimeCounter:longint;
  Procedure SetMusic(var m);
  Procedure RunMusic(from,to_:integer);
  Procedure HaltMusic;
  Function  SizeMusic:integer;
  Function  WhereMusic:integer;
  Procedure CloseMusic;

  implementation
  { ***************************************************** }
  const OldExitProc:pointer=NIL;
  Procedure Nosound;                   external;
  Procedure Sound(Hz:word);            external;
  
  Procedure OpenMusic;                 external;
  Function TimeCounter:longint;        external;
  Procedure SetMusic(var m);           external;
  Procedure RunMusic(from,to_:integer);external;
  Procedure HaltMusic;                 external;
  Function  SizeMusic:integer;         external;
  Function  WhereMusic:integer;        external;
  Procedure CloseMusic;                external;

  {$L music}

  Procedure Quit;
   begin
    CloseMusic;
    ExitProc:=OldExitProc;
    halt
   end;{procedure}

  begin
   OldExitProc:=ExitProc; ExitProc:=@Quit;
   OpenMusic;
  end.
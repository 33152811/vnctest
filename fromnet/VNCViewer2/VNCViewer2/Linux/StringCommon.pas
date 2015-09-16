unit StringCommon;

interface

uses {$ifdef WIN32}Windows,{$endif}Math;

type

  CharSet = set of Char;
  CharSetArray = array of CharSet;
  StringArray = array of string;
  charArray = array[1..100] of char;
  TuMSNStatus=(uMSNNotLogin,uMSNFindHost,uMSNConnecting,uMSNConnected,uMSNVersion,uMSNLogining,uMSNLogined,uMSNAway);
function Match(const M: CharSet; const S: string; const Pos: Integer = 1;
  const Count: Integer = 1): Boolean; overload;
function Match(const M: CharSetArray; const S: string; const Pos: Integer = 1)
  : Boolean; overload;
function Match(const M, S: string; const Pos: Integer = 1): Boolean; overload; // Blazing
function PosNext(const Find: CharSet; const S: string;
  const LastPos: Integer = 0): Integer; overload;
function PosNext(const Find: CharSetArray; const S: string;
  const LastPos: Integer = 0): Integer; overload;
function PosNext(const Find: string; const S: string;
  const LastPos: Integer = 0): Integer; overload;
function CopyRange(const S: string; const Start, Stop: Integer): string;
function CopyFrom(const S: string; const Start: Integer): string;
function Split(const S: string; const Delimiter: string = ' '): StringArray;
{$ifdef WIN32}
function DeleteDir(const Source:string): boolean;
function ReNameFile(Src:String;Dest:String):Boolean;
{$endif}

implementation
{$ifdef WIN32}
uses ShellAPI;

function ReNameFile(Src:String;Dest:String):Boolean;
begin
  Result:=MoveFile(pchar(src),pchar(Dest));
end;

function DeleteDir(const Source:string): boolean;
var
  fo: TSHFILEOPSTRUCT;
begin
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := 0;
    wFunc := FO_DELETE;
    pFrom := PChar(source+#0);
    pTo := #0#0;
    fFlags := FOF_NOCONFIRMATION+FOF_SILENT;
  end;
  Result := (SHFileOperation(fo) = 0);
end;
 {$endif}

///////////////////////////////////////////////
//      split 函数实现部分
///////////////////////////////////////////////

function PosNext(const Find: CharSet; const S: string; const LastPos: Integer): Integer;
var
  I: Integer;
begin
  if Find = [] then
  begin
    Result := 0;
    exit;
  end;

  for I := Max(LastPos + 1, 1) to Length(S) do
    if S[I] in Find then
    begin
      Result := I;
      exit;
    end;

  Result := 0;
end;

function PosNext(const Find: CharSetArray; const S: string; const LastPos: Integer): Integer;
var
  I, C: Integer;
begin
  C := Length(Find);
  if C = 0 then
  begin
    Result := 0;
    exit;
  end;

  for I := Max(LastPos + 1, 1) to Length(S) - C + 1 do
    if Match(Find, S, I) then
    begin
      Result := I;
      exit;
    end;

  Result := 0;
end;

function PosNext(const Find: string; const S: string; const LastPos: Integer = 0): Integer;
var
  I: Integer;
begin
  if Find = '' then
  begin
    Result := 0;
    exit;
  end;

  for I := LastPos + 1 to Length(S) - Length(Find) + 1 do
    if Match(Find, S, I) then
    begin
      Result := I;
      exit;
    end;

  Result := 0;
end;

function CopyRange(const S: string; const Start, Stop: Integer): string;
begin
  Result := Copy(S, Start, Stop - Start + 1);
end;

function CopyFrom(const S: string; const Start: Integer): string;
begin
  Result := Copy(S, Start, Length(S) - Start + 1);
end;

function Match(const M: CharSet; const S: string; const Pos: Integer; const Count: Integer): Boolean;
var
  I, PosEnd: Integer;
begin
  PosEnd := Pos + Count - 1;
  if (M = []) or (Pos < 1) or (Count = 0) or (PosEnd > Length(S)) then
  begin
    Result := False;
    exit;
  end;

  for I := Pos to PosEnd do
    if not (S[I] in M) then
    begin
      Result := False;
      exit;
    end;

  Result := True;
end;

function Match(const M: CharSetArray; const S: string; const Pos: Integer): Boolean;
var
  J, C: Integer;
begin
  C := Length(M);
  if (C = 0) or (Pos < 1) or (Pos + C - 1 > Length(S)) then
  begin
    Result := False;
    exit;
  end;

  for J := 0 to C - 1 do
    if not (S[J + Pos] in M[J]) then
    begin
      Result := False;
      exit;
    end;

  Result := True;
end;

{ Highly optimized version of Match. Equivalent to, but much faster and more   }
{ memory efficient than: M = Copy (S, Pos, Length (M))                         }
{ Does compare in 32-bit chunks (CPU's native type)                            }

function Match(const M, S: string; const Pos: Integer): Boolean;
asm
      push esi
      push edi
      push edx                    // save state

      push Pos
      push M
      push S                      // push parameters
      pop edi                     // edi = S [1]
      pop esi                     // esi = M [1]
      pop ecx                     // ecx = Pos
      cmp ecx, 1
      jb @NoMatch                 // if Pos < 1 then @NoMatch

      mov edx, [esi - 4]
      or edx, edx
      jz @NoMatch                 // if Length (M) = 0 then @NoMatch
      add edx, ecx
      dec edx                     // edx = Pos + Length (M) - 1

      cmp edx, [edi - 4]
      ja @NoMatch                 // if Pos + Length (M) - 1 > Length (S) then @NoMatch

      add edi, ecx
      dec edi                     // edi = S [Pos]
      mov ecx, [esi - 4]          // ecx = Length (M)

      // All the following code is an optimization of just two lines:         //
      //     rep cmsb                                                         //
      //     je @Match                                                        //
      mov dl, cl                                                              //
      and dl, $03                                                             //
      shr ecx, 2                                                              //
      jz @CheckMod                 { Length (M) < 4 }                         //
                                                                              //
      { The following is faster than:  {}                                     //
      {     rep cmpsd                  {}                                     //
      {     jne @NoMatch               {}                                     //
      @c1:                             {}                                     //
        mov eax, [esi]                 {}                                     //
        cmp eax, [edi]                 {}                                     //
        jne @NoMatch                   {}                                     //
        add esi, 4                     {}                                     //
        add edi, 4                     {}                                     //
        dec ecx                        {}                                     //
        jnz @c1                        {}                                     //
                                                                              //
      or edx, edx                                                             //
      jz @Match                                                               //
                                                                              //
      { Check remaining dl (0-3) bytes   {}                                   //
    @CheckMod:                           {}                                   //
      mov eax, [esi]                     {}                                   //
      mov ecx, [edi]                     {}                                   //
      cmp al, cl                         {}                                   //
      jne @NoMatch                       {}                                   //
      dec dl                             {}                                   //
      jz @Match                          {}                                   //
      cmp ah, ch                         {}                                   //
      jne @NoMatch                       {}                                   //
      dec dl                             {}                                   //
      jz @Match                          {}                                   //
      and eax, $00ff0000                 {}                                   //
      and ecx, $00ff0000                 {}                                   //
      cmp eax, ecx                       {}                                   //
      je @Match                          {}                                   //

    @NoMatch:
      xor al, al                  // Result := False
      jmp @Fin

    @Match:
      mov al, 1                   // Result := True

    @Fin:
      pop edx                     // restore state
      pop edi
      pop esi
end;

function Split(const S: string; const Delimiter: string = ' '): StringArray;
var
  I, J, L: Integer;
begin
  SetLength(Result, 0);
  if (Delimiter = '') or (S = '') then
    exit;

  I := 0;
  L := 0;
  repeat
    SetLength(Result, L + 1);
    J := PosNext(Delimiter, S, I);
    if J = 0 then
      Result[L] := CopyFrom(S, I + Length(Delimiter))
    else
    begin
      Result[L] := CopyRange(S, I + Length(Delimiter), J - 1);
      I := J;
      Inc(L);
    end;
  until J = 0;
end;

end.

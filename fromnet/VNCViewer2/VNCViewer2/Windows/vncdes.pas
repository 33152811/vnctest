unit vncdes;

interface
uses
  Classes, Sysutils;

const
  EN0 = 0; (* MODE == encrypt *)
  DE1 = 1; (* MODE == decrypt *)

  Df_Key: array[0..23] of byte = ($01, $23, $45, $67, $89, $AB, $CD, $EF,
    $FE, $DC, $BA, $98, $76, $54, $32, $10,
    $89, $AB, $CD, $EF, $01, $23, $45, $67);

  bytebit: array[0..7] of word = (1, 2, 4, 8, 16, 32, 64, 128);

  bigbyte: array[0..23] of Longword = ($800000, $400000, $200000, $100000,
    $80000, $40000, $20000, $10000,
    $8000, $4000, $2000, $1000,
    $800, $400, $200, $100,
    $80, $40, $20, $10,
    $8, $4, $2, $1);

(* Use the key schedule specified in the Standard (ANSI X3.92-1981). *)

  pc1: array[0..55] of byte = (56, 48, 40, 32, 24, 16, 8, 0, 57, 49, 41, 33, 25, 17,
    9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35,
    62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21,
    13, 5, 60, 52, 44, 36, 28, 20, 12, 4, 27, 19, 11, 3);

  totrot: array[0..15] of byte = (1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28);

  pc2: array[0..47] of byte = (13, 16, 10, 23, 0, 4, 2, 27, 14, 5, 20, 9,
    22, 18, 11, 3, 25, 7, 15, 6, 26, 19, 12, 1,
    40, 51, 30, 36, 46, 54, 29, 39, 50, 44, 32, 47,
    43, 48, 38, 55, 33, 52, 45, 41, 49, 35, 28, 31);

  SP1: array[0..63] of Longword = ($01010400, $00000000, $00010000, $01010404,
    $01010004, $00010404, $00000004, $00010000,
    $00000400, $01010400, $01010404, $00000400,
    $01000404, $01010004, $01000000, $00000004,
    $00000404, $01000400, $01000400, $00010400,
    $00010400, $01010000, $01010000, $01000404,
    $00010004, $01000004, $01000004, $00010004,
    $00000000, $00000404, $00010404, $01000000,
    $00010000, $01010404, $00000004, $01010000,
    $01010400, $01000000, $01000000, $00000400,
    $01010004, $00010000, $00010400, $01000004,
    $00000400, $00000004, $01000404, $00010404,
    $01010404, $00010004, $01010000, $01000404,
    $01000004, $00000404, $00010404, $01010400,
    $00000404, $01000400, $01000400, $00000000,
    $00010004, $00010400, $00000000, $01010004);

  SP2: array[0..63] of Longword = (
    $80108020, $80008000, $00008000, $00108020,
    $00100000, $00000020, $80100020, $80008020,
    $80000020, $80108020, $80108000, $80000000,
    $80008000, $00100000, $00000020, $80100020,
    $00108000, $00100020, $80008020, $00000000,
    $80000000, $00008000, $00108020, $80100000,
    $00100020, $80000020, $00000000, $00108000,
    $00008020, $80108000, $80100000, $00008020,
    $00000000, $00108020, $80100020, $00100000,
    $80008020, $80100000, $80108000, $00008000,
    $80100000, $80008000, $00000020, $80108020,
    $00108020, $00000020, $00008000, $80000000,
    $00008020, $80108000, $00100000, $80000020,
    $00100020, $80008020, $80000020, $00100020,
    $00108000, $00000000, $80008000, $00008020,
    $80000000, $80100020, $80108020, $00108000);

  SP3: array[0..63] of Longword = (
    $00000208, $08020200, $00000000, $08020008,
    $08000200, $00000000, $00020208, $08000200,
    $00020008, $08000008, $08000008, $00020000,
    $08020208, $00020008, $08020000, $00000208,
    $08000000, $00000008, $08020200, $00000200,
    $00020200, $08020000, $08020008, $00020208,
    $08000208, $00020200, $00020000, $08000208,
    $00000008, $08020208, $00000200, $08000000,
    $08020200, $08000000, $00020008, $00000208,
    $00020000, $08020200, $08000200, $00000000,
    $00000200, $00020008, $08020208, $08000200,
    $08000008, $00000200, $00000000, $08020008,
    $08000208, $00020000, $08000000, $08020208,
    $00000008, $00020208, $00020200, $08000008,
    $08020000, $08000208, $00000208, $08020000,
    $00020208, $00000008, $08020008, $00020200);

  SP4: array[0..63] of Longword = (
    $00802001, $00002081, $00002081, $00000080,
    $00802080, $00800081, $00800001, $00002001,
    $00000000, $00802000, $00802000, $00802081,
    $00000081, $00000000, $00800080, $00800001,
    $00000001, $00002000, $00800000, $00802001,
    $00000080, $00800000, $00002001, $00002080,
    $00800081, $00000001, $00002080, $00800080,
    $00002000, $00802080, $00802081, $00000081,
    $00800080, $00800001, $00802000, $00802081,
    $00000081, $00000000, $00000000, $00802000,
    $00002080, $00800080, $00800081, $00000001,
    $00802001, $00002081, $00002081, $00000080,
    $00802081, $00000081, $00000001, $00002000,
    $00800001, $00002001, $00802080, $00800081,
    $00002001, $00002080, $00800000, $00802001,
    $00000080, $00800000, $00002000, $00802080);

  SP5: array[0..63] of Longword = (
    $00000100, $02080100, $02080000, $42000100,
    $00080000, $00000100, $40000000, $02080000,
    $40080100, $00080000, $02000100, $40080100,
    $42000100, $42080000, $00080100, $40000000,
    $02000000, $40080000, $40080000, $00000000,
    $40000100, $42080100, $42080100, $02000100,
    $42080000, $40000100, $00000000, $42000000,
    $02080100, $02000000, $42000000, $00080100,
    $00080000, $42000100, $00000100, $02000000,
    $40000000, $02080000, $42000100, $40080100,
    $02000100, $40000000, $42080000, $02080100,
    $40080100, $00000100, $02000000, $42080000,
    $42080100, $00080100, $42000000, $42080100,
    $02080000, $00000000, $40080000, $42000000,
    $00080100, $02000100, $40000100, $00080000,
    $00000000, $40080000, $02080100, $40000100);

  SP6: array[0..63] of Longword = (
    $20000010, $20400000, $00004000, $20404010,
    $20400000, $00000010, $20404010, $00400000,
    $20004000, $00404010, $00400000, $20000010,
    $00400010, $20004000, $20000000, $00004010,
    $00000000, $00400010, $20004010, $00004000,
    $00404000, $20004010, $00000010, $20400010,
    $20400010, $00000000, $00404010, $20404000,
    $00004010, $00404000, $20404000, $20000000,
    $20004000, $00000010, $20400010, $00404000,
    $20404010, $00400000, $00004010, $20000010,
    $00400000, $20004000, $20000000, $00004010,
    $20000010, $20404010, $00404000, $20400000,
    $00404010, $20404000, $00000000, $20400010,
    $00000010, $00004000, $20400000, $00404010,
    $00004000, $00400010, $20004010, $00000000,
    $20404000, $20000000, $00400010, $20004010);

  SP7: array[0..63] of Longword = (
    $00200000, $04200002, $04000802, $00000000,
    $00000800, $04000802, $00200802, $04200800,
    $04200802, $00200000, $00000000, $04000002,
    $00000002, $04000000, $04200002, $00000802,
    $04000800, $00200802, $00200002, $04000800,
    $04000002, $04200000, $04200800, $00200002,
    $04200000, $00000800, $00000802, $04200802,
    $00200800, $00000002, $04000000, $00200800,
    $04000000, $00200800, $00200000, $04000802,
    $04000802, $04200002, $04200002, $00000002,
    $00200002, $04000000, $04000800, $00200000,
    $04200800, $00000802, $00200802, $04200800,
    $00000802, $04000002, $04200802, $04200000,
    $00200800, $00000000, $00000002, $04200802,
    $00000000, $00200802, $04200000, $00000800,
    $04000002, $04000800, $00000800, $00200002);

  SP8: array[0..63] of Longword = (
    $10001040, $00001000, $00040000, $10041040,
    $10000000, $10001040, $00000040, $10000000,
    $00040040, $10040000, $10041040, $00041000,
    $10041000, $00041040, $00001000, $00000040,
    $10040000, $10000040, $10001000, $00001040,
    $00041000, $00040040, $10040040, $10041000,
    $00001040, $00000000, $00000000, $10040040,
    $10000040, $10001000, $00041040, $00040000,
    $00041040, $00040000, $10041000, $00001000,
    $00000040, $10040040, $00001000, $00041040,
    $10001000, $00000040, $10000040, $10040000,
    $10040040, $10000000, $00040000, $10001040,
    $00000000, $10041040, $00040040, $10000040,
    $10040000, $10001000, $10001040, $00000000,
    $10041040, $00041000, $00041000, $00001040,
    $00001040, $00040040, $10000000, $10041000);


procedure cookey(raw1: PLongword);
procedure des(inblock: Pchar; outblock: Pchar);
procedure deskey(key: Pchar; edf: smallint);cdecl; (* Thanks to James Gillogly & Phil Karn! *)

var

  KnL: array[0..31] of Longword;
  KnR: array[0..31] of Longword;
  Kn3: array[0..31] of Longword;


implementation

procedure deskey(key: pchar; edf: smallint);cdecl;
var
  i, j, l, m, n: integer;
  pc1m: array[0..55] of byte;
  pcr: array[0..55] of byte;
  kn: array[0..31] of Longword;
  lkey: PByte;
  tt:char;
begin
  for j := 0 to 55 do
  begin
    l := pc1[j];
    m := l and 07;
    lkey := ptr(Integer(key) + (l shr 3));
    tt:=key[l shr 3];
    if (lkey^ and bytebit[m]) > 0 then
      pc1m[j] := 1
    else
      pc1m[j] := 0;
  end;
  for i := 0 to 15 do
  begin
    if (edf = DE1) then
      m := (15 - i) shl 1
    else
      m := i shl 1;
    n := m + 1;
    kn[m] := 0;
    kn[n] := 0;
    for j := 0 to 27 do
    begin
      l := j + totrot[i];
      if (l < 28) then
        pcr[j] := pc1m[l]
      else
        pcr[j] := pc1m[l - 28];
    end;
    for j := 28 to 55 do
    begin
      l := j + totrot[i];
      if (l < 56) then
        pcr[j] := pc1m[l]
      else
        pcr[j] := pc1m[l - 28];
    end;
    for j := 0 to 23 do
    begin
      if (pcr[pc2[j]] <> 0) then
        kn[m] := kn[m] or bigbyte[j];
      if (pcr[pc2[j + 24]]) <> 0 then
        kn[n] := kn[n] or bigbyte[j];
    end;
  end;
  cookey(@kn);
end;

procedure usekey(from: PLongword);
var
  I: Integer;
  lvalue: PLongword;
begin
  for I := 0 to 31 do // Iterate
  begin
    lValue := ptr(Integer(from) + i*4);
    KnL[i] := lValue^;
  end;
end;

procedure cookey(raw1: PLongword);
var
  cook, raw0: PLongword;
  dough: array[0..31] of Longword;
  i: Integer;
  lValue: PLongword;
begin
  cook := @dough[0];
  for i := 0 to 15 do
  begin
    raw0 := Ptr(Integer(raw1) + i * 8);
    lValue := Ptr(Integer(raw1) + i * 8 + 4);
    dough[i * 2] := (raw0^ and $00FC0000) shl 6;
    dough[i * 2] := dough[i * 2] or (raw0^ and $00000FC0) shl 10;
    dough[i * 2] := dough[i * 2] or (lValue^ and $00FC0000) shr 10;
    dough[i * 2] := dough[i * 2] or (lValue^ and $00000FC0) shr 6;
    dough[i * 2 + 1] := (raw0^ and $0003F000) shl 12;
    dough[i * 2 + 1] := dough[i * 2 + 1] or (raw0^ and $0000003F) shl 16;
    dough[i * 2 + 1] := dough[i * 2 + 1] or (lvalue^ and $0003F000) shr 4;
    dough[i * 2 + 1] := dough[i * 2 + 1] or (lvalue^ and $0000003F);
  end;
  usekey(@dough);
end;

procedure cpkey(into: PLongword);
var
  I: Integer;
  lvalue: PLongword;
begin
  for I := 0 to 31 do // Iterate
  begin
    lValue := ptr(Integer(into) + i*4);
    lValue^ := KnL[i];
  end;
end;

procedure scrunch(outof: PByte; into: PLongword);
var
  ld1, ld2: PLongword;
  lb1: PByte;
begin
  ld1 := into;
  ld2 := ptr(integer(into) + 4);
  lb1 := outof;
  ld1^ := (lb1^ and $FF) shl 24;
  lb1 := ptr(Integer(lb1) + 1);
  ld1^ := ld1^ or (lb1^ and $FF) shl 16;
  lb1 := ptr(Integer(lb1) + 1);
  ld1^ := ld1^ or (lb1^ and $FF) shl 8;
  lb1 := ptr(Integer(lb1) + 1);
  ld1^ := ld1^ or (lb1^ and $FF);
  lb1 := ptr(Integer(lb1) + 1);
  ld2^ := (lb1^ and $FF) shl 24;
  lb1 := ptr(Integer(lb1) + 1);
  ld2^ := ld2^ or (lb1^ and $FF) shl 16;
  lb1 := ptr(Integer(lb1) + 1);
  ld2^ := ld2^ or (lb1^ and $FF) shl 8;
  lb1 := ptr(Integer(lb1) + 1);
  ld2^ := ld2^ or (lb1^ and $FF);
end;

procedure unscrun(outof: PLongword; into: PByte);
var
  ld1, ld2: PLongword;
  lb1: PByte;
begin
  lb1 := into;
  ld1 := outof;
  ld2 := ptr(integer(outof) + 4);
  lb1^ := ((ld1^ shr 24) and $FF);
  lb1 := ptr(Integer(lb1) + 1);
  lb1^ := ((ld1^ shr 16) and $FF);
  lb1 := ptr(Integer(lb1) + 1);
  lb1^ := ((ld1^ shr 8) and $FF);
  lb1 := ptr(Integer(lb1) + 1);
  lb1^ := (ld1^ and $FF);
  lb1 := ptr(Integer(lb1) + 1);
  lb1^ := ((ld2^ shr 24) and $FF);
  lb1 := ptr(Integer(lb1) + 1);
  lb1^ := ((ld2^ shr 16) and $FF);
  lb1 := ptr(Integer(lb1) + 1);
  lb1^ := ((ld2^ shr 8) and $FF);
  lb1 := ptr(Integer(lb1) + 1);
  lb1^ := (ld2^ and $FF);
end;

procedure desfunc(block: PLongword; keys: PLongword);
var
  fval, work, right, leftt: Longword;
  round: Integer;
  lvalue: PLongword;
begin
  leftt := block^;
  lValue := ptr(integer(block) + 4);
  right := lValue^;
  work := ((leftt shr 4) xor right) and $0F0F0F0F;
  right := right xor work;
  leftt := leftt xor (work shl 4);
  work := ((leftt shr 16) xor right) and $0000FFFF;
  right := right xor work;
  leftt := leftt xor (work shl 16);
  work := ((right shr 2) xor leftt) and $33333333;
  leftt := leftt xor work;
  right := right xor (work shl 2);
  work := ((right shr 8) xor leftt) and $00FF00FF;
  leftt := leftt xor work;
  right := right xor (work shl 8);
  right := ((right shl 1) or ((right shr 31) and 1)) and $FFFFFFFF;
  work := (leftt xor right) and $AAAAAAAA;
  leftt := leftt xor work;
  right := right xor work;
  leftt := ((leftt shl 1) or ((leftt shr 31) and 1)) and $FFFFFFFF;

  for round := 0 to 7 do
  begin
    work := (right shl 28) or (right shr 4);
    work := work xor keys^;
    Keys := ptr(Integer(keys) + 4);
    fval := SP7[work and $3F];
    fval := fval or SP5[(work shr 8) and $3F];
    fval := fval or SP3[(work shr 16) and $3F];
    fval := fval or SP1[(work shr 24) and $3F];
    work := right xor keys^;
    Keys := ptr(Integer(keys) + 4);
    fval := fval or SP8[work and $3F];
    fval := fval or SP6[(work shr 8) and $3F];
    fval := fval or SP4[(work shr 16) and $3F];
    fval := fval or SP2[(work shr 24) and $3F];
    leftt := leftt xor fval;
    work := (leftt shl 28) or (leftt shr 4);
    work := work xor keys^;
    Keys := ptr(Integer(keys) + 4);
    fval := SP7[work and $3F];
    fval := fval or SP5[(work shr 8) and $3F];
    fval := fval or SP3[(work shr 16) and $3F];
    fval := fval or SP1[(work shr 24) and $3F];
    work := leftt xor keys^;
    Keys := ptr(Integer(keys) + 4);
    fval := fval or SP8[work and $3F];
    fval := fval or SP6[(work shr 8) and $3F];
    fval := fval or SP4[(work shr 16) and $3F];
    fval := fval or SP2[(work shr 24) and $3F];
    right := right xor fval;
  end;

  right := (right shl 31) or (right shr 1);
  work := (leftt xor right) and $AAAAAAAA;
  leftt := leftt xor work;
  right := right xor work;
  leftt := (leftt shl 31) or (leftt shr 1);
  work := ((leftt shr 8) xor right) and $00FF00FF;
  right := right xor work;
  leftt := leftt xor (work shl 8);
  work := ((leftt shr 2) xor right) and $33333333;
  right := right xor work;
  leftt := leftt xor (work shl 2);
  work := ((right shr 16) xor leftt) and $0000FFFF;
  leftt := leftt xor work;
  right := right xor (work shl 16);
  work := ((right shr 4) xor leftt) and $0F0F0F0F;
  leftt := leftt xor work;
  right := right xor (work shl 4);
  lvalue := ptr(Integer(block) + 4);
  block^ := right;
  lvalue^ := leftt;
end;

procedure des(inblock: Pchar; outblock: Pchar);
var
  work: array[0..1] of Longword;
begin
  scrunch(pbyte(inblock), @work);
  desfunc(@work, @KnL);
  unscrun(@work, pbyte(outblock));
end;


end.


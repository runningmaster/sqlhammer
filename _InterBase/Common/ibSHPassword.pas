{ **************************************************************************** }
{ SQLHammer_                                                                   }
{ Copyright (c) 2005 Metadata Forge, http://www.metadataforge.com              }
{ **************************************************************************** }

unit
  ibSHPassword;

interface

{
This is translated from ugly unix code, and as such, has no guarantees
associated with it and is provided "as is".
      Luke Tigaris
Thanks to Gérard Perreault for the C code.
}

function CreateInterbasePassword( const aPassword: String ): String;
function UnixPassword( const aPassword,aSalt: String ): String;

implementation

function CreateInterbasePassword( const aPassword: String ): String;
begin
  Result := Copy( UnixPassword( aPassword, '9z' ), 3, 99 );
  Result := Copy( UnixPassword( Result, '9z' ),3 , 99 );
end;

type

    TBlock = record
        Data: array[0..63] of Byte;
    end;

const
    InitialTranspose1: TBlock = (Data: (
        58,50,42,34,26,18,10, 2,60,52,44,36,28,20,12, 4,
        62,54,46,38,30,22,14, 6,64,56,48,40,32,24,16, 8,
        57,49,41,33,25,17, 9, 1,59,51,43,35,27,19,11, 3,
        61,53,45,37,29,21,13, 5,63,55,47,39,31,23,15, 7
    ));

    FinalTranspose1: TBlock = (Data: (
        40, 8,48,16,56,24,64,32,39, 7,47,15,55,23,63,31,
        38, 6,46,14,54,22,62,30,37, 5,45,13,53,21,61,29,
        36, 4,44,12,52,20,60,28,35, 3,43,11,51,19,59,27,
        34, 2,42,10,50,18,58,26,33, 1,41, 9,49,17,57,25
    ));

    // swaps first half of block with second half of block
    SwapTranspose: TBlock = (Data: (
        33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,
        49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,
         1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,
        17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
    ));

    // first key transpose pattern
    KeyTranspose1: TBlock = (Data: (
        57,49,41,33,25,17, 9, 1,58,50,42,34,26,18,
        10, 2,59,51,43,35,27,19,11, 3,60,52,44,36,
        63,55,47,39,31,23,15, 7,62,54,46,38,30,22,
        14, 6,61,53,45,37,29,21,13, 5,28,20,12, 4,
         0, 0, 0, 0, 0, 0, 0, 0
    ));

    // second key transpose pattern
    KeyTranspose2: TBlock = (Data: (
        14,17,11,24, 1, 5, 3,28,15, 6,21,10,
        23,19,12, 4,26, 8,16, 7,27,20,13, 2,
        41,52,31,37,47,55,30,40,51,45,33,48,
        44,49,39,56,34,53,46,42,50,36,29,32,
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
         0, 0, 0, 0
    ));

   InitialTranspose2: TBlock = (Data: (
        32, 1, 2, 3, 4, 5, 4, 5, 6, 7, 8, 9,
         8, 9,10,11,12,13,12,13,14,15,16,17,
        16,17,18,19,20,21,20,21,22,23,24,25,
        24,25,26,27,28,29,28,29,30,31,32, 1,
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
         0, 0, 0, 0
   ));

   FinalTranspose2: TBlock = (Data: (
        16, 7,20,21,29,12,28,17, 1,15,23,26, 5,18,31,10,
         2, 8,24,14,32,27, 3, 9,19,13,30, 6,22,11, 4,25,
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
   ));

    // patterns for shifting bytes during encryption loop
    ShiftBlocks: array[0..7, 0..63] of Byte = (
        ( 14, 4,13, 1, 2,15,11, 8, 3,10, 6,12, 5, 9, 0, 7,
           0,15, 7, 4,14, 2,13, 1,10, 6,12,11, 9, 5, 3, 8,
           4, 1,14, 8,13, 6, 2,11,15,12, 9, 7, 3,10, 5, 0,
          15,12, 8, 2, 4, 9, 1, 7, 5,11, 3,14,10, 0, 6,13
        ),
        ( 15, 1, 8,14, 6,11, 3, 4, 9, 7, 2,13,12, 0, 5,10,
           3,13, 4, 7,15, 2, 8,14,12, 0, 1,10, 6, 9,11, 5,
           0,14, 7,11,10, 4,13, 1, 5, 8,12, 6, 9, 3, 2,15,
          13, 8,10, 1, 3,15, 4, 2,11, 6, 7,12, 0, 5,14, 9
        ),
        ( 10, 0, 9,14, 6, 3,15, 5, 1,13,12, 7,11, 4, 2, 8,
          13, 7, 0, 9, 3, 4, 6,10, 2, 8, 5,14,12,11,15, 1,
          13, 6, 4, 9, 8,15, 3, 0,11, 1, 2,12, 5,10,14, 7,
           1,10,13, 0, 6, 9, 8, 7, 4,15,14, 3,11, 5, 2,12
        ),
        (  7,13,14, 3, 0, 6, 9,10, 1, 2, 8, 5,11,12, 4,15,
          13, 8,11, 5, 6,15, 0, 3, 4, 7, 2,12, 1,10,14, 9,
          10, 6, 9, 0,12,11, 7,13,15, 1, 3,14, 5, 2, 8, 4,
           3,15, 0, 6,10, 1,13, 8, 9, 4, 5,11,12, 7, 2,14
        ),
        (  2,12, 4, 1, 7,10,11, 6, 8, 5, 3,15,13, 0,14, 9,
          14,11, 2,12, 4, 7,13, 1, 5, 0,15,10, 3, 9, 8, 6,
           4, 2, 1,11,10,13, 7, 8,15, 9,12, 5, 6, 3, 0,14,
          11, 8,12, 7, 1,14, 2,13, 6,15, 0, 9,10, 4, 5, 3
        ),
        ( 12, 1,10,15, 9, 2, 6, 8, 0,13, 3, 4,14, 7, 5,11,
          10,15, 4, 2, 7,12, 9, 5, 6, 1,13,14, 0,11, 3, 8,
           9,14,15, 5, 2, 8,12, 3, 7, 0, 4,10, 1,13,11, 6,
           4, 3, 2,12, 9, 5,15,10,11,14, 1, 7, 6, 0, 8,13
        ),
        (  4,11, 2,14,15, 0, 8,13, 3,12, 9, 7, 5,10, 6, 1,
          13, 0,11, 7, 4, 9, 1,10,14, 3, 5,12, 2,15, 8, 6,
           1, 4,11,13,12, 3, 7,14,10,15, 6, 8, 0, 5, 9, 2,
           6,11,13, 8, 1, 4,10, 7, 9, 5, 0,15,14, 2, 3,12
        ),
        ( 13, 2, 8, 4, 6,15,11, 1,10, 9, 3,14, 5, 0,12, 7,
           1,15,13, 8,10, 3, 7, 4,12, 5, 6,11, 0,14, 9, 2,
           7,11, 4, 1, 9,12,14, 2, 0, 6,10,13,15, 3, 5, 8,
           2, 1,14, 7, 4,10, 8,13,15,12, 9, 0, 3, 5, 6, 11
        )
    );

    // number of rotates to due at various times within encryption loop
    RotateArray: array[0..15] of Integer = (1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1);
      
// transpose block data; rearrange Block data according to Order pattern
procedure TransposeBlock(var aBlock: TBlock; const aOrder: TBlock; const aTotal: Integer);
var
    i: Integer;
    CopyBlock: TBlock;
begin
	CopyBlock := aBlock;
	for i := aTotal - 1 downto 0 do
		aBlock.Data[i] := CopyBlock.Data[aOrder.Data[i] - 1];
end;

// rotate block data, basically moves all data in each half of the block to the left one spot
procedure RotateBlock(var aBlock: TBlock);
var
    Data0: Byte;
    Data28: Byte;
    i: Integer;
begin
	Data0 := aBlock.Data[0];
	Data28 := aBlock.Data[28];
    for i := 0 to 54 do
		aBlock.Data[i] := aBlock.Data[i + 1];
	aBlock.Data[27] := Data0;
	aBlock.Data[55] := Data28;
end;

// TransformBlock;  do some voodo magic on block, heart of encryption routine
procedure TransformBlock(const aTotalPasses: Integer; const aBlock,aNewTranspose: TBlock;
  var aKey,aResultBlock: TBlock);
var
    NewKey,ShiftSelector,NewBlock: TBlock;
    i,ShiftSpot,ShiftData: Integer;
begin
    NewBlock := aBlock;
	TransposeBlock(NewBlock, aNewTranspose, 48);
	for i := RotateArray[aTotalPasses] downto 1 do
		RotateBlock(aKey);
	NewKey := aKey;
    TransposeBlock(NewKey, KeyTranspose2, 48);
	for i := 47 downto 0 do
		ShiftSelector.Data[i] := NewBlock.Data[i] xor NewKey.Data[i];
    for i := 0 to 7 do
    begin
        ShiftSpot := ShiftSelector.Data[6*i] shl 5;
        ShiftSpot := ShiftSpot + ShiftSelector.Data[6*i + 1] shl 3;
        ShiftSpot := ShiftSpot + ShiftSelector.Data[6*i + 2] shl 2;
        ShiftSpot := ShiftSpot + ShiftSelector.Data[6*i + 3] shl 1;
        ShiftSpot := ShiftSpot + ShiftSelector.Data[6*i + 4];
        ShiftSpot := ShiftSpot + ShiftSelector.Data[6*i + 5] shl 4;
        ShiftData := ShiftBlocks[i][ShiftSpot];
		aResultBlock.Data[4*i] := (ShiftData shr 3) and 1;
		aResultBlock.Data[4*i + 1] := (ShiftData shr 2) and 1;
		aResultBlock.Data[4*i + 2] := (ShiftData shr 1) and 1;
        aResultBlock.Data[4*i + 3] := ShiftData and 1;
    end;
	TransposeBlock(aResultBlock, FinalTranspose2, 32);
end;

// DoEncrypt; does single encryption of block
procedure DoEncrypt(var aBlock,aKey: TBlock; const aNewTranspose: TBlock);
var
   i,j,TotalPasses: Integer;
   BlockCopy,TransformedBlock: TBlock;
begin
	TransposeBlock(aBlock, InitialTranspose1, 64);
    // do encryption loop 16 times
    for i := 15 downto 0 do
    begin
        TotalPasses := 15 - i;
		BlockCopy := aBlock;   // copy second half of block into first half
        for j := 31 downto 0 do
			aBlock.Data[j] := BlockCopy.Data[j + 32]; // transform second half of block
		TransformBlock(TotalPasses, aBlock, aNewTranspose, aKey, TransformedBlock);
        for j := 31 downto 0 do // copy transformed half of block into second half
			aBlock.Data[j + 32] := BlockCopy.Data[j] xor TransformedBlock.Data[j];
    end;
	TransposeBlock(aBlock, SwapTranspose, 64);
	TransposeBlock(aBlock, FinalTranspose1, 64);
end;

// UnixPassword
function UnixPassword(const aPassword,aSalt: String): String;
var
    NewPasswordBlock: array[0..65] of Byte;
    PasswordBlock,NewTranspose,CopyBlock,Key: TBlock;
    i,j,pwIndex,npwIndex,total,spot,holder,OneChar: Integer;
begin
    Result := '';
	if Length(aSalt) <> 2 then Exit; // otherwise will blow up
    Result := '1234567890123'; // need 13 characters so we can use as array
	total := Length(aPassword);
    if total > 8 then  // can't encrypt strings longer than 8 characters
        total := 8;
    for i := 1 to total do
		PasswordBlock.Data[i - 1] := Ord(aPassword[i]);
    for i := total to 63 do
        PasswordBlock.Data[i] := 0;
    pwIndex := 0;
    npwIndex := 0;
    while((PasswordBlock.Data[pwIndex] <> 0) and (npwIndex < 64)) do
    begin
        for j := 6 downto 0 do // splitting each byte into its respective bits
        begin                  // use only first seven bits, as eighth bit set to 0
            NewPasswordBlock[npwIndex] := (PasswordBlock.Data[pwIndex] shr j) and 1;
            Inc(npwIndex);     // NewPassword will contain 0's and 1's
        end;
        Inc(pwIndex);
        NewPasswordBlock[npwIndex] := 0;
        Inc(npwIndex);
    end;
    for i := npwIndex to 65 do  // zero out remaining part of block
        NewPasswordBlock[i] := 0;
    NewTranspose := InitialTranspose2;
	for i := 1 to Length(aSalt) do    // using salt to set up transpose key
    begin
        OneChar := Ord(aSalt[i]);
        Result[i] := Chr(OneChar);
        if OneChar > Ord('Z') then
            OneChar := OneChar - 6;
        if OneChar > Ord('9') then
            OneChar := OneChar - 7;
        OneChar := OneChar - Ord('.');
        for j := 0 to 5 do
            if ((OneChar shr j) and 1) = 1 then
            begin
                spot := 6*(i-1) + j;
                holder := NewTranspose.Data[spot];
                NewTranspose.Data[spot] := NewTranspose.Data[spot + 24];
                NewTranspose.Data[spot + 24] := holder;
            end;
    end;
    for i := 0 to 63 do    // copy password to key
        Key.Data[i] := NewPasswordBlock[i];
    TransposeBlock(Key, KeyTranspose1, 56);  // create start key from password
    for i := 0 to 65 do
        NewPasswordBlock[i] := 0;
    for i := 0 to 63 do   // must have TBlock variable for DoEncrypt loop
        CopyBlock.Data[i] := 0;
    for i := 0 to 24 do
        DoEncrypt(CopyBlock, Key, NewTranspose);
    for i := 0 to 63 do  // copy back our final TBlock into password
        NewPasswordBlock[i] := CopyBlock.Data[i];    // contains 0's and 1's
    npwIndex := 0;
    pwIndex := 2;
    while npwIndex < 66 do  // 6 bits * 11 characters = 66 times
    begin
        OneChar := 0;
        for j := 5 downto 0 do  // using the first six bytes to make a number
        begin
            OneChar := OneChar shl 1;
            OneChar := OneChar or NewPasswordBlock[npwIndex];
            Inc(npwIndex);
        end;
        OneChar := OneChar + Ord('.');
        if OneChar > Ord('9') then
            OneChar := OneChar + 7;
        if OneChar > Ord('Z') then
            OneChar := OneChar + 6;
        Result[pwIndex + 1] := Chr(OneChar);
        Inc(pwIndex);
    end;
    SetLength(Result, pwIndex);
end;

end.


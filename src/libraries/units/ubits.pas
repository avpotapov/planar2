unit uBits;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBaseMap,
  uVarDefine,
  uLibraries,
  uBitsSet;

type
  TBitsSpec = specialize TBaseMap<byte, IBitDefine>;

  TBits = class(TBitsSpec, IBits, IClonableBits)
  private
    fVarDefine: TVarDefine;
    fBitsSet: TBitsSet;
    fShortDescription: WideString;
  protected
    function GetName: WideString;
    procedure SetName(const aName: WideString);

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);

    function GetVarDefine: IVarDefine;
    function GetBitsSet: IBitsSet;
  public

    constructor Create(const aBitsSet: TBitsSet = nil); overload;
    constructor Create(const aVarDefine: TVarDefine); overload;

  public
    function Clone(const aDeep: boolean = True): IBits;
    function Add(const AKey: TKey): integer; reintroduce;
    property Name: WideString read GetName write SetName;
    property ShortDescription: WideString read GetShortDescription
      write SetShortDescription;
  end;


implementation

uses uBitDefine;

{$REGION Bits}

function TBits.GetName: WideString;
var
  FoundIndex: integer;
begin
  Result := '';
  if fBitsSet = nil then
    Exit;
  FoundIndex := fBitsSet.IndexOfData(Self as IBits);
  if FoundIndex < 0 then
    Exit;
  Result := fBitsSet.Keys[FoundIndex];
end;

procedure TBits.SetName(const aName: WideString);
var
  I: integer;
begin
  if fBitsSet = nil then
    Exit;

  if SameText(GetName, aName) then
    Exit;

  // Для изменения ключа отключается сортировка
  fBitsSet.Sorted := False;
  try
    // В случае дубликата возбуждается исключение
    if fBitsSet.Find(aName, I) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
    // Записывается новое значение ключа
    fBitsSet.Keys[fBitsSet.IndexOfData(Self)] := aName;
  finally
    fBitsSet.Sorted := True;
  end;

end;

function TBits.GetShortDescription: WideString;
begin
  Result := fShortDescription;
end;

procedure TBits.SetShortDescription(const aShortDescription: WideString);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TBits.GetVarDefine: IVarDefine;
begin
  Result := fVarDefine;
end;

function TBits.GetBitsSet: IBitsSet;
begin
  Result := fBitsSet;
end;

function TBits.Clone(const aDeep: boolean): IBits;
var
  Ptr: Pointer;
  ClonableBitDefine: IClonableBitDefine;
  BitDefine: IBitDefine;
begin
  Result := TBits.Create(fBitsSet) as IBits;
  for Ptr in Self do
  begin
    case aDeep of
      True:
        if Supports(ExtractData(Ptr), IClonableBitDefine, ClonableBitDefine) then
        begin
          BitDefine := ClonableBitDefine.Clone(aDeep);
          (BitDefine as TBitDefine).SetBits(Result as TBits);
        end;
      False:
        BitDefine := ExtractData(Ptr);
    end;
    Result.Add(ExtractKey(Ptr), BitDefine);
  end;

end;

constructor TBits.Create(const aBitsSet: TBitsSet);
begin
  inherited Create;
  fBitsSet := aBitsSet;
end;

constructor TBits.Create(const aVarDefine: TVarDefine);
begin
  inherited Create;
  fVarDefine := aVarDefine;
end;


function TBits.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Result := FoundIndex;
    Exit;
  end;
  Result := (Self as TBitsSpec).Add(AKey, TBitDefine.Create(Self) as IBitDefine);

end;

{$ENDREGION Bits}


end.

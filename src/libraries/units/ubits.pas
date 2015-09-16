unit uBits;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBaseMap,
  uLibraries;

type
  TBitsSet = specialize TBaseMap<string, IBits>;
  TBitsSpec = specialize TBaseMap<byte, IBitDefine>;

  { TBits }

  TBits = class(TBitsSpec, IBits, IClonedBits)
  private
    fBitsSet: TBitsSet;
    fShortDescription: string;
  protected
    function GetName: string;
    procedure SetName(const aName: string);

    function GetShortDescription: string;
    procedure SetShortDescription(const aShortDescription: string);
  public
    function Clone(const aDeep: boolean = True): IBits;
    constructor Create(const aBitsSet: TBitsSet); overload;

  public
    function Add(const AKey: TKey): integer; reintroduce;
    property Name: string read GetName write SetName;
    property ShortDescription: string read GetShortDescription write SetShortDescription;
  end;


implementation

uses uBitDefine;

{$REGION Bits}

function TBits.GetName: string;
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

procedure TBits.SetName(const aName: string);
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

function TBits.GetShortDescription: string;
begin
  Result := fShortDescription;
end;

procedure TBits.SetShortDescription(const aShortDescription: string);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TBits.Clone(const aDeep: boolean): IBits;
var
  Ptr: Pointer;
  ClonedBitDefine: IClonedBitDefine;
  BitDefine: IBitDefine;
begin
  Result := TBits.Create(fBitsSet) as IBits;
  for Ptr in Self do
  begin
    case aDeep of
      True:
        if Supports(ExtractData(Ptr), IClonedBitDefine, ClonedBitDefine) then
          BitDefine := ClonedBitDefine.Clone(aDeep);
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


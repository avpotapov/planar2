unit uBitDefine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBase,
  uDescription,
  uLibraries,
  uBits;

type

  { TBitDefine }

  TBitDefine = class(TBase, IBitDefine, IClonableBitDefine)
  private
    fBits: TBits;
    fName: widestring;
    fShortDescription: widestring;
    fDescription: IDescription;
    fVer: widestring;

  private
    function GetIndex: byte;
    procedure SetIndex(const aIndex: byte);

    function GetName: widestring;
    procedure SetName(const aName: widestring);

    function GetShortDescription: widestring;
    procedure SetShortDescription(const aShortDescription: widestring);

    function GetDescription: IDescription;

    function GetVer: widestring;
    procedure SetVer(const aVer: widestring);

  public
    constructor Create(const aBits: TBits = nil); reintroduce;

  public
    function Clone(const aDeep: boolean = True): IBitDefine;
    // Задействован при клонировании объекта
    procedure SetBits(const aBits: TBits);
  end;



implementation

{$REGION BitDefine}

constructor TBitDefine.Create(const aBits: TBits);
begin
  inherited Create;
  fBits := aBits;
end;

function TBitDefine.GetIndex: byte;
var
  I: integer;
begin
  if fBits = nil then
  begin
    fLastError := CONTAINER_IS_NIL;
    Exit;
  end;

  I := fBits.IndexOfData(Self);
  Result := fBits.Keys[I];
end;

procedure TBitDefine.SetIndex(const aIndex: byte);
var
  I: integer;
begin
  if fBits = nil then
  begin
    fLastError := CONTAINER_IS_NIL;
    Exit;
  end;

  if GetIndex = aIndex then
    Exit;

  // Для изменения ключа отключается сортировка
  fBits.Sorted := False;
  try
    // В случае дубликата возбуждается исключение
    if fBits.Find(aIndex, I) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
    // Записывается новое значение ключа
    fBits.Keys[fBits.IndexOfData(Self)] := aIndex;
  finally
    fBits.Sorted := True;
  end;

end;

function TBitDefine.GetName: widestring;
begin
  Result := fName;
end;

procedure TBitDefine.SetName(const aName: widestring);
begin
  if not SameText(fName, aName) then
    fName := aName;
end;

function TBitDefine.GetShortDescription: widestring;
begin
  Result := fShortDescription;
end;

procedure TBitDefine.SetShortDescription(const aShortDescription: widestring);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TBitDefine.GetDescription: IDescription;
begin
  if fDescription = nil then
    fDescription := TDescription.Create as IDescription;
  Result := fDescription;
end;

function TBitDefine.GetVer: widestring;
begin
  Result := fVer;
end;

procedure TBitDefine.SetVer(const aVer: widestring);
begin
  if not SameText(fVer, aVer) then
    fVer := aVer;
end;

function TBitDefine.Clone(const aDeep: boolean): IBitDefine;
var
  ClonableDescription: IClonableDescription;
  Desc: IDescription;
begin
  Result := TBitDefine.Create as IBitDefine;
  Result.Name := GetName;
  Result.ShortDescription := GetShortDescription;
  Result.Ver := GetVer;

  Desc := GetDescription;
  case aDeep of
    True:
      if aDeep and Supports(Desc, IClonableDescription, ClonableDescription) then
        (Result as TBitDefine).fDescription := ClonableDescription.Clone;
    False:
      (Result as TBitDefine).fDescription := GetDescription;
  end;

end;

procedure TBitDefine.SetBits(const aBits: TBits);
begin
  fBits := aBits;
end;

{$ENDREGION BitDefine}


end.


unit uBitDefine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBase,
  uBaseMap,
  uDescription,
  uLibraries;

type
  TBits = specialize TBaseMap<byte, IBitDefine>;

  TBitDefine = class(TBase, IBitDefine)
  private
    fBits: TBits;
    fName: string;
    fShortDescription: string;
    fDescription: IDescription;
    fVer: string;

  private
    function GetIndex: byte;
    procedure SetIndex(const aIndex: byte);

    function GetName: string;
    procedure SetName(const aName: string);

    function GetShortDescription: string;
    procedure SetShortDescription(const aShortDescription: string);

    function GetDescription: IDescription;

    function GetVer: string;
    procedure SetVer(const aVer: string);

  public
    constructor Create(const aBits: TBits = nil); reintroduce;
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

function TBitDefine.GetName: string;
begin
  Result := fName;
end;

procedure TBitDefine.SetName(const aName: string);
begin
  if not SameText(fName, aName) then
    fName := aName;
end;

function TBitDefine.GetShortDescription: string;
begin
  Result := fShortDescription;
end;

procedure TBitDefine.SetShortDescription(const aShortDescription: string);
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

function TBitDefine.GetVer: string;
begin
  Result := fVer;
end;

procedure TBitDefine.SetVer(const aVer: string);
begin
  if not SameText(fVer, aVer) then
    fVer := aVer;
end;

{$ENDREGION BitDefine}


end.

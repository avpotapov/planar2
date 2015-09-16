unit uPickItem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uLibraries,
  uBase,
  uDescription,
  uPickList;

type

  { TPickItem }

  TPickItem = class(TBase, IPickItem)
  private
    fPickList: TPickList;
    fName: string;
    fShortDescription: string;
    fDescription: IDescription;
    fVer: string;
  private
    function GetValue: word;
    procedure SetValue(const aValue: word);

    function GetName: string;
    procedure SetName(const aName: string);

    function GetShortDescription: string;
    procedure SetShortDescription(const aShortDescription: string);

    function GetDescription: IDescription;

    function GetVer: string;
    procedure SetVer(const aVer: string);

  public
    constructor Create(const aPickList: TPickList = nil); reintroduce;

  end;

implementation

{$REGION PickItem}

constructor TPickItem.Create(const aPickList: TPickList);
begin
  inherited Create;
  fPickList := aPickList;
end;

function TPickItem.GetValue: word;
begin
  if fPickList = nil then
  begin
    fLastError := CONTAINER_IS_NIL;
    Exit;
  end;

  if fPickList <> nil then
    Result := fPickList.Keys[fPickList.IndexOfData(Self)];
end;

procedure TPickItem.SetValue(const aValue: word);
var
  I: integer;
begin
  if fPickList = nil then
  begin
    fLastError := CONTAINER_IS_NIL;
    Exit;
  end;

  if GetValue = aValue then
    Exit;

  // Для изменения ключа отключаем сортировку
  fPickList.Sorted := False;
  try
    // В случае дубликата возбуждается исключение
    if fPickList.Find(aValue, I) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
    // Записывается новое значение ключа
    fPickList.Keys[fPickList.IndexOfData(Self)] := aValue;
  finally
    fPickList.Sorted := True;
  end;
end;

function TPickItem.GetName: string;
begin
  Result := fName;
end;

procedure TPickItem.SetName(const aName: string);
begin
  if not SameText(fName, aName) then
    fName := aName;
end;

function TPickItem.GetShortDescription: string;
begin
  Result := fShortDescription;
end;

procedure TPickItem.SetShortDescription(const aShortDescription: string);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TPickItem.GetDescription: IDescription;
begin
  if fDescription = nil then
    fDescription := TDescription.Create as IDescription;
  Result := fDescription;
end;

function TPickItem.GetVer: string;
begin
  Result := fVer;
end;

procedure TPickItem.SetVer(const aVer: string);
begin
  if not SameText(fVer, aVer) then
    fVer := aVer;
end;

{$ENDREGION PickItem}

end.


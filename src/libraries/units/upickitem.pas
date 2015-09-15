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
  public
    property Value: word read GetValue write SetValue;
    property Name: string read GetName write SetName;
    property ShortDescription: string read GetShortDescription write SetShortDescription;
    property Description: IDescription read GetDescription;
    property Ver: string read GetVer write SetVer;
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
  if fPickList <> nil then
    Result := fPickList.Keys[fPickList.IndexOfData(Self)];
end;

procedure TPickItem.SetValue(const aValue: word);
var
  I: integer;
begin
  if Value = aValue then
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


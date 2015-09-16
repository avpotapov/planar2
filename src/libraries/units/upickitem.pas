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

  TPickItem = class(TBase, IPickItem, IClonedPickItem)
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
    procedure SetDescription(const aDescription: IDescription);

    function GetVer: string;
    procedure SetVer(const aVer: string);

  public
    constructor Create(const aPickList: TPickList = nil); reintroduce;
  public
    function Clone(const aDeep: boolean = True): IPickItem;

    // Задействован при клонировании объекта
    procedure SetPickList(const aPickList: TPickList);
  end;

implementation

{$REGION PickItem}

constructor TPickItem.Create(const aPickList: TPickList);
begin
  inherited Create;
  fPickList := aPickList;
end;

function TPickItem.Clone(const aDeep: boolean): IPickItem;
var
  ClonedDescription: IClonedDescription;
  Desc: IDescription;
begin
  Result := TPickItem.Create as IPickItem;
  Result.Name := GetName;
  Result.ShortDescription := GetShortDescription;
  Result.Ver := GetVer;

  Desc := GetDescription;
  case aDeep of
    True:
      if aDeep and Supports(Desc, IClonedDescription, ClonedDescription) then
        Result.Description := ClonedDescription.Clone;
    False:
      Result.Description := GetDEscription;
  end;

end;

procedure TPickItem.SetPickList(const aPickList: TPickList);
begin
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

procedure TPickItem.SetDescription(const aDescription: IDescription);
begin
  if fDescription <> aDescription then
    fDescription := aDescription;
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



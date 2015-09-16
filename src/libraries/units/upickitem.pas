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

  TPickItem = class(TBase, IPickItem, IClonablePickItem)
  private
    fPickList: TPickList;
    fName: widestring;
    fShortDescription: widestring;
    fDescription: IDescription;
    fVer: widestring;
  private
    function GetValue: word;
    procedure SetValue(const aValue: word);

    function GetName: widestring;
    procedure SetName(const aName: widestring);

    function GetShortDescription: widestring;
    procedure SetShortDescription(const aShortDescription: widestring);

    function GetDescription: IDescription;

    function GetVer: widestring;
    procedure SetVer(const aVer: widestring);

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
  ClonableDescription: IClonableDescription;
  Desc: IDescription;
begin
  Result := TPickItem.Create as IPickItem;
  Result.Name := GetName;
  Result.ShortDescription := GetShortDescription;
  Result.Ver := GetVer;

  Desc := GetDescription;
  case aDeep of
    True:
      if aDeep and Supports(Desc, IClonableDescription, ClonableDescription) then
        (Result as TPickItem).fDescription := ClonableDescription.Clone;
    False:
       (Result as TPickItem).fDescription := GetDEscription;
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

function TPickItem.GetName: widestring;
begin
  Result := fName;
end;

procedure TPickItem.SetName(const aName: widestring);
begin
  if not SameText(fName, aName) then
    fName := aName;
end;

function TPickItem.GetShortDescription: widestring;
begin
  Result := fShortDescription;
end;

procedure TPickItem.SetShortDescription(const aShortDescription: widestring);
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

function TPickItem.GetVer: widestring;
begin
  Result := fVer;
end;

procedure TPickItem.SetVer(const aVer: widestring);
begin
  if not SameText(fVer, aVer) then
    fVer := aVer;
end;

{$ENDREGION PickItem}

end.



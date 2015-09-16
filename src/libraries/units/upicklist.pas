unit uPickList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uLibraries,
  uBaseMap;

type
  TPickLists = specialize TBaseMap<widestring, IPickList>;
  TPickListSpec = specialize TBaseMap<word, IPickItem>;

  { TPickList }

  TPickList = class(TPickListSpec, IPickList, IClonablePickList)
  private
    fPickLists: TPickLists;
    fName: widestring;
    fShortDescription: widestring;
  protected
    function GetName: widestring;
    procedure SetName(const aName: widestring);
    function GetShortDescription: widestring;
    procedure SetShortDescription(const aShortDescription: widestring);
  public
    function Clone(const aDeep: boolean = True): IPickList;
    constructor Create(const aPickLists: TPickLists = nil); overload;
  public
    function Add(const AKey: TKey): integer; reintroduce;
  end;


implementation

uses uPickItem;

{$REGION PickList}

function TPickList.GetName: widestring;
var
  FoundIndex: integer;
begin
  Result := fName;
  if fPickLists = nil then
    Exit;

  FoundIndex := fPickLists.IndexOfData(Self as IPickList);
  if FoundIndex < 0 then
    Exit;
  Result := fPickLists.Keys[FoundIndex];
end;

procedure TPickList.SetName(const aName: widestring);
var
  I: integer;
begin
  if fPickLists = nil then
    Exit;

  if SameText(GetName, aName) then
    Exit;

  // Для изменения ключа отключается сортировка
  fPickLists.Sorted := False;
  try
    // В случае дубликата возбуждается исключение
    if fPickLists.Find(aName, I) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
    // Записывается новое значение ключа
    fPickLists.Keys[fPickLists.IndexOfData(Self)] := aName;
    fName := aName;
  finally
    fPickLists.Sorted := True;
  end;
end;

function TPickList.GetShortDescription: widestring;
begin
  Result := fShortDescription;
end;

procedure TPickList.SetShortDescription(const aShortDescription: widestring);
begin
  fShortDescription := aShortDescription;
end;

function TPickList.Clone(const aDeep: boolean): IPickList;
var
  Ptr: Pointer;
  ClonablePickItem: IClonablePickItem;
  PickItem: IPickItem;
begin
  Result := TPickList.Create(fPickLists) as IPickList;
  for Ptr in Self do
  begin
    case aDeep of
      True:
        if Supports(ExtractData(Ptr), IClonablePickItem, ClonablePickItem) then
        begin
          PickItem := ClonablePickItem.Clone(aDeep);
          (PickItem as TPickItem).SetPickList(Result as TPickList);
        end;
      False:
        PickItem := ExtractData(Ptr);
    end;
    Result.Add(ExtractKey(Ptr), PickItem);
  end;
end;

constructor TPickList.Create(const aPickLists: TPickLists);
begin
  inherited Create;
  fPicklists := aPicklists;
end;

function TPickList.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Result := -1;
    Exit;
  end;
  Result := (Self as TPickListSpec).Add(AKey, TPickItem.Create(Self) as IPickItem);

end;

{$ENDREGION PickList}

end.


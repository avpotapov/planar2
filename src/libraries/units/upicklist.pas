unit uPickList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uLibraries,
  uFglExtCls;

type
  TPickLists = specialize TFpgMapExt<string, IPickList>;
  TPickListSpec = specialize TFpgMapExt<word, IPickItem>;

  { TPickList }

  TPickList = class(TPickListSpec, IPickList, IBase)
  private
    fLastError: Integer;
   	fPickLists: TPickLists;
    fName: string;
    fShortDescription: string;
  protected
    function GetName: string;
    procedure SetName(const aName: string);

    function GetShortDescription: String;
    procedure SetShortDescription(const aShortDescription: String);
  public
    constructor Create(const aPickLists: TPickLists = nil); overload;
    function GetLastError: integer;
   public
    function Add(const AKey: TKey): Integer; reintroduce;
    property Name: string read GetName write SetName;
    property ShortDescription: String read GetShortDescription write SetShortDescription;
  end;


implementation

uses uPickItem;

{$REGION PickList}

function TPickList.GetName: string;
var
  FoundIndex: Integer;
begin
  Result := fName;
  if fPickLists = nil then
    Exit;

  FoundIndex := fPickLists.IndexOfData(Self as IPickList);
  if FoundIndex < 0 then
    Exit;
  Result := fPickLists.Keys[FoundIndex];
end;

procedure TPickList.SetName(const aName: string);
var
  I: Integer;
begin
  if fPickLists = nil then
    Exit;

  if SameText(GetName,  aName) then
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

function TPickList.GetShortDescription: String;
begin
	Result := fShortDescription;
end;

procedure TPickList.SetShortDescription(const aShortDescription: String);
begin
	fShortDescription := aShortDescription;
end;

constructor TPickList.Create(const aPickLists: TPickLists);
begin
  inherited Create;
  fPicklists := aPicklists;
end;

function TPickList.GetLastError: integer;
begin
    Result := fLastError;
end;


function TPickList.Add(const AKey: TKey): Integer;
var
  FoundIndex: Integer;
begin
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Result     := -1;
    Exit;
  end;
  Result := (Self as TPickListSpec).Add(AKey, TPickItem.Create(Self) as IPickItem);

end;

{$ENDREGION PickList}

end.


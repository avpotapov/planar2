unit uPickLists;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBaseMap,
  uPreSets,
  uLibraries;

type
  TPickListsSpec = specialize TBaseMap<WideString, IPickList>;

  TPickLists = class(TPickListsSpec, IPickLists)
  private
    fPreSets: TPreSets;
  protected
    function GetPreSets: IPreSets;
  public
    function Add(const AKey: TKey): integer; reintroduce;
  public
    constructor Create(const aPreSets: TPreSets = nil); reintroduce;
  end;


implementation

uses
  uPickList;

{$REGION PickLists}

function TPickLists.GetPreSets: IPreSets;
begin
  Result := fPreSets;
end;

function TPickLists.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  Result := -1;
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Exit;
  end;
  Result := (Self as TPickListsSpec).Add(AKey, TPickList.Create(Self) as IPickList);

end;

constructor TPickLists.Create(const aPreSets: TPreSets);
begin
  inherited Create;
  fPreSets := aPreSets;
end;

{$ENDREGION PickLists}
end.

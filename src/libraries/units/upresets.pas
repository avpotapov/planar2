unit uPreSets;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uLibraries,
  uBase,
  uModule;

type

  TPreSets = class(TBase, IPreSets)
  private
    fModule: TModule;
    fPickLists: IPickLists;
    fBitsSet: IBitsSet;
  protected
    function GetPickLists: IPickLists;
    function GetBitsSet: IBitsSet;
    function GetModule: IModule;
  public
    constructor Create(const aModule: TModule = nil); reintroduce;
  end;

implementation

uses
  uPickLists,
  uBitsSet;

{$REGION PreSets}

constructor TPreSets.Create(const aModule: TModule);
begin
  inherited Create;
  fModule := aModule;
end;

function TPreSets.GetPickLists: IPickLists;
begin
  if fPickLists = nil then
    fPickLists := TPickLists.Create;
  Result := fPickLists;
end;

function TPreSets.GetBitsSet: IBitsSet;
begin
  if fBitsSet = nil then
    fBitsSet := TBitsSet.Create;
  Result := fBitsSet;
end;

function TPreSets.GetModule: IModule;
begin
  Result := fModule;
end;

{$ENDREGION PreSets}

end.


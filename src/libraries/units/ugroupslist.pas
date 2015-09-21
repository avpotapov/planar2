unit uGroupsList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uLibraries,
  uFglExtCls,
  uGroups,
  uBaseList;

type
  TGroupsListSpec = specialize TBaseList<IGroups>;

  { TGroupsList }

  TGroupsList = class(TGroupsListSpec, IGroupsList)
  type
    TListEnumeratorSpec = specialize TFpgListEnumeratorExt<IGroups>;
  private
  	fParentGroups: TGroups;
  public
    function GetEnumerator: IGroupsListEnumeratorSpec;
    function AddGroups(const aShortDescription: WideString = ''): Integer;
    function Find(const aShortDescription: WideString): Integer;
		function GetParentGroups: IGroups;
	public
		constructor Create(const aGroups: TGroups = nil); reintroduce;
  end;
implementation
uses
  uModule;

{$REGION GroupsList }

function TGroupsList.GetEnumerator: IGroupsListEnumeratorSpec;
begin
  Result := TListEnumeratorSpec.Create(Self) as IGroupsListEnumeratorSpec;
end;

function TGroupsList.AddGroups(const aShortDescription: WideString): Integer;
begin
  Result := Add(TGroups.Create(fParentGroups.Module as TModule, fParentGroups, aShortDescription));
end;

function TGroupsList.Find(const aShortDescription: WideString): Integer;
var
  I: Integer;
begin
  Result := -1;
  if aShortDescription = '' then
  begin
    fLastError := ARGUMENT_ISEMPTY;
    Exit;
  end;
  for I := 0 to Count - 1 do
    if SameText(Items[I].ShortDescription, aShortDescription) then
    begin
      Result := I;
      Exit;
    end;

end;

function TGroupsList.GetParentGroups: IGroups;
begin
  Result := fParentGroups;
end;

constructor TGroupsList.Create(const aGroups: TGroups);
begin
  inherited Create;
  fParentGroups := aGroups;
end;

{$ENDREGION GroupsList }

end.


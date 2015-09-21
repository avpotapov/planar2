unit uGroups;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBase,
  uLibraries,
  uModule;

type

  { TGroups }

  TGroups = class(TBase, IGroups)
  private
    fModule: TModule;
    fParentGroups: TGroups;

    fShortDescription: WideString;
    fGroupsList: IGroupsList;
    fGroup: IGroup;
  protected
    function GetGroupsList: IGroupsList;
    function GetGroup: IGroup;

    function GetShortDescription:WideString;
    procedure SetShortDescription(const aShortDescription: WideString);

    function GetModule: IModule;

    function GetParentGroups: IGroups;
  public
    constructor Create(const aModule: TModule; const aGroups: TGroups; const aShortDescription: WideString); overload;
    constructor Create(const aModule: TModule); overload;

    property Module: IModule read GetModule;
  end;


implementation

uses
  uGroupsList,
  uGroup;

{$REGION Groups}

function TGroups.GetGroupsList: IGroupsList;
begin
  if fGroupsList = nil then
    fGroupsList := TGroupsList.Create(Self) as IGroupsList;
  Result := fGroupsList;
end;

function TGroups.GetGroup: IGroup;
begin
  if fGroup = nil then
    fGroup := TGroup.Create(Self) as IGroup;
  Result := fGroup;
end;

function TGroups.GetShortDescription: WideString;
begin
  Result := fShortDescription;
end;

procedure TGroups.SetShortDescription(const aShortDescription: WideString);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TGroups.GetModule: IModule;
begin
	Result := fModule;
end;

function TGroups.GetParentGroups: IGroups;
begin
  Result := fParentGroups;
end;

constructor TGroups.Create(const aModule: TModule; const aGroups: TGroups;
  const aShortDescription: WideString);
begin
  inherited Create;
  fModule := aModule;
  fParentGroups := aGroups;
  fShortDescription := aShortDescription;
end;

constructor TGroups.Create(const aModule: TModule);
begin
	inherited Create;
  fModule := aModule;
end;

{$ENDREGION Groups}

end.


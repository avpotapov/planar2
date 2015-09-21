unit uModule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBase,
  uModuleDefine,
  uLibraries;

type

  TModule = class(TBase, IModule)
  private
    fModuleDefine: TModuleDefine;
    fDescription: IBaseDescription;
    fRegisters: IRegisters;
    fPreSets: IPreSets;
    fConfiguration: IGroups;
  protected
    function GetModuleDefine: IModuleDefine;
    function GetDescription: IBaseDescription;
    function GetRegisters: IRegisters;
    function GetPreSets: IPreSets;
    function GetConfiguration: IGroups;
  public
    constructor Create(const aModuleDefine: TModuleDefine = nil); reintroduce;
  end;

implementation

uses
  uBaseDescription,
  uRegisters,
  uPreSets,
  uGroups;

{$REGION Module}

function TModule.GetModuleDefine: IModuleDefine;
begin
  Result := fModuleDefine as IModuleDefine;
end;

function TModule.GetDescription: IBaseDescription;
begin
  if fDescription = nil then
    fDescription := TBaseDescription.Create(Self) as IBaseDescription;
  Result := fDescription;
end;

function TModule.GetRegisters: IRegisters;
begin
  if fRegisters = nil then
    fRegisters := TRegisters.Create(Self) as IRegisters;
  Result := fRegisters;
end;

function TModule.GetPreSets: IPreSets;
begin
  if fPreSets = nil then
    fPreSets := TPreSets.Create(Self) as IPreSets;
  Result := fPreSets;

end;

function TModule.GetConfiguration: IGroups;
begin
  if fConfiguration = nil then
    fConfiguration := TGroups.Create(Self);
  Result := fConfiguration;
end;

constructor TModule.Create(const aModuleDefine: TModuleDefine);
begin
  inherited Create;
  fModuleDefine := aModuleDefine;
end;

{$ENDREGION Module}

end.



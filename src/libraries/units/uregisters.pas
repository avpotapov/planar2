unit uRegisters;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uDefs,
  uBase,
  uModule,
  uLibraries;

type

  { TRegisters }

  TRegisters = class(TBase, IRegisters)
    type
    TAllRegisters = array [TTypeRegister] of IVars;
  private
    fModule: TModule;
    fAllRegisters: TAllRegisters;
  protected
    function GetVars(aTypeRegister: TTypeRegister): IVars;
    function GetModule: IModule;
  public
    constructor Create(const aModule: TModule = nil); reintroduce;
  end;

implementation

uses
  uVars;

{$REGION Registers}

function TRegisters.GetVars(aTypeRegister: TTypeRegister): IVars;
begin
  if fAllRegisters[aTypeRegister] = nil then
    fAllRegisters[aTypeRegister] := TVars.Create(aTypeRegister, Self);
  Result := fAllRegisters[aTypeRegister];
end;

function TRegisters.GetModule: IModule;
begin
  Result := fModule as IModule;
end;

constructor TRegisters.Create(const aModule: TModule);
begin
  inherited Create;
  fModule := aModule;
end;

{$ENDREGION Registers}

end.


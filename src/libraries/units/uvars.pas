unit uVars;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uDefs,
  uRegisters,
  uBaseMap,
  uLibraries;

type
  TVarsSpec = specialize TBaseMap<WideString, IVarDefine>;

  TVars = class(TVarsSpec, IVars)
  private
    fRegisters: TRegisters;
    fTypeRegister: TTypeRegister;
  protected
    function GetTypeRegister: TTypeRegister;
    function GetRegisters: IRegisters;
  public
    constructor Create(aTypeRegister: TTypeRegister = TTypeRegister.trHolding;
      const aRegisters: TRegisters = nil); reintroduce;
  public
    function Add(const AKey: TKey): integer; reintroduce;
    property TypeRegister: TTypeRegister read GetTypeRegister;
  end;

implementation

uses
  uVarDefine;

{$REGION Vars}

function TVars.GetTypeRegister: TTypeRegister;
begin
  Result := fTypeRegister;
end;

function TVars.GetRegisters: IRegisters;
begin
  Result := nil;
  if fRegisters <> nil then
    Result := fRegisters as IRegisters;
end;

constructor TVars.Create(aTypeRegister: TTypeRegister; const aRegisters: TRegisters);
begin
  inherited Create;
  fTypeRegister := aTypeRegister;
  fRegisters := aRegisters;
end;

function TVars.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  Result := -1;
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Exit;
  end;
  Result := (Self as TVarsSpec).Add(AKey, TVarDefine.Create(Self) as IVarDefine);
end;

{$ENDREGION Vars}
end.

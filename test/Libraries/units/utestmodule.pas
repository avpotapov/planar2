unit utestmodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uLibraries, uModule, uDefs, fpcunit, testutils,
  testregistry;

type

  TTestModule= class(TTestCase)
  private
    fModule: IModule;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
  end;

implementation

procedure TTestModule.TestInstance;
var
  Module: IModule;
begin
  AssertTrue(fModule <> nil);
  fModule.Description.Description.Add('1');
  fModule.Description.Description.Add('1');
  fModule.Description.Description.Add('1');
  fModule.Description.Description.Add('1');
  AssertTrue(fModule = fModule.Description.Module);
  fModule.Description.Module.Registers[TTypeRegister.trHolding];
end;

procedure TTestModule.SetUp;
begin
	fModule := TModule.Create as IModule;
end;


initialization

  RegisterTest(TTestModule);
end.


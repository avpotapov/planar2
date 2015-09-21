unit utestregisters;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uLibraries, uRegisters, uDefs, fpcunit, testutils,
  testregistry;

type

  { TTestRegisters }

  TTestRegisters= class(TTestCase)
  private
    fRegisters: IRegisters;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
  end;

implementation

procedure TTestRegisters.TestInstance;
begin
  AssertTrue(fRegisters <> nil);
  AssertTrue(fRegisters[TTypeRegister.trHolding] <> nil);
  AssertTrue(fRegisters[TTypeRegister.trInput] <> nil);

end;


procedure TTestRegisters.SetUp;
begin
	fRegisters := TRegisters.Create;
end;


initialization
  RegisterTest(TTestRegisters);
end.


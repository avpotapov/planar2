unit utestvars;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uLibraries, uVars, fpcunit, testutils, testregistry;

type

  { TTestVars }

  TTestVars= class(TTestCase)
  private
    fVars: IVars;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestAdd;
  end;

implementation

procedure TTestVars.TestInstance;
begin
  AssertTrue(fVars <> nil);
end;

procedure TTestVars.TestAdd;
var
  I: Integer;
begin
  I := fVars.Add('1');
  if I >= 0 then
  	fVars['1'].Name := 'Test1';
  I := fVars.Add('2');
  if I >= 0 then
  	fVars['2'].Name := 'Test2';
  I := fVars.Add('3');
  if I >= 0 then
  	fVars['3'].Name := 'Test3';

  I := fVars.Add('3');
  if I >= 0 then
  	fVars['3'].Name := 'Test3';
  AssertEquals(fVars.Count, 3);
end;

procedure TTestVars.SetUp;
begin
	fVars := TVars.Create;
end;


initialization

  RegisterTest(TTestVars);
end.


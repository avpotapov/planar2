unit uTestInterfaceFpgList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  // Тестируемый модуль
  uFglExt,
  uFglExtCls;

type

  TFpgIntegerList = specialize TFpgListExt<Integer>;
  IFpgIntegerList = specialize IFpgList<integer>;

  { TTestInterfaceFpgList }

  TTestInterfaceFpgList= class(TTestCase)
  private
    fFpgIntegerList: IFpgIntegerList;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestAdd;
    procedure TestRemove;
    procedure TestExtract;

  end;

implementation

procedure TTestInterfaceFpgList.TestInstance;
begin
	AssertTrue(fFpgIntegerList <> nil);
end;

procedure TTestInterfaceFpgList.TestAdd;
var
  I: Integer;
begin
  fFpgIntegerList.Add(1);
  fFpgIntegerList.Add(2);
  fFpgIntegerList.Add(3);
  fFpgIntegerList.Add(4);
  fFpgIntegerList.Add(5);
  fFpgIntegerList.Add(6);
  AssertEquals(fFpgIntegerList.Count, 6);

  Writeln('Added Values to List');
  Writeln('Test Enumerator ...');

  for I in fFpgIntegerList do
  	Writeln(I);
  Writeln('-');

  Writeln('Repeat test Enumerator ...');
  for I in fFpgIntegerList do
  	Writeln(I);
  Writeln('-');

end;

procedure TTestInterfaceFpgList.TestRemove;
var
  I: Integer;
begin
  fFpgIntegerList.Add(1);
  fFpgIntegerList.Add(2);
  fFpgIntegerList.Add(3);
  fFpgIntegerList.Add(4);
  fFpgIntegerList.Add(5);
  fFpgIntegerList.Add(6);
  AssertEquals(fFpgIntegerList.Count, 6);

  Writeln('Added Values to List');
  for I in fFpgIntegerList do
  	Writeln(I);
  Writeln('-');

  Writeln('Removed ''5'' from List');
  AssertEquals(fFpgIntegerList.Remove(5), 4);

  Writeln('Values in List');
  for I in fFpgIntegerList do
  	Writeln(I);
  Writeln('-');
end;

procedure TTestInterfaceFpgList.TestExtract;
var
  I: Integer;
begin
  fFpgIntegerList.Add(1);
  fFpgIntegerList.Add(2);
  fFpgIntegerList.Add(3);
  fFpgIntegerList.Add(4);
  fFpgIntegerList.Add(5);
  fFpgIntegerList.Add(6);
  AssertEquals(fFpgIntegerList.Count, 6);

  Writeln('Added Values to List');
  for I in fFpgIntegerList do
  	Writeln(I);
  Writeln('-');

  Writeln('Extracted ''5'' from List');
  AssertEquals(fFpgIntegerList.Extract(5), 5);

  Writeln('Values in List');
  for I in fFpgIntegerList do
  	Writeln(I);
  Writeln('-');

end;

procedure TTestInterfaceFpgList.SetUp;
begin
	fFpgIntegerList := TFpgIntegerList.Create;
end;


initialization
  RegisterTest(TTestInterfaceFpgList);
end.


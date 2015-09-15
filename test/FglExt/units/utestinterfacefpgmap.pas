unit utestinterfacefpgmap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
   // Тестируемый модуль
  uFglExt,
  uFglExtCls;

type

  TFpgSIMap = specialize TFpgMapExt<string, Integer>;
  IFpgSIMap = specialize IFpgMap<string, integer>;

  { TTestInterfaceFpgMap }

  TTestInterfaceFpgMap= class(TTestCase)
  private
    fSIMap: IFpgSIMap;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestAdd;
    procedure TestRemove;
    procedure TestDuplicates;
  end;

implementation

procedure TTestInterfaceFpgMap.TestInstance;
begin
	AssertTrue(fSIMap <> nil);
end;

procedure TTestInterfaceFpgMap.TestAdd;
var
  Ptr: Pointer;
begin
  fSIMap.Add('first', 1);
  fSIMap.Add('second', 2);
  fSIMap.Add('third', 3);
  fSIMap.Add('fourth', 4);

  AssertEquals(fSIMap.Count, 4);

  Writeln('Added Keys to Map');
  Writeln('Test Enumerator ...');
  for Ptr in fSIMap do
     Writeln(fSIMap.ExtractKey(Ptr));
  Writeln('-');

  Writeln('Added Data to Map');
  for Ptr in fSIMap do
     Writeln(fSIMap.ExtractData(Ptr));
  Writeln('-');

end;

procedure TTestInterfaceFpgMap.TestRemove;
var
  Ptr: Pointer;
begin
  fSIMap.Add('first', 1);
  fSIMap.Add('second', 2);
  fSIMap.Add('third', 3);
  fSIMap.Add('fourth', 4);

  AssertEquals(fSIMap.Count, 4);

  Writeln('Remove second');
  fSIMap.Remove('second');

  AssertEquals(fSIMap.Count, 3);

  Writeln('Keys in Map');
  for Ptr in fSIMap do
     Writeln(fSIMap.ExtractKey(Ptr));
  Writeln('-');

  Writeln('Data in Map');
  for Ptr in fSIMap do
     Writeln(fSIMap.ExtractData(Ptr));
  Writeln('-');


end;

procedure TTestInterfaceFpgMap.TestDuplicates;
var
  Ptr: Pointer;
begin
  fSIMap.Add('first', 1);
  fSIMap.Add('second', 2);
  fSIMap.Add('third', 3);
  fSIMap.Add('fourth', 4);
  AssertEquals(fSIMap.Count, 4);
  fSIMap.Add('third', 3);
  AssertEquals(fSIMap.Count, 5);
  fSIMap.Clear;

  fSIMap.Duplicates := TDuplicates.dupIgnore;
  fSIMap.Add('first', 1);
  fSIMap.Add('second', 2);
  fSIMap.Add('third', 3);
  fSIMap.Add('fourth', 4);
  AssertEquals(fSIMap.Count, 4);
  fSIMap.Add('third', 3);
  AssertEquals(fSIMap.Count, 4);

  Writeln('Keys in Map');
  for Ptr in fSIMap do
     Writeln(fSIMap.ExtractKey(Ptr));
  Writeln('-');

end;

procedure TTestInterfaceFpgMap.SetUp;
begin
  fSIMap := TFpgSIMap.Create;
end;


initialization

  RegisterTest(TTestInterfaceFpgMap);
end.


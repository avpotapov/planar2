unit utestvardefine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFglExt, uLibraries, uVarDefine, fpcunit, testregistry;

type

  { TTestVarDefine }

  TTestVarDefine= class(TTestCase)
  private
    fVarDefine: IVarDefine;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestAdd;
    procedure TestClone;
  end;

implementation

procedure TTestVarDefine.TestInstance;
begin
  AssertTrue(fVarDefine <> nil);
end;

procedure TTestVarDefine.TestAdd;
var
  I: Integer;
  Bit: IBitDefine;
  Bits: IBits;
begin
  fVarDefine.Name := 'VarDefine1';
  fVarDefine.Description.Add('Description1');
  fVarDefine.Description.Add('Description2');
  fVarDefine.Description.Add('Description3');
  Bits := fVarDefine.Bits;
  I := Bits.Add(10);
  if I <> -1 then
  begin
  	Bit := fVarDefine.Bits.Data[I];
    Bit.Name := 'Bit1';
    Bit.Description.Add('Description1')
  end;

  AssertEquals(fVarDefine.Name, 'VarDefine1');
  AssertEquals(fVarDefine.Description.Count, 3);

  AssertEquals(fVarDefine.Bits[10].Description.Count, 1);



end;

procedure TTestVarDefine.TestClone;
var
  I: Integer;
  Bit: IBitDefine;
  Bits: IBits;
  ClonableVarDefine: IClonableVarDefine;
  VarDefine: IVarDefine;
begin
  fVarDefine.Name := 'VarDefine1';
  fVarDefine.Description.Add('Description1');
  fVarDefine.Description.Add('Description2');
  fVarDefine.Description.Add('Description3');
  Bits := fVarDefine.Bits;
  I := Bits.Add(10);
  if I <> -1 then
  begin
  	Bit := fVarDefine.Bits.Data[I];
    Bit.Name := 'Bit1';
    Bit.Description.Add('Description1')
  end;
  Supports(fVarDefine, IClonableVarDefine, ClonableVarDefine);
  VarDefine := ClonableVarDefine.Clone;
  AssertTrue(VarDefine <> nil);
  AssertEquals(VarDefine.Name, 'VarDefine1');
  AssertEquals(VarDefine.Description.Count, 3);

  AssertEquals(VarDefine.Bits[10].Description.Count, 1);


end;

procedure TTestVarDefine.SetUp;
begin
	fVarDefine := TVarDefine.Create;
end;


initialization

  RegisterTest(TTestVarDefine);
end.


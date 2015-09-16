unit utestdescription;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uLibraries, uDescription, fpcunit, testregistry;

type

  ICloneSpec = specialize IClonable<IDescription>;

  { TTestDescription }

  TTestDescription= class(TTestCase)
  private
    fDescription: IDescription;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestClone;
  end;

implementation

procedure TTestDescription.TestInstance;
begin
  AssertTrue(fDescription <> nil);
end;

procedure TTestDescription.TestClone;
var
  Clone: ICloneSpec;
  Desc: IDescription;
  S: widestring;
begin
  fDescription.Add('String 1');
  fDescription.Add('String 2');
  fDescription.Add('String 3');
  fDescription.Add('String 4');
  if Supports(fDescription, ICloneSpec, Clone) then
  	Desc := Clone.Clone;
  fDescription.Clear;

  AssertTrue(Desc <> nil);
  AssertEquals(fDescription.Count, 0);
  AssertEquals(Desc.Count, 4);

  Writeln('Cloned Description');
  for S in Desc do
  	Writeln(S);
  Writeln('-');

end;

procedure TTestDescription.SetUp;
begin
	fDescription := TDescription.Create as IDescription;
end;


initialization

  RegisterTest(TTestDescription);
end.


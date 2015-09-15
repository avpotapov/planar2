unit uTestPickItem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  uLibraries, uPickItem;

type

  { TTestPickItem }

  TTestPickItem= class(TTestCase)
  private
    fPickItem: IPickItem;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestFilling;
  end;

implementation


procedure TTestPickItem.TestInstance;
begin
	AssertTrue(fPickItem <> nil);
end;

procedure TTestPickItem.TestFilling;
var
  S: string;
begin
  fPickItem.Name := 'PickItem';
  fPickItem.ShortDescription := 'Description PickItem';
  fPickItem.Ver := '1.0';
  fPickItem.Description.Add('PickItem Description 1');
  fPickItem.Description.Add('PickItem Description 2');
  fPickItem.Description.Add('PickItem Description 3');
  fPickItem.Description.Add('PickItem Description 4');
  AssertEquals(fPickItem.Description.Count, 4);

  AssertEquals(fPickItem.Name, 'PickItem');
  AssertEquals(fPickItem.ShortDescription, 'Description PickItem');
  AssertEquals(fPickItem.Ver,  '1.0');

  for S in  fPickItem.Description do
  	Writeln(S);
end;

procedure TTestPickItem.SetUp;
begin
	fPickItem := TPickItem.Create();
end;


initialization

  RegisterTest(TTestPickItem);
end.


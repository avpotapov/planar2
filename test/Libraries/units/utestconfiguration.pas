unit utestconfiguration;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uLibraries, uGroup, uGroupItem, uGroups, uGroupsList,
  fpcunit, testutils, testregistry;

type

  { TTestConfiguration }

  TTestConfiguration= class(TTestCase)
  private
    fC: IGroups;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestAddGroups;
    procedure TestAddGroupItem;
  end;

implementation

procedure TTestConfiguration.TestInstance;
begin
  AssertTrue(fC <> nil);
end;

procedure TTestConfiguration.TestAddGroupItem;

begin
	fC.Group.AddGroupItem(nil);
  fC.Group.Last.ImageIndex := 1;
 	fC.Group.AddGroupItem(nil);
  fC.Group.Last.ImageIndex := 2;
 	fC.Group.AddGroupItem(nil);
  fC.Group.Last.ImageIndex := 3;
	fC.Group.AddGroupItem(nil);
  fC.Group.Last.ImageIndex := 4;
  AssertEquals(fC.Group.Count, 1);


end;

procedure TTestConfiguration.TestAddGroups;
var
  G: IGroups;
begin
  fC.GroupsList.AddGroups('test1');
  Assert(fC.GroupsList <> nil);
  AssertEquals(fC.GroupsList.Count , 1);
  fC.GroupsList.AddGroups('test2');
  fC.GroupsList.AddGroups('test3');
  AssertEquals(fC.GroupsList.Count , 3);
  AssertTrue(fC.GroupsList.ParentGroups = fC);
  AssertTrue(fC.GroupsList[0].ParentGroups = fC);
  Writeln('Groups ------');
  for G in fC.GetGroupsList do
  	Writeln(G.ShortDescription);
  Writeln('Groups ------');
end;

procedure TTestConfiguration.SetUp;
begin
	fC := TGroups.Create(nil);
end;


initialization

  RegisterTest(TTestConfiguration);
end.


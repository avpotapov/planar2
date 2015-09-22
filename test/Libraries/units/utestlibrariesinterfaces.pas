unit uTestLibrariesInterfaces;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  uLibraries,
  uDefs;

type

  TTestLibrariesInterface= class(TTestCase)
  private
    L: ILibraries;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestCreateLibrary;
    procedure TestCreateModuleDefine;
    procedure TestCreateModule;
  end;

implementation

procedure TTestLibrariesInterface.TestInstance;
begin
  AssertTrue(L <> nil);
end;

procedure TTestLibrariesInterface.TestCreateLibrary;
begin
  AssertTrue(L[TTypeLibrary.tlVerdor] <> nil);
  AssertTrue(L[TTypeLibrary.tlCustom] <> nil);
end;

procedure TTestLibrariesInterface.TestCreateModuleDefine;
var
  Lbr: ILibrary;
  Idx: Integer;
begin
  Lbr := L[TTypeLibrary.tlVerdor];
  AssertTrue(Lbr <> nil);
  Idx := Lbr.Add(10);
  AssertEquals(Idx, 0);
  AssertTrue(L[TTypeLibrary.tlVerdor][10] <> nil);
  Idx := Lbr.Add(20);
  AssertEquals(Idx, 1);
  AssertTrue(L[TTypeLibrary.tlVerdor][20] <> nil);
  Idx := Lbr.Add(20);
  AssertEquals(Idx, -1);
  AssertTrue(L[TTypeLibrary.tlVerdor].Count = 2);
  Lbr.Remove(10);
  AssertTrue(L[TTypeLibrary.tlVerdor].Count = 1);
end;

procedure TTestLibrariesInterface.TestCreateModule;
var
  Lbr: ILibrary;
  Module: IModule;
  Groups: IGroups;
  Idx: Integer;
begin
  Lbr := L[TTypeLibrary.tlVerdor];
  AssertTrue(Lbr <> nil);
  Lbr.Add(10);
  AssertTrue(L[TTypeLibrary.tlVerdor][10] <> nil);
  Module := L[TTypeLibrary.tlVerdor][10].Module;
  AssertTrue(Module <> nil);
  Idx := Module.Configuration.GroupsList.AddGroups('Groups1');
  AssertEquals(Idx, 0);
  Groups := Module.Configuration.GroupsList[Idx];
  Idx := Groups.GroupsList.AddGroups('Groups1 - Groups1');
  AssertEquals(Idx, 0);
  AssertTrue(Module.Configuration.GroupsList.Count = 1);

end;

procedure TTestLibrariesInterface.SetUp;
begin
  L := GetNewLibraries;
end;


initialization

  RegisterTest(TTestLibrariesInterface);
end.


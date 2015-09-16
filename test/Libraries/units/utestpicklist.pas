unit uTestPickList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  uLibraries,
  uPickList;

type

  { TTestPickList }

  TTestPickList = class(TTestCase)
  private
    fPickList: IPickList;
  protected
    procedure SetUp; override;
  published
    procedure TestInstance;
    procedure TestAdd;
    procedure TestClone;
  end;

implementation

procedure TTestPickList.TestInstance;
begin
  AssertTrue(fPickList <> nil);
end;

procedure TTestPickList.TestAdd;
var
  I: integer;
  PickItem: IPickItem;
begin
  // Тест добавления
  I := fPickList.Add(1);
  if I > 0 then
  begin
    PickItem := fPickList.Data[I];
    PickItem.Name := 'PickItem';
    PickItem.ShortDescription := 'Description PickItem';
    PickItem.Ver := '1.0';
    PickItem.Description.Add('PickItem Description 1');
    PickItem.Description.Add('PickItem Description 2');
    PickItem.Description.Add('PickItem Description 3');
    PickItem.Description.Add('PickItem Description 4');
    AssertEquals(PickItem.Description.Count, 4);
  end;

  I := fPickList.Add(2);
  if I > 0 then
  begin
    PickItem := fPickList.Data[I];
    PickItem.Name := 'PickItem 2';
    PickItem.ShortDescription := 'Description PickItem 2';
    PickItem.Ver := '2.0';
    PickItem.Description.Add('PickItem Description 1');
    PickItem.Description.Add('PickItem Description 2');
    PickItem.Description.Add('PickItem Description 3');
    PickItem.Description.Add('PickItem Description 4');
    AssertEquals(PickItem.Description.Count, 4);
  end;

  I := fPickList.Add(1);
  if I > 0 then
  begin
    PickItem := fPickList.Data[I];
    PickItem.Name := 'PickItem 1';
    PickItem.ShortDescription := 'Description PickItem 2';
    PickItem.Ver := '2.0';
    PickItem.Description.Add('PickItem Description 1');
    PickItem.Description.Add('PickItem Description 2');
    PickItem.Description.Add('PickItem Description 3');
    PickItem.Description.Add('PickItem Description 4');
    AssertEquals(PickItem.Description.Count, 4);
  end;

  AssertEquals(fPickList.Count, 2);

end;

procedure TTestPickList.TestClone;
var
  I: integer;
  PickItem: IPickItem;
  ClonedPickList: IClonedPickList;
  PickList: IPickList;
  Ptr: Pointer;
  S: string;
begin
  // Тест добавления
  I := fPickList.Add(1);
  if I >= 0 then
  begin
    PickItem := fPickList.Data[I];
    PickItem.Name := 'PickItem';
    PickItem.ShortDescription := 'Description PickItem';
    PickItem.Ver := '1.0';
    PickItem.Description.Add('PickItem Description 1');
    PickItem.Description.Add('PickItem Description 2');
    PickItem.Description.Add('PickItem Description 3');
    PickItem.Description.Add('PickItem Description 4');
    AssertEquals(PickItem.Description.Count, 4);
  end;

  I := fPickList.Add(2);
  if I >= 0 then
  begin
    PickItem := fPickList.Data[I];
    PickItem.Name := 'PickItem 2';
    PickItem.ShortDescription := 'Description PickItem 2';
    PickItem.Ver := '2.0';
    PickItem.Description.Add('PickItem Description 1');
    PickItem.Description.Add('PickItem Description 2');
    PickItem.Description.Add('PickItem Description 3');
    PickItem.Description.Add('PickItem Description 4');
    AssertEquals(PickItem.Description.Count, 4);
  end;

  I := fPickList.Add(3);
  if I >= 0 then
  begin
    PickItem := fPickList.Data[I];
    PickItem.Name := 'PickItem 3';
    PickItem.ShortDescription := 'Description PickItem 3';
    PickItem.Ver := '2.0';
    PickItem.Description.Add('PickItem Description 1');
    PickItem.Description.Add('PickItem Description 2');
    PickItem.Description.Add('PickItem Description 3');
    PickItem.Description.Add('PickItem Description 4');
    AssertEquals(PickItem.Description.Count, 4);
  end;

  if Supports(fPickList, IClonedPickList, ClonedPickList) then
  	PickList := ClonedPickList.Clone;

  fPickList.Clear;
  AssertTrue(PickList <> nil);
  AssertEquals(PickList.Count, 3);

  Writeln('Native PickList:');
  for Ptr in fPickList do
  begin
    Writeln('Key = ', fPickList.ExtractKey(Ptr));
    PickItem := fPickList.ExtractData(Ptr);

    Writeln(' - ', PickItem.Name);
    Writeln(' - ', PickItem.ShortDescription);
    for S in PickItem.Description do
    	Writeln(' -- ', S);
  end;

  Writeln('Cloned PickList:');
  for Ptr in PickList do
  begin
    Writeln('Key = ', PickList.ExtractKey(Ptr));
    PickItem := PickList.ExtractData(Ptr);
    Writeln(' - ', PickItem.Value);
    Writeln(' - ', PickItem.Name);
    Writeln(' - ', PickItem.ShortDescription);
    for S in PickItem.Description do
    	Writeln(' -- ', S);
  end;



end;

procedure TTestPickList.SetUp;
begin
  fPickList := TPickList.Create;
end;


initialization

  RegisterTest(TTestPickList);
end.



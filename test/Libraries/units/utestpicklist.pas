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

procedure TTestPickList.SetUp;
begin
  fPickList := TPickList.Create;
end;


initialization

  RegisterTest(TTestPickList);
end.



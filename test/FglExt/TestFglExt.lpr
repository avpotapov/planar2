program TestFglExt;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, uTestInterfaceFpgList, uFglExt, uFglExtCls,
  uTestInterfaceFpgMap;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.


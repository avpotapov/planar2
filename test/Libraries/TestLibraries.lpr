program TestLibraries;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, uTestPickItem, uTestPickList;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.


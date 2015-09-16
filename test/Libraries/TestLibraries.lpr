program TestLibraries;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, uTestPickItem, uTestPickList, 
utestdescription;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.


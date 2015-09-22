program TestLibrariesInterface;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, uTestLibrariesInterfaces;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.


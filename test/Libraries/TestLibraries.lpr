program TestLibraries;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, uTestPickItem, uTestPickList,
  utestdescription, utestvardefine, uVars, utestvars, uRegisters,
  utestregisters, uModule, uModuleDefine, uLibrary, uBaseDescription,
  utestmodule, uPreSets, uPickLists, uBitsSet, uGroupItem, uGroup, uBaseList,
  uGroupsList, uGroups, utestconfiguration;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.


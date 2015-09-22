library libraries;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  ulibraries,
  uLibrariesCls,
  uFglExt,
  uFglExtCls,
  uDefs;

{$R *.res}

var
  L: ILibraries;

  function GetNewLibraries: ILibraries; export;
  begin
    if L = nil then
      L := TLibraries.Create;
    Result := L;
  end;

  function GetNewGuid: string; export;
  var
    Guid: TGuid;
    StartChar: integer;
    EndChar: integer;
    Count: integer;
  begin
    CreateGuid(Guid);
    Result := GuidToString(Guid);

    StartChar := Pos('{', Result) + 1;
    EndChar := Pos('}', Result) - 1;
    Count := EndChar - StartChar + 1;

    Result := Copy(Result, StartChar, Count);
  end;


exports
  GetNewLibraries,
  GetNewGuid;

begin
end.


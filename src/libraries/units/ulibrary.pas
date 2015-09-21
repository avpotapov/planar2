unit uLibrary;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uDefs,
  uBase,
  uBaseMap,
  uLibraries;

type

  TLibraries = class(TBase, ILibraries)
    type
    TAllLibraries = array [TTypeLibrary] of ILibrary;
  private
    fAllLibraries: TAllLibraries;
    function GetLibrary(ATypeLibrary: TTypeLibrary): ILibrary;
  public
    property AllLibraries[ATypeLibrary: TTypeLibrary]: ILibrary read GetLibrary;
  end;


  TLibrarySpec = specialize TBaseMap<word, IModuleDefine>;

  { TLibrary }

  TLibrary = class(TLibrarySpec, ILibrary)
  private
    fTypeLibrary: TTypeLibrary;
    function GetTypeLibrary: TTypeLibrary;
  public
    constructor Create(const aTypeLibrary: TTypeLibrary = TTypeLibrary.tlVerdor);
      reintroduce;
  public
    function Add(const AKey: TKey): integer; reintroduce;
    property TypeLibrary: TTypeLibrary read GetTypeLibrary;
  end;

implementation

uses
  uModuleDefine;

{$REGION Libraries}

function TLibraries.GetLibrary(ATypeLibrary: TTypeLibrary): ILibrary;
begin
  if fAllLibraries[ATypeLibrary] = nil then
    fAllLibraries[ATypeLibrary] := TLibrary.Create(ATypeLibrary);
  Result := fAllLibraries[ATypeLibrary];
end;

{$ENDREGION Libraries}

{$REGION Library}

function TLibrary.GetTypeLibrary: TTypeLibrary;
begin
  Result := fTypeLibrary;
end;

constructor TLibrary.Create(const aTypeLibrary: TTypeLibrary);
begin
  inherited Create;
  fTypeLibrary := aTypeLibrary;
end;

function TLibrary.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  Result := -1;
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Exit;
  end;
  Result := (Self as TLibrarySpec).Add(AKey, TModuleDefine.Create(Self) as
    IModuleDefine);

end;

{$ENDREGION Library}

end.

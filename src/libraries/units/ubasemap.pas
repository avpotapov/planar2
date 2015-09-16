unit uBaseMap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uFglExtCls,
  uLibraries;

type

  { TBaseMap }

  generic TBaseMap<TKey, TData> = class(specialize TFpgMapExt<TKey, TData>, specialize IBaseMap<TKey, TData>)
  protected
    fLastError: Integer;
  public
    function GetLastError: integer;
  end;

implementation

{ TBaseMap }

function TBaseMap.GetLastError: integer;
begin
  Result := fLastError;
  fLastError := 0;
end;

end.


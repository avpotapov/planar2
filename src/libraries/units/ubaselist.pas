unit uBaseList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uFglExtCls,
  uLibraries;

type

  generic TBaseList<T> = class(specialize TFpgListExt<T>, specialize IBaseList<T>)
  protected
    fLastError: Integer;
  public
    function GetLastError: integer;
  end;

implementation

{ TBaseList }

function TBaseList.GetLastError: integer;
begin
  Result := fLastError;
  fLastError := 0;
end;

end.


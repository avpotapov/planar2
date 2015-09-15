unit uBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uLibraries;

type

  { TBase }

  TBase = class(TInterfacedObject, IBase)
  protected
    fLastError: Integer;
  public
    function GetLastError: Integer;
  end;

implementation

{ TBase }

function TBase.GetLastError: Integer;
begin
  Result := fLastError;
  fLastError := 0;
end;

end.


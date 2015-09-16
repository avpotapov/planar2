unit uDescription;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uLibraries,
  uFglExtCls;

type
  TDescriptionSpec = specialize TFpgListExt<widestring>;
  TDescription = class(specialize TFpgListExt<widestring>, specialize IClonable<IDescription>)
  public
    function Clone(const {%H-}aDeep: boolean = True): IDescription;
  end;

implementation

{ TDescription }

function TDescription.Clone(const aDeep: boolean): IDescription;
var
  S: widestring;
begin
  Result := TDescription.Create as IDescription;
  for S in Self do
    Result.Add(S);
end;

end.

unit uBitsSet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uPreSets,
  uBaseMap,
  uLibraries;

type
  TBitsSetSpec = specialize TBaseMap<WideString, IBits>;

  TBitsSet = class(TBitsSetSpec, IBitsSet)
  private
    fPreSets: TPreSets;
  protected
    function GetPreSets: IPreSets;
  public
    function Add(const AKey: TKey): integer; reintroduce;
  public
    constructor Create(const aPreSets: TPreSets = nil); reintroduce;
  end;

implementation

uses uBits;

{$REGION BitsSet}

function TBitsSet.GetPreSets: IPreSets;
begin
  Result := fPreSets;
end;

function TBitsSet.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  Result := -1;
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Exit;
  end;
  Result := (Self as TBitsSetSpec).Add(AKey, TBits.Create(Self) as IBits);

end;

constructor TBitsSet.Create(const aPreSets: TPreSets);
begin
  inherited Create;
  fPreSets := aPreSets;
end;

{$ENDREGION BitsSet}
end.

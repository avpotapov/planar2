unit uGroup;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  uBaseList,
  uFglExtCls,
  uGroups,
  uLibraries;

type
  TGroupSpec = specialize TBaseList<IGroupItem>;

  { TGroup }

  TGroup = class(TGroupSpec, IGroup)
  type
      TListEnumeratorSpec = specialize TFpgListEnumeratorExt<IGroupItem>;
  private
  	fGroups: TGroups;
  public
    function GetEnumerator: IGroupEnumeratorSpec;
    function AddGroupItem(const aVarDefine: IVarDefine): integer;
		function GetGroups: IGroups;
  public
		constructor Create(const aGroups: TGroups = nil); reintroduce;
  end;

implementation

uses
  uGroupItem;

{$REGION Group}

function TGroup.GetEnumerator: IGroupEnumeratorSpec;
begin
  Result := TListEnumeratorSpec.Create(Self) as IGroupEnumeratorSpec;
end;

function TGroup.AddGroupItem(const aVarDefine: IVarDefine): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if Items[I].VarDefine = aVarDefine then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
  Result := Add(TGroupItem.Create(aVarDefine, Self));
end;

function TGroup.GetGroups: IGroups;
begin
	Result := fGroups;
end;

constructor TGroup.Create(const aGroups: TGroups);
begin
  inherited Create;
  fGroups := aGroups;
end;

{$ENDREGION Group}

end.

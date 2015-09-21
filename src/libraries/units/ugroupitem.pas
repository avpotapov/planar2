unit uGroupItem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBase,
  uGroup,
  uLibraries;

type

  { TGroupItem }

  TGroupItem = class(TBase, IGroupItem)
  private
    fVarDefine: IVarDefine;
    fImageIndex: integer;
    fGroup: TGroup;
  protected
    function GetVarDefine: IVarDefine;
    function GetImageIndex: integer;
    procedure SetImageIndex(const aImageIndex: integer);
    function GetGroup: IGroup;
  public
    constructor Create(const aVarDefine: IVarDefine; const aGroup: TGroup); reintroduce;
  public
    property VarDefine: IVarDefine read GetVarDefine;
  end;

implementation

{$REGION GroupItem}

function TGroupItem.GetVarDefine: IVarDefine;
begin
  Result := fVarDefine;
end;

constructor TGroupItem.Create(const aVarDefine: IVarDefine;
  const aGroup: TGroup);
begin
  inherited Create;
  fVarDefine := aVarDefine;
  fGroup := aGroup;
end;

function TGroupItem.GetImageIndex: integer;
begin
  Result := fImageIndex;
end;

procedure TGroupItem.SetImageIndex(const aImageIndex: integer);
begin
  if fImageIndex <> aImageIndex then
    fImageIndex := aImageIndex;
end;

function TGroupItem.GetGroup: IGroup;
begin
  Result := fGroup;
end;

{$ENDREGION GroupItem}

end.

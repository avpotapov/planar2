{
	*
	*   Реализация интерфейсов коллекций
  *    - TFpgList<T>
  *    - TFpgMap<TKey, TData>
  *
}
unit uFglExtCls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, uFglExt;

type

{$REGION TFpgListEnumeratorExt<T> - реализация перечислителя IFpgListEnumerator<T> }

  { TFpgListEnumeratorExt }

  generic TFpgListEnumeratorExt<T> = class(TInterfacedObject, specialize IFpgListEnumerator<T>)
  protected
    fList: TFpsList;
    fPosition: Integer;
    function GetCurrent: T; virtual;
  public
    constructor Create(aList: TFpsList);
    function MoveNext: Boolean;
    property Current: T read GetCurrent;
  end;
{$ENDREGION}

{$REGION TFpgListExt  - расширение TFpgList<T> за счет включения методов реализации интерфейса IUnknown}

  { TFpgListExt }

  generic TFpgListExt<T> = class(specialize TFPGList<T>, IUnknown, specialize IFpgList<T>)
  type
  	IFpgListEnumeratorSpec = specialize IFpgListEnumerator<T>;
		TFpgListEnumeratorExtSpec = specialize TFpgListEnumeratorExt<T>;
  protected
 		fRefCount : longint;
  public
    { implement methods of IUnknown }
    function QueryInterface(constref iid: tguid; out obj): longint; stdcall;
    function _AddRef: longint; stdcall;
    function _Release: longint; stdcall;
	public
    constructor Create;
    procedure AfterConstruction;override;
    procedure BeforeDestruction;override;
    property RefCount : longint read frefcount;

  public
    function GetEnumerator: IFpgListEnumeratorSpec;
    function GetCount: Integer;
  end;
{$ENDREGION}

{$REGION TPtrEnumerator  - перечислитель Pointer'ов}
	TPtrEnumerator = class (specialize TFpgListEnumeratorExt<Pointer>)
	protected
		function GetCurrent: Pointer; override;
	end;
{$ENDREGION}

{$REGION TFpgMapExt  - расширение TFpgMap<T> за счет включения методов реализации интерфейса IUnknown}

{ TFpgMapExt }

generic TFpgMapExt<TKey, TData> = class(specialize TFPGMap<TKey, TData>, IUnknown, specialize IFpgMap<TKey, TData>)
protected
 	fRefCount : longint;
private
  function GetDuplicates: TDuplicates;
  procedure SetDuplicates(AValue: TDuplicates);

public
  { implement methods of IUnknown }
  function QueryInterface(constref iid: tguid; out obj): longint; stdcall;
  function _AddRef: longint; stdcall;
  function _Release: longint; stdcall;
public
  constructor Create;
  procedure AfterConstruction;override;
  procedure BeforeDestruction;override;
  property RefCount : longint read frefcount;

public
  function GetCount: Integer;
  function ExtractData(const aItem: Pointer): TData;
  function ExtractKey(const aItem: Pointer): TKey;
  function GetEnumerator: IPtrEnumerator;

end;
{$ENDREGION}

implementation

{$REGION TFpgListEnumeratorExt<T> - реализация перечислителя IFpgListEnumerator<T> }

function TFpgListEnumeratorExt.GetCurrent: T;
begin
  Result := T(fList.Items[fPosition]^);
end;

constructor TFpgListEnumeratorExt.Create(aList: TFpsList);
begin
	inherited Create;
  fList := aList;
  fPosition := -1;
end;

function TFpgListEnumeratorExt.MoveNext: Boolean;
begin
  Inc(fPosition);
  Result := fPosition < fList.Count;
end;

{$ENDREGION}

{$REGION TFpgListExt  - расширение TFpgList<T> за счет включения методов реализации интерфейса IUnknown}

function TFpgListExt.QueryInterface(constref iid: tguid; out obj): longint;
  stdcall;
begin
  if GetInterface(iid,obj) then
    Result:=S_OK
  else
    Result:=longint(E_NOINTERFACE);
end;

function TFpgListExt._AddRef: longint; stdcall;
begin
  _addref:=InterLockedIncrement(fRefCount);
end;

function TFpgListExt._Release: longint; stdcall;
begin
  _Release:=InterLockedDecrement(fRefCount);
  if _Release=0 then
    Destroy;
end;

procedure TFpgListExt.AfterConstruction;
begin
	inherited AfterConstruction;
  InterLockedDecrement(fRefCount);
end;

procedure TFpgListExt.BeforeDestruction;
begin
	inherited BeforeDestruction;
  if fRefCount<>0 then
  	RaiseLastOSError(204);
end;

function TFpgListExt.GetEnumerator: IFpgListEnumeratorSpec;
begin
  Result := TFpgListEnumeratorExtSpec.Create(Self) as  IFpgListEnumeratorSpec;
end;

function TFpgListExt.GetCount: Integer;
begin
  Result := Count;
end;

constructor TFpgListExt.Create;
begin
  inherited Create;
  fRefCount := 1;
end;
{$ENDREGION}

{$REGION TPtrEnumerator  - перечислитель Pointer'ов}

function TPtrEnumerator.GetCurrent: T;
begin
    Result := fList.Items[fPosition];
end;
{$ENDREGION}

{$REGION TFpgMapExt  - расширение TFpgMap<T> за счет включения методов реализации интерфейса IUnknown}

function TFpgMapExt.GetDuplicates: TDuplicates;
begin
  Result := Duplicates;
end;

procedure TFpgMapExt.SetDuplicates(AValue: TDuplicates);
begin
  Sorted := True;
  if Duplicates <> AValue then
     Duplicates := AValue;
end;

function TFpgMapExt.QueryInterface(constref iid: tguid; out obj): longint;
  stdcall;
begin
  if GetInterface(iid,obj) then
    Result:=S_OK
  else
    Result:=longint(E_NOINTERFACE);
end;

function TFpgMapExt._AddRef: longint; stdcall;
begin
  _addref:=InterLockedIncrement(fRefCount);
end;

function TFpgMapExt._Release: longint; stdcall;
begin
  _Release:=InterLockedDecrement(fRefCount);
  if _Release=0 then
    Destroy;
end;

constructor TFpgMapExt.Create;
begin
  inherited Create;
  fRefCount := 1;
end;

procedure TFpgMapExt.AfterConstruction;
begin
	inherited AfterConstruction;
  InterLockedDecrement(fRefCount);
end;

procedure TFpgMapExt.BeforeDestruction;
begin
	inherited BeforeDestruction;
  if fRefCount<>0 then
  	RaiseLastOSError(204);
end;

function TFpgMapExt.GetCount: Integer;
begin
	Result := Count;
end;

function TFpgMapExt.ExtractData(const aItem: Pointer): TData;
var
  PData: Pointer;
begin
  PData := PByte(aItem) + KeySize;
  Result := TData(PData^);
end;

function TFpgMapExt.ExtractKey(const aItem: Pointer): TKey;
begin
  Result := TKey(aItem^);
end;

function TFpgMapExt.GetEnumerator: IPtrEnumerator;
begin
  Result := TPtrEnumerator.Create(Self) as IPtrEnumerator;
end;

{$ENDREGION}
end.


unit uVarDefine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uDefs,
  uBase,
  uBaseMap,
  uDescription,
  uLibraries,
  uPickList,
  uBits;

type
  TVars = specialize TBaseMap<TTypeRegister, IVarDefine>;

  { TVarDefine }

  TVarDefine = class(TBase, IVarDefine, IClonableVarDefine)
  private
    // Ссылка на контейнер регистров
    fVars: TVars;
    // Имя регистра
    fName: WideString;
    // Краткое описание
    fShortDescription: WideString;
    // Полное описание переменной
    fDescription: IDescription;
    // Версия переменной
    fVer: WideString;
    // Уровень доступа: uGeneral
    fAccess: TAccess;
    // Тип переменной: uGeneral
    fVarType: TVarType;
    // Разновидность переменной: uGeneral
    fKind: TKind;
    // Читать всегда
    fReadAlways: boolean;
    // Множитель
    fMultipler: Dword;
    // Индекс
    fIndex: word;
    // Только единичный запрос регистра
    fSingleRequest: boolean;
    // Режим синхронизации
    fSynchronization: TSynchronization;
    // Единица измерения
    fMeasure: WideString;
    // Коллекция битов
    fBits: IBits;
    // Список значений
    fPickList: IPickList;

  protected
    function GetAccess: TAccess;
    function GetBits: IBits;
    function GetDescription: IDescription;
    function GetIndex: word;
    function GetKind: TKind;
    function GetMeasure: WideString;
    function GetMultipler: DWord;
    function GetName: WideString;
    function GetPickList: IPickList;
    function GetReadAlways: boolean;
    function GetShortDescription: WideString;
    function GetSingleRequest: boolean;
    function GetSynchronization: TSynchronization;
    function GetTypeRegister: TTypeRegister;
    function GetUid: WideString;
    function GetVarType: TVarType;
    function GetVer: WideString;
    procedure SetAccess(const aAccess: TAccess);
    procedure SetBits(const aBits: IBits);
    procedure SetIndex(const aIndex: word);
    procedure SetKind(const aKind: TKind);
    procedure SetMeasure(const aMeasure: WideString);
    procedure SetMultipler(const aMultipler: DWord);
    procedure SetName(const aName: WideString);
    procedure SetPickList(const aPickList: IPickList);
    procedure SetReadAlways(const aReadAlways: boolean);
    procedure SetShortDescription(const aShortDescription: WideString);
    procedure SetSingleRequest(const aSingleRequest: boolean);
    procedure SetSynchronization(const aSynchronization: TSynchronization);
    procedure SetVarType(const aVarType: TVarType);
    procedure SetVer(const aVer: WideString);
  public
    constructor Create(const aVars: TVars = nil);
  public
    function Clone(const aDeep: boolean): IVarDefine;
    procedure SetVars(const aVars: TVars);
  end;

implementation

{$REGION VarDefine}

constructor TVarDefine.Create(const aVars: TVars);
begin
  inherited Create;
  fVars := aVars;
end;

function TVarDefine.GetAccess: TAccess;
begin
  Result := fAccess;
end;

function TVarDefine.GetMeasure: WideString;
begin
  Result := fMeasure;
end;

procedure TVarDefine.SetAccess(const aAccess: TAccess);
begin
  if fAccess <> aAccess then
    fAccess := aAccess;
end;

function TVarDefine.GetVarType: TVarType;
begin
  Result := fVarType;
end;

procedure TVarDefine.SetMeasure(const aMeasure: WideString);
begin
  if not SameText(fMeasure, aMeasure) then
    fMeasure := aMeasure;
end;


procedure TVarDefine.SetVarType(const aVarType: TVarType);
begin
  if fVarType <> aVarType then
    fVarType := aVarType;
end;

function TVarDefine.GetKind: TKind;
begin
  Result := fKind;
end;

procedure TVarDefine.SetKind(const aKind: TKind);
begin
  if fKind <> aKind then
    fKind := aKind;
end;

function TVarDefine.GetReadAlways: boolean;
begin
  Result := fReadAlways;
end;

procedure TVarDefine.SetReadAlways(const aReadAlways: boolean);
begin
  if fReadAlways <> aReadAlways then
    fReadAlways := aReadAlways;
end;

function TVarDefine.GetDescription: IDescription;
begin
  if fDescription = nil then
    fDescription := TDescription.Create as IDescription;
  Result := fDescription;
end;

function TVarDefine.GetMultipler: DWord;
begin
  Result := fMultipler;
end;

procedure TVarDefine.SetMultipler(const aMultipler: DWord);
begin
  if fMultipler <> aMultipler then
    fMultipler := aMultipler;
end;

function TVarDefine.GetIndex: word;
begin
  Result := fIndex;
end;

procedure TVarDefine.SetIndex(const aIndex: word);
begin
  if fIndex <> aIndex then
    fIndex := aIndex;
end;

function TVarDefine.GetName: WideString;
begin
  Result := fName;
end;

procedure TVarDefine.SetName(const aName: WideString);
begin
  if not SameText(fName, aName) then
    fName := aName;
end;

function TVarDefine.GetTypeRegister: TTypeRegister;
begin
  Exception.Create('Not inplementation');
  //  Result := fVars.fTypeRegister;
end;

function TVarDefine.GetShortDescription: WideString;
begin
  Result := fShortDescription;
end;

procedure TVarDefine.SetShortDescription(const aShortDescription: WideString);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TVarDefine.GetSingleRequest: boolean;
begin
  Result := fSingleRequest;
end;

procedure TVarDefine.SetSingleRequest(const aSingleRequest: boolean);
begin
  if fSingleRequest <> aSingleRequest then
    fSingleRequest := aSingleRequest;
end;

function TVarDefine.GetUid: WideString;
var
  I: integer;
begin
  Exception.Create('Not Inplementation');
  //I := fVars.IndexOfData(Self);
  //Result := fVars.Keys[I];
end;

function TVarDefine.GetVer: WideString;
begin
  Result := fVer;
end;

procedure TVarDefine.SetVer(const aVer: WideString);
begin
  if not SameText(fVer, aVer) then
    fVer := aVer;
end;

procedure TVarDefine.SetVars(const aVars: TVars);
begin
  if fVars <> aVars then
    fVars := aVars;
end;

function TVarDefine.GetSynchronization: TSynchronization;
begin
  Result := fSynchronization;
end;

procedure TVarDefine.SetSynchronization(const aSynchronization: TSynchronization);
begin
  if fSynchronization <> aSynchronization then
    fSynchronization := aSynchronization;
end;

function TVarDefine.GetBits: IBits;
begin
  if fBits = nil then
     fBits := TBits.Create;
  Result := fBits;
end;

procedure TVarDefine.SetBits(const aBits: IBits);
begin
  fBits := aBits;
end;

function TVarDefine.GetPickList: IPickList;
begin
  if fPickList = nil then
    fPickList := TPickList.Create;
  Result := fPickList;
end;

procedure TVarDefine.SetPickList(const aPickList: IPickList);
begin
  fPickList := aPickList;
end;

function TVarDefine.Clone(const aDeep: boolean): IVarDefine;
var
  ClonedDescription: IClonableDescription;
  ClonableBits: IClonableBits;
  ClonablePickList: IClonablePickList;
begin
  Result := TVarDefine.Create as IVarDefine;
  Result.Name := GetName;
  Result.Access := GetAccess;
  Result.Kind := GetKind;
  Result.Measure := GetMeasure;
  Result.Multipler := GetMultipler;
  Result.ReadAlways := GetReadAlways;
  Result.ShortDescription := GetShortDescription;
  Result.SingleRequest := GetSingleRequest;
  Result.Synchronization := GetSynchronization;
  Result.VarType := GetVarType;
  Result.Ver := GetVer;

  case aDeep of
    True:
    begin
      if Supports(GetDescription, IClonableDescription, ClonedDescription) then
        (Result as TVarDefine).fDescription := ClonedDescription.Clone(aDeep);

      if Supports(fBits, IClonableBits, ClonableBits) then
        Result.Bits := ClonableBits.Clone(aDeep);

      if Supports(fPickList, IClonablePickList, ClonablePickList) then
        Result.PickList := ClonablePickList.Clone(aDeep);
    end;
    False:
    begin
      (Result as TVarDefine).fDescription := fDescription;
      (Result as TVarDefine).fBits := fBits;
      (Result as TVarDefine).fPickList := fPickList;
    end;
  end;
end;

{$ENDREGION VarDefine}



end.


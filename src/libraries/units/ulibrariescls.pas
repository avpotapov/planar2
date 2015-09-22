unit uLibrariesCls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uLibraries,
  uFglExt,
  uFglExtCls,
  uDefs;

type

	//TLibraries = class;
	//TLibrary = class;
	//TDescription = class;
	//TLibraries = class;
	//TLibrary = class;
	//TModuleDefine = class;
	//TModule = class;
	//TBaseDescription = class;
	//TPreSets = class;
	//TBitsSet = class;
	//TPickLists = class;
	//TBits = class;
	//TBitDefine = class;
	//TPickList = class;
	//TPickItem = class;
	//TRegisters = class;
	//TVars = class;
	TVarDefine = class;
	//TGroups = class;
	//TGroupsList = class;
	//TGroup = class;
	//TGroupItem = class;


{$REGION Базовые интерфейсы библиотеки (включен код ошибки)}
 
  TBase = class(TInterfacedObject, IBase)
  protected
    fLastError: Integer;
  public
    function GetLastError: Integer;
  end;
  
  generic TBaseMap<TKey, TData> = class(specialize TFpgMapExt<TKey, TData>, specialize IBaseMap<TKey, TData>)
  protected
    fLastError: Integer;
  public
    function GetLastError: integer;
  end;

  generic TBaseList<T> = class(specialize TFpgListExt<T>, specialize IBaseList<T>)
  protected
    fLastError: Integer;
  public
    function GetLastError: integer;
  end; 

{$ENDREGION}

{$REGION Description}

  TDescriptionSpec = specialize TFpgListExt<widestring>;
  TDescription = class(specialize TFpgListExt<widestring>, specialize IClonable<IDescription>)
  public
    function Clone(const {%H-}aDeep: boolean = True): IDescription;
  end;
{$ENDREGION Description}

{$REGION Libraries}

  TLibraries = class(TBase, ILibraries)
    type
    TAllLibraries = array [TTypeLibrary] of ILibrary;
  private
    fAllLibraries: TAllLibraries;
    function GetLibrary(ATypeLibrary: TTypeLibrary): ILibrary;
  public
    property AllLibraries[ATypeLibrary: TTypeLibrary]: ILibrary read GetLibrary;
  end;
{$ENDREGION Libraries}

{$REGION Library}

  TLibrarySpec = specialize TBaseMap<word, IModuleDefine>;
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
{$ENDREGION Library}  

{$REGION ModuleDefine}

  TModuleDefine = class(TBase, IModuleDefine)
  private
    fLibrary: TLibrary;
    fTypeSignature: TTypeSignature;
    fTypeBootloader: TTypeBootloader;
    fName: WideString;
    fModule: IModule;
  protected
    function GetUid: word;
    procedure SetUid(const aUid: word);

    function GetName: WideString;
    procedure SetName(const aName: WideString);

    function GetTypeBootloader: TTypeBootloader;
    procedure SetTypeBootloader(const aTypeBootloader: TTypeBootloader);

    function GetTypeSignature: TTypeSignature;
    procedure SetTypeSignature(const aTypeSignature: TTypeSignature);

    function GetModule: IModule;
    function GetLibrary: ILibrary;
  public
    constructor Create(const aLibrary: TLibrary); reintroduce;
  end;
{$ENDREGION ModuleDefine}  

{$REGION Module}

  TModule = class(TBase, IModule)
  private
    fModuleDefine: TModuleDefine;
    fDescription: IBaseDescription;
    fRegisters: IRegisters;
    fPreSets: IPreSets;
    fConfiguration: IGroups;
  protected
    function GetModuleDefine: IModuleDefine;
    function GetDescription: IBaseDescription;
    function GetRegisters: IRegisters;
    function GetPreSets: IPreSets;
    function GetConfiguration: IGroups;
  public
    constructor Create(const aModuleDefine: TModuleDefine = nil); reintroduce;
  end;
{$ENDREGION Module}

{$REGION BaseDescription }

  TBaseDescription = class(TBase, IBaseDescription)
  private
    fModule: TModule;
    fDescription: IDescription;
    fImage: WideString;
  protected
    function GetModule: IModule;
    function GetDescription: IDescription;
    function GetImage: WideString;
    procedure SetImage(const aImage: WideString);
  public
    constructor Create(const aModule: TModule = nil); reintroduce;
  end;
{$ENDREGION BaseDescription }  

{$REGION PreSets}

  TPreSets = class(TBase, IPreSets)
  private
    fModule: TModule;
    fPickLists: IPickLists;
    fBitsSet: IBitsSet;
  protected
    function GetPickLists: IPickLists;
    function GetBitsSet: IBitsSet;
    function GetModule: IModule;
  public
    constructor Create(const aModule: TModule = nil); reintroduce;
  end;
{$ENDREGION PreSets}

{$REGION BitsSet}

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
{$ENDREGION BitsSet}

{$REGION Bits}

  TBitsSpec = specialize TBaseMap<byte, IBitDefine>;
  TBits = class(TBitsSpec, IBits, IClonableBits)
  private
    fVarDefine: TVarDefine;
    fBitsSet: TBitsSet;
    fShortDescription: WideString;
  protected
    function GetName: WideString;
    procedure SetName(const aName: WideString);

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);

    function GetVarDefine: IVarDefine;
    function GetBitsSet: IBitsSet;
  public

    constructor Create(const aBitsSet: TBitsSet = nil); overload;
    constructor Create(const aVarDefine: TVarDefine); overload;

  public
    function Clone(const aDeep: boolean = True): IBits;
    function Add(const AKey: TKey): integer; reintroduce;
    property Name: WideString read GetName write SetName;
    property ShortDescription: WideString read GetShortDescription
      write SetShortDescription;
  end;
{$ENDREGION Bits}

{$REGION BitDefine}

 TBitDefine = class(TBase, IBitDefine, IClonableBitDefine)
  private
    fBits: TBits;
    fName: WideString;
    fShortDescription: WideString;
    fDescription: IDescription;
    fVer: WideString;
  private
    function GetIndex: byte;
    procedure SetIndex(const aIndex: byte);

    function GetName: WideString;
    procedure SetName(const aName: WideString);

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);

    function GetDescription: IDescription;

    function GetVer: WideString;
    procedure SetVer(const aVer: WideString);

    function GetBits: IBits;

  public
    constructor Create(const aBits: TBits = nil); reintroduce;

  public
    function Clone(const aDeep: boolean = True): IBitDefine;
    // Задействован при клонировании объекта
    procedure SetBits(const aBits: TBits);
  end;
{$ENDREGION BitDefine}

{$REGION PickLists}

  TPickListsSpec = specialize TBaseMap<WideString, IPickList>;
  TPickLists = class(TPickListsSpec, IPickLists)
  private
    fPreSets: TPreSets;
  protected
    function GetPreSets: IPreSets;
  public
    function Add(const AKey: TKey): integer; reintroduce;
  public
    constructor Create(const aPreSets: TPreSets = nil); reintroduce;
  end;
{$ENDREGION PickLists}

{$REGION PickList}

  TPickListSpec = specialize TBaseMap<word, IPickItem>;
  TPickList = class(TPickListSpec, IPickList, IClonablePickList)
  private
    fPickLists: TPickLists;
    fVarDefine: TVarDefine;
    fName: WideString;
    fShortDescription: WideString;
  protected
    function GetName: WideString;
    procedure SetName(const aName: WideString);
    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);
    function GetVarDefine: IVarDefine;
  public
    function Clone(const aDeep: boolean = True): IPickList;
    constructor Create(const aPickLists: TPickLists = nil); overload;
    constructor Create(const aVarDefine: TVarDefine); overload;
  public
    function Add(const AKey: TKey): integer; reintroduce;
  end;
{$ENDREGION PickList}
 
{$REGION PickItem} 
  
  TPickItem = class(TBase, IPickItem, IClonablePickItem)
  private
    fPickList: TPickList;
    fName: WideString;
    fShortDescription: WideString;
    fDescription: IDescription;
    fVer: WideString;
  private
    function GetValue: word;
    procedure SetValue(const aValue: word);

    function GetName: WideString;
    procedure SetName(const aName: WideString);

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);

    function GetDescription: IDescription;

    function GetVer: WideString;
    procedure SetVer(const aVer: WideString);

    function GetPickList: IPickList;
  public
    constructor Create(const aPickList: TPickList = nil); reintroduce;
  public
    function Clone(const aDeep: boolean = True): IPickItem;

    // Задействован при клонировании объекта
    procedure SetPickList(const aPickList: TPickList);
  end;
{$ENDREGION PickItem}

{$REGION Registers}

 TRegisters = class(TBase, IRegisters)
    type
    TAllRegisters = array [TTypeRegister] of IVars;
  private
    fModule: TModule;
    fAllRegisters: TAllRegisters;
  protected
    function GetVars(aTypeRegister: TTypeRegister): IVars;
    function GetModule: IModule;
  public
    constructor Create(const aModule: TModule = nil); reintroduce;
  end;
{$ENDREGION Registers}

{$REGION Vars}
  TVarsSpec = specialize TBaseMap<WideString, IVarDefine>;
  TVars = class(TVarsSpec, IVars)
  private
    fRegisters: TRegisters;
    fTypeRegister: TTypeRegister;
  protected
    function GetTypeRegister: TTypeRegister;
    function GetRegisters: IRegisters;
  public
    constructor Create(aTypeRegister: TTypeRegister = TTypeRegister.trHolding;
      const aRegisters: TRegisters = nil); reintroduce;
  public
    function Add(const AKey: TKey): integer; reintroduce;
    property TypeRegister: TTypeRegister read GetTypeRegister;
  end;
{$ENDREGION Vars}

{$REGION VarDefine}

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
    function GetVars: IVars;
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
{$ENDREGION VarDefine}

{$REGION Groups}
  TGroups = class(TBase, IGroups)
  private
    fModule: TModule;
    fParentGroups: TGroups;

    fShortDescription: WideString;
    fGroupsList: IGroupsList;
    fGroup: IGroup;
  protected
    function GetGroupsList: IGroupsList;
    function GetGroup: IGroup;

    function GetShortDescription:WideString;
    procedure SetShortDescription(const aShortDescription: WideString);

    function GetModule: IModule;

    function GetParentGroups: IGroups;
  public
    constructor Create(const aModule: TModule; const aGroups: TGroups; const aShortDescription: WideString); overload;
    constructor Create(const aModule: TModule); overload;

    property Module: IModule read GetModule;
  end;
{$ENDREGION Groups}

{$REGION GroupsList }

  TGroupsListSpec = specialize TBaseList<IGroups>;
  TGroupsList = class(TGroupsListSpec, IGroupsList)
  type
    TListEnumeratorSpec = specialize TFpgListEnumeratorExt<IGroups>;
  private
  	fParentGroups: TGroups;
  public
    function GetEnumerator: IGroupsListEnumeratorSpec;
    function AddGroups(const aShortDescription: WideString = ''): Integer;
    function Find(const aShortDescription: WideString): Integer;
		function GetParentGroups: IGroups;
	public
		constructor Create(const aGroups: TGroups = nil); reintroduce;
  end;
{$ENDREGION GroupsList }

{$REGION Group}

  TGroupSpec = specialize TBaseList<IGroupItem>;
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
{$ENDREGION Group}

{$REGION GroupItem}
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
{$ENDREGION GroupItem}  
implementation

{$REGION Базовые интерфейсы библиотеки (включен код ошибки)}

function TBase.GetLastError: Integer;
begin
  Result := fLastError;
  fLastError := 0;
end;

function TBaseMap.GetLastError: integer;
begin
  Result := fLastError;
  fLastError := 0;
end;

function TBaseList.GetLastError: integer;
begin
  Result := fLastError;
  fLastError := 0;
end;

{$ENDREGION Базовые интерфейсы библиотеки (включен код ошибки)}

{$REGION Description}

function TDescription.Clone(const aDeep: boolean): IDescription;
var
  S: widestring;
begin
  Result := TDescription.Create as IDescription;
  for S in Self do
    Result.Add(S);
end;
{$ENDREGION Description}

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

{$REGION ModuleDefine}

constructor TModuleDefine.Create(const aLibrary: TLibrary);
begin
  inherited Create;
  fLibrary := aLibrary;
end;

function TModuleDefine.GetLibrary: ILibrary;
begin
  Result := fLibrary as ILibrary;
end;

function TModuleDefine.GetUid: word;
begin
  // Ключ по индексу объекта
  Result := fLibrary.Keys[fLibrary.IndexOfData(Self)];
end;

procedure TModuleDefine.SetUid(const aUid: word);
var
  Index: integer;
begin
  if GetUid = aUid then
    Exit;

  // Для изменения ключа отключается сортировка
  fLibrary.Sorted := False;
  try
    // Если введенный Uid уже присутствует в списке
    // генерируется исключение
    if fLibrary.Find(aUid, Index) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;

    // Записывается новое значение ключа
    fLibrary.Keys[TLibrary(fLibrary).IndexOfData(Self)] := aUid;
  finally
    fLibrary.Sorted := True;
  end;
end;

function TModuleDefine.GetName: WideString;
begin
  Result := fName;
end;

procedure TModuleDefine.SetName(const aName: WideString);
begin
  if not SameText(fName, aName) then
    fName := aName;
end;

function TModuleDefine.GetTypeBootloader: TTypeBootloader;
begin
  Result := fTypeBootloader;
end;

procedure TModuleDefine.SetTypeBootloader(const aTypeBootloader: TTypeBootloader);
begin
  if fTypeBootloader <> aTypeBootloader then
    fTypeBootloader := aTypeBootloader;
end;

function TModuleDefine.GetTypeSignature: TTypeSignature;
begin
  Result := fTypeSignature;
end;

procedure TModuleDefine.SetTypeSignature(const aTypeSignature: TTypeSignature);
begin
  if fTypeSignature <> aTypeSignature then
    fTypeSignature := aTypeSignature;
end;

function TModuleDefine.GetModule: IModule;
begin
  if fModule = nil then
    fModule := TModule.Create(Self) as IModule;
  Result := fModule;
end;
{$ENDREGION ModuleDefine}

{$REGION Module}

function TModule.GetModuleDefine: IModuleDefine;
begin
  Result := fModuleDefine as IModuleDefine;
end;

function TModule.GetDescription: IBaseDescription;
begin
  if fDescription = nil then
    fDescription := TBaseDescription.Create(Self) as IBaseDescription;
  Result := fDescription;
end;

function TModule.GetRegisters: IRegisters;
begin
  if fRegisters = nil then
    fRegisters := TRegisters.Create(Self) as IRegisters;
  Result := fRegisters;
end;

function TModule.GetPreSets: IPreSets;
begin
  if fPreSets = nil then
    fPreSets := TPreSets.Create(Self) as IPreSets;
  Result := fPreSets;

end;

function TModule.GetConfiguration: IGroups;
begin
  if fConfiguration = nil then
    fConfiguration := TGroups.Create(Self);
  Result := fConfiguration;
end;

constructor TModule.Create(const aModuleDefine: TModuleDefine);
begin
  inherited Create;
  fModuleDefine := aModuleDefine;
end;
{$ENDREGION Module}

{$REGION BaseDescription}

constructor TBaseDescription.Create(const aModule: TModule);
begin
  inherited Create;
  fModule := aModule;
end;

function TBaseDescription.GetModule: IModule;
begin
  Result := fModule as IModule;
end;

function TBaseDescription.GetDescription: IDescription;
begin
  if fDescription = nil then
    fDescription := TDescription.Create as IDescription;
  Result := fDescription;
end;

function TBaseDescription.GetImage: WideString;
begin
  Result := fImage;
end;

procedure TBaseDescription.SetImage(const aImage: WideString);
begin
  if not SameText(fImage, aImage) then
    fImage := aImage;
end;
{$ENDREGION BaseDescription }

{$REGION PreSets}

constructor TPreSets.Create(const aModule: TModule);
begin
  inherited Create;
  fModule := aModule;
end;

function TPreSets.GetPickLists: IPickLists;
begin
  if fPickLists = nil then
    fPickLists := TPickLists.Create;
  Result := fPickLists;
end;

function TPreSets.GetBitsSet: IBitsSet;
begin
  if fBitsSet = nil then
    fBitsSet := TBitsSet.Create;
  Result := fBitsSet;
end;

function TPreSets.GetModule: IModule;
begin
  Result := fModule;
end;
{$ENDREGION PreSets}

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

{$REGION Bits}

function TBits.GetName: WideString;
var
  FoundIndex: integer;
begin
  Result := '';
  if fBitsSet = nil then
    Exit;
  FoundIndex := fBitsSet.IndexOfData(Self as IBits);
  if FoundIndex < 0 then
    Exit;
  Result := fBitsSet.Keys[FoundIndex];
end;

procedure TBits.SetName(const aName: WideString);
var
  I: integer;
begin
  if fBitsSet = nil then
    Exit;

  if SameText(GetName, aName) then
    Exit;

  // Для изменения ключа отключается сортировка
  fBitsSet.Sorted := False;
  try
    // В случае дубликата возбуждается исключение
    if fBitsSet.Find(aName, I) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
    // Записывается новое значение ключа
    fBitsSet.Keys[fBitsSet.IndexOfData(Self)] := aName;
  finally
    fBitsSet.Sorted := True;
  end;

end;

function TBits.GetShortDescription: WideString;
begin
  Result := fShortDescription;
end;

procedure TBits.SetShortDescription(const aShortDescription: WideString);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TBits.GetVarDefine: IVarDefine;
begin
  Result := fVarDefine;
end;

function TBits.GetBitsSet: IBitsSet;
begin
  Result := fBitsSet;
end;

function TBits.Clone(const aDeep: boolean): IBits;
var
  Ptr: Pointer;
  ClonableBitDefine: IClonableBitDefine;
  BitDefine: IBitDefine;
begin
  Result := TBits.Create(fBitsSet) as IBits;
  for Ptr in Self do
  begin
    case aDeep of
      True:
        if Supports(ExtractData(Ptr), IClonableBitDefine, ClonableBitDefine) then
        begin
          BitDefine := ClonableBitDefine.Clone(aDeep);
          (BitDefine as TBitDefine).SetBits(Result as TBits);
        end;
      False:
        BitDefine := ExtractData(Ptr);
    end;
    Result.Add(ExtractKey(Ptr), BitDefine);
  end;

end;

constructor TBits.Create(const aBitsSet: TBitsSet);
begin
  inherited Create;
  fBitsSet := aBitsSet;
end;

constructor TBits.Create(const aVarDefine: TVarDefine);
begin
  inherited Create;
  fVarDefine := aVarDefine;
end;


function TBits.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Result := FoundIndex;
    Exit;
  end;
  Result := (Self as TBitsSpec).Add(AKey, TBitDefine.Create(Self) as IBitDefine);

end;
{$ENDREGION Bits}

{$REGION BitDefine}

constructor TBitDefine.Create(const aBits: TBits);
begin
  inherited Create;
  fBits := aBits;
end;

function TBitDefine.GetIndex: byte;
var
  I: integer;
begin
  if fBits = nil then
  begin
    fLastError := CONTAINER_IS_NIL;
    Exit;
  end;

  I := fBits.IndexOfData(Self);
  Result := fBits.Keys[I];
end;

procedure TBitDefine.SetIndex(const aIndex: byte);
var
  I: integer;
begin
  if fBits = nil then
  begin
    fLastError := CONTAINER_IS_NIL;
    Exit;
  end;

  if GetIndex = aIndex then
    Exit;

  // Для изменения ключа отключается сортировка
  fBits.Sorted := False;
  try
    // В случае дубликата возбуждается исключение
    if fBits.Find(aIndex, I) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
    // Записывается новое значение ключа
    fBits.Keys[fBits.IndexOfData(Self)] := aIndex;
  finally
    fBits.Sorted := True;
  end;

end;

function TBitDefine.GetName: WideString;
begin
  Result := fName;
end;

procedure TBitDefine.SetName(const aName: WideString);
begin
  if not SameText(fName, aName) then
    fName := aName;
end;

function TBitDefine.GetShortDescription: WideString;
begin
  Result := fShortDescription;
end;

procedure TBitDefine.SetShortDescription(const aShortDescription: WideString);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TBitDefine.GetDescription: IDescription;
begin
  if fDescription = nil then
    fDescription := TDescription.Create as IDescription;
  Result := fDescription;
end;

function TBitDefine.GetVer: WideString;
begin
  Result := fVer;
end;

procedure TBitDefine.SetVer(const aVer: WideString);
begin
  if not SameText(fVer, aVer) then
    fVer := aVer;
end;

function TBitDefine.GetBits: IBits;
begin
  Result := fBits;
end;

function TBitDefine.Clone(const aDeep: boolean): IBitDefine;
var
  ClonableDescription: IClonableDescription;
  Desc: IDescription;
begin
  Result := TBitDefine.Create as IBitDefine;
  Result.Name := GetName;
  Result.ShortDescription := GetShortDescription;
  Result.Ver := GetVer;

  Desc := GetDescription;
  case aDeep of
    True:
      if aDeep and Supports(Desc, IClonableDescription, ClonableDescription) then
        (Result as TBitDefine).fDescription := ClonableDescription.Clone;
    False:
      (Result as TBitDefine).fDescription := GetDescription;
  end;

end;

procedure TBitDefine.SetBits(const aBits: TBits);
begin
  fBits := aBits;
end;
{$ENDREGION BitDefine}

{$REGION PickLists}

function TPickLists.GetPreSets: IPreSets;
begin
  Result := fPreSets;
end;

function TPickLists.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  Result := -1;
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Exit;
  end;
  Result := (Self as TPickListsSpec).Add(AKey, TPickList.Create(Self) as IPickList);

end;

constructor TPickLists.Create(const aPreSets: TPreSets);
begin
  inherited Create;
  fPreSets := aPreSets;
end;
{$ENDREGION PickLists}

{$REGION PickList}

function TPickList.GetName: WideString;
var
  FoundIndex: integer;
begin
  Result := fName;
  if fPickLists = nil then
    Exit;

  FoundIndex := fPickLists.IndexOfData(Self as IPickList);
  if FoundIndex < 0 then
    Exit;
  Result := fPickLists.Keys[FoundIndex];
end;

procedure TPickList.SetName(const aName: WideString);
var
  I: integer;
begin
  if fPickLists = nil then
    Exit;

  if SameText(GetName, aName) then
    Exit;

  // Для изменения ключа отключается сортировка
  fPickLists.Sorted := False;
  try
    // В случае дубликата возбуждается исключение
    if fPickLists.Find(aName, I) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
    // Записывается новое значение ключа
    fPickLists.Keys[fPickLists.IndexOfData(Self)] := aName;
    fName := aName;
  finally
    fPickLists.Sorted := True;
  end;
end;

function TPickList.GetShortDescription: WideString;
begin
  Result := fShortDescription;
end;

procedure TPickList.SetShortDescription(const aShortDescription: WideString);
begin
  fShortDescription := aShortDescription;
end;

function TPickList.GetVarDefine: IVarDefine;
begin
  Result := nil;
  if fVarDefine <> nil then
    Result := fVarDefine as IVarDefine;
end;

function TPickList.Clone(const aDeep: boolean): IPickList;
var
  Ptr: Pointer;
  ClonablePickItem: IClonablePickItem;
  PickItem: IPickItem;
begin
  Result := TPickList.Create(fPickLists) as IPickList;
  for Ptr in Self do
  begin
    case aDeep of
      True:
        if Supports(ExtractData(Ptr), IClonablePickItem, ClonablePickItem) then
        begin
          PickItem := ClonablePickItem.Clone(aDeep);
          (PickItem as TPickItem).SetPickList(Result as TPickList);
        end;
      False:
        PickItem := ExtractData(Ptr);
    end;
    Result.Add(ExtractKey(Ptr), PickItem);
  end;
end;

constructor TPickList.Create(const aPickLists: TPickLists);
begin
  inherited Create;
  fPicklists := aPicklists;
end;

constructor TPickList.Create(const aVarDefine: TVarDefine);
begin
  inherited Create;
  fVarDefine := aVarDefine;
end;

function TPickList.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Result := -1;
    Exit;
  end;
  Result := (Self as TPickListSpec).Add(AKey, TPickItem.Create(Self) as IPickItem);

end;
{$ENDREGION PickList}

{$REGION PickItem}

constructor TPickItem.Create(const aPickList: TPickList);
begin
  inherited Create;
  fPickList := aPickList;
end;

function TPickItem.Clone(const aDeep: boolean): IPickItem;
var
  ClonableDescription: IClonableDescription;
  Desc: IDescription;
begin
  Result := TPickItem.Create as IPickItem;
  Result.Name := GetName;
  Result.ShortDescription := GetShortDescription;
  Result.Ver := GetVer;

  Desc := GetDescription;
  case aDeep of
    True:
      if aDeep and Supports(Desc, IClonableDescription, ClonableDescription) then
        (Result as TPickItem).fDescription := ClonableDescription.Clone;
    False:
      (Result as TPickItem).fDescription := GetDEscription;
  end;
end;

procedure TPickItem.SetPickList(const aPickList: TPickList);
begin
  fPickList := aPickList;
end;

function TPickItem.GetValue: word;
begin
  if fPickList = nil then
  begin
    fLastError := CONTAINER_IS_NIL;
    Exit;
  end;

  if fPickList <> nil then
    Result := fPickList.Keys[fPickList.IndexOfData(Self)];
end;

procedure TPickItem.SetValue(const aValue: word);
var
  I: integer;
begin
  if fPickList = nil then
  begin
    fLastError := CONTAINER_IS_NIL;
    Exit;
  end;

  if GetValue = aValue then
    Exit;

  // Для изменения ключа отключаем сортировку
  fPickList.Sorted := False;
  try
    // В случае дубликата возбуждается исключение
    if fPickList.Find(aValue, I) then
    begin
      fLastError := DUPLICATE_KEY;
      Exit;
    end;
    // Записывается новое значение ключа
    fPickList.Keys[fPickList.IndexOfData(Self)] := aValue;
  finally
    fPickList.Sorted := True;
  end;
end;

function TPickItem.GetName: WideString;
begin
  Result := fName;
end;

procedure TPickItem.SetName(const aName: WideString);
begin
  if not SameText(fName, aName) then
    fName := aName;
end;

function TPickItem.GetShortDescription: WideString;
begin
  Result := fShortDescription;
end;

procedure TPickItem.SetShortDescription(const aShortDescription: WideString);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TPickItem.GetDescription: IDescription;
begin
  if fDescription = nil then
    fDescription := TDescription.Create as IDescription;
  Result := fDescription;
end;

function TPickItem.GetVer: WideString;
begin
  Result := fVer;
end;

procedure TPickItem.SetVer(const aVer: WideString);
begin
  if not SameText(fVer, aVer) then
    fVer := aVer;
end;

function TPickItem.GetPickList: IPickList;
begin
  Result := fPickList;
end;
{$ENDREGION PickItem}

{$REGION Registers}

function TRegisters.GetVars(aTypeRegister: TTypeRegister): IVars;
begin
  if fAllRegisters[aTypeRegister] = nil then
    fAllRegisters[aTypeRegister] := TVars.Create(aTypeRegister, Self);
  Result := fAllRegisters[aTypeRegister];
end;

function TRegisters.GetModule: IModule;
begin
  Result := fModule as IModule;
end;

constructor TRegisters.Create(const aModule: TModule);
begin
  inherited Create;
  fModule := aModule;
end;
{$ENDREGION Registers}

{$REGION Vars}

function TVars.GetTypeRegister: TTypeRegister;
begin
  Result := fTypeRegister;
end;

function TVars.GetRegisters: IRegisters;
begin
  Result := nil;
  if fRegisters <> nil then
    Result := fRegisters as IRegisters;
end;

constructor TVars.Create(aTypeRegister: TTypeRegister; const aRegisters: TRegisters);
begin
  inherited Create;
  fTypeRegister := aTypeRegister;
  fRegisters := aRegisters;
end;

function TVars.Add(const AKey: TKey): integer;
var
  FoundIndex: integer;
begin
  Result := -1;
  if Find(AKey, FoundIndex) then
  begin
    fLastError := DUPLICATE_KEY;
    Exit;
  end;
  Result := (Self as TVarsSpec).Add(AKey, TVarDefine.Create(Self) as IVarDefine);
end;
{$ENDREGION Vars}

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
  Result := fVars.TypeRegister;
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
begin
  Result := fVars.Keys[fVars.IndexOfData(Self as IVarDefine)];
end;

function TVarDefine.GetVer: WideString;
begin
  Result := fVer;
end;

function TVarDefine.GetVars: IVars;
begin
  Result := fVars as IVars;
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
    fPickList := TPickList.Create(Self) as IPickList;
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

{$REGION Groups}

function TGroups.GetGroupsList: IGroupsList;
begin
  if fGroupsList = nil then
    fGroupsList := TGroupsList.Create(Self) as IGroupsList;
  Result := fGroupsList;
end;

function TGroups.GetGroup: IGroup;
begin
  if fGroup = nil then
    fGroup := TGroup.Create(Self) as IGroup;
  Result := fGroup;
end;

function TGroups.GetShortDescription: WideString;
begin
  Result := fShortDescription;
end;

procedure TGroups.SetShortDescription(const aShortDescription: WideString);
begin
  if not SameText(fShortDescription, aShortDescription) then
    fShortDescription := aShortDescription;
end;

function TGroups.GetModule: IModule;
begin
	Result := fModule;
end;

function TGroups.GetParentGroups: IGroups;
begin
  Result := fParentGroups;
end;

constructor TGroups.Create(const aModule: TModule; const aGroups: TGroups;
  const aShortDescription: WideString);
begin
  inherited Create;
  fModule := aModule;
  fParentGroups := aGroups;
  fShortDescription := aShortDescription;
end;

constructor TGroups.Create(const aModule: TModule);
begin
	inherited Create;
  fModule := aModule;
end;
{$ENDREGION Groups}

{$REGION GroupsList }

function TGroupsList.GetEnumerator: IGroupsListEnumeratorSpec;
begin
  Result := TListEnumeratorSpec.Create(Self) as IGroupsListEnumeratorSpec;
end;

function TGroupsList.AddGroups(const aShortDescription: WideString): Integer;
begin
  Result := Add(TGroups.Create(fParentGroups.Module as TModule, fParentGroups, aShortDescription));
end;

function TGroupsList.Find(const aShortDescription: WideString): Integer;
var
  I: Integer;
begin
  Result := -1;
  if aShortDescription = '' then
  begin
    fLastError := ARGUMENT_ISEMPTY;
    Exit;
  end;
  for I := 0 to Count - 1 do
    if SameText(Items[I].ShortDescription, aShortDescription) then
    begin
      Result := I;
      Exit;
    end;

end;

function TGroupsList.GetParentGroups: IGroups;
begin
  Result := fParentGroups;
end;

constructor TGroupsList.Create(const aGroups: TGroups);
begin
  inherited Create;
  fParentGroups := aGroups;
end;
{$ENDREGION GroupsList }

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


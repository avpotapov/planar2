unit uLibraries;

{$mode objfpc}{$H+}

interface

uses
  // Константы, типы и т.д.
	uDefs,
  // Интерфейсы коллекций
  uFglExt;

const
  DUPLICATE_KEY = 1;
  CONTAINER_IS_NIL = 2;
  ARGUMENT_ISEMPTY = 3;

type
  IBase = interface;

  ILibraries = interface;
  ILibrary = interface;
  IModuleDefine = interface;
  IModule = interface;
  IBaseDescription = interface;
  IPreSets = interface;
  IPickLists = interface;
  IBitsSet = interface;
  IRegisters = interface;
  IVars = interface;
  IVarDefine = interface;
  IPickList = interface;
  IPickItem = interface;
  IBits = interface;
  IBitDefine = interface;
  IGroups = interface;
  IGroup = interface;
  IGroupsList = interface;
  IGroupItem = interface;



{$REGION Базовые интерфейсы библиотеки (включен код ошибки)}

  // Базовый интерфейс для элементов
  IBase = interface
    ['{8AC3D981-F071-4A23-A80F-F205E1DEFE92}']
    function GetLastError: integer;
  end;

  // Базовый интерфейс карты отображения
  generic IBaseMap<TKey, TData> = interface(specialize IFpgMap<TKey, TData>)
  	['{A66B9D52-398F-470E-9B77-22844E1243BA}']
    function GetLastError: integer;
  end;

  // Базовый интерфейс списка
  generic IBaseList<T> = interface(specialize IFpgList<T>)
    ['{ABDDC08E-E34B-4EC0-A43C-0174BD58D6B3}']
    function GetLastError: integer;
  end;

  // Интерфейс клонирования объекта
  generic IClonable<T> = interface
    ['{FE984462-7A03-49C3-97DB-0FC89DC6F3ED}']
    function Clone(const aDeep: boolean = True): T;
  end;


{$ENDREGION}

  // Интерфейс многострочного текста
  IDescription = specialize IFpgList<WideString>;
  IClonableDescription = specialize IClonable<IDescription>;

  // Вся библиотека
  ILibraries = interface(IBase)
    ['{7E1E04F0-581D-4789-A3FF-52850E371A10}']
    function GetLibrary(ATypeLibrary: TTypeLibrary): ILibrary;
  	property Libraries[ATypeLibrary: TTypeLibrary] : ILibrary read GetLibrary; default;
  end;

  // Коллекция модулей библиотеки
  ILibrary = interface(specialize IBaseMap<word, IModuleDefine>)
    ['{060A6576-A6DA-400F-B418-B0D41C5C2640}']
    function GetTypeLibrary: TTypeLibrary;
    property TypeLibrary: TTypeLibrary read GetTypeLibrary;

    property Module[aUid: Word]: TData read GetKeyData; default;
  end;

  // Описание модуля
  IModuleDefine = interface(IBase)
    ['{A050DFAF-E18A-4272-ACB8-47414201541F}']
    function GetUid: Word;
    procedure SetUid(const aUid: Word);
    property Uid: Word read GetUid write SetUid;

    function GetName: WideString;
    procedure SetName(const aName: WideString);
    property Name: WideString read GetName write SetName;

    function GetTypeSignature: TTypeSignature;
    procedure SetTypeSignature(const aTypeSignature: TTypeSignature);
    property TypeSignature: TTypeSignature read GetTypeSignature write SetTypeSignature;

    function GetTypeBootloader: TTypeBootloader;
    procedure SetTypeBootloader(const aTypeBootloader: TTypeBootloader);
    property TypeBootloader: TTypeBootloader read GetTypeBootloader write SetTypeBootloader;

    function GetModule: IModule;
    property Module: IModule read GetModule;

    function GetLibrary: ILibrary;
    property Lib: ILibrary read GetLibrary;
  end;

  // Содержание модуля
  IModule = interface(IBase)
    ['{4A44E843-C50D-419E-AD6B-55EC62CDC0B6}']
    function GetModuleDefine: IModuleDefine;
    property ModuleDefine: IModuleDefine read GetModuleDefine;

    function GetRegisters: IRegisters;
    property Registers: IRegisters read GetRegisters;

    function GetDescription: IBaseDescription;
    property Description: IBaseDescription read GetDescription;

    function GetPreSets: IPreSets;
    property PreSets: IPreSets read GetPreSets;

    function GetConfiguration: IGroups;
    property Configuration: IGroups read GetConfiguration;

  end;

  // Назначение модуля
  IBaseDescription = interface(IBase)
    ['{FAA522EF-E8DC-4329-9DB8-11DE590004E3}']
    function GetDescription: IDescription;
    property Description: IDescription read GetDescription;

    function GetImage:WideString;
    procedure SetImage(const aImage: WideString);
    property Image: WideString read GetImage write SetImage;

    function GetModule: IModule;
    property Module: IModule read GetModule;
  end;

  // Предустановленные значения
  IPreSets = interface(IBase)
  ['{7D6AA590-3951-46C6-91C5-AF1C42483146}']
    function GetPickLists: IPickLists;
    property PickLists: IPickLists read GetPickLists;

    function GetBitsSet: IBitsSet;
    property BitsSet: IBitsSet read GetBitsSet;

    function GetModule: IModule;
    property Module: IModule read GetModule;
  end;

   // Предустановленный список значений
  IPickLists = interface(specialize IBaseMap<WideString, IPickList>)
   ['{1F3FA130-6B3E-444B-A1F9-96AF4AD14FCC}']
   function GetPreSets: IPreSets;
   property PreSets: IPreSets read GetPreSets;
   property PickLists[aName: WideString]: TData read GetKeyData; default;
  end;

  // Предустановленный список наборов битов
  IBitsSet = interface(specialize IBaseMap<WideString, IBits>)
   ['{86EB0665-CC7B-4A61-9201-37B685FAF1B1}']
   function GetPreSets: IPreSets;
   property PreSets: IPreSets read GetPreSets;
   property BitsSet[aName: WideString]: TData read GetKeyData; default;
  end;

  // Коллекция всех регистров
  IRegisters = interface (IBase)
    ['{EF531012-BB25-47F7-9B23-6BCA403030C3}']
    function GetVars(ATypeRegister: TTypeRegister): IVars;
    property Vars[ATypeRegister: TTypeRegister]: IVars read GetVars; default;

    function GetModule: IModule;
    property Module: IModule read GetModule;
  end;

  // Коллекция переменных одного типа регистров
  IVars = interface(specialize IBaseMap<WideString, IVarDefine>)
  ['{F89445AD-9C72-465F-838D-E73693E73113}']
    function GetTypeRegister: TTypeRegister;
    property TypeRegister: TTypeRegister read GetTypeRegister;

    function GetRegisters: IRegisters;
    property Registers: IRegisters read GetRegisters;

    property VarDefine[aUid: WideString]: TData read GetKeyData; default;
  end;

  // Описание переменной
  IVarDefine = interface(IBase)
    ['{F4641ADE-3469-4079-992C-1B62B9FD32EB}']

    function GetAccess: TAccess;
    procedure SetAccess(const aAccess: TAccess);
    property Access: TAccess read GetAccess write SetAccess;

    function GetVarType: TVarType;
    procedure SetVarType(const aVarType: TVarType);
    property VarType: TVarType read GetVarType write SetVarType;

    function GetKind: TKind;
    procedure SetKind(const aKind: TKind);
    property Kind: TKind read GetKind write SetKind;

    function GetReadAlways: Boolean;
    procedure SetReadAlways(const aReadAlways: Boolean);
    property ReadAlways: Boolean read GetReadAlways write SetReadAlways;

    function GetDescription: IDescription;
    property Description: IDescription read GetDescription;

    function GetMultipler: DWord;
    procedure SetMultipler(const aMultipler: DWord);
    property Multipler: DWord read GetMultipler write SetMultipler;

    function GetIndex: Word;
    procedure SetIndex(const aIndex: Word);
    property Index: Word read GetIndex write SetIndex;

    function GetName: WideString;
    procedure SetName(const aName: WideString);
    property Name: WideString read GetName write SetName;

    function GetTypeRegister: TTypeRegister;
    property TypeRegister: TTypeRegister read GetTypeRegister;

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);
    property ShortDescription: WideString read GetShortDescription write SetShortDescription;

    function GetSingleRequest: Boolean;
    procedure SetSingleRequest(const aSingleRequest: Boolean);
    property SingleRequest: Boolean read GetSingleRequest write SetSingleRequest;

    function GetUid: WideString;
    property Uid: WideString read GetUid;

    function GetVer: WideString;
    procedure SetVer(const aVer: WideString);
    property Ver: WideString read GetVer write SetVer;

    function GetSynchronization: TSynchronization;
    procedure SetSynchronization(const aSynchronization: TSynchronization);
    property Synchronization: TSynchronization
      read GetSynchronization write SetSynchronization;

    procedure SetMeasure(const aMeasure: WideString);
    function GetMeasure: WideString;
    property Measure: WideString read GetMeasure write SetMeasure;

    function GetBits: IBits;
    procedure SetBits(const aBits: IBits);
    property Bits: IBits read GetBits write SetBits;

    function GetPickList: IPickList;
    procedure SetPickList(const aPickList: IPickList);
    property Picklist: IPickList read GetPickList write SetPickList;

    function GetVars: IVars;
    property Vars: IVars read GetVars;

  end;
  IClonableVarDefine = specialize IClonable<IVarDefine>;

  // Список
  IPickList = interface(specialize IBaseMap<word, IPickItem>)
    ['{A325ECFD-7226-4405-99E7-64D1CBA0FAE8}']

    function GetName: WideString;
    procedure SetName(const aName: WideString);
    property Name: WideString read GetName write SetName;

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);
    property ShortDescription: WideString read GetShortDescription write SetShortDescription;

    function GetVarDefine: IVarDefine;
    property VarDefine: IVarDefine read GetVarDefine;

    property PickItem[aItem: word]: TData read GetKeyData; default;
  end;
  IClonablePickList = specialize IClonable<IPickList>;

  // Элемент списка
  IPickItem = interface(IBase)
    ['{2661A677-5958-48CE-ADBE-1E7957F11B56}']

    function GetValue: word;
    procedure SetValue(const aValue: word);
    property Value: word read GetValue write SetValue;

    function GetName: WideString;
    procedure SetName(const aName: WideString);
    property Name: WideString read GetName write SetName;

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);
    property ShortDescription: WideString read GetShortDescription write SetShortDescription;

    function GetDescription: IDescription;
    property Description: IDescription read GetDescription;

    function GetVer: WideString;
    procedure SetVer(const aVer: WideString);
    property Ver: WideString read GetVer write SetVer;
  end;
  IClonablePickItem = specialize IClonable<IPickItem>;

  // Набор битов
  IBits = interface(specialize IBaseMap<byte, IBitDefine>)
    ['{EF5D002E-EC55-4A5D-B369-AD4B1DF8BA71}']

    function GetBitsSet: IBitsSet;
    property BitsSet: IBitsSet read GetBitsSet;

    function GetName: WideString;
    procedure SetName(const aName: WideString);
    property Name: WideString read GetName write SetName;

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);
    property ShortDescription: WideString read GetShortDescription write SetShortDescription;

    function GetVarDefine: IVarDefine;
    property VarDefine: IVarDefine read GetVarDefine;

    property BitDefine[aBit: byte]: TData read GetKeyData; default;
  end;
  IClonableBits = specialize IClonable<IBits>;

  // Описание бита
  IBitDefine = interface(IBase)
    ['{583A0377-D1F5-400A-95C4-B8F3ECC724E1}']

    function GetBits: IBits;
    property Bits: IBits read GetBits;

    function GetIndex: byte;
    procedure SetIndex(const aIndex: byte);
    property Index: byte read GetIndex write SetIndex;

    function GetName: WideString;
    procedure SetName(const aName: WideString);
    property Name: WideString read GetName write SetName;

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);
    property ShortDescription: WideString read GetShortDescription write SetShortDescription;

    function GetDescription: IDescription;
    property Description: IDescription read GetDescription;

    function GetVer: WideString;
    procedure SetVer(const aVer: WideString);
    property Ver: WideString read GetVer write SetVer;
  end;
  IClonableBitDefine = specialize IClonable<IBitDefine>;

  // Коллекция групп переменных конфигурации
  IGroups = interface(IBase)
    ['{4A426538-0847-433E-AA2C-C55E32CD3DB8}']
    function GetModule: IModule;
    property Module: IModule read GetModule;

    function GetShortDescription: WideString;
    procedure SetShortDescription(const aShortDescription: WideString);
    property ShortDescription: WideString read GetShortDescription write SetShortDescription;

    function GetGroupsList: IGroupsList;
    property GroupsList: IGroupsList read GetGroupsList;

    function GetParentGroups: IGroups;
    property ParentGroups: IGroups read GetParentGroups;

    function GetGroup: IGroup;
    property Group: IGroup read GetGroup;
  end;

  // Список коллекций групп конфигурации
  IGroupsListEnumeratorSpec = specialize IFpgListEnumerator<IGroups>;
  IGroupsList = interface(specialize IFpgList<IGroups>)
    ['{0C1A424D-6E27-413F-8C21-2CCF742D5B65}']
    function GetParentGroups: IGroups;
    property ParentGroups: IGroups read GetParentGroups;

    function {%H-}GetEnumerator: IGroupsListEnumeratorSpec;
    function AddGroups(const aShortDescription: WideString = ''): Integer;
    function Find(const aShortDescription: WideString): Integer;
  end;

  //  Список групп
  IGroupEnumeratorSpec = specialize IFpgListEnumerator<IGroupItem>;
  IGroup = interface(specialize IBaseList<IGroupItem>)
    ['{43255234-E361-4C44-A2BD-CD0D2E43B366}']

    function GetGroups: IGroups;
    property Groups: IGroups read GetGroups;

    function {%H-}GetEnumerator: IGroupEnumeratorSpec;
    function AddGroupItem(const aVarDefine: IVarDefine): Integer;
  end;

  //  Элемент группы = описание переменной и ее интерфейсное представление
  IGroupItem = interface(IBase)
  ['{F18BB969-B619-44EB-AC12-E080BEF43087}']
  function GetGroup: IGroup;
  property Group: IGroup read GetGroup;

  function GetImageIndex: Integer;
  procedure SetImageIndex(const aImageIndex: Integer);
  property ImageIndex: Integer read GetImageIndex write SetImageIndex;

  function GetVarDefine: IVarDefine;
  property VarDefine: IVarDefine read GetVarDefine;
end;


  {$REGION EXTERNAL}
  function GetNewLibraries: ILibraries; external 'libraries.dll';
  function GetNewGuid: String; external 'libraries.dll';
  {$ENDREGION EXTERNAL}

implementation

end.


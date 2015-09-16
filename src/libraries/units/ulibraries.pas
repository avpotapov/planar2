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

type
  IBase = interface;
  IVarDefine = interface;
  IPickList = interface;
  IPickItem = interface;
  IBits = interface;
  IBitDefine = interface;

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
  IDescription = specialize IFpgList<widestring>;
  IClonableDescription = specialize IClonable<IDescription>;


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

    function GetName: widestring;
    procedure SetName(const aName: widestring);
    property Name: widestring read GetName write SetName;

    function GetTypeRegister: TTypeRegister;
    property TypeRegister: TTypeRegister read GetTypeRegister;

    function GetShortDescription: widestring;
    procedure SetShortDescription(const aShortDescription: widestring);
    property ShortDescription: widestring read GetShortDescription write SetShortDescription;

    function GetSingleRequest: Boolean;
    procedure SetSingleRequest(const aSingleRequest: Boolean);
    property SingleRequest: Boolean read GetSingleRequest write SetSingleRequest;

    function GetUid: widestring;
    property Uid: widestring read GetUid;

    function GetVer: widestring;
    procedure SetVer(const aVer: widestring);
    property Ver: widestring read GetVer write SetVer;

    function GetSynchronization: TSynchronization;
    procedure SetSynchronization(const aSynchronization: TSynchronization);
    property Synchronization: TSynchronization
      read GetSynchronization write SetSynchronization;

    procedure SetMeasure(const aMeasure: widestring);
    function GetMeasure: widestring;
    property Measure: widestring read GetMeasure write SetMeasure;

    function GetBits: IBits;
    procedure SetBits(const aBits: IBits);
    property Bits: IBits read GetBits write SetBits;

    function GetPickList: IPickList;
    procedure SetPickList(const aPickList: IPickList);
    property Picklist: IPickList read GetPickList write SetPickList;

  end;
  IClonableVarDefine = specialize IClonable<IVarDefine>;


  // Список
  IPickList = interface(specialize IBaseMap<word, IPickItem>)
    ['{A325ECFD-7226-4405-99E7-64D1CBA0FAE8}']

    function GetName: widestring;
    procedure SetName(const aName: widestring);
    property Name: widestring read GetName write SetName;

    function GetShortDescription: widestring;
    procedure SetShortDescription(const aShortDescription: widestring);
    property ShortDescription: widestring read GetShortDescription write SetShortDescription;

    property PickItem[aItem: word]: TData read GetKeyData; default;
  end;
  IClonablePickList = specialize IClonable<IPickList>;

  // Элемент списка
  IPickItem = interface(IBase)
    ['{2661A677-5958-48CE-ADBE-1E7957F11B56}']

    function GetValue: word;
    procedure SetValue(const aValue: word);
    property Value: word read GetValue write SetValue;

    function GetName: widestring;
    procedure SetName(const aName: widestring);
    property Name: widestring read GetName write SetName;

    function GetShortDescription: widestring;
    procedure SetShortDescription(const aShortDescription: widestring);
    property ShortDescription: widestring read GetShortDescription write SetShortDescription;

    function GetDescription: IDescription;
    property Description: IDescription read GetDescription;

    function GetVer: widestring;
    procedure SetVer(const aVer: widestring);
    property Ver: widestring read GetVer write SetVer;
  end;
  IClonablePickItem = specialize IClonable<IPickItem>;

  // Набор битов
  IBits = interface(specialize IBaseMap<byte, IBitDefine>)
    ['{EF5D002E-EC55-4A5D-B369-AD4B1DF8BA71}']
    function GetName: widestring;
    procedure SetName(const aName: widestring);
    property Name: widestring read GetName write SetName;

    function GetShortDescription: widestring;
    procedure SetShortDescription(const aShortDescription: widestring);
    property ShortDescription: widestring read GetShortDescription write SetShortDescription;

    property BitDefine[aBit: byte]: TData read GetKeyData; default;
  end;
  IClonableBits = specialize IClonable<IBits>;

  // Описание бита
  IBitDefine = interface(IBase)
    ['{583A0377-D1F5-400A-95C4-B8F3ECC724E1}']

    function GetIndex: byte;
    procedure SetIndex(const aIndex: byte);
    property Index: byte read GetIndex write SetIndex;

    function GetName: widestring;
    procedure SetName(const aName: widestring);
    property Name: widestring read GetName write SetName;

    function GetShortDescription: widestring;
    procedure SetShortDescription(const aShortDescription: widestring);
    property ShortDescription: widestring read GetShortDescription write SetShortDescription;

    function GetDescription: IDescription;
    property Description: IDescription read GetDescription;

    function GetVer: widestring;
    procedure SetVer(const aVer: widestring);
    property Ver: widestring read GetVer write SetVer;
  end;
  IClonableBitDefine = specialize IClonable<IBitDefine>;

implementation

end.


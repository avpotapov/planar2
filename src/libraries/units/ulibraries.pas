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
  generic IClone<T> = interface
    ['{FE984462-7A03-49C3-97DB-0FC89DC6F3ED}']
    function Clone(const aDeep: boolean = True): T;
  end;


{$ENDREGION}

  // Интерфейс многострочного текста
  IDescription = specialize IFpgList<string>;
  IClonedDescription = specialize IClone<IDescription>;


  // Описание переменной
  IVarDefine = interface(IBase)
    ['{F4641ADE-3469-4079-992C-1B62B9FD32EB}']


  end;


  // Список
  IPickList = interface(specialize IBaseMap<word, IPickItem>)
    ['{A325ECFD-7226-4405-99E7-64D1CBA0FAE8}']

    function GetName: string;
    procedure SetName(const aName: string);
    property Name: string read GetName write SetName;

    function GetShortDescription: string;
    procedure SetShortDescription(const aShortDescription: string);
    property ShortDescription: string read GetShortDescription write SetShortDescription;

    property PickItem[aItem: word]: TData read GetKeyData; default;
  end;
  IClonedPickList = specialize IClone<IPickList>;

  // Элемент списка
  IPickItem = interface(IBase)
    ['{2661A677-5958-48CE-ADBE-1E7957F11B56}']

    function GetValue: word;
    procedure SetValue(const aValue: word);
    property Value: word read GetValue write SetValue;

    function GetName: string;
    procedure SetName(const aName: string);
    property Name: string read GetName write SetName;

    function GetShortDescription: string;
    procedure SetShortDescription(const aShortDescription: string);
    property ShortDescription: string read GetShortDescription write SetShortDescription;

    function GetDescription: IDescription;
    procedure SetDescription(const aDescription: IDescription);
    property Description: IDescription read GetDescription write SetDescription;

    function GetVer: string;
    procedure SetVer(const aVer: string);
    property Ver: string read GetVer write SetVer;
  end;
  IClonedPickItem = specialize IClone<IPickItem>;

  // Набор битов
  IBits = interface(specialize IBaseMap<byte, IBitDefine>)
    ['{EF5D002E-EC55-4A5D-B369-AD4B1DF8BA71}']
    function GetName: string;
    procedure SetName(const aName: string);
    property Name: string read GetName write SetName;

    function GetShortDescription: String;
    procedure SetShortDescription(const aShortDescription: String);
    property ShortDescription: String read GetShortDescription write SetShortDescription;

    property BitDefine[aBit: byte]: TData read GetKeyData; default;
  end;
  IClonedBits = specialize IClone<IBits>;

  // Описание бита
  IBitDefine = interface(IBase)
    ['{583A0377-D1F5-400A-95C4-B8F3ECC724E1}']

    function GetIndex: byte;
    procedure SetIndex(const aIndex: byte);
    property Index: byte read GetIndex write SetIndex;

    function GetName: string;
    procedure SetName(const aName: string);
    property Name: string read GetName write SetName;

    function GetShortDescription: string;
    procedure SetShortDescription(const aShortDescription: string);
    property ShortDescription: string read GetShortDescription write SetShortDescription;

    function GetDescription: IDescription;
    property Description: IDescription read GetDescription;

    function GetVer: string;
    procedure SetVer(const aVer: string);
    property Ver: string read GetVer write SetVer;
  end;
  IClonedBitDefine = specialize IClone<IBitDefine>;

implementation

end.


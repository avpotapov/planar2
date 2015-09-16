unit uLibraries;

{$mode objfpc}{$H+}

interface

uses
  uDefs,
  uFglExt;

const
  DUPLICATE_KEY = 1;
  CONTAINER_IS_NIL = 2;

type
  IBase = interface;
  IPickItem = interface;

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
{$ENDREGION}

  // Интерфейс многострочного текста
  IDescription = specialize IFpgList<string>;

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
    property Description: IDescription read GetDescription;

    function GetVer: string;
    procedure SetVer(const aVer: string);
    property Ver: string read GetVer write SetVer;
  end;

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

implementation

end.


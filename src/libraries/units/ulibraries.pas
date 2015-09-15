unit uLibraries;

{$mode objfpc}{$H+}

interface

uses
  uDefs,
  uFglExt;

const
  DUPLICATE_KEY = 1;

type
  IBase = interface;
  IPickItem = interface;


  // Базовый интерфейс для элементов
  IBase = interface
    ['{8AC3D981-F071-4A23-A80F-F205E1DEFE92}']
    function GetLastError: integer;
  end;


  // Интерфейс многострочного текста
  IDescription = specialize IFpgList<string>;

  // Список
  IPickListSpec = specialize IFpgMap<word, IPickItem>;
  IPickList = interface(IPickListSpec)
    ['{A325ECFD-7226-4405-99E7-64D1CBA0FAE8}']
    function GetName: string;
    procedure SetName(const aName: string);

    function GetShortDescription: string;
    procedure SetShortDescription(const aShortDescription: string);
    property PickItem[aItem: word]: TData read GetKeyData; default;
    property Name: string read GetName write SetName;
    property ShortDescription: string read GetShortDescription write SetShortDescription;

  end;


  // Элемент списка
  IPickItem = interface(IBase)
    ['{2661A677-5958-48CE-ADBE-1E7957F11B56}']

    function GetValue: word;
    procedure SetValue(const aValue: word);

    function GetName: string;
    procedure SetName(const aName: string);

    function GetShortDescription: string;
    procedure SetShortDescription(const aShortDescription: string);

    function GetVer: string;
    procedure SetVer(const aVer: string);

    function GetDescription: IDescription;

    property Value: word read GetValue write SetValue;
    property Name: string read GetName write SetName;
    property ShortDescription: string read GetShortDescription write SetShortDescription;
    property Description: IDescription read GetDescription;
    property Ver: string read GetVer write SetVer;
  end;

implementation

end.



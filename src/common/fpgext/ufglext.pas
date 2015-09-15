{
	*
	*   Интерфейсы коллекций
  *    - IFpgList<T>
  *    - IFpgMap<TKey, TData>
  *
}

unit uFglExt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
{$REGION IFpgListEnumerator<T>}
  generic IFpgListEnumerator<T> = interface
    ['{F8CA5F0E-0BFC-463D-8C24-812C01A40749}']

    function GetCurrent: T;
    function MoveNext: boolean;
    property Current: T read GetCurrent;
  end;
{$ENDREGION}

{$REGION IFpgList<T>}
  generic IFpgList<T> = interface
    ['{29E5172A-D9A8-48FD-846C-465B3A71084F}']

    function Get(Index: integer): T;
    procedure Put(Index: integer; const Item: T);
    function GetLast: T;
    procedure SetLast(const Value: T);
    function GetFirst: T;
    procedure SetFirst(const Value: T);
    function Add(const Item: T): integer;
    function Extract(const Item: T): T;
    property First: T read GetFirst write SetFirst;
    function GetEnumerator: specialize IFpgListEnumerator<T>;
    function IndexOf(const Item: T): integer;
    procedure Insert(Index: integer; const Item: T);
    property Last: T read GetLast write SetLast;
    function Remove(const Item: T): integer;
    property Items[Index: integer]: T read Get write Put; default;
    function GetCount: integer;
    property Count: integer read GetCount;
    procedure Clear;
  end;

{$ENDREGION}

  // Перечислитель в IFpgMap<TKey, TData>
  IPtrEnumerator = specialize IFpgListEnumerator<Pointer>;

{$REGION IFpgMap<T>}

  { IFpgMap }

  generic IFpgMap<TKey, TData> = interface
    ['{FDE142EF-8474-4EE6-AF15-56A33F7DAE46}']

    function ExtractData(const aItem: Pointer): TData;
    function ExtractKey(const aItem: Pointer): TKey;
    function GetDuplicates: TDuplicates;
    function GetKey(Index: integer): TKey;
    function GetKeyData(const AKey: TKey): TData;
    function GetData(Index: integer): TData;
    procedure PutKey(Index: integer; const NewKey: TKey);
    procedure PutKeyData(const AKey: TKey; const NewData: TData);
    procedure PutData(Index: integer; const NewData: TData);
    function Add(const AKey: TKey; const AData: TData): integer;
    function Add(const AKey: TKey): integer;
    function Find(const AKey: TKey; out Index: integer): boolean;
    function IndexOf(const AKey: TKey): integer;
    function IndexOfData(const AData: TData): integer;
    procedure InsertKey(Index: integer; const AKey: TKey);
    procedure InsertKeyData(Index: integer; const AKey: TKey; const AData: TData);
    function Remove(const AKey: TKey): integer;
    procedure SetDuplicates(AValue: TDuplicates);
    property Keys[Index: integer]: TKey read GetKey write PutKey;
    property Data[Index: integer]: TData read GetData write PutData;
    property KeyData[const AKey: TKey]: TData read GetKeyData write PutKeyData; default;
    function GetCount: integer;
    property Count: integer read GetCount;
    function GetEnumerator: IPtrEnumerator;
    property Duplicates: TDuplicates read GetDuplicates write SetDuplicates;
    procedure Clear;
  end;

{$ENDREGION}

implementation

end.

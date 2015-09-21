unit uModuleDefine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBase,
  uLibrary,
  uLibraries,
  uDefs;

type

  { TModuleDefine }

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

implementation

uses
  uModule;

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

end.


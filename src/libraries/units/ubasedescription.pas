unit uBaseDescription;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  uBase,
  uModule,
  uLibraries;

type

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

implementation

uses
  uDescription;

{$REGION BaseDescription }

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

end.


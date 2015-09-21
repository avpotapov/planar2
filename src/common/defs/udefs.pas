{
  *
  *  Константы, типы, определения и т.д., используемые в приложениях
  *
}

unit uDefs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

{$REGION Types, Declarations etc.}

resourcestring
  // Строковое представление типов переменных
  sUINT8L = 'UINT8L';
  sUINT8H = 'UINT8H';
  sUINT16 = 'UINT16';
  sSINT16 = 'SINT16';
  sUINT32 = 'UINT32';
  sSINT32 = 'SINT32';
  sUINTIP = 'UINTIP';
  sFLOAT = 'FLOAT';
  sBITMAP16 = 'BITMAP16';
  sBITMAP32 = 'BITMAP32';
  sBOOL = 'BOOL';
  sBOOL_EXT = 'BOOL_EXT';
  sIO_DATA = 'IO_DATA';
  sID_DATA = 'ID_DATA';
  sID_VERSION = 'ID_VERSION';
  sID_SN = 'ID_SN';
  sID_HARD = 'ID_HARD';
  sID_SOFT = 'ID_SOFT';
  sID_PROJECT = 'ID_PROJECT';
  sID_BOX = 'ID_BOX';
  sID_PLANT = 'ID_PLANT';
  sID_TYPEFIRMWARE = 'ID_TYPEFIRMWARE';
  sPROC = 'PROC';
  sUNKNOWN = 'UNKNOWN';

  // Строковое представление уровня доступа
  sUSER = 'Пользователь';
  sDEVELOPER = 'Разработчик';
  sSERVICE = 'Сервис';

  // Строковое представление разновидности переменной
  sNormal = 'Обычная';
  sGauge = 'Калибровочная';

  // Строковое представление разновидности регистров
  sHolding = 'HOLDING';
  sInput = 'INPUT';

  // Строковое представление синхронизации: 0 Двунаправленный, 1 Принудительный, 2 Только запись
  sBedirectional = 'Двунаправленный';
  sForce = 'Принудительный';
  sReadOnly = 'Только запись';

type

  // Разделы бибилиотеки:  разработчика, пользователя
  TTypeLibrary = (tlVerdor, tlCustom);
  // Типы сигнатур:  автоопределение, RCCU, автоопределение недоступно (старые)
  TTypeSignature = (sgNone = 0, sgAuto, sgRccu);
  // Типы bootloader'а: 1 - без записи в 120-124 смещение, 2 - с записью, 3 - с шифрованием
  TTypeBootloader = (bl1 = 1, bl2, bl3);
  // Тип регистра: Holding, Input
  TTypeRegister = (trHolding, trInput);
  TTypeRegisters = array[TTypeRegister] of WideString;

  // Уровень доступа: пользователь, производитель, сервис
  TAccess = (acUser, acDeveloper, acService);
  TAccesses = array[TAccess] of WideString;

  // Разновидность переменной: обычный, калибровочный
  TKind = (kdNormal, kdGauge);
  TKinds = array[TKind] of WideString;

  // Режимы синхронизации: 0 Двунаправленный, 1 Принудительный, 2 Только запись
  TSynchronization = (syBedirectional, syForce, syReadOnly);
  TSynchronizations = array[TSynchronization] of WideString;

  // Тип переменной
  TVarType = (
    vtUINT8L,    // младший 8-битная беззнаковая целочисленная              0 .. 255          byte
    vtUINT8H,    // старшая 8-битная беззнаковая целочисленная              0 .. 255          byte
    vtUINT16,    // 16-разрядная беззнаковая     целочисленная              0 .. 65535        word
    vtSINT16,    // 16-разрядная знаковая        целочисленная         -32768 .. -32767       smallint
    vtUINT32,    // 32-разрядная беззнаковая     целочисленная              0 .. -2147483647  dword
    vtSINT32,    // 32-разрядная знаковая        целочисленная    -2147483648 .. -2147483647  longint
    vtFLOAT,     // 32 бита с плавающей запятой                                               single
    vtBITMAP16,  // 16-разрядная беззнаковая     целочисленная              0 .. 65535        word
    vtBITMAP32,  // 32-разрядная беззнаковая     целочисленная              0 .. -2147483647  dword
    vtBOOL,      // 16-битная
    vtBOOL_EXT,  // 16-битная
    vtUINTIP,    // 32-разрядная беззнаковая     целочисленная              0 .. -2147483647  dword
    vtIO_DATA,
    vtID_DATA,
    vtID_VERSION,
    vtID_SN,
    vtID_HARD,
    vtID_SOFT,
    vtID_TYPEFIRMWARE,
    vtID_PROJECT,
    vtID_BOX,
    vtID_PLANT,
    vtPROC,
    vtUNKNOWN);

  TVarTypes = specialize TFPGMap<WideString, TVarType>;
{$ENDREGION Types, Declarations etc.}


var
  VarTypes: TVarTypes;
  Accesses: TAccesses;
  Kinds: TKinds;
  TypeRegisters: TTypeRegisters;
  Synchronizations: TSynchronizations;
  DWordTypes: set of TVarType;

implementation


procedure PopulateVarTypes();
begin
  with VarTypes do
  begin
    Add(sUINT8L, vtUINT8L);
    Add(sUINT8H, vtUINT8H);
    Add(sUINT16, vtUINT16);
    Add(sSINT16, vtSINT16);
    Add(sUINT32, vtUINT32);
    Add(sSINT32, vtSINT32);
    Add(sFLOAT, vtFLOAT);
    Add(sBITMAP16, vtBITMAP16);
    Add(sBITMAP32, vtBITMAP32);
    Add(sBOOL, vtBOOL);
    Add(sBOOL_EXT, vtBOOL_EXT);
    Add(sIO_DATA, vtIO_DATA);
    Add(sID_DATA, vtID_DATA);
    Add(sID_VERSION, vtID_VERSION);
    Add(sID_SN, vtID_SN);
    Add(sID_HARD, vtID_Hard);
    Add(sID_SOFT, vtID_SOFT);
    Add(sID_TYPEFIRMWARE, vtID_TYPEFIRMWARE);
    Add(sID_PROJECT, vtID_PROJECT);
    Add(sID_BOX, vtID_BOX);
    Add(sID_PLANT, vtID_PLANT);
    Add(sPROC, vtPROC);
    Add(sUNKNOWN, vtUNKNOWN);
  end;
end;

procedure PopulateAccesses;
begin
  Accesses[acUser] := sUSER;
  Accesses[acDeveloper] := sDeveloper;
  Accesses[acService] := sService;
end;

procedure PopulateKinds;
begin
  Kinds[kdNormal] := sNormal;
  Kinds[kdGauge] := sGauge;
end;

procedure PopulateRegisters;
begin
  TypeRegisters[trHolding] := sHolding;
  TypeRegisters[trInput] := sInput;

end;


procedure PopulateSynchronization;
begin
  Synchronizations[syBedirectional] := sBedirectional;
  Synchronizations[syForce] := sForce;
  Synchronizations[syReadOnly] := sReadOnly;

end;


initialization

  begin
    DWordTypes := [vtUINT32, vtSINT32, vtFLOAT, vtBITMAP32, vtBOOL_EXT,
      vtUINTIP, vtIO_DATA];

    VarTypes := TVarTypes.Create;
    PopulateVarTypes();

    PopulateAccesses();

    PopulateKinds();

    PopulateRegisters();

    PopulateSynchronization();
  end;

finalization
  begin
    FreeAndNil(VarTypes);
  end;

end.

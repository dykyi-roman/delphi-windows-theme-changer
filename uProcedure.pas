unit uProcedure;

interface

uses
  Graphics, Windows, Controls, Forms;

// процедуры для получения пути к папке System32
function  GetSystem32Path: string;
// процедуры для получения пути к папке Windows
function  GetWinPath: string;
// процедуры для проверки включеный GUI или нет
function  IsGUI: Boolean;

/// <summary>Процедура для редактирования темы</summary>
procedure SetStrToIni(const Section, Ident, Value: string);
/// <summary>Процедура для редактирования темы</summary>
procedure SetIntToIni(const Section, Ident: string; const Value: Integer);
/// <summary>Процедура для рисования системных курсоров</summary>
procedure DrawCursor(ACanvas: TCanvas; ACursor: TCursor); overload;
/// <summary>Процедура для рисования своих курсоров</summary>
procedure DrawCursor(ACanvas: TCanvas; ACursor: String); overload;
/// <summary>Процедура для получения параметров из файла темы</summary>
function  GetStrFromIni(const Section, Ident, Value: string): string;
/// <summary>процедура для изминения иконок в теме</summary>
function  PickIcon(hwndicon: HWND; var iconfile : string; var iconindex: integer): Boolean;

var
  ThemePath: string;

implementation

uses
  SHFolder, Inifiles, SysUtils, activex;

/// <summary>Диалог для вибора иконки</summary>
function PickIconDlg(Handle: THandle; FileName: PChar; FileNameSize: integer; var IconIndex: Integer): Boolean; stdcall; external 'shell32.dll' index 62;

function PickIcon(hwndicon: HWND; var iconfile : string; var iconindex: integer): Boolean;
var
  buf : widestring;
  idx : Integer;
begin
 // buf wird mit korrekter Länge angelegt
  SetLength(buf, MAX_PATH * 2);
  ZeroMemory(@buf[1],length(buf));

  //Show open icon dialog
  Result := PickIconDlg(hwndicon, PChar(PWideChar(buf)), length (buf), idx);
  if Result then
    begin
      iconfile  := WideCharToString(Pwidechar(buf));
      iconindex := idx;              // return icon index
    end;
end;

procedure DrawCursor(ACanvas: TCanvas; ACursor: TCursor);
var
   HCursor : THandle;
begin
  HCursor := Screen.Cursors[Ord(ACursor)];//Gets the cursor handle.
  DrawIcon(ACanvas.Handle, 0, 0, HCursor);//Draws to canvas
end;

procedure DrawCursor(ACanvas: TCanvas; ACursor: String);
var
  HCursor : THandle;
begin
  HCursor := LoadCursorFromFile(PChar(ACursor));
  DrawIcon(ACanvas.Handle, 0, 0, HCursor);//Draws to canvas
end;

function GetStrFromIni(const Section, Ident, Value: string): string;
var
  ini: TIniFile;
begin
  //Change Theme
  ini := TIniFile.Create(ThemePath);
  try
    Result := ini.ReadString(Section, Ident, '');
  finally
    FreeAndNil(ini);
  end;
end;

procedure SetStrToIni(const Section, Ident, Value: string);
var
  ini: TIniFile;
begin
  //Change Theme
  ini := TIniFile.Create(ThemePath);
  try
    ini.WriteString(Section, Ident, Value);
  finally
    FreeAndNil(ini);
  end;
end;

procedure SetIntToIni(const Section, Ident: string; const Value: Integer);
var
  ini: TIniFile;
begin
  //Change Theme
  ini := TIniFile.Create(ThemePath);
  try
    ini.WriteInteger(Section, Ident, Value);
  finally
    FreeAndNil(ini);
  end;
end;

//http://www.sqldoc.net/get-system-folder-in-delphi.html
function GetSpecialFolderPath(folder : integer) : string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
end;

function GetWinPath: string;
begin
 Result := IncludeTrailingPathDelimiter( GetSpecialFolderPath(CSIDL_WINDOWS));
end;

function GetSystem32Path: string;
begin
 Result := IncludeTrailingPathDelimiter( GetSpecialFolderPath(CSIDL_SYSTEM));
end;

function IsGUI: Boolean;
var
  tmp: string;
begin
  tmp := GetWinPath;
  Result := CreateDir(tmp + 'test');
  if Result then
    RemoveDir(tmp + 'test');
end;

end.

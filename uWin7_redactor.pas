//http://msdn.microsoft.com/en-us/library/bb773190(VS.85).aspx#theme

unit uWin7_redactor;

interface

uses
  uTypes, Graphics;

const
 ICON_PC            = 'CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\DefaultIcon';
 ICON_USER          = 'CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}\DefaultIcon';
 ICON_NETWORK       = 'CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\DefaultIcon';
 ICON_RECYCLE       = 'CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon';
 CURSORS            = 'Control Panel\Cursors';
 DESKTOP            = 'Control Panel\Desktop';
 COLORS             = 'Control Panel\Colors';
 THEME_COLORS       = 'VisualStyles';
 SOUNDS             = 'AppEvents\Schemes\Apps\.Default\%s';
 THEME              = 'Theme';

procedure SetTemeName_win7(Name: string);
procedure ChangeDesktop_win7(ImagePath: string; WallpaperStyle: TWallpaperStyle);
procedure ChangeLogWallpaper_win7(ImagePath: string);
procedure ChangeIcon_win7(Icon: TIcon_type; Value: string);
procedure ChangeCursor_win7(Cursor: string; Value: string);
procedure ChangeColor_win7(Color: String; Value: TColor);
procedure ChangeThemeColor_win7(Value: TColor);
procedure ChangeSound_win7(Sound: String; Value: string);

implementation

uses
  SysUtils, Windows, Controls, Registry, Inifiles, uProcedure;

procedure ChangeDesktop_win7(ImagePath: string; WallpaperStyle: TWallpaperStyle);
begin
  // Изменяем картинку на роб столе
   SetStrToIni(DESKTOP, 'Wallpaper', ImagePath);
  // задаем параметры для картинки
   SetIntToIni(DESKTOP, 'WallpaperStyle', Integer(WallpaperStyle))
end;

procedure ChangeLogWallpaper_win7(ImagePath: string);
var
  Reg: TRegistry;
  tmp: string;
begin
  // проверяем присутстивия файла
  if not FileExists(ImagePath) then
    Exit;

  //производим действия с реестром
  Reg := TRegistry.Create;
  Try
     Reg.RootKey := HKEY_LOCAL_MACHINE;
     Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background', True);
     Reg.WriteInteger('OEMBackground', 1);
  Finally
    Reg.Free;
  End;

  //Сосздаем нужные файли и папки
  tmp := GetSystem32Path;
  if not DirectoryExists( tmp + 'oobe\info') then
    CreateDir(tmp + 'oobe\info');

  if not DirectoryExists( tmp + 'oobe\info\backgrounds') then
    CreateDir(tmp + 'oobe\info\backgrounds');

   tmp := tmp + 'oobe\info\backgrounds\backgroundDefault.jpg';
   CopyFile(Pchar(ImagePath), Pchar(tmp), false);

   //Вносим изминения в тему
   SetIntToIni('Theme','SetLogonBackground',1);
end;

procedure SetTemeName_win7(Name: string);
begin
   SetStrToIni(THEME, 'DisplayName', Name);
end;

procedure SetIconPC(Name: string);
begin
   SetStrToIni(THEME, 'DisplayName', Name);
end;

procedure ChangeIcon_win7(Icon: TIcon_type; Value: string);
begin
  // Опредиляем тип иконки котурую будем менять
  case Icon of
    it_pc:
      SetStrToIni(ICON_PC,      'DefaultValue', Value);
    it_user:
      SetStrToIni(ICON_USER,    'DefaultValue', Value);
    it_network:
      SetStrToIni(ICON_NETWORK, 'DefaultValue', Value);
    it_recycle_full:
      SetStrToIni(ICON_RECYCLE, 'Full', Value);
    it_recycle_empty:
      SetStrToIni(ICON_RECYCLE, 'Empty', Value);
  end;
end;

procedure ChangeCursor_win7(Cursor: string; Value: string);
begin
    if Cursor = 'crDefault' then
      SetStrToIni(CURSORS,'DefaultValue',Value)
    else
      SetStrToIni(CURSORS,Copy(Cursor,3,length(Cursor)),Value);
end;

procedure ChangeColor_win7(Color: String; Value: TColor);

// превращаем цветовую схему в RGB
function ColotToRGBText(AColor: TColor): string;
var
  Color  : Longint;
  r, g, b: Byte;
begin
  Color := ColorToRGB(AColor);
  r     := Color;
  g     := Color shr 8;
  b     := Color shr 16;
  Result := Format('%d %d %d',[r,g,b]);
end;

begin
  SetStrToIni(COLORS, Color, ColotToRGBText(Value));
end;

procedure ChangeThemeColor_win7(Value: TColor);

function ColotToHexText(AColor: TColor): string;
begin
   Result := '0x' +
     IntToHex(GetRValue(AColor), 2) +
     IntToHex(GetGValue(AColor), 2) +
     IntToHex(GetBValue(AColor), 2) ;
end;

begin
  SetStrToIni(THEME_COLORS, 'ColorizationColor', ColotToHexText(Value));
end;

procedure ChangeSound_win7(Sound: String; Value: string);
begin
  SetStrToIni(Format(SOUNDS,[Sound]), 'DefaultValue', Value);
end;

end.
unit uRedactor;

interface

uses
  uTypes, Graphics;

/// <summary>Процедура для установки имени для темы</summary>
procedure SetTemeName(Name: string);
/// <summary>Процедура для установки заставки</summary>
procedure ChangeDesktop(ImagePath: string; WallpaperStyle: TWallpaperStyle);
/// <summary>Процедура для установки заставки приветсвия</summary>
procedure ChangeLogWallpaper(ImagePath: string);

/// <summary>Процедура для изминения иконки</summary>
///   <param name="Icon">Тип иконки</param>
///   <param name="Value">Значения иконки</param>
procedure ChangeIcon(Icon: TIcon_type; Value: string);

/// <summary>Процедура для изминения курсора</summary>
///   <param name="Cursor">Названия курсора для изминения</param>
///   <param name="Value">путь к файлу</param>
procedure ChangeCursor(Cursor: string; Value: string);

/// <summary>Процедура для изминения цветовой схемы</summary>
///   <param name="Color">Названия цвета для изминения</param>
///   <param name="Value">Цвет</param>
procedure ChangeColor(Color: String; Value: TColor);

/// <summary>Процедура для изминения цветовой схемы темы</summary>
/// <param name="Color">HEX код цвета</param>///
procedure ChangeThemeColor(Value: TColor);

/// <summary>Процедура для изминения звуковой схемы</summary>
///   <param name="Color">Названия звука для изминения</param>
///   <param name="Value">путь к файлу</param>
procedure ChangeSound(Sound: String; Value: string);

implementation

uses
  Windows, SysUtils, uWin7_redactor;

/// <summary>Процедура для опредиления типа ОС</summary>
function DetectWinVersion: TWinVersion;
var
  OSVersionInfo: TOSVersionInfo;
begin
  Result := wvUnknown;
  OSVersionInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
  begin
    case OSVersionInfo.DwMajorVersion of
      3: Result := wvNT3;
      4: case OSVersionInfo.DwMinorVersion of
          0: if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
              Result := wvNT4
            else
              Result := wv95;
          10: Result := wv98;
          90: Result := wvME;
        end;
      5: case OSVersionInfo.DwMinorVersion of
          0: Result := wvW2K;
          1: Result := wvXP;
        end;
      6: Result := wvW7;
      7: Result := wvW8;
    end;
  end;
end;

procedure SetTemeName(Name: string);
begin
  SetTemeName_win7(Name);
end;

procedure ChangeDesktop(ImagePath: string; WallpaperStyle: TWallpaperStyle);
begin
  ChangeDesktop_win7(ImagePath, WallpaperStyle);
end;

procedure ChangeLogWallpaper(ImagePath: string);
begin
  ChangeLogWallpaper_win7(ImagePath);
end;

procedure ChangeIcon(Icon: TIcon_type; Value: string);
begin
  ChangeIcon_win7(Icon, Value);
end;

procedure ChangeCursor(Cursor: string; Value: string);
begin
  ChangeCursor_win7(Cursor, Value);
end;

procedure ChangeColor(Color: String; Value: TColor);
begin
  ChangeColor_win7(Color, Value);
end;

procedure ChangeThemeColor(Value: TColor);
begin
  ChangeThemeColor_win7(Value);
end;

procedure ChangeSound(Sound: String; Value: string);
begin
  ChangeSound_win7(Sound, Value);
end;

end.

unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ComCtrls, Vcl.ImgList, Vcl.ExtDlgs;

type
  TfThemeRedactor = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ActionManager: TActionManager;
    actNew: TAction;
    actSaveAs: TAction;
    actOpen: TAction;
    actClose: TAction;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TTabIcons: TTabSheet;
    System1: TMenuItem;
    actOpenSystemDirTheme: TAction;
    Open2: TMenuItem;
    lbRedactor: TListBox;
    ImageList: TImageList;
    Button1: TButton;
    OpenPictureDlg: TOpenPictureDialog;
    Button2: TButton;
    StaticText1: TStaticText;
    Action1: TAction;
    BitBtn1: TBitBtn;
    actSetThemeAndRun: TAction;
    actThemeOpenAndRun1: TMenuItem;
    Open3: TMenuItem;
    leThemeName: TLabeledEdit;
    btnOk_1: TBitBtn;
    imgPc: TImage;
    StaticText2: TStaticText;
    imgUserFiles: TImage;
    StaticText3: TStaticText;
    imgNetwork: TImage;
    StaticText4: TStaticText;
    imgRecycleFull: TImage;
    imgRecycleEmpty: TImage;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    TTabCursors: TTabSheet;
    TTabColors: TTabSheet;
    cbCursor: TComboBox;
    Image1: TImage;
    imgCursosDisplay: TImage;
    btnCursosChange: TButton;
    cbColor: TComboBox;
    StaticText7: TStaticText;
    ColorDlg: TColorDialog;
    btnColorChange: TButton;
    TabSheet3: TTabSheet;
    TabDefaultPage: TTabSheet;
    Memo1: TMemo;
    cbSound: TComboBox;
    StaticText8: TStaticText;
    btnSoundPlay: TBitBtn;
    Button3: TButton;
    stSoundPath: TStaticText;
    imgColorDisplay: TShape;
    btnSoundOpen: TBitBtn;
    cbWallpaperStyle: TComboBox;
    btnCursorOpen: TBitBtn;
    stCursorPath: TStaticText;
    imgThemeColorDisplay: TShape;
    StaticText9: TStaticText;
    btnThemeColorChange: TButton;
    procedure actCloseExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actOpenSystemDirThemeExecute(Sender: TObject);
    procedure lbRedactorDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Button1Click(Sender: TObject);
    procedure lbRedactorClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actSetThemeAndRunExecute(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TTabIconsShow(Sender: TObject);
    procedure imgPcClick(Sender: TObject);
    procedure imgUserFilesClick(Sender: TObject);
    procedure imgNetworkClick(Sender: TObject);
    procedure imgRecycleFullClick(Sender: TObject);
    procedure imgRecycleEmptyClick(Sender: TObject);
    procedure TTabCursorsShow(Sender: TObject);
    procedure cbCursorChange(Sender: TObject);
    procedure btnCursosChangeClick(Sender: TObject);
    procedure btnColorChangeClick(Sender: TObject);
    procedure btnSoundPlayClick(Sender: TObject);
    procedure btnSoundOpenClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnOk_1Click(Sender: TObject);
    procedure btnCursorOpenClick(Sender: TObject);
    procedure btnThemeColorChangeClick(Sender: TObject);
  private
    Procedure PaintImage(AList :TListBox; Control: TWinControl; Index: Integer; Rect: TRect);
  public
    { Public declarations }
  end;

  TDlgTypeRec = record
  type
    TDlgType = (tdtl_Theme, tdtl_Cursor, tdtl_Sound);
  private
    DlgFilter  : TArray<TDlgTypeRec>;
  public
    DefaultExt : string;
    Filter     : string;
    procedure Create;
    procedure SetFilter(DlgType: TDlgType);
  end;

const
  CAPTION_NAME   = 'Theme Redactor';
  SYS_THEME_PATH = 'Resources\Themes';
  SYSTEM_DLL     = 'imageres.dll';

var
  fThemeRedactor: TfThemeRedactor;
  DlgTypeRec    : TDlgTypeRec;

implementation

uses
  Uxtheme, MMSystem, uTypes, Shellapi, uProcedure, uRedactor;

{$R *.dfm}

Procedure TfThemeRedactor.PaintImage(AList :TListBox; Control: TWinControl;Index: Integer; Rect: TRect);
var
  BMPRect: TRect;
  bmp    : TBitmap;
begin
  with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    bmp        := TBitmap.Create;
    try
      bmp.Width  := ImageList.Width;
      bmp.Height := ImageList.Height;
      ImageList.GetBitmap(Index, bmp);
      AList.Canvas.Draw(0, Rect.Top, bmp);
      BMPRect := Bounds(Rect.Left, Rect.Top, ImageList.Width, ImageList.Height);
      TextOut(Rect.Left+ImageList.Width, Rect.Top, AList.Items[index]);
    finally
      bmp.Free;
    end;
  end;
end;

procedure TfThemeRedactor.TTabIconsShow(Sender: TObject);
begin
   leThemeName.Text                   := ExtractFileName(ThemePath);
   imgPc.Picture.Icon.Handle          := ExtractIcon(hInstance, pchar(GetSystem32Path + SYSTEM_DLL), UINT(-109));
   imgUserFiles.Picture.Icon.Handle   := ExtractIcon(hInstance, pchar(GetSystem32Path + SYSTEM_DLL), UINT(-123));
   imgNetwork.Picture.Icon.Handle     := ExtractIcon(hInstance, pchar(GetSystem32Path + SYSTEM_DLL), UINT(-25));
   imgRecycleFull.Picture.Icon.Handle := ExtractIcon(hInstance, pchar(GetSystem32Path + SYSTEM_DLL), UINT(-54));
   imgRecycleEmpty.Picture.Icon.Handle:= ExtractIcon(hInstance, pchar(GetSystem32Path + SYSTEM_DLL), UINT(-55));
end;

procedure TfThemeRedactor.TTabCursorsShow(Sender: TObject);
type
  TGetStrFunc = function(const Value: string): Integer of object;
var
  CursorNames: TStringList;
  AddValue   : TGetStrFunc;
begin
  CursorNames := TStringList.Create;
  try
    AddValue := CursorNames.Add;
    GetCursorValues(TGetStrProc(AddValue));
    cbCursor.Items.Assign(CursorNames);
    cbCursor.ItemIndex := 0;
    cbCursorChange(Sender);
  finally
    CursorNames.Free;
  end;
end;

procedure TfThemeRedactor.actCloseExecute(Sender: TObject);
begin
  if MessageDlg('Save changes?',mtCustom, [mbYes,mbNo], 0) = mrYes then
    actSaveAs.Execute;
  Close;
end;

procedure TfThemeRedactor.actNewExecute(Sender: TObject);
begin
  ThemePath := ExtractFilePath(ParamStr(0) + 'new.theme');
  Caption   := Format('%s [%s]',[CAPTION_NAME, ExtractFileName(ThemePath)]);
end;

procedure TfThemeRedactor.actOpenExecute(Sender: TObject);
begin
//  DlgTypeRec.SetFilter(tdtl_Theme);
  if OpenDlg.Execute then
  begin
    ThemePath := OpenDlg.FileName;
    Caption   := Format('%s [%s]',[CAPTION_NAME, ExtractFileName(ThemePath)]);
  end;
end;

procedure TfThemeRedactor.actOpenSystemDirThemeExecute(Sender: TObject);
var
  tmp: string;
begin
  // Открываем папку з системными темами
  tmp := GetWinPath + SYS_THEME_PATH;
  ShellExecute(Application.Handle, 'open', PChar(tmp), nil, nil, SW_NORMAL);
end;

procedure TfThemeRedactor.actSaveAsExecute(Sender: TObject);
begin
  // сохраняем тему в отдельный файл
  if SaveDlg.Execute then

end;

procedure TfThemeRedactor.actSetThemeAndRunExecute(Sender: TObject);
begin
  //Применяем тему
  ShellExecute(Application.Handle, 'open', PChar(ThemePath), nil, nil, SW_NORMAL);
end;

procedure TfThemeRedactor.BitBtn1Click(Sender: TObject);
begin
  //Применяем тему
  actSetThemeAndRun.Execute;
end;

procedure TfThemeRedactor.btnCursorOpenClick(Sender: TObject);
begin
  DlgTypeRec.SetFilter(tdtl_Cursor);
  if OpenDlg.Execute then
  begin
    stCursorPath.Caption := OpenDlg.FileName;
    DrawCursor(imgCursosDisplay.Canvas, OpenDlg.FileName);
  end;
end;

procedure TfThemeRedactor.Button1Click(Sender: TObject);
begin
  if OpenPictureDlg.Execute then
    ChangeDesktop(OpenPictureDlg.FileName, TWallpaperStyle(cbWallpaperStyle.ItemIndex));
end;

procedure TfThemeRedactor.Button2Click(Sender: TObject);
begin
  if OpenPictureDlg.Execute then
    ChangeLogWallpaper(OpenPictureDlg.FileName);
end;

procedure TfThemeRedactor.Button3Click(Sender: TObject);
begin
  if FileExists(stSoundPath.Caption) then
    ChangeSound(cbSound.Text, stSoundPath.Caption);
end;

procedure TfThemeRedactor.btnColorChangeClick(Sender: TObject);
begin
  if ColorDlg.Execute then
  begin
    ChangeColor(cbColor.Text, ColorDlg.Color);
    imgColorDisplay.Brush.Color := ColorDlg.Color;
  end;
end;

procedure TfThemeRedactor.btnCursosChangeClick(Sender: TObject);
begin
  if FileExists(stCursorPath.Caption) then
    ChangeCursor(cbCursor.Text, stCursorPath.Caption);
end;

procedure TfThemeRedactor.btnOk_1Click(Sender: TObject);
begin
  SetTemeName(leThemeName.Text);
end;

procedure TfThemeRedactor.btnSoundPlayClick(Sender: TObject);
begin
  sndPlaySound(nil, 0);
  if FileExists(stSoundPath.Caption) then
    sndPlaySound(Pchar(stSoundPath.Caption), SND_NODEFAULT Or SND_ASYNC Or SND_LOOP);
end;

procedure TfThemeRedactor.btnThemeColorChangeClick(Sender: TObject);
begin
  if ColorDlg.Execute then
  begin
    ChangeThemeColor(ColorDlg.Color);
    imgThemeColorDisplay.Brush.Color := ColorDlg.Color;
  end;
end;

procedure TfThemeRedactor.cbCursorChange(Sender: TObject);
begin
  imgCursosDisplay.Canvas.Brush.Color := ClWhite;
  imgCursosDisplay.Canvas.FillRect(imgCursosDisplay.Canvas.ClipRect);
  imgCursosDisplay.Repaint;
  DrawCursor(imgCursosDisplay.Canvas, StringToCursor(cbCursor.Text))
end;

procedure TfThemeRedactor.FormCreate(Sender: TObject);
begin
  //Задаем настройки для работы програмы
  DlgTypeRec.Create;
  //
  ThemePath := ExtractFilePath(ParamStr(0)) + 'new.theme';
  Caption   := Format('%s [%s]',[CAPTION_NAME, ExtractFileName(ThemePath)]);
  //
  OpenPictureDlg.InitialDir := ExtractFilePath(ExtractFileDir(ParamStr(0))) + 'img';
  OpenDlg.InitialDir        := ExtractFilePath(ParamStr(0));
  SaveDlg.InitialDir        := ExtractFilePath(ParamStr(0));
  //
end;

procedure TfThemeRedactor.FormShow(Sender: TObject);
 {$IFNDEF DEBUG}
var
  i: Integer;
  {$ENDIF}
begin
  //ховаем в режиме компиляции страницы компонента PageControl
  {$IFNDEF DEBUG}
  for I := 0 to PageControl1.ControlCount -1 do
    PageControl1.Pages[i].TabVisible := False;
  {$ENDIF}
  PageControl1.ActivePage := TabDefaultPage;
end;

procedure TfThemeRedactor.imgNetworkClick(Sender: TObject);
var
  FileName : String;
  Idx      : Integer;
begin
  FileName := SYSTEM_DLL;
  if PickIcon(Handle, FileName, Idx) then
  begin
    ChangeIcon(it_network, Format('%s,-%d',[FileName, Idx]));
    imgNetwork.Picture.Icon.Handle := ExtractIcon(hInstance, pchar(FileName), UINT(Idx));
  end;
end;

procedure TfThemeRedactor.imgPcClick(Sender: TObject);
var
  FileName : String;
  Idx: Integer;
begin
  FileName := SYSTEM_DLL;
  if PickIcon(Handle, FileName, Idx) then
  begin
    ChangeIcon(it_pc, Format('%s,-%d',[FileName, Idx]) );
    imgPc.Picture.Icon.Handle := ExtractIcon(hInstance, pchar(FileName), UINT(Idx));
  end;
end;

procedure TfThemeRedactor.imgRecycleEmptyClick(Sender: TObject);
var
  FileName : String;
  Idx: Integer;
begin
  FileName := SYSTEM_DLL;
  if PickIcon(Handle, FileName, Idx) then
  begin
    ChangeIcon(it_recycle_empty, Format('%s,-%d',[FileName, Idx]));
    imgRecycleEmpty.Picture.Icon.Handle := ExtractIcon(hInstance, pchar(FileName), UINT(Idx));
  end;
end;

procedure TfThemeRedactor.imgRecycleFullClick(Sender: TObject);
var
  FileName : String;
  Idx: Integer;
begin
  FileName := SYSTEM_DLL;
  if PickIcon(Handle, FileName, Idx) then
  begin
    ChangeIcon(it_recycle_full, Format('%s,-%d',[FileName, Idx]));
    imgRecycleFull.Picture.Icon.Handle := ExtractIcon(hInstance, pchar(FileName), UINT(Idx));
  end;
end;

procedure TfThemeRedactor.imgUserFilesClick(Sender: TObject);
var
  FileName : String;
  Idx: Integer;
begin
  FileName := SYSTEM_DLL;
  if PickIcon(Handle, FileName, Idx) then
  begin
    ChangeIcon(it_user, Format('%s,-%d',[FileName, Idx]));
    imgUserFiles.Picture.Icon.Handle := ExtractIcon(hInstance, pchar(FileName), UINT(Idx));
  end;
end;

procedure TfThemeRedactor.lbRedactorClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex := lbRedactor.ItemIndex;
end;

procedure TfThemeRedactor.lbRedactorDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  PaintImage(lbRedactor, Control, Index, Rect);
end;

procedure TfThemeRedactor.btnSoundOpenClick(Sender: TObject);
begin
  DlgTypeRec.SetFilter(tdtl_Sound);
  if OpenDlg.Execute then
    stSoundPath.Caption := OpenDlg.FileName;
end;

{ TDlgTypeRec }

procedure TDlgTypeRec.Create;
begin
  SetLength(DlgFilter,  3);
  DlgFilter[0].DefaultExt := '*.theme';
  DlgFilter[0].Filter     := 'Theme file|*.theme|All file|*.*';
  DlgFilter[1].DefaultExt := '*.cur';
  DlgFilter[1].Filter     := 'Cursor|*.cur|Cursor 2|*.ani';
  DlgFilter[2].DefaultExt := '*.wav';
  DlgFilter[2].Filter     := 'Sound|*.wav|All file|*.*';
end;

procedure TDlgTypeRec.SetFilter(DlgType: TDlgType);
begin
  case DlgType of
    tdtl_Theme:
    begin
      fThemeRedactor.OpenDlg.DefaultExt := DlgFilter[0].DefaultExt;
      fThemeRedactor.OpenDlg.Filter     := DlgFilter[0].Filter;
    end;
    tdtl_Cursor:
    begin
      fThemeRedactor.OpenDlg.DefaultExt := DlgFilter[1].DefaultExt;
      fThemeRedactor.OpenDlg.Filter     := DlgFilter[1].Filter;
    end;
    tdtl_Sound:
    begin
      fThemeRedactor.OpenDlg.DefaultExt := DlgFilter[2].DefaultExt;
      fThemeRedactor.OpenDlg.Filter     := DlgFilter[2].Filter;
    end;
  end;
end;

end.

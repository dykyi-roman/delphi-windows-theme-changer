program ThemeRedactorProject;

uses
  Vcl.Forms,
  Dialogs,
  uMain in 'uMain.pas' {fThemeRedactor},
  uWin7_redactor in 'uWin7_redactor.pas',
  uProcedure in 'uProcedure.pas',
  uRedactor in 'uRedactor.pas',
  uTypes in 'uTypes.pas';

{$R *.res}

const
  mrNo = 7;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  {$IFNDEF DEBUG}
  if not IsGUI then
    if MessageDlg('Please run program as administrator! Else some functionality may not work. Continue?',mtInformation,mbYesNo,0) = mrNo then
      Exit;
  {$ENDIF}

   Application.CreateForm(TfThemeRedactor, fThemeRedactor);
  Application.Run;

end.

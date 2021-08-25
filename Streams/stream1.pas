unit stream1;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, PbInspector, StdCtrls, ComCtrls, PbLogger, PbInpUtil, Buttons,
  PbRun, PbOutputUnit, PbUnit, PbStreamStateUnit, PbGttBalance, ExtCtrls,
  PbObject, PbStream, PbInputStreams, PbConstituent, PbPhase, PbErrHdl,
  PbExceptionDlg;

type
  TForm1 = class(TForm)
    in1_Air: TPbInputStream;
    in1_AirFE: TPbFloatEdit;
    reactor: TPbGttBalance;
    out1: TPbStream;
    outU: TPbOutputUnit;
    PbRun1: TPbRun;
    PbLogger1: TPbLogger;
    in1_Memo: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    out1_Memo: TMemo;
    Mod_out1_Button: TButton;
    Mod_out2_Button: TButton;
    Mod_out3_Button: TButton;
    Mod_out4_Button: TButton;
    Mod_out5_Button: TButton;
    Mod_out6_Button: TButton;
    Mod_in1_Button: TButton;
    Mod_in2_Button: TButton;
    Mod_in3_Button: TButton;
    Mod_in4_Button: TButton;
    Mod_in5_Button: TButton;
    Mod_in6_Button: TButton;
    procedure resetAirStream;
    procedure reactorBeforeCalculation(sender: TPbUnit);
    procedure printStreamContents(stream: TPbStream; memo: TMemo);
    procedure reactorCalculated(sender: TPbUnit);
    procedure in1_AirInputChanged(sender: TPbObject);
    procedure Mod_in1_ButtonClick(Sender: TObject);
    procedure Mod_in2_ButtonClick(Sender: TObject);
    procedure Mod_in3_ButtonClick(Sender: TObject);
    procedure Mod_in4_ButtonClick(Sender: TObject);
    procedure Mod_in5_ButtonClick(Sender: TObject);
    procedure Mod_in6_ButtonClick(Sender: TObject);
    procedure Mod_out1_ButtonClick(Sender: TObject);
    procedure Mod_out2_ButtonClick(Sender: TObject);
    procedure Mod_out3_ButtonClick(Sender: TObject);
    procedure Mod_out4_ButtonClick(Sender: TObject);
    procedure Mod_out5_ButtonClick(Sender: TObject);
    procedure Mod_out6_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MyExceptionHandler(Sender: TObject; E: Exception);
  end;
var
  Form1: TForm1;

implementation

{$R *.lfm}

{
 This procedure displays the amounts of phases, the amounts of phase
 constituents and enthalpy by a TMemo control.
}
procedure TForm1.printStreamContents(stream: TPbStream; memo: TMemo);
var iphase, iconstituent: integer;
    phase: TPbPhase;
    constituent: TPbConstituent;
begin

  {
   First, the current TMemo control is cleared.
  }
  memo.Clear;

  {
   Then, an iteration over the individual phases in the stream is performed and
   the amount of active phases together with its name is displayed by the TMemo
   control.
  }
  for iphase := 0 to stream.PhaseList.Count-1 do
  begin
    phase := stream.PhaseList.Objects[iphase] as TPbPhase;
    if stream.getPhaseAmount(phase.Name) > 0.0 then
      memo.Lines.Add('Amount Phase ' + phase.Name + ': ' +
        FloatToStrF(stream.getPhaseAmount(phase.Name), ffGeneral,
          8, 4 ) + ' mol');

    {
     A second iteration over the individual phase constituents is performed and
     the amount of the individual phase constituent together with its name is
     displayed by the TMemo control.
    }
    for iconstituent := 0 to phase.Constituents.Count-1 do
    begin
      constituent := phase.Constituents.Objects[iconstituent]
        as TPbConstituent;
      if stream.getConstituentAmount(phase.Name, constituent.Name) > 0.0 then
        memo.Lines.Add('Amount ' + constituent.Name
          + '/' + phase.Name + '/: ' +
          FloatToStrF(stream.getConstituentAmount(phase.Name, constituent.Name),
          ffGeneral, 8, 4) + ' mol');
    end;
  end;

  {
   Finally, the enthalphy of the stream is displayed by the TMemo control.
  }
  memo.Lines.Add('');
  memo.Lines.Add('Enthalpy: ' +
    FloatToStrF(stream.Enthalpy, ffGeneral, 8, 4) + ' J');
 end;

{
 Before the calculation of the reactor starts, the contents of the 'in1_Air'
 stream are displayed in the TMemo control in1_Memo.
}
procedure TForm1.reactorBeforeCalculation(sender: TPbUnit);
begin
  printStreamContents(in1_Air, in1_Memo);
end;

{
 After the calculation of the reactor is finished, the 'out1' stream is displayed
 by the TMemo control out1_Memo.
}
procedure TForm1.reactorCalculated(sender: TPbUnit);
begin
  printStreamContents(out1, out1_Memo);
end;

{
 This procedure sets the properties of the in1_Air stream.
}
procedure TForm1.resetAirStream;
begin

  {
   The amounts of O2 and N2 in the gas phase in the stream in1_Air are set
   to 200 and 800 mol, respectively.
  }
  in1_Air.CAmount['GAS','O2'] := 200;
  in1_Air.CAmount['GAS','N2'] := 800;

  {
   The amount of stream in1_Air is set to 1000 mol.
  }
  in1_Air.Amount := 1000;

  {
   The temperature of stream in1_Air is set to 25°C.
  }
  in1_Air.Temperature := 25.0;
end;

procedure TForm1.in1_AirInputChanged(sender: TPbObject);
begin
  printStreamContents(in1_Air, in1_Memo);
end;

{
 The change of composition of the input stream during runtime is handeled via a
 click event on the TButton control Mod_in1_Button.
}
procedure TForm1.Mod_in1_ButtonClick(Sender: TObject);
begin
  resetAirStream;

  {
   The amounts of O2 and N2 in the gas phase in stream in1_Air are changed
   to 250 and 750 mol, respectively.
  }
  in1_Air.CAmount['GAS','O2'] := 250;
  in1_Air.CAmount['GAS','N2'] := 750;
  {
   Alternatively, the following syntax may also be used:
   in1_Air.setConstituentAmount('GAS','O2',250.0);
   in1_Air.setConstituentAmount('GAS','N2',750.0);
  }

  {
   The temperature of the input stream may also be changed:
  }
  in1_Air.Temperature := 50.0;

  {
   The updated properties of stream in1_Air are finally displayed in TMemo
   control in1_Memo.
  }
  printStreamContents(in1_Air, in1_Memo);
end;

{
 Setting one of the phase constituents' amount to zero during runtime is
 handeled via a click event on the TButton control Mod_in2_Button.
}
procedure TForm1.Mod_in2_ButtonClick(Sender: TObject);
begin
  resetAirStream;

  {
   The amounts of O2 in the gas phase in stream in1_Air is changed
   to 0.
  }
  in1_Air.CAmount['GAS','O2'] := 0;
  in1_Air.CAmount['GAS','N2'] := 800;

  {
   The updated properties of stream in1_Air are displayed in TMemo
   control 'in1_Memo'.
  }
  printStreamContents(in1_Air, in1_Memo);
end;

{
 The amount of stream in1_Air can be set to zero and then to a non-zero value;
 this is handeled via a click event on the TButton control Mod_in3_Button.
}
procedure TForm1.Mod_in3_ButtonClick(Sender: TObject);
begin
  resetAirStream;

  {
   First, the amount of stream in1_Air is set to 0 mol.
  }
  in1_Air.Amount := 0.0;

  {
   After that, the stream's amount can be set to a non-zero value again.
   In doing so, the new amount of the stream is calculated proportionally
   adjusting the concentrations of the phase constituents.
  }
  in1_Air.Amount := 2000.0;

  printStreamContents(in1_Air, in1_Memo);
end;

{
 The amount of O2 and N2 in gas phase of stream in1_Air are set to zero;
 this is handeled via a click event on the TButton control Mod_in4_Button.
}
procedure TForm1.Mod_in4_ButtonClick(Sender: TObject);
begin
  resetAirStream;
  {
   Setting the amount of O2 in the gas phase to zeros is permitted and will not
   lead to any errors.
  }
  in1_Air.CAmount['GAS','O2'] := 0;

  {
   Setting the amounts of O2 AND N2 in the gas phase to zero will trigger
   a run time error, since the analysis of the input stream's material will
   be reduced to zeros only.
  }
  in1_Air.CAmount['GAS','N2'] := 0;

  printStreamContents(in1_Air, in1_Memo);
end;


procedure TForm1.Mod_in5_ButtonClick(Sender: TObject);
begin
  resetAirStream;

  {
   This will trigger a run time error, because the access to the TPbStream.Phase
   property is disabled for input streams.
  }
  in1_Memo.Lines.Add('>>> Amount of phase GAS: ' +
     floattostr(in1_Air.Phase['GAS'].Amount) + ' mol');
  {
   Instead TPbStream.getPhaseAmount can be used:
   in1_Memo.Lines.Add('>>> Amount of phase GAS: ' +
   floattostr(in1_Air.getPhaseAmount('GAS')) + ' mol');
  }
end;


procedure TForm1.Mod_in6_ButtonClick(Sender: TObject);
begin
  resetAirStream;

  {
   This will trigger a run time error, because the access to the
   TPbStream.Constituent property is disabled for input streams.
  }
  in1_Memo.Lines.Add('>>> Amount of phase constituent O2/GAS/: ' +
     floattostr(in1_Air.Constituent['GAS','O2'].Amount) + ' mol');
  {
   Instead TPbStream.getConstituentAmount can be used:
   in1_Memo.Lines.Add('>>> Amount of phase constituent O2/GAS/: ' +
   floattostr(in1_Air.getConstituentAmount('GAS','O2')) + ' mol');
  }
end;

{
 The change of composition of the output stream during runtime is handeled via a
 click event on the TButton control Mod_out1_Button.
}
procedure TForm1.Mod_out1_ButtonClick(Sender: TObject);
begin
  out1.CAmount['GAS','O2'] := 250;
  out1.CAmount['GAS','N2'] := 750;

  printStreamContents(out1, out1_Memo);
end;

{
 Setting one of the phase constituents' amount to zero during runtime is
 handeled via a click event on the TButton control Mod_out2_Button.
}
procedure TForm1.Mod_out2_ButtonClick(Sender: TObject);
var phase: TPbPhase;
begin
  out1.CAmount['GAS','O2'] := 0.0;

  phase:=out1.GetPhase('Bla');

  printStreamContents(out1, out1_Memo);

end;

{
 The amount of stream out1 is set to a non-zero value;
 this is handeled via a click event on the TButton control Mod_out3_Button.
}
procedure TForm1.Mod_out3_ButtonClick(Sender: TObject);
begin
  if out1.Amount > 0.0 then
    out1.Amount := 2000.0
  else
    ShowMessage(
      'Run the simulation first to give this stream a' + #13#10 +
      'non-zero amount. Only then can the stream amount' + #13#10 +
      'be set to another non-zero amount') ;

  printStreamContents(out1, out1_Memo);
end;

{
 The amount of stream out1 is set to zero and then to a non-zero value;
 this is handeled via a click event on the TButton control Mod_out4_Button.
}
procedure TForm1.Mod_out4_ButtonClick(Sender: TObject);
begin
  out1.Amount := 0.0;

  {
   Setting the amount of out1 to zero and then assigning it a
   non-zero value will trigger a run time error, since the stream has more
   than one phase.
  }
  out1.Amount := 2000.0;

  printStreamContents(out1, out1_Memo);
end;

{
 The amount of gas phase in the out1 stream is displayed by the TMemo control
 out1_Memo; this is handeled via a click event on the TButton control
 Mod_out5_Button.
}
procedure TForm1.Mod_out5_ButtonClick(Sender: TObject);
begin

  {
   This is ok for streams that are not input streams.
  }
  out1_Memo.Lines.Add('>>> Amount of phase GAS: ' +
     floattostr(out1.Phase['GAS'].Amount) + ' mol');
end;

{
 The amount of a constituent of a phase in the out1 stream is displayed by the
 TMemo control out1_Memo; this is handeled via a click event on the TButton
 control Mod_out6_Button.
}
procedure TForm1.Mod_out6_ButtonClick(Sender: TObject);
begin

  {
   This is ok for streams that are not input streams.
  }
  out1_Memo.Lines.Add('>>> Amount of phase constituent O2/GAS/: ' +
     floattostr(out1.Constituent['GAS','O2'].Amount) + ' mol');
end;

{
 This procedure creates an exception handler.
}
procedure TForm1.MyExceptionHandler(Sender: TObject; E: Exception);
var ErrDlg: TPbSimuSageExceptionDlg;
begin

  ErrDlg := nil;
  {
   If the exception caught is a SimuSage exception, a dialog window is created
   in which the exception message and the help context variables are displayed.
  }
  if (E is ExcSimuSage) then
  begin
    try
      ErrDlg := TPbSimuSageExceptionDlg.create(self);
      ErrDlg.Message := E.Message;
      ErrDlg.HelpContext := E.HelpContext;
      beep;
      ErrDlg.ShowModal;
    finally
      ErrDlg.free;
    end;
  end
  {
   If the exception caught is not a SimuSage exception, the exception is
   displayed the default way using Application.ShowException.
  }
  else
    Application.ShowException(E);
end;

{
 This procedure assigns a custom exception handler when the program is initialized.
}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnException := @MyExceptionHandler;
end;

end.


unit heatexchanger;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, PbInspector, StdCtrls, Buttons, PbRun, ComCtrls, PbLogger,
  PbOutputUnit, PbStreamStateUnit, PbGttBalance, PbUnit, PbHeatExch,
  PbInpUtil, ExtCtrls, PbObject, PbStream, PbInputStreams;

type

  { TForm1 }

  TForm1 = class(TForm)
    inAir: TPbInputStream;
    inAirFE: TPbFloatEdit;
    Label1: TLabel;
    hotAir: TPbStream;
    inCO: TPbInputStream;
    inCOFE: TPbFloatEdit;
    Label2: TLabel;
    reactor: TPbGttBalance;
    outReactor: TPbStream;
    outUnit: TPbOutputUnit;
    PbLogger1: TPbLogger;
    PbRun1: TPbRun;
    Inspector: TPbInspector;
    Panel1: TPanel;
    heater: TPbHeatExch;
    EnthInRB: TRadioButton;
    EnthFE: TPbFloatEdit;
    Label3: TLabel;
    TempEstiFE: TPbFloatEdit;
    Label4: TLabel;
    TempInRB: TRadioButton;
    TempFE: TPbFloatEdit;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure EnthInRBClick(Sender: TObject);
    procedure TempInRBClick(Sender: TObject);
    procedure EnthFEUpdate(updateVal: Double; sender: TObject);
    procedure TempEstiFEUpdate(updateVal: Double; sender: TObject);
    procedure TempFEUpdate(updateVal: Double; sender: TObject);
    procedure heaterCalculated(sender: TPbUnit);
  private
    { private declarations }
  public
    procedure updatefields;
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

{
 When the program is started, one of the radio buttons, corresponding to the two
 calculation modes (TempIn and EnthIn), is selected by default.
}
procedure TForm1.FormCreate(Sender: TObject);
begin
  {
   The case corresponding to CalcMode is selected by default.
  }
  if heater.CalcMode = TempIn then
    TempInRB.Checked := true
  else
    EnthInRB.Checked := true;

  updatefields;

end;

{
 This procedure handles an OnClick event of the EnthIn radio button. If the
 radio button is clicked, the reactor is set to the EnthIn mode.
}
procedure TForm1.EnthInRBClick(Sender: TObject);
begin
  heater.CalcMode := EnthIn;
  self.updatefields;
end;

{
 This procedure handles an OnClick event of the TempIn radio button. If the
 radio button is clicked, the reactor is set to the TempIn mode.
}
procedure TForm1.TempInRBClick(Sender: TObject);
begin
  heater.CalcMode := TempIn;
  self.updatefields;
end;

{
 This procedure assigns the values entered in the EnthFE input field to the
 corresponding property of the heater.
}
procedure TForm1.EnthFEUpdate(updateVal: Double; sender: TObject);
begin
  heater.EnthalpyKJ := updateVal;
end;

{
 This procedure assigns the values entered in the TempEstiFE input field to the
 corresponding property of the heater.
}
procedure TForm1.TempEstiFEUpdate(updateVal: Double; sender: TObject);
begin
  heater.TempEsti := updateVal;
end;

{
 This procedure assigns the values entered in the TempFE input field to the
 corresponding property of the heater.
}
procedure TForm1.TempFEUpdate(updateVal: Double; sender: TObject);
begin
  heater.Temperature := updateVal;
end;

{
 This proceduren reports the calculated results of the heater to the user.
}
procedure TForm1.heaterCalculated(sender: TPbUnit);
begin

  case heater.CalcMode of

    {
     In the case of the TempIn mode, the the enthalpy of the heater will be
     provided in the log window.
    }
    TempIn: AL.log(heater, lcInfo,
      'Enthalpy/KJ is ' + floattostr(heater.EnthalpyKJ));

    {
     In the case of the EnthIn mode, the the temperature of the heater will be
     provided in the log window.
    }
    EnthIn: AL.log(heater, lcInfo,
      'Temperature/C is ' + floattostr(heater.Temperature));
  end;

end;

{
 This procedure checks the selected calculation mode of the heater and
 activates the proper input fields to accept the user's input.
}
procedure TForm1.updatefields;
begin

  case heater.CalcMode of

  {
   In the case of the TempIn mode, the corresponding input field is activated
   while the input fields for the EnthIn mode are deactivated.
  }
  TempIn:
    begin
      TempFE.Enabled := true;
      TempFE.Flt := heater.Temperature;

      EnthFE.Enabled := false;
      TempEstiFE.Enabled := false;
    end;

  {
   In the case of the EnthIn mode, the corresponding input fields are activated
   while the input field for the TempIn mode is deactivated.
  }
  EnthIn:
    begin
      EnthFE.Enabled := true;
      EnthFE.Flt := heater.EnthalpyKJ;
      TempEstiFE.Enabled := true;
      TempEstiFE.Flt := heater.TempEsti;

      TempFE.Enabled := false;
    end;
  end;
end;

end.


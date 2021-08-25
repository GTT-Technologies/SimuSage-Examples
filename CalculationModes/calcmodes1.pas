unit calcmodes1;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PbRun, ComCtrls, PbLogger, PbOutputUnit,
  PbUnit, PbStreamStateUnit, PbGttBalance, PbInpUtil, ExtCtrls, PbObject,
  PbStream, PbInputStreams;

type
  TForm1 = class(TForm)
    CO: TPbInputStream;
    inAirFE: TPbFloatEdit;
    Carbon: TPbInputStream;
    inCarbonFE: TPbFloatEdit;
    Reactor: TPbGttBalance;
    GroupBox1: TGroupBox;
    RBTempIn: TRadioButton;
    RBEnthIn: TRadioButton;
    RBVolIn: TRadioButton;
    TempInFE: TPbFloatEdit;
    Label1: TLabel;
    EnthInFE: TPbFloatEdit;
    Label2: TLabel;
    VolInFE: TPbFloatEdit;
    Label3: TLabel;
    ReactorOut: TPbStream;
    OutUnit: TPbOutputUnit;
    PbLogger1: TPbLogger;
    PbRun1: TPbRun;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RBTempInClick(Sender: TObject);
    procedure RBEnthInClick(Sender: TObject);
    procedure RBVolInClick(Sender: TObject);
    procedure ReactorCalculated(sender: TPbUnit);
  private
    { Private declarations }
  public
    procedure updatefields;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{
 This procedure checks the calculation mode of the reactor at the start of the
 program.
}
procedure TForm1.FormCreate(Sender: TObject);
begin
  case Reactor.CalcMode of
    TempIn:
    begin
      RBTempIn.Checked := true;
      self.updatefields;
    end;
    EnthIn:
    begin
      RBEnthIn.Checked := true;
      self.updatefields;
    end;
    VolIn:
    begin
      RBVolIn.Checked := true;
      self.updatefields;
    end;
  end;
end;

{
 This procedure checks the selected calculation mode of the reactor and
 activates the proper input fields to accept the user's input.
}
procedure TForm1.updatefields;
begin

  TempInFE.Enabled := false;
  EnthInFE.Enabled := false;
  VolInFE.Enabled := false;

  case Reactor.CalcMode of
    TempIn:
    begin
      TempInFE.Enabled := true;
      TempInFE.Flt := Reactor.Temperature
    end;
    EnthIn:
    begin
      EnthInFE.Enabled := true;
      EnthInFE.Flt := Reactor.Enthalpy;
    end;
    VolIn:
    begin
      VolInFE.Enabled := true;
      VolInFE.Flt := Reactor.Volume;
    end;
  end;
end;

{
 This procedure sets the calculation mode of the reactor to TempIn
 (isothermal), if the TRadioButton RBTempIn is clicked.
}
procedure TForm1.RBTempInClick(Sender: TObject);
begin
  Reactor.CalcMode := TempIn;
  self.updatefields;
end;

{
 This procedure sets the calculation mode of the reactor to EnthIn
 (enthalpy difference target), if the TRadioButton RBEnthIn is clicked.
}
procedure TForm1.RBEnthInClick(Sender: TObject);
begin
  Reactor.CalcMode := EnthIn;
  self.updatefields;
end;

{
 This procedure sets the calculation mode of the reactor to VolIn
 (total volume target), if the TRadioButton RBVolIn is clicked.
}
procedure TForm1.RBVolInClick(Sender: TObject);
begin
  Reactor.CalcMode := VolIn;
  self.updatefields;

end;

{
 This procedure displays the temperature, enthalpy and volume of the reactor via
 the TPbFloatEdit controls TempInFE, EnthInFE and VolInFE after the reactor has
 been calculated.
}
procedure TForm1.ReactorCalculated(sender: TPbUnit);
begin
  TempInFE.Flt := Reactor.Temperature;
  EnthInFE.Flt := Reactor.Enthalpy;
  VolInFE.Flt := Reactor.Volume;
end;

end.


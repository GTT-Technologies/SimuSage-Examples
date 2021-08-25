unit net;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PbInpUtil, ExtCtrls, PbObject, PbUnit, PbStream,
  PbInputStreams, PbSplitter2, PbOutputUnit, PbNewMixer, PbInspector,
  ComCtrls, PbLogger, Buttons, PbRun;

type
  TForm1 = class(TForm)
    in1: TPbInputStream;
    in1FE: TPbFloatEdit;
    in2: TPbInputStream;
    in2FE: TPbFloatEdit;
    Mixer1: TPbMixer;
    c1: TPbStream;
    Mixer2: TPbMixer;
    out1: TPbStream;
    outU1: TPbOutputUnit;
    in3: TPbInputStream;
    in3FE: TPbFloatEdit;
    Splitter: TPbSplitter2;
    c2: TPbStream;
    c3: TPbStream;
    Mixer3: TPbMixer;
    in4: TPbInputStream;
    in4FE: TPbFloatEdit;
    out2: TPbStream;
    outU2: TPbOutputUnit;
    calcU1: TButton;
    calcU2: TButton;
    Inspector: TPbInspector;
    c1FE: TPbFloatEdit;
    c2FE: TPbFloatEdit;
    c3FE: TPbFloatEdit;
    out1FE: TPbFloatEdit;
    out2FE: TPbFloatEdit;
    PbLogger1: TPbLogger;
    procedure calcU1Click(Sender: TObject);
    procedure calcU2Click(Sender: TObject);
    procedure doBeforeCalculation(Sender: TPbUnit);
    procedure Mixer1Calculated(sender: TPbUnit);
    procedure Mixer2Calculated(sender: TPbUnit);
    procedure Mixer3Calculated(sender: TPbUnit);
    procedure SplitterCalculated(sender: TPbUnit);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{
 The calculation of output stream (outU1) is started by a click event on
 the calcU1 button.
}
procedure TForm1.calcU1Click(Sender: TObject);
begin
  outU1.process;
end;
{
 The calculation of output stream (outU2) is started by a click event on
 the calcU2 button.
}
procedure TForm1.calcU2Click(Sender: TObject);
begin
  outU2.process;
end;

{
 The OnBeforeCalculation event is used to trace the simulation run. It returns
 a message window to the user with information on which unit operation is
 currently calculated.
}
procedure TForm1.doBeforeCalculation(Sender: TPbUnit);
begin
  MessageDlg('OnBeforeCalculation: ' + Sender.Name, mtInformation,[mbOk], 0);
end;

{
 This procedure displays the updated amounts of the c1 stream after Mixer1 has
 been calculated.
}
procedure TForm1.Mixer1Calculated(sender: TPbUnit);
begin
  c1FE.Flt := c1.Amount;
end;

{
 This procedure displays the updated amounts of the out1 stream after Mixer2 has
 been calculated.
}
procedure TForm1.Mixer2Calculated(sender: TPbUnit);
begin
  out1FE.Flt := out1.Amount;
end;

{
 This procedure displays the updated amounts of the out2 stream after Mixer3 has
 been calculated.
}
procedure TForm1.Mixer3Calculated(sender: TPbUnit);
begin
  out2FE.Flt := out2.Amount;
end;

{
 This procedure displays the updated amounts of the streams c2 and c3 after
 Splitter has been calculated.
}
procedure TForm1.SplitterCalculated(sender: TPbUnit);
begin
  c2FE.Flt := c2.Amount;
  c3FE.Flt := c3.Amount;
end;

end.


unit optimization1;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, PbObject, PbUnit, PbStream, PbInputStreams,
  PbInpUtil, StdCtrls, ComCtrls, PbLogger, PbInspector, Buttons, PbRun,
  PbOptimizer, PbOutputUnit, PbPhaseSplitter, PbStreamStateUnit, PbGttBalance;

type

  { TForm1 }

  TForm1 = class(TForm)
    inAir: TPbInputStream;
    inCarbon: TPbInputStream;
    PbOptimizer1: TPbOptimizer;
    reactor: TPbGttBalance;
    reactorOut: TPbStream;
    splitter: TPbPhaseSplitter;
    outGas: TPbStream;
    outSolids: TPbStream;
    outUnit: TPbOutputUnit;
    inAirFE: TPbFloatEdit;
    inCarbonFE: TPbFloatEdit;
    outGasAMT: TPbFloatEdit;
    outSolidsAMT: TPbFloatEdit;
    reactorTempFE: TPbFloatEdit;
    PbRun1: TPbRun;
    Inspector: TPbInspector;
    PbLogger1: TPbLogger;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure reactorBeforeCalculation(sender: TPbUnit);
    procedure splitterCalculated(sender: TPbUnit);
    procedure outUnitCalculated(sender: TPbUnit);
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
 This procedure displays the total amount of the streams outGas and outSolids
 by the TPbFloatEdit controls outGasAMT and outSolidAMT, respectively, after
 the splitter has been calculated.
}
procedure TForm1.splitterCalculated(sender: TPbUnit);
begin
  outGasAMT.Flt := outGas.Kg;
  outSolidsAMT.Flt := outSolids.Kg;
end;

{
 This procedure starts the optimization.
}
procedure TForm1.reactorBeforeCalculation(sender: TPbUnit);
begin
  PbOptimizer1.Run;
end;

{
 This procedure displays one line of text, showing the total amount of material
 input and the total amount of material output, in the log window.
}
procedure TForm1.outUnitCalculated(sender: TPbUnit);
begin
  AL.log(lcInfo, 'Total input amount: ' +
    FloatToStr(inAir.Kg + inCarbon.Kg) + ' Kg, ' +
    'total output amount: ' +
    FloatToStr(outGas.Kg + outSolids.Kg) + ' Kg');
end;


end.


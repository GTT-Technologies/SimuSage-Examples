unit ccreactor;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, PbOutputUnit, PbInspector, StdCtrls,
  Buttons, PbRun, ComCtrls, PbLogger, PbIterator, PbPhaseSplitter,
  PbUnit, PbStreamStateUnit, PbGttBalance, PbInpUtil, ExtCtrls,
  PbObject, PbStream, PbInputStreams, PbPhase, PbConstituent;

type

  { TForm1 }

  TForm1 = class(TForm)
    SolidsIn: TPbInputStream;
    FESolidsIn: TPbFloatEdit;
    GasIn: TPbInputStream;
    FEGasIn: TPbFloatEdit;
    Stage1: TPbGttBalance;
    FEStage1Temp: TPbFloatEdit;
    Stage1Out: TPbStream;
    Stage1OutSplit: TPbPhaseSplitter;
    Stage1OutGas: TPbStream;
    Stage1OutSolids: TPbStream;
    Iterator: TPbInStreamIterator;
    Stage2: TPbGttBalance;
    FEStage2Temp: TPbFloatEdit;
    Stage2Out: TPbStream;
    Stage2OutSplit: TPbPhaseSplitter;
    Stage2OutGas: TPbStream;
    Stage2OutSolids: TPbStream;
    Stage3: TPbGttBalance;
    FEStage3Temp: TPbFloatEdit;
    Stage3Out: TPbStream;
    Stage3OutSplit: TPbPhaseSplitter;
    Stage3OutGas: TPbStream;
    Stage3OutSolids: TPbStream;
    PbLogger1: TPbLogger;
    PbRun1: TPbRun;
    Inspector: TPbInspector;
    OutUnit: TPbOutputUnit;
    GasOut: TPbStream;
    SolidsOut: TPbStream;
    Stage2SolidsIn: TPbInputStream;
    Stage3SolidsIn: TPbInputStream;
    procedure IteratorInitNextStep(sender: TPbUnit);
    procedure IteratorCalculated(sender: TPbUnit);
    function IteratorCheckExit(sender: TPbUnit): Boolean;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Stage1OutGasSave, Stage3OutSolidsSave: TPbStream;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.IteratorInitNextStep(sender: TPbUnit);
begin

    {
     A copy of the current state of these 2 streams is saved in the present
     iterator cycle for later use.
    }
    Stage1OutGasSave.copyFromStream(Stage1OutGas);
    Stage3OutSolidsSave.copyFromStream(Stage3OutSolids);

    {
     If it's the very first iteration, make sure
     Stage2SolidsIn and Stage3SolidsIn, which are the 2 input streams
     controlled by this InstreamIterator, are given an initial guessed
     value. 0 works fine.
    }
    if Iterator.Iteration = 0 then
    begin
      Stage2SolidsIn.SetAmount(0);
      Stage3SolidsIn.SetAmount(0);
    end
    else
    begin
      {
       For all further iterations, set Stage2SolidsIn to the contents of
       Stage1OutSolids, and Stage3SolidsIn to the contents of Stage2OutSolids.
      }
      Stage2SolidsIn.SetNewStream(Stage1OutSolids);
      Stage3SolidsIn.SetNewStream(Stage2OutSolids);
    end;
end;

{
Once the InstreamIterator has been calculated successfully
and the solver moves on to other unit operations, the GasOut
and SolidsOut streams are set to their final value.
}
procedure TForm1.IteratorCalculated(sender: TPbUnit);
begin
    GasOut.copyFromStream(Stage1OutGas);
    SolidsOut.copyFromStream(Stage3OutSolids);

    Stage1OutGasSave.destroy;
    Stage3OutSolidsSave.destroy;
end;

{
 This function returns a boolean value that ends the iteration if True.
}
function TForm1.IteratorCheckExit(sender: TPbUnit): Boolean;
var ii, jj: integer;
    newphase, oldphase: TPbPhase;
    newcons, oldcons: TPbConstituent;
    sumGas, sumSolids, newAmount, oldAmount: double;

begin

    {
    Custom info is written to the log window.
    }
    AL.log(lcInfo, '-----------------------------------------------');
    AL.log(Iterator, lcInfo, 'Iteration stage ' + inttostr(Iterator.Iteration));

    {
     The temporary streams which are used to save the
     contents of the current state of two of the network streams are created.
    }
    if Iterator.Iteration = 0 then
    begin
      Stage1OutGasSave := TPbStream.create;
      Stage3OutSolidsSave := TPbStream.create;
      Stage1OutGasSave.copyFromStream(Stage1OutGas);
      Stage3OutSolidsSave.copyFromStream(Stage3OutSolids);
      Result := false;
      exit;
    end;


    {
     The values used in the exit condition are determined. Here, a rather
     simple solution is chosen by summing up the squares of the differences for
     each constituent's amount, for both the gas and the solid streams.
    }
    sumGas := 0.0;
    sumSolids := 0.0;

    for ii:= 0 to Stage3OutSolids.PhaseList.Count-1 do
    begin
      newphase:= Stage3OutSolids.PhaseList.Objects[ii] as TPbPhase;
      oldphase:= Stage3OutSolidsSave.PhaseList.Objects[ii] as TPbPhase;
      for  jj:= 0 to newphase.Constituents.Count-1 do
      begin
        newcons := newphase.Constituents.Objects[jj] as TPbConstituent;
        oldcons := oldphase.Constituents.Objects[jj] as TPbConstituent;

        newAmount := newcons.Amount;
        oldAmount := oldcons.Amount;

        sumSolids:=sumSolids + sqr(newAmount - oldAmount);
      end
    end;

    for ii:= 0 to Stage1OutGas.PhaseList.Count-1 do
    begin
      newphase:= Stage1OutGas.PhaseList.Objects[ii] as TPbPhase;
      oldphase:= Stage1OutGasSave.PhaseList.Objects[ii] as TPbPhase;
      for  jj:= 0 to newphase.Constituents.Count-1 do
      begin
        newcons := newphase.Constituents.Objects[jj] as TPbConstituent;
        oldcons := oldphase.Constituents.Objects[jj] as TPbConstituent;

        newAmount := newcons.Amount;
        oldAmount := oldcons.Amount;

        sumGas:=sumGas + sqr(newAmount - oldAmount);
      end
    end;

    {
     Custom info is written to the log window.
    }
    AL.log(Iterator, lcInfo, 'Stage1OutGasSave.Amount is ' + floattostr(Stage1OutGasSave.Amount));
    AL.log(Iterator, lcInfo, 'Stage1OutGas.Amount is ' + floattostr(Stage1OutGas.Amount));
    AL.log(Iterator, lcInfo, 'sumGas is ' + floattostr(sumGas));
    AL.log(Iterator, lcInfo, 'Stage3OutSolidsSave.Amount is ' + floattostr(Stage3OutSolidsSave.Amount));
    AL.log(Iterator, lcInfo, 'Stage3OutSolids.Amount is ' + floattostr(Stage3OutSolids.Amount));
    AL.log(Iterator, lcInfo, 'sumSolids is ' + floattostr(sumSolids));
    AL.log(lcInfo, '-----------------------------------------------');


    {
     Determining whether another iteration will be performed. Note that
     the first 2 iterations are not considered, to avoid unintended exits
     due the initial (arbitrary, in our case 0) values of the streams, before
     a stable solution is reached.
    }
    Result := (sumSolids < 1.0e-30) and (sumGas < 1.0e-30) and (Iterator.Iteration > 2);

end;

end.


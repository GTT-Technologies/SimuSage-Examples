unit instreamiterator1;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PbRun, ComCtrls, PbLogger, PbInspector,
  PbOutputUnit, PbIterator, PbSplitter2, PbUnit, PbNewMixer, PbInpUtil, ExtCtrls,
  PbObject, PbStream, PbInputStreams;

type
  TForm1 = class(TForm)
    inStream: TPbInputStream;
    inStreamFE: TPbFloatEdit;
    mixer: TPbMixer;
    total: TPbStream;
    splitter: TPbSplitter2;
    recout: TPbStream;
    outStream: TPbStream;
    outUnit: TPbOutputUnit;
    PbLogger1: TPbLogger;
    PbRun1: TPbRun;
    recoutFE: TPbFloatEdit;
    recinFE: TPbFloatEdit;
    totalFE: TPbFloatEdit;
    outStreamFE: TPbFloatEdit;
    CheckBox: TCheckBox;
    splitfactorFE: TPbFloatEdit;
    noiterations: TEdit;
    recin: TPbInputStream;
    iterator: TPbInStreamIterator;
    result: TPbStream;
    PbInspector1: TPbInspector;
    resultFE: TPbFloatEdit;
    function iteratorCheckExit(Sender: TPbUnit) : Boolean;
    procedure iteratorInitNextStep(Sender: TPbUnit);
    procedure mixerCalculated(Sender: TPbUnit);
    procedure splitterCalculated(Sender: TPbUnit);
    procedure iteratorCalculated(sender: TPbUnit);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
{
 This function returns a boolean value that ends the iteration if True.
 Additionally, this function exemplifies various custumizable feautures of
 SimuSage components that can provide helpful information for the user.
}
function TForm1.iteratorCheckExit(Sender: TPbUnit) : Boolean;
var
  diff: double;
begin
  {
   The number of iterations are displayed by the noiterations TEdit control.
  }
  noiterations.Text := IntToStr(iterator.Iteration);

  {
   The stream amounts of recout and recin are displayed by the TPbFloatEdit
   controls recoutFE and recinFE, respectively.
  }
  recoutFE.Flt := recout.Amount;
  recinFE.Flt := recin.Amount;

  {
   The absolute value of the difference of the stream amount of recout
   and recin is calculated.
  }
  diff := abs(recout.Amount - recin.Amount);

  {
   If the check box is currently checked, a message is displayed in a message
   window giving the user feedback on the status of the current iteration.
  }
  if CheckBox.checked then
    ShowMessage('Iteration: ' + noiterations.Text + #13#10
      + 'Difference in stream amounts is ' + floattostr(diff) + ' mol.');

  {
   The program returns True if the difference in stream amounts is below a
   certain value.
  }
  Result := (diff < 1e-3)
end;

{
 This procedure copies the stream recout to stream recin.
 Note that setNewStream also makes sure that the stream's ToUnit is notified
 that its input has changed.
}
procedure TForm1.iteratorInitNextStep(Sender: TPbUnit);
begin
  recin.setNewStream(recout);
end;


{
 This procedure displays the stream amount of total by the TPbFloatEdit
 control totalFE.
}
procedure TForm1.mixerCalculated(Sender: TPbUnit);
begin
  totalFE.Flt := total.Amount
end;

{
 This procedure displays the stream amounts of outStream and recout by the
 TPbFloatEdit controls outStreamFE and recoutFE, respectively.
}
procedure TForm1.splitterCalculated(Sender: TPbUnit);
begin
  outStreamFE.Flt := outStream.Amount;
  recoutFE.Flt := recout.Amount
end;

{
 This procedure sets the outgoing stream (outStream) after the iterator has been
 calculated and displays the result by the resultFE TPbFloatEdit control.
}
procedure TForm1.iteratorCalculated(sender: TPbUnit);
begin
  result.copyFromStream(outStream);
  resultFE.Flt := result.Amount;
end;


end.


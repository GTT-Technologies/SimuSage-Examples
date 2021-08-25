unit recycleiterator1;

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
    iterator: TPbRecycleIterator;
    recin: TPbStream;
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
    function iteratorCheckExit(Sender: TPbUnit) : Boolean;
    procedure iteratorInitNextStep(Sender: TPbUnit);
    procedure outUnitBeforeCalculation(Sender: TPbUnit);
    procedure mixerCalculated(Sender: TPbUnit);
    procedure splitterCalculated(Sender: TPbUnit);
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
 This function returns a boolean value that ends the iteration if True.
 Additionally, this function exemplifies various custumizable features of
 SimuSage components that can provide helpful information for the user.
}
function TForm1.iteratorCheckExit(Sender: TPbUnit) : Boolean;
var
  diff: double;
begin

  {
   The number of iterations is displayed by the TEdit control noiterations.
  }
  noiterations.Text := IntToStr(iterator.Iteration);

  {
   The stream amounts of recout and recin are displayed by the TPbFloatEdit
   controls recoutFE and recinFE, respectively.
  }
  recoutFE.Flt := recout.Amount;
  recinFE.Flt := recin.Amount;

  {
   The absolute value of the difference of the stream amounts of recout
   and recin is calculated.
  }
  diff := abs(recout.Amount - recin.Amount);

  {
   If the check box is currently checked, a message is displayed in a message
   window giving the user feedback on the current iteration status.
  }
  if CheckBox.checked then
    ShowMessage('Iteration: ' + noiterations.Text + #13#10
      + 'Difference in stream amounts is ' + floattostr(diff) + ' mol.');

  {
  The program returns True if the difference in stream amounts is below a certain
  value.
  }
  Result := (diff < 1e-20)
end;


{
 This procedure copies the contents of steam recout to stream recin.
}
procedure TForm1.iteratorInitNextStep(Sender: TPbUnit);
begin
  recin.copyFromStream(recout)
end;

{
 This procedure starts the iterative process.
}
procedure TForm1.outUnitBeforeCalculation(Sender: TPbUnit);
begin
  iterator.iterate
end;

{
 This procedure displays the stream amount of total by the TPbFloatEdit control
 totalFE.
}
procedure TForm1.mixerCalculated(Sender: TPbUnit);
begin
  totalFE.Flt := total.Amount
end;

{
 This procedure displays the stream amounts of outStream and recount by the
 TPbFloatEdit controls outStreamFE and recountFE, respectively.
}
procedure TForm1.splitterCalculated(Sender: TPbUnit);
begin
  outStreamFE.Flt := outStream.Amount;
  recoutFE.Flt := recout.Amount
end;

end.


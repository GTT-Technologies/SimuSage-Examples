unit streamstates;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, PbUnit, PbStreamStateUnit, PbGttBalance, StdCtrls, PbInpUtil,
  ExtCtrls, PbObject, PbStream, PbInputStreams, ComCtrls, PbLogger,
  Buttons, PbRun, PbOutputUnit, PbInspector;

type
  TForm1 = class(TForm)
    inCO: TPbInputStream;
    inAir: TPbInputStream;
    inCOFE: TPbFloatEdit;
    inAirFE: TPbFloatEdit;
    reactor: TPbGttBalance;
    outStream: TPbStream;
    outUnit: TPbOutputUnit;
    PbRun1: TPbRun;
    PbLogger1: TPbLogger;
    RadioGroup1: TRadioGroup;
    valCarbon: TPbFloatEdit;
    Label1: TLabel;
    valDiamond: TPbFloatEdit;
    Label2: TLabel;
    valCO: TPbFloatEdit;
    Label3: TLabel;
    MemoStreamState: TMemo;
    Label4: TLabel;
    procedure RadioGroup1Click(Sender: TObject);
    procedure reactorCalculated(sender: TPbUnit);
    procedure reactorBeforeCalculation(sender: TPbUnit);
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
 This procedure is an event handler for the TRadioGroup TRadioGroup1. It allows
 for changes in the stream state.
}
procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  {
   The ALL stream state is loaded first to reset any previous stream state.
  }
  reactor.StreamStateName := 'ALL';
  case RadioGroup1.ItemIndex of
    0: reactor.StreamStateName := 'ALL';
    1: reactor.StreamStateName := 'NoCarbon';
    {
     If the status of phases or phase constituents are changed individually, the
     network has to be informed that the input has changed.
    }
    2: begin
         reactor.StreamState.cEntered['GAS','CO'] := false;
         reactor.inputChanged;
       end;
  end;
end;

{
 This procedure displays the amounts of two phases and a phase constituent of
 the gas phase of outStream after the calculation of the reactor has finsihed.
}
procedure TForm1.reactorCalculated(sender: TPbUnit);
begin
  {
   The amounts of phases and of the phase constituent are displayed in the
   TPbFloatEdit controls valCarbon, valDiamond and valCO.
  }
  valCarbon.Flt := outStream.PAmount['C'];
  valDiamond.Flt := outStream.PAmount['C_DIAMOND_A4'];
  valCO.Flt := outStream.CAmount['GAS','CO'];
end;

{
 This procedure displays information on which phases and phase constituents are
 entered and which are eliminated by the TMemo control MemoStreamState.
}
procedure TForm1.reactorBeforeCalculation(sender: TPbUnit);
begin
  MemoStreamState.Clear;
  MemoStreamState.Lines[0] := reactor.StreamState.printInString;
end;

end.


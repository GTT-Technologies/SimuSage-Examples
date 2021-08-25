unit splitfactor;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PbOutputUnit, PbUnit, PbSplitter2, PbInpUtil,
  ExtCtrls, PbObject, PbStream, PbInputStreams, PbInspector;

type
  TForm1 = class(TForm)
    in1: TPbInputStream;
    out1: TPbStream;
    out2: TPbStream;
    splitter: TPbSplitter2;
    outUnit: TPbOutputUnit;
    in1FE: TPbFloatEdit;
    O2splitfactorFE: TPbFloatEdit;
    N2splitfactorFE: TPbFloatEdit;
    splitfacFE: TPbFloatEdit;
    Calculate1: TButton;
    Calculate2: TButton;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PbInspector1: TPbInspector;
    procedure Calculate1Click(Sender: TObject);
    procedure Calculate2Click(Sender: TObject);
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
 The calculation using a global split factor is started via a click event on the
 TButton control Calculate1.
}
procedure TForm1.Calculate1Click(Sender: TObject);
begin

  {
   The splitter is reset to the most recently used global split factor.
  }
  splitter.resetSplitFactor;

  {
   The calculation is started.
  }
  outunit.process;

  {
   The report is displayed in the TMemo control Memo1.
  }
  Memo1.Text := splitter.report(1E-5, KMOL);

end;

{
 The calculation using individual split factors is started via a click event
 on the TButton control Calculate2.
}
procedure TForm1.Calculate2Click(Sender: TObject);
begin

  {
   The individual split factors for O2 and N2 in the gas phase are set.
  }
  splitter.SplitFactorPC['GAS','O2'] := O2splitfactorFE.Flt;
  splitter.SplitFactorPC['GAS','N2'] := N2splitfactorFE.Flt;

  {
   The splitter needs to be informed that the input conditions have been changed.
   The splitter will then call its calculate method.
  }
  splitter.inputChanged;

  {
   The calculation is started.
  }
  outUnit.process;

  {
   The report is displayed in the TMemo control Memo1.
  }
  Memo1.Text := splitter.report(1E-5, KMOL);

end;

end.


unit nomenclature;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, PbLogger, Buttons, PbRun, PbOutputUnit,
  PbStreamStateUnit, PbGttBalance, PbUnit, PbNewMixer, PbInpUtil, ExtCtrls,
  PbObject, PbStream, PbInputStreams;

type
  TForm1 = class(TForm)
    Stream1: TPbInputStream;
    Stream2: TPbInputStream;
    Stream1Input: TPbFloatEdit;
    Stream2Input: TPbFloatEdit;
    Mixer: TPbMixer;
    Stream3: TPbStream;
    Stream4: TPbInputStream;
    Stream4Input: TPbFloatEdit;
    Reactor: TPbGttBalance;
    Stream5: TPbStream;
    AllOut: TPbOutputUnit;
    PbRun1: TPbRun;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.


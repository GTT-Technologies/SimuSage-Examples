unit graphics1;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, PbInspector, StdCtrls, Buttons, PbRun, PbOutputUnit, PbUnit,
  PbStreamStateUnit, PbGttBalance, PbInpUtil, ExtCtrls, PbObject, PbStream,
  PbInputStreams, ComCtrls, TAGraph, TASeries, PbPhase, PbConstituent;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1PieSeries1: TPieSeries;
    Chart2: TChart;
    Chart2BarSeries1: TBarSeries;
    Chart3: TChart;
    Chart3BarSeries1: TBarSeries;
    inAir: TPbInputStream;
    inCarbon: TPbInputStream;
    inAirFE: TPbFloatEdit;
    inCarbonFE: TPbFloatEdit;
    reactor: TPbGttBalance;
    reactorTempFE: TPbFloatEdit;
    outReactor: TPbStream;
    outUnit: TPbOutputUnit;
    PbRun1: TPbRun;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ConstCutoffValueFE: TPbFloatEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure reactorCalculated(sender: TPbUnit);
    procedure ConstCutoffValueFEUpdate(updateVal: Double; sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateGraphs(constcutoffvalue: double);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{
 OnCalculated event handler of reactor (TPbGttBalance).
}
procedure TForm1.reactorCalculated(sender: TPbUnit);
begin
  {
   Update graphs.
  }
  UpdateGraphs(ConstCutoffValueFE.Flt);
end;

{
 Custom-made procedure to update graphs.
}
procedure TForm1.UpdateGraphs(constcutoffvalue: double);
var II: integer;
    phase: TPbPhase;
    constituent: TPbConstituent;
    syscomp: TPbComponent;
begin
  {
   The amount of individual phases (in this case: carbon and gas) in mol
   in the output stream are represented via a pie chart.
   The current series for the pie chart needs to be cleared first.
  }
  Chart1PieSeries1.Clear;

  {
   The next step is an iteration over all phases in the output stream (outReactor)
  }
  for II := 0 to outReactor.PhaseList.Count - 1 do
  begin

    {
     Each individual phase is retrieved from the list of possible phases
     (PhaseList) of the output stream (outReactor).
    }
    phase := outReactor.PhaseList.Objects[II] as TPbPhase;

    {
     Check if the phase amount has a positive value.
    }
    if phase.hasPosAmount then
    begin
      {
       The amount of the phase and its name will be added to the series of the
       pie chart (Chart1PieSeries1).
      }
      Chart1PieSeries1.AddXY(0, phase.Amount, phase.Name);
    end;
  end;

  {
   The composition of the output gas is depicted in form of a bar chart.
   The current series for the bar chart needs to be cleared first.
  }
  Chart2BarSeries1.Clear;

  {
   The gas phase is retrieved from the output stream (outReactor).
  }
  phase := outReactor.GetPhase('GAS');

  {
   An iteration over all gas phase constituents is performed to
   get the amounts of relevant constituents for the bar series.
  }
  for II := 0 to phase.Constituents.Count - 1 do
  begin

    {
     Each individual phase constituent is retrieved from the constituents
     defined for the gas phase (phase.Constituents).
    }
    constituent := phase.Constituents.Objects[II] as TPbConstituent;

    {
     Check if the amount of the constituent is larger than the pre-defined
     cutoff value.
    }
    if constituent.Amount > constcutoffvalue then
    begin
      {
       The amount of the constituent and its name will be added to the series
       of the bar chart (Chart2BarSeries1) with a random color.
      }
      Chart2BarSeries1.Add(constituent.Amount, constituent.Name,
        random(256*256*256));
    end;
  end;

  {
   The amounts of system components in the output stream (outReactor) in mol are
   represented by a bar chart.
   First, the current bar chart series needs to be cleared.
  }
  Chart3BarSeries1.Clear;

  {
   An iteration over all system components in the output stream is performed.
  }
  for II := 0 to outReactor.SystemComponentList.Count - 1 do
  begin

    {
     Each individual system component is retrieved from the list of system
     components(SystemComponentList) in the output stream (outReactor).
    }
    syscomp := outReactor.SystemComponentList.Objects[II] as TPbComponent;

    {
     The amount of a system component in the output stream is added to the bar
     chart series together with its name and a random color.

     Please note that the syntax for retrieving the amount of a system component
     (below) is different from the syntax used to retrieve the amount of a phase
     or phase constituent (above).
    }
    Chart3BarSeries1.Add(outReactor.GetSystemComponentAmount(syscomp.Name),
      syscomp.Name, random(256*256*256));
  end;

end;

{
 OnUpdate event handler of ConstCutoffValueFE (TPbFloatEdit)
}
procedure TForm1.ConstCutoffValueFEUpdate(updateVal: Double; sender: TObject);
begin
  {
   Update graphs.
  }
  UpdateGraphs(updateVal);
end;

end.


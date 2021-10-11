unit Z;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Slider: TTrackBar;
    cbSrediste: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormResize(Sender: TObject);
begin
// panel in the middle of the form
 Panel1.Left:=(Form1.ClientWidth Div 2) - Panel1.Width div 2;
 Panel1.Top:=(Form1.ClientHeight Div 2) - Panel1.Height div 2;
 Image1.Picture:=nil;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Timer1.Interval:=0;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
 Srect,Drect,PosForme:TRect;
 iWidth,iHeight,DmX,DmY:Integer;
 iTmpX,iTmpY:Real;
 C:TCanvas;
 Kursor:TPoint;
begin
 If not IsIconic(Application.Handle) then
  begin
   GetCursorPos(Kursor);
   PosForme:=Rect(Form1.Left,Form1.Top,Form1.Left+Form1.Width,Form1.Top+Form1.Height);
   if not PtInRect(PosForme,Kursor) then
    begin
     if Panel1.Visible=True then Panel1.Visible:=False;
     if Image1.Visible=False then Image1.Visible:=True;
     iWidth:=Image1.Width;
     iHeight:=Image1.Height;
     Drect:=Rect(0,0,iWidth,iHeight);
     iTmpX:=iWidth / (Slider.Position * 4);
     iTmpY:=iHeight / (Slider.Position * 4);
     Srect:=Rect(Kursor.x,Kursor.y,Kursor.x,Kursor.y);
     InflateRect(Srect,Round(iTmpX),Round(iTmpY));
     // move Srect if outside visible area of the screen
     if Srect.Left<0 then OffsetRect(Srect,-Srect.Left,0);
     if Srect.Top<0 then OffsetRect(Srect,0,-Srect.Top);
     if Srect.Right>Screen.Width then OffsetRect(Srect,-(Srect.Right-Screen.Width),0);
     if Srect.Bottom>Screen.Height then OffsetRect(Srect,0,-(Srect.Bottom-Screen.Height));
     C:=TCanvas.Create;
      try
       C.Handle:=GetDC(GetDesktopWindow);
       Image1.Canvas.CopyRect(Drect,C,Srect);
      finally
       C.Free;
      end;
     if cbSrediste.Checked=True then
      begin // show crosshair
       with Image1.Canvas do
        begin
         DmX:=Slider.Position * 2 * (Kursor.X-Srect.Left);
         DmY:=Slider.Position * 2 * (Kursor.Y-Srect.Top);
   	 MoveTo(DmX - (iWidth div 4),DmY); // -
   	 LineTo(DmX + (iWidth div 4),DmY); // -
    	 MoveTo(DmX,DmY - (iHeight div 4)); // |
   	 LineTo(DmX,DmY + (iHeight div 4)); // |
        end; // with image1.Canvas
      end; // show crosshair
     Application.ProcessMessages;
    end // Cursor not inside form
   else
    begin  // cursor inside form
     if Panel1.Visible=False then Panel1.Visible:=True;
     if Image1.Visible=True then Image1.Visible:=False;
    end;
 end; // IsIconic
end;

end.

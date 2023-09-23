unit GameViewKakuView;

interface

uses Classes,
  CastleVectors, CastleUIControls, CastleControls, CastleKeysMouse;

type

  { TViewKakuView }

  TViewKakuView = class(TCastleView)
  published
    { Components designed using CGE editor.
      These fields will be automatically initialized at Start. }
    // ButtonXxx: TCastleButton;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
    procedure Update(const SecondsPassed: Single; var HandleInput: boolean); override;
    function Press(const Event: TInputPressRelease): boolean; override;
  end;

var
  ViewKakuView: TViewKakuView;

implementation

uses CastleWindow;  //Para usar Applicarion.Terminate

constructor TViewKakuView.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gameviewkakuview.castle-user-interface';
end;

procedure TViewKakuView.Start;
begin
  inherited;
  { Executed once when view starts. }
end;

procedure TViewKakuView.Update(const SecondsPassed: Single; var HandleInput: boolean);
begin
  inherited;
  { Executed every frame. }
end;

function TViewKakuView.Press(const Event: TInputPressRelease): boolean;
begin
  Result:=inherited Press(Event);
  if Event.IsKey(keyEscape) then
  begin
    Application.Terminate;
  end;
end;

end.

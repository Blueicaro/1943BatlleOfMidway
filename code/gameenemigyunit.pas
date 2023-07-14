unit Gameenemigyunit;

interface

uses Classes, CastleTransform, CastleKeysMouse, CastleVectors;

type

  { TEnemyBigPlane }

  TEnemyBigPlane = class(TCastleBehavior)
  private
    Speed: TVector2;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Update(const SecondsPassed: single; var RemoveMe: TRemoveType); override;
  end;

implementation

{ TEnemyBigPlane }

constructor TEnemyBigPlane.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Speed := Vector2(0, 25);
end;

procedure TEnemyBigPlane.Update(const SecondsPassed: single; var RemoveMe: TRemoveType);
begin
  inherited Update(SecondsPassed, RemoveMe);
  with Parent do
  begin
    if TranslationXY.Y < 100 then
    begin
      TranslationXY := Vector2(TranslationXY.X,100);
    end
    else
    begin
     TranslationXY := TranslationXY - Speed * SecondsPassed;
    end;
  end;
end;

end.

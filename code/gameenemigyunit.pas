unit Gameenemigyunit;

interface

uses Classes, CastleTransform, CastleKeysMouse, CastleVectors, Gamegeneral;

type

  { TEnemyBigPlane }

  TEnemyBigPlane = class(TCastleBehavior)
  private
    Speed: TVector2;
    VelocidadX: single;
    Area: TLimites;
  published
    constructor Create(AOwner: TComponent); override;
    procedure Update(const SecondsPassed: single; var RemoveMe: TRemoveType); override;
    procedure Collision(const CollisionDetails: TPhysicsCollisionDetails);
  end;

implementation

uses CastleLog;

{ TEnemyBigPlane }

constructor TEnemyBigPlane.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Area := Limite;
  VelocidadX := 100.0;
  Speed := Vector2(0, 25.0);
end;

procedure TEnemyBigPlane.Update(const SecondsPassed: single; var RemoveMe: TRemoveType);
begin
  inherited Update(SecondsPassed, RemoveMe);
  with Parent do
  begin
    if TranslationXY.Y < 100 then
    begin
      TranslationXY := Vector2(TranslationXY.X, 100);
      Speed := Vector2(VelocidadX, 0);
    end;
    if TranslationXY.X > Area.Derecha then
    begin
      TranslationXY := Vector2(Area.Derecha, TranslationXY.y);
      Speed := Vector2(VelocidadX, 0.0);
    end
    else if TranslationXY.X < Area.Izquierda then
    begin
      TranslationXY := Vector2(Area.Izquierda, TranslationXY.y);
      Speed := Vector2(-VelocidadX, 0.0);
    end;
    begin
      TranslationXY := TranslationXY - Speed * SecondsPassed;
    end;
  end;
end;

procedure TEnemyBigPlane.Collision(const CollisionDetails: TPhysicsCollisionDetails);

begin
  { #todo : Comprobar si choca con la bala o con el jugador }
  CollisionDetails.Transforms[1].Exists:=False;
  WritelnLog('Colision en el avión');

  Speed := Vector2(0.0, 0.0);
  Parent.Exists := False;
end;

end.

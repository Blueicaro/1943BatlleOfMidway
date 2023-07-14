unit GamePlayerUnit;

interface

uses Classes, CastleTransform, CastleKeysMouse, CastleVectors, Gamegeneral;

type

  { TLeft }

  { TPlayerBehavior }

  TPlayerBehavior = class(TCastleBehavior)
  private
    SpeedX: single;
    SpeedY: single;
    Speed: TVector2;
    Coordenadas: TVector2;
    Area: TLimites;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Press(aKey: TKey);   //En un futuro podrian ser TEVent para
    procedure Release(aKey: Tkey); //gestionar tambien el ratón
    procedure Update(const SecondsPassed: single; var RemoveMe: TRemoveType); override;
    procedure Collision(const CollisionDetails: TPhysicsCollisionDetails);
    function GetPosition: TVector2;
  end;

type

  { TBulletBehavior }

  TBulletBehavior = class(TCastleBehavior)
  private
    Speed: single;
    Area: TLimites;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Update(const SecondsPassed: single; var RemoveMe: TRemoveType); override;

  end;

implementation

uses CastleScene, CastleLog, SysUtils;

{ TBulletBehavior }

constructor TBulletBehavior.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Speed := 300.0;
  Area := Limite;

end;

procedure TBulletBehavior.Update(const SecondsPassed: single;
  var RemoveMe: TRemoveType);
begin

   inherited Update(SecondsPassed, RemoveMe);
   //Si sale de la pantalla lo borramos
   //If I left the screen (camera)
  if (Parent.TranslationXY.y > Area.Arriba + 100 )  then
  begin

    Parent.RemoveDelayed(self.Parent, True);

    exit;
  end;

  with Parent do
  begin
    TranslationXY := TranslationXY + Vector2(0, Speed * SecondsPassed);

  end;

end;



{ TPlayerBehavior }

constructor TPlayerBehavior.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SpeedX := 100.0;
  SpeedY := 100.0;
  Speed := Vector2(0.0, 0.0);
  Area := Limite;
  Area.Arriba := -200;
end;

procedure TPlayerBehavior.Press(aKey: TKey);
begin
  case aKey of
    keyArrowLeft:
    begin
      if Speed.X > 0 then
      begin
        Speed := Vector2(0.0, 0.0);
        with Parent as TCastleScene do
          AutoAnimation := 'Recto';
      end
      else
      begin
        Speed := Vector2(-SpeedX, 0.0);
        with Parent as TCastleScene do
          AutoAnimation := 'Izq1';
      end;
    end;
    keyArrowRight:
    begin
      if Speed.X < 0 then
      begin
        Speed := Vector2(0.0, 0.0);
        with Parent as TCastleScene do
          AutoAnimation := 'Recto';
      end
      else
      begin
        Speed := Vector2(SpeedX, 0.0);
        with Parent as TCastleScene do
          AutoAnimation := 'der1';
      end;
    end;
    keyArrowUp:
    begin
      if Speed.Y < 0 then
      begin
        Speed := Vector2(0.0, 0.0);
      end
      else
      begin
        Speed := Vector2(0.0, SpeedY);
      end;
      with Parent as TCastleScene do
        AutoAnimation := 'Recto';
    end;
    keyArrowDown:
    begin
      if Speed.Y > 0 then
      begin
        Speed := Vector2(0.0, 0.0);
      end
      else
      begin
        Speed := Vector2(0.0, -SpeedY);
      end;
      with Parent as TCastleScene do
        AutoAnimation := 'Recto';
    end
    else
      Speed := Vector2(0.0, 0.0);
      with Parent as TCastleScene do
        AutoAnimation := 'Recto';
  end;
end;

procedure TPlayerBehavior.Release(aKey: Tkey);
begin

  if (aKey = keyArrowRight) or (aKey = keyArrowleft) or (aKey = keyArrowDown) or
    (aKey = keyArrowUp) then
  begin
    Speed := Vector2(0.0, 0.0);
    with Parent as TCastleScene do
      AutoAnimation := 'Recto';
  end;
end;
//Este evento se ejecuta cada vez que se actualiza el juego
procedure TPlayerBehavior.Update(const SecondsPassed: single;
  var RemoveMe: TRemoveType);
begin
  inherited Update(SecondsPassed, RemoveMe);
  with Parent do
  begin
    if TranslationXY.X > Area.Derecha then
    begin
      TranslationXY := Vector2(Area.Derecha, TranslationXY.y);
      Speed := Vector2(0.0, 0.0);
    end
    else if TranslationXY.X < Area.Izquierda then
    begin
      TranslationXY := Vector2(Area.Izquierda, TranslationXY.y);
      Speed := Vector2(0.0, 0.0);
    end
    else if TranslationXY.Y < Area.Abajo then
    begin
      TranslationXY := Vector2(TranslationXY.X, Area.Abajo);
      Speed := Vector2(0.0, 0.0);
    end
    else if TranslationXY.Y > Area.Arriba then
    begin
      TranslationXY := Vector2(TranslationXY.X, Area.Arriba);
      Speed := Vector2(0.0, 0.0);
    end
    else
    begin
      TranslationXY := TranslationXY + Speed * SecondsPassed;
    end;
    Coordenadas := TranslationXY;
  end;

end;
//Control de colisiones
procedure TPlayerBehavior.Collision(const CollisionDetails: TPhysicsCollisionDetails);
begin

end;
//Devuelve la posición actual
function TPlayerBehavior.GetPosition: TVector2;
begin
  Result := Coordenadas;
end;

end.

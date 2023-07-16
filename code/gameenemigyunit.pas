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

type

  { TEnemyLittlePlane }

  TEnemyLittlePlane = class(TCastleBehavior)
  private
    AngularSpeed: single;
    AnguloActual : single; //Grados
  public
    Radio: single;
    Clockwise : boolean; //Sentido de giro
  published
    constructor Create(AOwner: TComponent); override;
    procedure Update(const SecondsPassed: single; var RemoveMe: TRemoveType); override;
  end;

implementation

uses CastleLog,Math,sysutils;

{ TEnemyLittlePlane }

constructor TEnemyLittlePlane.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AngularSpeed := 50; //Grados
  radio := 200.0;
  AnguloActual:=0.0;


end;

procedure TEnemyLittlePlane.Update(const SecondsPassed: single;
  var RemoveMe: TRemoveType);
var
  AnguloRadianes: Single;
  X, Y: ValReal;
  R: TComponent;

begin
  inherited Update(SecondsPassed, RemoveMe);


  if Clockwise then
   begin
   AnguloActual := (AnguloActual-AngularSpeed*SecondsPassed);
   if AnguloActual < -360 then
   begin
     AnguloActual:=0.0;
   end;

   WritelnLog(FloatToStr(AnguloActual));

  end

  else
  begin
   AnguloActual := AnguloActual+AngularSpeed*SecondsPassed;
   if AnguloActual > 360.0 then
   begin
     AnguloActual:=0.0;
   end;
  end;


  AnguloRadianes:=DegToRad(AnguloActual);
  X := radio *Cos(AnguloRadianes);
  Y := radio *Sin(AnguloRadianes);

  //Rotación en Z
  if Clockwise then
  begin
  Parent.Rotation:=Vector4(0,0,1,AnguloRadianes+pi);
  end
  else
  begin
   Parent.Rotation:=Vector4(0,0,1,AnguloRadianes);
  end;

  Parent.TranslationXY:=Vector2(X,Y);
end;



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
  CollisionDetails.Transforms[1].Exists := False;
  WritelnLog('Colision en el avión');

  Speed := Vector2(0.0, 0.0);
  Parent.Exists := False;
end;

end.

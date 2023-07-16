{ Main view, where most of the application logic takes place.

  Feel free to use this code as a starting point for your own projects.
  This template code is in public domain, unlike most other CGE code which
  is covered by BSD or LGPL (see https://castle-engine.io/license). }
unit GameViewMain;

interface

uses Classes,
  CastleVectors, CastleComponentSerialize,
  CastleUIControls, CastleControls, CastleKeysMouse,
  CastleViewport, CastleTransform, GamePlayerUnit,CastleScene;

type
  { Main view, where most of the application logic takes place. }

  { TViewMain }

  TViewMain = class(TCastleView)
  private
    procedure CreateEnemyLevel2;
    procedure CreateEnenmyRedPlane;
  published
    { Components designed using CGE editor.
      These fields will be automatically initialized at Start. }
    LabelFps: TCastleLabel;
    View: TCastleViewport;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
    procedure Update(const SecondsPassed: single; var HandleInput: boolean); override;
    function Press(const Event: TInputPressRelease): boolean; override;
    function Release(const Event: TInputPressRelease): boolean; override;
  end;

var
  ViewMain: TViewMain;
  PlayerBehavior: TPlayerBehavior;

implementation

uses SysUtils, CastleLog, Gameenemigyunit, Gamegeneral,math;

{ TViewMain ----------------------------------------------------------------- }

procedure TViewMain.CreateEnemyLevel2;
var
  Enemy: TCastleTransform;
  Cuerpo: TCastleRigidBody;
  EnemyBehavior: TEnemyBigPlane;
begin
  Enemy := TransformLoad('castle-data:/Assets/bigplane.castle-transform', FreeAtStop);
  Enemy.TranslationXY := Vector3(0, 600,10);
  Enemy.Collides := True;
  EnemyBehavior := TEnemyBigPlane.Create(FreeAtStop);
  Enemy.AddBehavior(EnemyBehavior);
  Cuerpo := Enemy.FindBehavior(TCastleRigidBody) as TCastleRigidBody;
  {$IFDEF FPC}
  Cuerpo.OnCollisionEnter:=@EnemyBehavior.Collision;
  {$ELSE}
  Cuerpo.OnCollisionStay := EnemyBehavior.Collision;
  {$ENDIF}

  View.Items.Add(Enemy);

end;

procedure TViewMain.CreateEnenmyRedPlane;
var
  Enemy: TCastleTransform;
  EnemyBehavior: TEnemyLittlePlane;
begin
  Enemy := TransformLoad('castle-data:/Assets/redplane.castle-transform', FreeAtStop);
  Enemy.Translation := Vector3(100, 0,10);

  EnemyBehavior := TEnemyLittlePlane.Create(FreeAtStop);
   EnemyBehavior.Clockwise:=true;
  Enemy.AddBehavior(EnemyBehavior);
  View.Items.Add(Enemy);
end;

constructor TViewMain.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gameviewmain.castle-user-interface';
end;

procedure TViewMain.Start;
var
  Player1: TCastleTransform;
  Cuerpo: TCastleRigidBody;
  h, w: single;
begin
  inherited;
  View := DesignedComponent('ViewPort1') as TCastleViewport;


  //Obtener límites
  with Limite do
  begin
    Izquierda := -View.EffectiveWidth / 2;
    Derecha := View.EffectiveWidth / 2;
    Arriba := View.EffectiveHeight / 2;
    Abajo := -View.EffectiveHeight / 2;
  end;




  //Crear player
  Player1 := TransformLoad('castle-data:/Assets/player1.castle-transform', FreeAtStop);
  Player1.TranslationXY := Vector2(0.0, Limite.Abajo);
  PlayerBehavior := TPlayerBehavior.Create(FreeAtStop);
  Player1.AddBehavior(PlayerBehavior);
  Cuerpo := Player1.FindBehavior(TCastleRigidBody) as TCastleRigidBody;
 {$IFDEF FPC}
  Cuerpo.OnCollisionEnter := @PlayerBehavior.Collision;
 {$ELSE}
  Cuerpo.OnCollisionEnter := PlayerBehavior.Collision;
 {$ENDIF}
  View.Items.Add(Player1);
end;

procedure TViewMain.Update(const SecondsPassed: single; var HandleInput: boolean);
var
  I: integer;
begin
  inherited;
  { This virtual method is executed every frame (many times per second). }
  Assert(LabelFps <> nil,
    'If you remove LabelFps from the design, remember to remove also the assignment "LabelFps.Caption := ..." from code');
  LabelFps.Caption := 'FPS: ' + Container.Fps.ToString;
  for I := View.Items.Count - 1 downto 0 do
  begin
    if View.Items[I].Exists = False then
    begin
      WritelnLog(IntToStr(I) + ':' + View.Items[I].Name);
      View.Items.Delete(I);
    end;

  end;
  //WritelnLog(IntToStr(View.Items.Count));
end;

function TViewMain.Press(const Event: TInputPressRelease): boolean;
var

  BulletBehavior: TBulletBehavior;
  Bullet: TCastleTransform;
  Cuerpo: TCastleRigidBody;
begin
  Result := inherited;
  if Result then Exit; // allow the ancestor to handle keys

  { This virtual method is executed when user presses
    a key, a mouse button, or touches a touch-screen.

    Note that each UI control has also events like OnPress and OnClick.
    These events can be used to handle the "press", if it should do something
    specific when used in that UI control.
    The TViewMain.Press method should be used to handle keys
    not handled in children controls.
  }

  // Use this to handle keys:
  {
  if Event.IsKey(keyXxx) then
  begin
    // DoSomething;
    Exit(true); // key was handled
  end;
  }
  if Event.IsKey(keyEscape) then
  begin
    Halt(0);
  end;

  PlayerBehavior.Press(Event.Key);
  if Event.IsKey(keySpace) then
  begin
    Bullet := TransformLoad('castle-data:/Assets/bullet.castle-transform',
      FreeAtStop);
    Bullet.TranslationXY := PlayerBehavior.GetPosition + Vector2(0, 100);
    BulletBehavior := TBulletBehavior.Create(FreeAtStop);
    Bullet.AddBehavior(BulletBehavior);
    Cuerpo := Bullet.FindBehavior(TCastleRigidBody) as TCastleRigidBody;
  {$IFDEF FPC}
  Cuerpo.OnCollisionStay:=@BulletBehavior.collision;
  {$ELSE}
    Cuerpo.OnCollisionEnter := BulletBehavior.collision;
  {$ENDIF}
    View.Items.Add(Bullet);
    Exit(True);
  end;
  if Event.IsKey(keyT) then
  begin
    CreateEnenmyRedPlane;
    Exit(True);
  end;

end;

//Cuando se suelta una tecla o un botón del teclado

function TViewMain.Release(const Event: TInputPressRelease): boolean;
begin
  Result := inherited;
  if Result then Exit;
  PlayerBehavior.Release(Event.Key);
  Exit(True);
end;

end.

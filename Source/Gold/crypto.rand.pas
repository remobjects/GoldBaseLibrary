namespace go.crypto.rand;

uses
  go.builtin;


type
  RandReader = public partial class(go.io.Reader)
    {$IF ECHOES}
    class var fRandom: System.Random;
    {$ENDIF}

    method &Read(p: Slice<byte>): RemObjects.Elements.MicroTasks.&Result<tuple of (int, go.builtin.error)>;
    begin
      {$IF ISLAND}
      raise new NotImplementedException();
      exit (0, nil)
      {$ELSEIF ECHOES}
      for i: Integer := 0 to p.Length - 1 do
        p[i] := fRandom.Next(256);

      exit (p.Length, nil);
      {$ENDIF}
    end;

    class constructor;
    begin
      {$IF ECHOES}
      fRandom := new System.Random();
      {$ENDIF}
    end;
  end;

  __Global = public partial class
    public class constructor;
    begin
      Reader := new RandReader();
    end;
  end;

end.
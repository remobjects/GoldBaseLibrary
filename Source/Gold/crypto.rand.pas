namespace go.crypto.rand;

uses
  go.builtin;


type
  PlatformRandom = {$IF ECHOES}System.Random{$ELSEIF ISLAND}RemObjects.Elements.System.Random{$ENDIF};
  RandReader = public partial class(go.io.Reader)
    class var fRandom: PlatformRandom;

    method &Read(p: Slice<byte>): tuple of (int, go.builtin.error);
    begin
      {$IF ISLAND}
      fRandom.CryptoSafeRandom(p, p.fStart, p.Length);
      exit(p.Length, nil);
      {$ELSEIF ECHOES}
      for i: Integer := 0 to p.Length - 1 do
        p[i] := fRandom.Next(256);

      exit (p.Length, nil);
      {$ENDIF}
    end;

    class constructor;
    begin
      fRandom := new PlatformRandom();
    end;
  end;

  __Global = public partial class
    public class constructor;
    begin
      Reader := new RandReader();
    end;
  end;

end.
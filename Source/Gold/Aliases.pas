namespace builtin;

type
  int = public RemObjects.Elements.System.Int32;
  uint = public RemObjects.Elements.System.UInt32;
  int8 = public RemObjects.Elements.System.SByte;
  uint8 = public RemObjects.Elements.System.Byte;
  byte = public RemObjects.Elements.System.Byte;
  int16 = public RemObjects.Elements.System.Int16;
  uint16 = public RemObjects.Elements.System.UInt16;
  uintptr = public RemObjects.Elements.System.NativeUInt;
  intptr = public RemObjects.Elements.System.NativeInt;
  [AliasSemantics]
  int32 = public partial record
  public
    Value: RemObjects.Elements.System.Int32;
  end;
  [AliasSemantics]
  uint32 = public partial record
  public
    Value: RemObjects.Elements.System.UInt32;
  end;
  int64 = public RemObjects.Elements.System.Int64;
  uint64 = public RemObjects.Elements.System.UInt64;
  float32 = public Single;
  float64 = public Double;
  bool = public Boolean;
  [AliasSemantics]
  rune = public partial record
  public
    Value: Char;
  end;
  string = public RemObjects.Elements.System.String;

  complex128 = public record
  public
    r, i: Double;

    class operator Equal(a, b: complex128): Boolean;
    begin
      exit (a.r = b.r) and (a.i = b.i);
    end;

    class operator NotEqual(a, b: complex128): Boolean;
    begin
      exit (a.r <> b.r) or (a.i <> b.i);
    end;

    class operator Implicit(x: Integer): complex128;
    begin
      if x = 0 then exit new complex128();
      raise new NotSupportedException();
    end;
  end;
  complex64 = public record
  public
    r, i: Single;

    class operator Explicit(x: complex64): complex128;
    begin
      exit new complex128(r := x.r, i := x.i);
    end;

    class operator Explicit(x: complex128): complex64;
    begin
      exit new complex64(r := x.r, i := x.i);
    end;

    class operator Equal(a, b: complex128): Boolean;
    begin
      exit (a.r = b.r) and (a.i = b.i);
    end;

    class operator NotEqual(a, b: complex128): Boolean;
    begin
      exit (a.r <> b.r) or (a.i <> b.i);
    end;


    class operator Implicit(x: Integer): complex64;
    begin
      if x = 0 then exit new complex64();
      raise new NotSupportedException();
    end;
  end;

  method complex(r, i: Single): complex64;
  begin
    exit new complex64(r := r, i := i);
  end;

  method complex(r, i: Double): complex128;
  begin
    exit new complex128(r := r, i := i);
  end;

  method real(r: complex64): Single;
  begin
    exit r.r;
  end;

  method imag(r: complex64): Single;
  begin
    exit r.i;
  end;

  method real(r: complex128): Double;
  begin
    exit r.r;
  end;

  method imag(r: complex128): Double;
  begin
    exit r.i;
  end;

  method print(params x: array of Object);
  begin
    fmt.Print(x);
  end;

  method println(params x: array of Object);
  begin
    fmt.Println(x);
  end;

end.
namespace go.builtin;

type
  complex128 = public record
  public
    r, i: Double;

    operator Equal(a, b: complex128): Boolean;
    begin
      exit (a.r = b.r) and (a.i = b.i);
    end;

    operator NotEqual(a, b: complex128): Boolean;
    begin
      exit (a.r <> b.r) or (a.i <> b.i);
    end;

    operator Implicit(x: Integer): complex128;
    begin
      result.r := x;
    end;

    operator Implicit(x: Double): complex128;
    begin
      result.r := x;
    end;

    operator Implicit(x: complex64): complex128;
    begin
      result.r := x.r;
      result.i := x.i;
    end;

    operator Add(x: complex128; y: complex128): complex128;
    begin
      result.r := x.r+y.r;
      result.i := x.i+y.i;
    end;

    operator Subtract(x: complex128; y: complex128): complex128;
    begin
      result.r := x.r-y.r;
      result.i := x.i-y.i;
    end;

    operator Multiply(x: complex128; y: complex128): complex128;
    begin
      result.r := (x.r*y.r - x.i*y.i);
      result.i := (x.r*y.i + x.i*y.r);
    end;

    operator Divide(x: complex128; y: complex128): complex128;
    begin
      var common := (1/(x.r*x.r + x.i*x.i));
      result.r := common * (y.r*x.r + y.i*x.i);
      result.r := common * (y.i*x.r - x.r*y.i);
    end;

  end;

  complex64 = public record
  public
    r, i: Single;

    operator Explicit(x: complex64): complex128;
    begin
      exit new complex128(r := x.r, i := x.i);
    end;

    operator Explicit(x: complex128): complex64;
    begin
      exit new complex64(r := x.r, i := x.i);
    end;

    operator Equal(a, b: complex128): Boolean;
    begin
      exit (a.r = b.r) and (a.i = b.i);
    end;

    operator NotEqual(a, b: complex128): Boolean;
    begin
      exit (a.r <> b.r) or (a.i <> b.i);
    end;

    operator Implicit(x: Integer): complex64;
    begin
      result.r := x;
    end;

    operator Implicit(x: Single): complex64;
    begin
      result.r := x;
    end;

    operator Add(x: complex64; y: complex64): complex64;
    begin
      result.r := x.r+y.r;
      result.i := x.i+y.i;
    end;

    operator Subtract(x: complex64; y: complex64): complex64;
    begin
      result.r := x.r-y.r;
      result.i := x.i-y.i;
    end;

    operator Multiply(x: complex64; y: complex64): complex64;
    begin
      result.r := (x.r*y.r - x.i*y.i);
      result.i := (x.r*y.i + x.i*y.r);
    end;

    operator Divide(x: complex64; y: complex64): complex64;
    begin
      var common := (1/(x.r*x.r + x.i*x.i));
      result.r := common * (y.r*x.r + y.i*x.i);
      result.r := common * (y.i*x.r - x.r*y.i);
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

end.
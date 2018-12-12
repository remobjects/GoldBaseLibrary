namespace math;

const
        E   = 2.71828182845904523536028747135266249775724709369995957496696763; public; // https://oeis.org/A001113
        Pi  = 3.14159265358979323846264338327950288419716939937510582097494459; public;// https://oeis.org/A000796
        Phi = 1.61803398874989484820458683436563811772030917980576286213544862; public;// https://oeis.org/A001622

        Sqrt2   = 1.41421356237309504880168872420969807856967187537694807317667974; public;// https://oeis.org/A002193
        SqrtE   = 1.64872127070012814684865078781416357165377610071014801157507931; public;// https://oeis.org/A019774
        SqrtPi  = 1.77245385090551602729816748334114518279754945612238712821380779; public;// https://oeis.org/A002161
        SqrtPhi = 1.27201964951406896425242246173749149171560804184009624861664038; public;// https://oeis.org/A139339

        Ln2    = 0.693147180559945309417232121458176568075500134360255254120680009; public;// https://oeis.org/A002162
        Log2E  = 1 / Ln2;
        Ln10   = 2.30258509299404568401799145468436420760110148862877297603332790; public;// https://oeis.org/A002392
        Log10E = 1 / Ln10;

const
        MaxFloat32             = 3.40282346638528859811704183484516925440e+38 ; public; // 2**127 * (2**24 - 1) / 2**23
        SmallestNonzeroFloat32 = 1.401298464324817070923729583289916131280e-45; public; // 1 / 2**(127 - 1 + 23)

        MaxFloat64             = 1.797693134862315708145274237317043567981e+308; public; // 2**1023 * (2**53 - 1) / 2**52
        SmallestNonzeroFloat64 = 4.940656458412465441765687928682213723651e-324; public; // 1 / 2**(1023 - 1 + 52)


const
        MaxInt8   = 1 shl 7 - 1; public;
        MinInt8   = -1  shl  7; public;
        MaxInt16  = 1 shl 15 - 1; public;
        MinInt16  = -1  shl  15; public;
        MaxInt32  = 1 shl 31 - 1; public;
        MinInt32  = -1  shl  31; public;
        MaxInt64  = 1 shl 63 - 1; public;
        MinInt64  = -1  shl  63; public;
        MaxUint8  = 1 shl 8 - 1; public;
        MaxUint16 = 1 shl 16 - 1; public;
        MaxUint32 = 1 shl  32 - 1; public;
        MaxUint64 = 1 shl 64 - 1; public;


method Trunc(x: Double): Double; public;
begin
  {$IFDEF ECHOES}
  exit System.Math.Truncate(x);
  {$ELSE}
  exit RemObjects.Elements.System.Math.Truncate(x);
  {$ENDIF}
end;

method NaN(): Double; public;
begin
  exit Double.NaN;
end;

method IsInf(v: Double; sign: Integer): Boolean; public;
begin
  if sign < 0 then
    exit Double.IsNegativeInfinity(v);
  if sign > 0 then
    exit Double.IsPositiveInfinity(v);
  exit Double.IsInfinity(v);
end;

method IsNaN(v: Double): Boolean; public;
begin
  exit Double.IsNaN(v);
end;

method Abs(v: Double): Double; public;
begin
  exit Math.Abs(v);
end;

method Sqrt(v: Double): Double; public;
begin
  exit :Math.Sqrt(v);
end;


method Inf(sign: Integer): Double; public;unsafe;
begin
  if sign < 0 then
    exit Double.NegativeInfinity;
  exit Double.PositiveInfinity
end;

method Float32bits(f: Single): UInt32; public;unsafe;
begin
  ^Single(@result)^ := f;
end;

method Float32frombits(b: UInt32): Single; public; unsafe;
begin
  ^UInt32(@Result)^ := b;
end;

method Float64bits(f: Double): UInt64; public;unsafe;
begin
  ^Double(@result)^ := f;
end;

method Float64frombits(b: UInt64): Double; public; unsafe;
begin
  ^UInt64(@Result)^ := b;
end;

method Log(x: Double): Double; public;
begin
  exit :Math.Log(x);
end;

method Exp(x: Double): Double; public;
begin
  exit :Math.Exp(x);
end;

method Floor(x: Double): Double; public;
begin
  exit :Math.Floor(x);
end;

method Ceil(x: Double): Double; public;
begin
  exit :Math.Ceil(x);
end;

method Ldexp(frac: Double; aexp: Integer): Double; public;
begin
  exit Math.Pow(2, aexp) * frac;
end;

method Frexp(value: Double): tuple of (Double, Integer); public;
begin
  var bits: Int64 := BitConverter.DoubleToInt64Bits(value);
  var realMant: Double := 1.0;
  var exponent: Integer;
  var resmmantissa: Double;

  if Double.isNaN(value) or
  (value + value = value) or
  Double.IsInfinity(value) then begin
    exponent := 0;
    resmmantissa := value;
  end   else begin
    var neg := bits < 0;
    exponent := ((bits shr 52) and $7ff);
    var mantissa := bits and $fffffffffffff;

    if(exponent = 0) then begin
      inc(exponent);
    end
    else begin
      mantissa := mantissa or (Int64(1) shl 52);
    end;

      // bias the exponent - actually biased by 1023.
      // we are treating the mantissa as m.0 instead of 0.m
      //  so subtract another 52.
    exponent := exponent - 1075;
    realMant := mantissa;

      // normalize
    while(realMant > 1.0)  do begin
      mantissa := mantissa shr 11;
      realMant := realMant / 2.0;
      inc(exponent);
    end;

    if(neg) then begin
      realMant := realMant * -1;
    end;

    resmmantissa := realMant;
  end;
  exit (resmmantissa, exponent);
end;

method Log2(d: Double): Double;
begin
  exit :System.Math.Log(d, 2);
end;

method Signbit(d: Double): Boolean;
begin
  exit d < 0;
end;

end.
namespace unicode.utf8;

const
        RuneError: builtin.rune = #$FFFD;
        RuneSelf  = $80      ;
        MaxRune   = $10FFFF;
        UTFMax    = 4       ;
        surrogateMin = $D800;

        surrogateMax = $DFFF;


        t1 = $00; // 0000 0000
        tx = $80; // 1000 0000
        t2 = $C0; // 1100 0000
        t3 = $E0; // 1110 0000
        t4 = $F0; // 1111 0000
        t5 = $F8; // 1111 1000

        maskx = $3F; // 0011 1111
        mask2 = $1F; // 0001 1111
        mask3 = $0F; // 0000 1111
        mask4 = $07; // 0000 0111

        rune1Max = 1 shl 7 - 1;
        rune2Max = 1 shl 11 - 1;
        rune3Max = 1 shl 16 - 1;

        // The default lowest and highest continuation byte.
        locb = $80; // 1000 0000
        hicb = $BF; // 1011 1111

        // These names of these constants are chosen to give nice alignment in the
        // table below. The first nibble is an index into acceptRanges or F for
        // special one-byte cases. The second nibble is the Rune length or the
        // Status for the special one-byte case.
        xx = $F1; // invalid: size 1
        &as = $F0; // ASCII: size 1
        s1 = $02; // accept 0, size 2
        s2 = $13; // accept 1, size 3
        s3 = $03; // accept 0, size 3
        s4 = $23; // accept 2, size 3
        s5 = $34; // accept 3, size 4
        s6 = $04; // accept 0, size 4
        s7 = $44; // accept 4, size 4

var first: array of builtin.uint8 := [
  //   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, // 0x00-0x0F
  &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, // 0x10-0x1F
  &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, // 0x20-0x2F
  &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, // 0x30-0x3F
  &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, // 0x40-0x4F
  &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, // 0x50-0x5F
  &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, // 0x60-0x6F
  &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, &as, // 0x70-0x7F
  //   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, // 0x80-0x8F
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, // 0x90-0x9F
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, // 0xA0-0xAF
  xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, // 0xB0-0xBF
  xx, xx, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, // 0xC0-0xCF
  s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, // 0xD0-0xDF
  s2, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s4, s3, s3, // 0xE0-0xEF
  s5, s6, s6, s6, s7, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx // 0xF0-0xFF
];

var acceptRanges: array of array of Integer :=[
  [locb, hicb],
  [$A0, hicb],
  [locb, $9F],
  [$90, hicb],
  [locb, $8F]
];

method DecodeRuneInString(n: builtin.string): tuple of (builtin.rune, Integer);public;
begin
  exit (new builtin.rune(Value := Integer(n[0])), 8);
end;

method ValidString(n: builtin.string): Boolean;public;
begin
  exit true;
end;

method ValidRune(r: builtin.rune): Boolean; public;
begin
  exit Integer(r) in [0..$D800, $DFFF..$10FFFF];
end;

method EncodeRune(p: builtin.Slice<Byte>; r: builtin.rune): Integer; public;
begin
  {$IFDEF ECHOES}
  var z := System.Text.Encoding.UTF8.GetBytes(r.ToString());
  {$ELSE}
  var z := Encoding.UTF8.GetBytes(r.ToString());
  {$ENDIF}
  if z.Length > p.Length then exit -1;
  for i: Integer := 0 to z.Length -1 do
    p[i] := z[i];
  exit z.Length;
end;

method RuneLen(r: builtin.rune): Integer;
begin
  if r < 0 then exit -1;
  if r ≤ rune1Max then exit 1;
  if r ≤ rune2Max then exit 2;
  if Integer(r) in [surrogateMin .. surrogateMax] then exit -1;
  if r ≤ rune3Max then exit 3;
  //if r ≤ rune4Max then exit 4;
  exit -1;
end;


method FullRune(p: builtin.Slice<Byte>): Boolean;
begin
  var n := p.Length;
  if n = 0 then begin
    exit false;
  end;

  var x := first[p[0]];

  if n >= Integer(x and 7) then begin
    exit true; // ASCII, invalid or valid.
  end;

  // Must be short or invalid.

  var accept := acceptRanges[x shr 4];

  if (n > 1) and ((p[1] < accept[0]) or (accept[1] < p[1]))  then begin
    exit true;
  end else if (n > 2) and ((p[2] < locb) or (hicb < p[2])) then
    exit true;
  exit false;
end;

method DecodeLastRuneInString(p: String): tuple of (builtin.rune, Integer); public;
begin
  if length(p) < 1 then exit (RuneError, 0);
  exit (Integer(p[p.Length-1]), 1);
end;

method DecodeRune(p: builtin.Slice<Byte>): tuple of (builtin.rune, Integer); public;
// Based on the UTf8 code from Go/unicode/utf8
begin
  var n := p.Length;
  if n < 1 then exit (RuneError, 0);

  var p0 := p[0];
  var x := first[p0];

  if x >= &as then begin

    // The following code simulates an additional check for x == xx and

    // handling the ASCII and invalid cases accordingly. This mask-and-or

    // approach prevents an additional branch.

    var mask := Integer(x) shl 31 shr 31; // Create 0x0000 or 0xFFFF.

    exit (((Integer(p[0]) and not mask) or (Integer(RuneError) and mask)), 1);

  end;

  var sz := x and 7;

  var accept := acceptRanges[x shr 4];

  if n < Integer(sz) then begin
    exit (RuneError, 1);
  end;

  var b1 := p[1];

  if (b1 < accept[0]) or(accept[1] < b1) then begin

    exit (RuneError, 1)

  end;

  if( sz = 2) then begin
    exit (((Integer(p0 and mask2) shl 6) or Integer(b1 and maskx)), 2);
  end;

  var b2 := p[2];

  if (b2 < locb) or (hicb < b2) then begin
    exit (RuneError, 1)
  end;

  if (sz = 3) then begin

    exit (((Integer(p0 and mask3) shl 12) or (Integer(b1 and maskx)shl 6) or Integer(b2 and maskx)), 3);
  end;

  var b3 := p[3];

  if (b3 < locb) or (hicb < b3) then begin
    exit (RuneError, 1)
  end;

  exit ((((Integer(p0 and mask4)shl 18) or (Integer(b1 and maskx)shl 12) or (Integer(b2 and maskx)shl 6) or Integer(b3 and maskx))), 4)
end;

method RuneCountInString(v: String): Integer; public;
begin
  exit v.Length;
end;


// RuneCount returns the number of runes in p. Erroneous and short
// encodings are treated as single runes of width 1 byte.
method RuneCount(p: builtin.Slice<Byte>): Integer;
begin
  var np := p.Length;
  var n: Integer;
  var i := 0;
  while i < np do begin
    inc(n);
    var c := p[i];
    if c < RuneSelf then begin
      // ASCII fast path
      inc(i);
      continue
    end;
    var x := first[c];
    if x = xx then begin
      inc(i); // invalid.
      continue;
    end;
    var size := Integer(x and 7);
    if i+size > np then begin
      inc(i); // Short or invalid.
      continue
    end;
    var accept := acceptRanges[x shr 4];
    c := p[i+1];
    if (c < accept[0]) or (accept[1] < c) then begin
      size := 1;
    end else if size = 2 then begin
    end else begin
      c := p[i+2];
      if (c < locb) or (hicb < c) then begin
      size := 1;
      end else if size = 3 then begin
        end else begin
          c := p[i+3];
          if  (c < locb) or (hicb < c) then begin
            size := 1;
        end;
      end;
    end;
    i := i + size;
  end;
  exit n;
end;


method RuneStart(b: Byte): Boolean; public; begin exit (b and $C0) <> $80; end;

// DecodeLastRune unpacks the last UTF-8 encoding in p and returns the rune and
// its width in bytes. If p is empty it returns (RuneError, 0). Otherwise, if
// the encoding is invalid, it returns (RuneError, 1). Both are impossible
// results for correct, non-empty UTF-8.
//
// An encoding is invalid if it is incorrect UTF-8, encodes a rune that is
// out of range, or is not the shortest possible UTF-8 encoding for the
// value. No other validation is performed.
method  DecodeLastRune(p: builtin.Slice<Byte>): tuple of (builtin.rune, Integer); public;
begin
  var lend := p.Length;
  if lend = 0 then begin;
    exit ( RuneError, 0)
  end;
  var start := lend - 1;
  var r := (p[start]);
  if r < RuneSelf then begin
    exit (r, 1);
  end;
  // guard against O(n^2) behavior when traversing
  // backwards through strings with long sequences of
  // invalid UTF-8.
  var lim := lend - UTFMax;
  if lim < 0 then begin
    lim := 0
  end;
  dec(start);
  while start ≥ lim do begin

    if RuneStart(p[start]) then begin
      break
    end;
    dec(start);
  end;
  if start < 0 then begin
    start := 0
  end;
  var (rq, size) := DecodeRune(builtin.Slice(p, start, lend));
  if start+size <> lend then begin
    exit (RuneError, 1);
  end;
  exit (rq, size);
end;

method Valid(p: builtin.Slice<Byte>): Boolean; public;
begin
  var n := p.Length;
  var i := 0;
  while i < n do begin
    var pi := p[i];
    if pi < RuneSelf then begin
      inc(i);
      continue
    end;
    var x := first[pi];
    if x = xx then
      exit false; // Illegal starter byte.

    var size := Integer(x and 7);
    if i+size > n then
      exit  false; // Short or invalid.

    var accept := acceptRanges[x shr 4];
    var c := p[i+1];
    if (c < accept[0]) or (accept[1] < c) then begin
      exit  false;
  end else if size = 2  then
  else begin
    c := p[i+2];

    if (c < locb) or (hicb < c) then begin
      exit false;
     end else if size = 3 then begin
     end else begin
       c := p[i+3];
       if (c < locb) or (hicb < c) then begin
         exit false;
       end;
     end
   end;
    i := i + size;
    exit;
    exit true;
  end;
end;

end.
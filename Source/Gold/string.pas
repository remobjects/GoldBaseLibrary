namespace go.builtin;

uses
{$IFDEF ECHOES}  System.Linq, System.Collections.Generic{$ENDIF}
  ;

type
  string = public partial record
  public
    Value: Slice<byte>;

    constructor(aValue: PlatformString);
    begin
      {$IF ISLAND}
      Value := Encoding.UTF8.GetBytes(aValue);
      {$ELSEIF ECHOES}
      Value := System.Text.Encoding.UTF8.GetBytes(aValue);
      {$ENDIF}
    end;

    constructor(aValue: array of Char);
    begin
      // TODO optimize!!
      var lBytes := new List<byte>();
      var z: array of byte;
      for each lChar in aValue do begin
        var lRune := uint32(lChar);
        {$IFDEF ECHOES}
        z := System.Text.Encoding.UTF8.GetBytes(chr(lRune));
        {$ELSE}
        z := Encoding.UTF8.GetBytes(chr(lRune));
        {$ENDIF}
        for i: Integer := 0 to z.Length - 1 do
          lBytes.Add(z[i]);
      end;
      Value := lBytes.ToArray();
    end;

    constructor(aValue: Slice<byte>);
    begin
      Value := new Slice<byte>(aValue.Length);
      copy(Value, aValue);
    end;

    constructor(aValue: array of rune);
    begin
      // TODO optimize!!
      var lBytes := new List<byte>();
      var z: array of byte;
      for each lRune in aValue do begin
        {$IFDEF ECHOES}
        z := System.Text.Encoding.UTF8.GetBytes(chr(lRune));
        {$ELSE}
        z := Encoding.UTF8.GetBytes(chr(lRune));
        {$ENDIF}
        for i: Integer := 0 to z.Length - 1 do
          lBytes.Add(z[i]);
      end;
      Value := lBytes.ToArray();
    end;

    class operator Implicit(aValue: string): PlatformString;
    begin
      {$IF ISLAND}
      result := Encoding.UTF8.GetString(aValue.Value);
      {$ELSEIF ECHOES}
      result := System.Text.Encoding.UTF8.GetString(aValue.Value);
      {$ENDIF}
    end;

    class operator Implicit(aValue: PlatformString): string;
    begin
      {$IF ISLAND}
      result := new String(Encoding.UTF8.GetBytes(aValue));
      {$ELSEIF ECHOES}
      result := new String(System.Text.Encoding.UTF8.GetBytes(aValue));
      {$ENDIF}
    end;

    class operator Implicit(aValue: string): Slice<byte>;
    begin
      result := new Slice<byte>(aValue.Value);
    end;

    class operator Implicit(aValue: Char): string;
    begin
      result := new string([aValue]);
    end;

    class operator Equal(a, b: string): Boolean;
    begin
      result := go.bytes.Compare(a.Value, b.Value) = 0;
    end;

    class operator NotEqual(a, b: string): Boolean;
    begin
      result := not (a = b);
    end;

    class operator Less(aLeft, aRight: string): Boolean;
    begin
      result := go.bytes.Compare(aLeft.Value, aRight.Value) < 0;
    end;

    class operator LessOrEqual(aLeft, aRight: string): Boolean;
    begin
      result := go.bytes.Compare(aLeft.Value, aRight.Value) <= 0;
    end;

    class operator GreaterOrEqual(aLeft, aRight: string): Boolean;
    begin
      result := go.bytes.Compare(aLeft.Value, aRight.Value) ≥ 0;
    end;

    class operator Greater(aLeft, aRight: string): Boolean;
    begin
      result := go.bytes.Compare(aLeft, aRight) > 0;
    end;

    class operator &Add(aLeft, aRight: string): string;
    begin
      var lNew := new byte[aLeft.Length];
      for i: Integer := 0 to aLeft.Length - 1 do
        lNew[i] := aLeft[i];
      result := new string(appendSlice(aLeft, aRight.Value));
    end;

    class operator &Add(aLeft: string; aRight: Integer): string;
    begin
      result := aLeft + go.strconv.Itoa(aRight);
    end;

    // go does not have Substring method
    method Substring(aIndex: int32): string;
    begin
      result := new string(new Slice<byte>(Value, aIndex, Value.Length - 1));
    end;

    method Substring(aIndex: int32; aLen: int32): string;
    begin
      result := new string(new Slice<byte>(Value, aIndex, (aIndex + aLen) - 1));
    end;

    class method IsNullOrEmpty(aValue: string): Boolean; public;
    begin
      result := (aValue.Value = nil) or (aValue.Value.Length = 0);
    end;

    property Chars[aIndex: int32]: byte read begin
      result := Value[aIndex];
    end; default; inline;

    property Length: Integer read Value.Length;

    method GetSequence: sequence of tuple of (Integer, rune); iterator;
    begin
      // TODO optimize!!
      {$IF ISLAND}
      var lString := Encoding.UTF8.GetString(Value);
      {$ELSEIF ECHOES}
      var lString := System.Text.Encoding.UTF8.GetString(Value);
      {$ENDIF}
      var lRunes := new Slice<rune>(lString.Select(a -> rune(a)).ToArray());
      for i: Integer := 0 to lRunes.Length -1 do
        yield (i, lRunes[i]);
    end;

    method GoldIterate: sequence of tuple of (Integer, go.builtin.rune); iterator; public;
    begin
      for each el in self index n do
        yield (n, go.builtin.rune(el[1]));
    end;

    method Name: string;
    begin
      result := '';
    end;

    method ToString: PlatformString; override;
    begin
      {$IF ISLAND}
      result := Encoding.UTF8.GetString(Value);
      {$ELSEIF ECHOES}
      result := System.Text.Encoding.UTF8.GetString(Value);
      {$ENDIF}
    end;

    method GetHashCode: Integer; override; public;
    begin
      // TODO optimize
      {$IF ISLAND}
      {$ELSEIF ECHOES}
      result := System.Text.Encoding.UTF8.GetString(Value).GetHashCode();
      {$ENDIF}
    end;

    method &Equals(obj: Object): Boolean; override; public;
    begin
      var lOther := string(obj);
      if assigned(lOther) then
        result := lOther = self;
    end;

    class var fZero: string := new string();
    class property Zero: string := fZero; public;

    class method PlatformStringArrayToGoArray(aValue: array of PlatformString): array of go.builtin.string;
    begin
      result := new go.builtin.string[aValue.Length];
      for i: Integer := 0 to aValue.Length - 1 do
        result[i] := aValue[i];
    end;

    class method PlatformStringArrayToGoSlice(aValue: array of PlatformString): Slice<go.builtin.string>;
    begin
      result := new Slice<go.builtin.string>(aValue.Length);
      for i: Integer := 0 to aValue.Length - 1 do
        result[i] := aValue[i];
    end;
  end;


  operator implicit(aVal: string): Slice<Char>; public;
  begin
    // TODO optimize!!
    {$IF ISLAND}
    var lString := Encoding.UTF8.GetString(aVal.Value);
    result := new Slice<Char>(lString.ToCharArray);
    {$ELSEIF ECHOES}
    var lString := System.Text.Encoding.UTF8.GetString(aVal.Value);
    result := new Slice<Char>(lString.ToCharArray);
    {$ENDIF}
  end;

  operator implicit(aVal: string): Slice<go.builtin.rune>; public;
  begin
    // TODO optimize!!
    {$IF ISLAND}
    var lString := Encoding.UTF8.GetString(aVal.Value);
    {$ELSEIF ECHOES}
    var lString := System.Text.Encoding.UTF8.GetString(aVal.Value);
    {$ENDIF}
    result := new Slice<rune>(lString.Select(a -> rune(a)).ToArray());
  end;

  operator implicit(aVal: byte): string; public;
  begin
    exit new string([rune(aVal)]);
  end;

  operator implicit(aVal: rune): string; public;
  begin
    exit new string([aVal]);
  end;

  operator Implicit(aVal: Slice<Char>): string; public;
  begin
    exit new string(aVal.ToArray());
  end;

  operator Implicit(aVal: Slice<rune>): string; public;
  begin
    exit new string(aVal.ToArray());
  end;

  operator Explicit(aVal: string): Slice<byte>; public;
  begin
    result := new Slice<byte>(aVal.Length);
    copy(result, aVal.Value);
  end;

  operator Explicit(aVal: PlatformString): Slice<byte>; public;
  begin
    {$IFDEF ISLAND}
    exit new Slice<byte>(Encoding.UTF8.GetBytes(aVal));
    {$ELSE}
    exit new Slice<byte>(System.Text.Encoding.UTF8.GetBytes(aVal));
    {$ENDIF}
  end;

  operator Explicit(aVal: PlatformString): go.net.http.htmlSig; public;
  begin
    var q: go.builtin.Slice<byte> := (aVal as go.builtin.Slice<byte>);
    {$IF ISLAND}
    // TODO
    result := nil;
    {$ELSEIF ECHOES}
    exit new go.net.http.htmlSig(Value := System.Text.Encoding.UTF8.GetBytes(aVal));
    {$ENDIF}
    //exit new go.net.http.htmlSig(Value := q);
  end;

  operator Implicit(aVal: Slice<byte>): string; public;
  begin
    exit new string(aVal);
  end;

  operator Implicit(aVal: PlatformString): Slice<byte>; public;
  begin
    {$IF ISLAND}
    result := new Slice<byte>(Encoding.UTF8.GetBytes(aVal));
    {$ELSEIF ECHOES}
    result := new Slice<byte>(System.Text.Encoding.UTF8.GetBytes(aVal));
    {$ENDIF}
  end;

  operator Implicit(aVal: PlatformString): array of byte; public;
  begin
    {$IF ISLAND}
    // TODO
    {$ELSEIF ECHOES}
    result := System.Text.Encoding.UTF8.GetBytes(aVal);
    {$ENDIF}
  end;

  operator Implicit(aVal: Slice<byte>): PlatformString; public;
  begin
    {$IF ISLAND}
    result := Encoding.UTF8.GetString(aVal);
    {$ELSEIF ECHOES}
    result := System.Text.Encoding.UTF8.GetString(aVal);
    {$ENDIF}
  end;

  end.
namespace go.builtin;

uses
{$IFDEF ECHOES}  System.Text, System.Linq, System.Collections.Generic{$ENDIF}
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
      {$IF ECHOES}
      Value := Encoding.UTF8.GetBytes(aValue);
      {$ELSE}
      var lString := PlatformString.FromCharArray(aValue);
      Value := Encoding.UTF8.GetBytes(lString);
      {$ENDIF}
    end;

    constructor(aValue: Slice<byte>);
    begin
      Value := new Slice<byte>(aValue.Length);
      copy(Value, aValue);
    end;

    constructor(aValue: array of rune);
    begin
      var lArray := new Char[aValue.Length];
      for i: Integer := 0 to aValue.Length - 1 do
        lArray[i] := chr(aValue[i]);

      constructor(lArray);
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
      result := new string(Encoding.UTF8.GetBytes(aValue));
      {$ELSEIF ECHOES}
      result := new string(System.Text.Encoding.UTF8.GetBytes(aValue));
      {$ENDIF}
    end;

    class operator Implicit(aValue: array of uint8): string;
    begin
      result := new string(aValue);
    end;

    class operator Implicit(aValue: string): Slice<byte>;
    begin
      var lData := aValue.Value.ToArray;
      result := new Slice<byte>(lData);
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
      result := new string(append(aLeft, aRight.Value));
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
      var lLength := (aIndex + aLen) - 1;
      if lLength < 0 then
        lLength := 0;
      result := new string(new Slice<byte>(Value, aIndex, lLength));
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
      var i := 0;
      var c := 0;
      var r: rune;
      while i < Value.Length do begin
        r := UTF8ToString(Value, i, var c);
        yield (i, r);
        i := i + c;
      end;
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
      {$IF ISLAND}
      result := Utilities.CalcHash(^Void(@Value.fArray[0]), Value.Length);
      {$ELSEIF ECHOES}
      result := System.Collections.IStructuralEquatable(Value).GetHashCode(EqualityComparer<byte>.Default);
      {$ENDIF}
    end;

    method &Equals(obj: Object): Boolean; override; public;
    begin
      var lOther := string(obj);
      if assigned(lOther) then
        result := lOther = self;
    end;

    class var fZero: string := new string();
    class property Zero: string := fZero; published;

    class method UTF8ToString(aValue: array of byte; aIndex: Integer; var aSize: Integer): rune;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      var len := aValue.Length;
      if len = 0 then exit 0;
      var pos := aIndex;
      var last := aValue.Length;
      // skip BOM
      if len>2 then begin
        if (aValue[0] = $EF) and
           (aValue[1] = $BB) and
           (aValue[2] = $BF) then pos := 3;
      end;
        var ch := aValue[pos];
        if ch and $F0 = $F0 then begin
          //   11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
          if pos+4 > last then
            raise new Exception('Bad UTF8 string');
          var code := (((((
                        uint32(ch and $7) shl 6 +
                        (uint32(aValue[pos+1]) and $3F)) shl 6)+
                        (uint32(aValue[pos+2]) and $3F)) shl 6)+
                        (uint32(aValue[pos+3]) and $3F));
          //if (code < $10000) or (code>$1FFFFF) then MalformedError;
          var code1 := code - $10000;
          //str.Append(Char($D800 or (code1 shr 10)));
          //str.Append(Char($DC00 or (code1 and $3FF)));
          aSize := 4;
          exit 65; // TODO
        end
        else if (ch and $E0) = $E0 then begin
          //1110xxxx 10xxxxxx 10xxxxxx
          if pos+3 > last then
            raise new Exception('Bad UTF8 string');
          var code := ((
                        uint32(ch and $F) shl 6 +
                        (uint32(aValue[pos+1]) and $3F)) shl 6)+
                        (uint32(aValue[pos+2]) and $3F);
          if (code < $800) or (code > $FFFF) then
            raise new Exception('Bad UTF8 string');
          aSize := 3;
          exit code;
        end
        else if (ch and $C0) = $C0 then begin
          // 110xxxxx 10xxxxxx
          if pos+2 > last then
            raise new Exception('Bad UTF8 string');
          var code :=
                      uint32(ch and $1F) shl 6 +
                      (uint32(aValue[pos+1]) and $3F);
          if (code < $80) or (code >$7FF) then
            raise new Exception('Bad UTF8 string');
          aSize := 2;
          exit code;
        end
        else begin
          // 0xxxxxxx
          var code := ch;
          if (code < $0)  or (code > $7F) then
            raise new Exception('Bad UTF8 string');
          aSize := 1;
          exit code;
        end;
    end;

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
    exit new go.net.http.htmlSig(Value := Encoding.UTF8.GetBytes(aVal));
    result := nil;
    {$ELSEIF ECHOES}
    exit new go.net.http.htmlSig(Value := System.Text.Encoding.UTF8.GetBytes(aVal));
    {$ENDIF}
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
    result := Encoding.UTF8.GetBytes(aVal);
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
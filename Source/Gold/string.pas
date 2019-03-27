namespace go.builtin;

uses
{$IFDEF ECHOES}  System.Linq, System.Collections.Generic{$ENDIF}
  ;

type
  //{$IF NEWSTRING}
  string = public partial record
  public
    Value: Slice<byte>;

    constructor(aValue: PlatformString);
    begin
      {$IF ISLAND}
      // TODO
      {$ELSEIF ECHOES}
      Value := System.Text.Encoding.UTF8.GetBytes(aValue);
      {$ENDIF}
    end;

    constructor(aValue: array of Char);
    begin
      // TODO
    end;

    constructor(aValue: Slice<byte>);
    begin
      Value := aValue;
    end;

    class operator Implicit(aValue: string): PlatformString;
    begin
      {$IF ISLAND}
      // TODO
      {$ELSEIF ECHOES}
      result := System.Text.Encoding.UTF8.GetString(aValue.Value);
      {$ENDIF}
    end;

    class operator Implicit(aValue: PlatformString): string;
    begin
      result := new string(aValue);
    end;

    class operator Implicit(aValue: string): Slice<byte>;
    begin
      result := nil;
    end;

    class operator Equal(a, b: string): Boolean;
    begin
      result := false;
    end;

    class operator NotEqual(a, b: string): Boolean;
    begin
      result := not (a = b);
    end;

    class operator Less(aLeft, aRight: string): Boolean;
    begin
      // TODO
      result := true;
    end;

    class operator GreaterOrEqual(aLeft, aRight: string): Boolean;
    begin
      // TODO
      result := true;
    end;

    class operator &Add(aLeft, aRight: string): string;
    begin
      // TODO
      result := aLeft;
    end;

    class operator &Add(aLeft: string; aRight: Integer): string;
    begin
      // TODO
      result := aLeft;
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

    property Chars[aIndex: int32]: byte read begin
      result := Value[aIndex];
    end; default; inline;

    property Length: Integer read Value.Length;

    method GetSequence: sequence of tuple of (Integer, byte); iterator;
    begin
      for i: Integer := 0 to Value.Length -1 do
        yield (i, Value[i]);
    end;

    method Name: string;
    begin
      result := '';
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
  //{$ENDIF}

  operator Implicit(aVal: PlatformString): Slice<byte>; public;
  begin
    {$IF ISLAND}
    // TODO
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

  end.
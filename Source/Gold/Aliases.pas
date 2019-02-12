namespace go.builtin;

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
    Value: Integer;
  end;
  string = public RemObjects.Elements.System.String;

  method print(params x: array of Object);
  begin
    go.fmt.Print(x);
  end;

  method println(params x: array of Object);
  begin
    go.fmt.Println(x);
  end;

end.
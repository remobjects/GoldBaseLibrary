﻿namespace reflect;

type
  Kind = public type builtin.uint;
  ChanDir = public type builtin.int;
  [ValueTypeSemantics]
  MapIter = public class
  public
    method Key: Value; begin raise new NotImplementedException; end;
    method Value: Value; begin raise new NotImplementedException; end;
    method Next: Boolean; begin raise new NotImplementedException; end;
  end;

const
  Invalid: Kind = Kind(0);
  Bool: Kind = Kind(1);
  Int: Kind = Kind(2);
  Int8: Kind = Kind(3);
  Int16: Kind = Kind(4);
  Int32: Kind = Kind(5);
  Int64: Kind = Kind(6);
  Uint: Kind = Kind(7);
  Uint8: Kind = Kind(8);
  Uint16: Kind = Kind(9);
  Uint32: Kind = Kind(10);
  Uint64: Kind = Kind(11);
  Uintptr: Kind = Kind(12);
  Float32: Kind = Kind(13);
  Float64: Kind = Kind(14);
  Complex64: Kind = Kind(15);
  Complex128: Kind = Kind(16);
  Array: Kind = Kind(17);
  Chan: Kind = Kind(18);
  Func: Kind = Kind(19);
  &Interface: Kind = Kind(20);
  Map: Kind = Kind(21);
  Ptr: Kind = Kind(22);
  Slice: Kind = Kind(23);
  String: Kind = Kind(24);
  Struct: Kind = Kind(25);
  UnsafePointer: Kind = Kind(26);

  RecvDir: ChanDir = ChanDir(1 shl 0);
  SendDir: ChanDir = ChanDir(1 shl 1);
  BothDor: ChanDir = ChanDir(Integer(RecvDir) + Integer(SendDir));

type
  Value = public class
  private
  assembly
    fValue: Object;
    fType: &Type;
  public
    constructor;
    begin

    end;

    constructor(aValue: Object; aType: &Type := nil);
    begin
      fValue := aValue;
      if aType ≠ nil then
        fType := aType
      else
        fType := TypeOf(aValue);
    end;

    method String: String;
    begin
      exit (if fValue is builtin.Reference<Object> then builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)) else fValue).ToString;
    end;

    method Int: Int64;
    begin
      exit {$IFDEF ISLAND}RemObjects.Elements.System.Convert{$ELSE}System.Convert{$ENDIF}.ToInt64(if fValue is builtin.Reference<Object> then builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)) else fValue);
    end;
    method Uint: UInt64;
    begin
      exit {$IFDEF ISLAND}RemObjects.Elements.System.Convert{$ELSE}System.Convert{$ENDIF}.ToUInt64(if fValue is builtin.Reference<Object> then builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)) else fValue);
    end;
    method Float: Double;
    begin
      exit {$IFDEF ISLAND}RemObjects.Elements.System.Convert{$ELSE}System.Convert{$ENDIF}.ToDouble(if fValue is builtin.Reference<Object> then builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)) else fValue);
    end;

    method IsNil: Boolean;
    begin
      case fType.Kind of
        Chan, Func, Map, reflect.Interface, UnsafePointer, __Global.Slice: // missing &Interface Kind(20) --> &Interface
          exit (if fValue is builtin.Reference<Object> then builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)) else fValue) = nil;

        else
          raise new Exception('Wrong value type');
      end;
    end;

    method Complex: builtin.complex128;
    begin
      exit builtin.complex128(if fValue is builtin.Reference<Object> then builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)) else fValue);
    end;

    method Bool: Boolean;
    begin
      exit {$IFDEF ISLAND}RemObjects.Elements.System.Convert{$ELSE}System.Convert{$ENDIF}.ToBoolean(if fValue is builtin.Reference<Object> then builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)) else fValue);
    end;

    method Convert(aTo: &Type): Value;
    begin
      raise new NotImplementedException;
    end;

    method IsValid: Boolean;
    begin
      var lValue := if fValue is builtin.Reference<Object> then builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)) else fValue;
      result := lValue ≠ Zero(fType);
    end;

    method CanSet: Boolean;
    begin
      result := fValue is builtin.Reference<Object>;
    end;

    method Recv(): tuple of (Value, Boolean);
    begin
      raise new NotImplementedException();
    end;


    method MapIndex(key: Value): tuple of (Value);
    begin
      raise new NotImplementedException();
    end;

    method MapIter: builtin.Reference<MapIter>;
    begin
      raise new NotImplementedException;
    end;


    method MapKeys: builtin.Slice<Value>;
    begin
      raise new NotImplementedException();
    end;

    method &Set(aVal: Object);
    begin
      if not CanSet or not fType.AssignableTo(TypeOf(aVal)) then
        raise new Exception('Can not set object');

      builtin.Reference<Object>.Set(fValue, aVal);
    end;


    method CanInterface(): Boolean;
    begin
      raise new NotImplementedException;
    end;

    method Slice(i, j: Integer): Value;
    begin
      raise new NotImplementedException;
    end;

    method Pointer(): UInt64;
    begin
      raise new NotImplementedException;
    end;

    method MethodByName(name: String): Value;
    begin
      raise new NotImplementedException;
    end;

    method OverflowFloat(x: Double): Boolean;
    begin
      raise new NotImplementedException;
    end;

    method OverflowInt(x: Int64): Boolean;
    begin
      raise new NotImplementedException;
    end;

    method OverflowUint(x: Int64): Boolean;
    begin
      raise new NotImplementedException;
    end;

    method FieldByIndex(idx: builtin.Slice<Integer>): Value;
    begin
      raise new NotImplementedException;
    end;

    method SetCap(n: Integer);
    begin
      raise new NotImplementedException;
    end;

    method SetLen(n: Integer);
    begin
      raise new NotImplementedException;
    end;

    method Cap: Integer;
    begin
      raise new NotImplementedException;
    end;

    method SetBytes(aval: builtin.Slice<Byte>);
    begin
      raise new NotImplementedException;
    end;

    method &SetInt(aVal: Int64);
    begin
      if (not CanSet) or not (Integer(Kind) in [Integer(reflect.Int)..Integer(reflect.Int64)])  then
        raise new Exception('Can not set object to integer value');

      builtin.Reference<Object>.Set(fValue, aVal);
    end;

    method &SetBool(aVal: Boolean);
    begin
      if (not CanSet) or (Kind ≠ reflect.Bool) then
        raise new Exception('Can not set object to bool value');

      builtin.Reference<Object>.Set(fValue, aVal);
    end;

    method &SetUint(aVal: UInt64);
    begin
      if (not CanSet) or not (Integer(Kind) in [Integer(reflect.Uint)..Integer(reflect.Uint64)])  then
        raise new Exception('Can not set object to unsigned integer value');

      builtin.Reference<Object>.Set(fValue, aVal);
    end;

    method &SetFloat(aVal: Double);
    begin
      if (not CanSet) or ((Kind ≠ reflect.Float32) and (Kind ≠ reflect.Float64)) then
        raise new Exception('Can not set object to float value');

      builtin.Reference<Object>.Set(fValue, aVal);
    end;

    method &SetComplex(aVal: builtin.complex128);
    begin
      raise new NotImplementedException;
    end;

    method &SetString(aVal: String);
    begin
      if (not CanSet) or (Kind ≠ reflect.String) then
        raise new Exception('Can not set object to string value');

      builtin.Reference<Object>.Set(fValue, aVal);
    end;

    method &Type: &Type;
    begin
      result := fType;
    end;

    method Bytes: builtin.Slice<Byte>;
    begin
      raise new NotImplementedException;
    end;

    method Kind: Kind;
    begin
      result := fType.Kind;
    end;

    method Len: Integer;
    begin
      raise new NotImplementedException;
    end;

    method Index(i: Integer): Value;
    begin
      raise new NotImplementedException;
    end;

    method SetMapIndex(key: Value; val: Value);
    begin
      raise new NotImplementedException;
    end;

    method NumField: Integer;
    begin
      raise new NotImplementedException;
    end;

    method NumMethod: Integer;
    begin
      raise new NotImplementedException;
    end;

    method Field(i: Integer): Value;
    begin
      raise new NotImplementedException;
    end;

    method CanAddr: Boolean;
    begin
    raise new NotImplementedException;
    end;

    method Call(inn: builtin.Slice<Value>): builtin.Slice<Value>;
    begin
      raise new NotImplementedException;
    end;

    method Addr: Value;
    begin
      raise new NotImplementedException;
    end;

    method MapRange() :builtin.Reference<MapIter>;
    begin
      raise new NotImplementedException;
    end;

    method &Interface: Object;
    begin
      exit fValue;
    end;

    method Elem: Value;
    begin
      if fValue is builtin.Reference<Object> then
        exit new Value(builtin.Reference<Object>.Get(builtin.Reference<Object>(fValue)), fType);
      raise new NotSupportedException;
    end;

    method &Implements(u: &Type): Boolean;
    begin
      result := fType.Implements(u);
    end;

    method &AssignableTo(u: &Type): Boolean;
    begin
      result := fType.AssignableTo(u);
    end;

    method &ConvertibleTo(u: &Type): Boolean;
    begin
      result := fType.ConvertibleTo(u);
    end;

  end;

  &Type = public interface
    method Align: Integer;
    method FieldAlign: Integer;
    method &Method(i: Integer): &Method;
    method MethodByName(s: String): tuple of (&Method, Boolean);
    method NumMethod: Integer;
    method Name: String;
    method PkgPath: String;
    method Size: UIntPtr;
    method String: String;
    method Kind: Kind;
    method Implements(u: &Type): Boolean;
    method AssignableTo(u: &Type): Boolean;
    method ConvertibleTo(u: &Type): Boolean;
    method Comparable: Boolean;
    method Bits: Integer;
    method ChanDir: ChanDir;
    method IsVariadic: Boolean;
    method Elem: &Type;
    method Field(i: Integer): StructField;
    method FiedlByIndex(i: builtin.Slice<Integer>): StructField;
    method FieldByName(aname: String): tuple of (StructField, Boolean);
    method FieldByNameFunc(match: delegate(aName: String): Boolean): tuple of (StructField, Boolean);
    method &In(i: Integer): &Type;
    method Key: &Type;
    method Len: Integer;
    method NumField: Integer;
    method NumIn: Integer;
    method NumOut: Integer;
    method &Out(i: Integer): &Type;
  end;

  [AliasSemantics]
  StructTag = public record
  public
    Value: String;

    method Get(key: String): String;
    begin
      raise new NotImplementedException;
    end;

    method Lookup(key: String): tuple of (String, Boolean);
    begin
      raise new NotImplementedException;
    end;
  end;

  StructField = public interface
    property Name: String read;
    property PkgPath: String read;
    property &Type: &Type read;
    property Tag: StructTag read;
    property Offset: UIntPtr read;
    property &Index: builtin.Slice<Integer> read;
    property Anonymous: Boolean read;
  end;

  PlatformField = public {$IFDEF ECHOES}System.Reflection.FieldInfo{$ELSE}RemObjects.Elements.System.FieldInfo{$ENDIF};
  StructFieldImpl = class(StructField)
  private
    fField: PlatformField;
  public
    constructor(aField: PlatformField);
    begin
      fField := aField;
    end;

    property Name: String read fField.Name;
    property PkgPath: String read;
    property &Type: &Type read {$IF ISLAND}new TypeImpl(fField.&Type){$ELSEIF ECHOES}new TypeImpl(fField.GetType()){$ENDIF};
    property Tag: StructTag read;
    property Offset: UIntPtr read;
    property &Index: builtin.Slice<Integer> read;
    property Anonymous: Boolean read;
  end;

  &Method = public interface
    property Name: String read;
    property PkgPath: String read;
    property &Type: &Type read;
    property Func: Value read;
    property &Index: Integer read;
  end;

  PlatformMethod = public {$IFDEF ECHOES}System.Reflection.MethodInfo{$ELSE}RemObjects.Elements.System.MethodInfo{$ENDIF};
  MethodImpl = class(&Method)
  private
    fMethod: PlatformMethod;

    method get_Index: Integer;
    begin
      {$IF ISLAND}
      result := fMethod.DeclaringType.Methods.ToList.IndexOf(fMethod);
      {$ELSEIF ECHOES}
      result := System.Array.IndexOf(fMethod.DeclaringType.GetMethods, fMethod);
      {$ENDIF}
    end;

  public
    constructor(aMethod: PlatformMethod);
    begin
      fMethod := aMethod;
    end;

    property Name: String read fMethod.Name;
    property PkgPath: String read;
    property &Type: &Type read {$IF ISLAND}new TypeImpl(fMethod.&Type){$ELSEIF ECHOES}new TypeImpl(fMethod.ReturnType){$ENDIF};
    property Func: Value read;
    property &Index: Integer read get_Index;
  end;

  PlatformType = public {$IFDEF ECHOES}System.Type{$ELSE}RemObjects.Elements.System.Type{$ENDIF};
  TypeImpl = class(&Type)
  private
  assembly
    fRealType: PlatformType;

    method IsInteger: Boolean;
    begin
      result := (Integer(self.Kind) ≥ Integer(reflect.Bool)) and (Integer(self.Kind) ≤ Integer(reflect.Uint64));
    end;

    method IsFloatOrComplex: Boolean;
    begin
      result := (Integer(self.Kind) ≥ Integer(reflect.Float32)) and (Integer(self.Kind) ≤ Integer(reflect.Complex128));
    end;

  public
    property RealType: PlatformType read fRealType;

    constructor(aType: PlatformType);
    begin
      fRealType := aType;
    end;

    method Align: Integer;
    begin
    end;

    method FieldAlign: Integer;
    begin
    end;

    method &Method(i: Integer): &Method;
    begin
      if (i < 0) or (i ≥ NumMethod) then
        raise new Exception('Wrong method index');

      {$IF ISLAND}
      result := new MethodImpl(fRealType.Methods.ToList[i]);
      {$ELSEIF ECHOES}
      result := new MethodImpl(fRealType.GetMethods[i]);
      {$ENDIF}
    end;

    method MethodByName(s: String): tuple of (&Method, Boolean);
    begin
      var lMethod: &PlatformMethod;
      {$IF ISLAND}
      lMethod := fRealType.Methods.Where(a->a.Name = s).FirstOrDefault;
      {$ELSEIF ECHOES}
      lMethod := System.Array.Find(fRealType.GetMethods, a->a.Name = s);
      {$ENDIF}
      exit(new MethodImpl(lMethod), lMethod ≠ nil);
    end;

    method NumMethod: Integer;
    begin
      {$IF ISLAND}
      result := fRealType.Methods.Count;
      {$ELSEIF ECHOES}
      result := fRealType.GetMethods.Length;
      {$ENDIF}
    end;

    method Name: String;
    begin
      result := fRealType.Name;
    end;

    method PkgPath: String;
    begin
    end;

    method Size: UIntPtr;
    begin
      {$IF ISLAND}
      result := fRealType.SizeOfType;
      {$ELSEIF ECHOES}
      result := System.Runtime.InteropServices.Marshal.SizeOf(fRealType);
      {$ENDIF}
    end;

    method String: String;
    begin
    end;

    method Kind: Kind;
    begin
      {$IF ISLAND}
      case (fRealType.Flags and IslandTypeFlags.TypeKindMask) of
        IslandTypeFlags.Array: exit reflect.Array;
        IslandTypeFlags.Struct: exit reflect.Struct;
        IslandTypeFlags.Interface: exit reflect.Interface;
      end;

      case fRealType.Code of
        TypeCodes.None: result := reflect.Invalid;
        TypeCodes.Boolean: result := reflect.Bool;
        TypeCodes.Char: result := reflect.Uint16;
        TypeCodes.SByte: result := reflect.Uint8;
        TypeCodes.Byte: result := reflect.Int8;
        TypeCodes.Int16: result := reflect.Int16;
        TypeCodes.UInt16: result := reflect.Uint16;
        TypeCodes.Int32: result := reflect.Int32;
        TypeCodes.UInt32: result := reflect.Uint32;
        TypeCodes.Int64: result := reflect.Int64;
        TypeCodes.UInt64: result := reflect.Uint64;
        TypeCodes.Single: result := reflect.Float32;
        TypeCodes.Double: result := reflect.Float64;
        TypeCodes.UIntPtr: result := reflect.UintPtr;
        TypeCodes.IntPtr: result := reflect.Ptr;
        TypeCodes.String: result := reflect.String;
      end;
      {$ELSEIF ECHOES}
      if fRealType.IsArray then
        exit reflect.Array;

      if fRealType.IsInterface then
        exit reflect.Interface;

      if fRealType.IsPointer then
        exit reflect.Ptr;

      case System.Type.GetTypeCode(fRealType) of
        TypeCode.Boolean: result := reflect.Bool;
        TypeCode.Byte: result := reflect.Int8;
        TypeCode.SByte: result := reflect.Uint8;
        TypeCode.Int16: result := reflect.Int16;
        TypeCode.UInt16: result := reflect.Uint16;
        TypeCode.Int32: result := reflect.Int32;
        TypeCode.UInt32: result := reflect.Uint32;
        TypeCode.Int64: result := reflect.Int64;
        TypeCode.UInt64: result := reflect.Uint64;
        TypeCode.Single: result := reflect.Float32;
        TypeCode.Double: result := reflect.Float64;
        TypeCode.String: result := reflect.String;
        TypeCode.Char: result := reflect.Uint16;
        TypeCode.Empty: result := reflect.Invalid;
      end;
      {$ENDIF}
    end;

    method Implements(u: &Type): Boolean;
    begin
      {$IF ISLAND OR ECHOES}
      result := fRealType.isSubClassOf(TypeImpl(u).fRealType);
      {$ENDIF}
    end;

    method AssignableTo(u: &Type): Boolean;
    begin
      if u = nil then
        raise new Exception('nil type in AssignableTo');

      {$IF ISLAND OR ECHOES}
      result := TypeImpl(u).fRealType.IsAssignableFrom(self.fRealType);
      {$ENDIF}
    end;

    method ConvertibleTo(u: &Type): Boolean;
    begin
      if u = nil then
        raise new Exception('nil type in ConvertibleTo');

      if AssignableTo(u) then
        exit(true);

      // TODO Check underlying type

      if (IsInteger or IsFloatOrComplex) and (TypeImpl(u).IsInteger or TypeImpl(u).IsFloatOrComplex) then
        exit(true);

      if (IsInteger or (Kind = reflect.String) or (Kind = reflect.Slice)) and (u.Kind = reflect.String) then
        exit(true);

      if (Kind = reflect.String) and (TypeImpl(u).IsInteger or (u.Kind = reflect.String) or (u.Kind = reflect.Slice)) then
        exit(true);

      exit(false);
    end;

    method Comparable: Boolean;
    begin
    end;

    method Bits: Integer;
    begin
    end;

    method ChanDir: ChanDir;
    begin
    end;

    method IsVariadic: Boolean;
    begin
    end;

    method Elem: &Type;
    begin
    end;

    method Field(i: Integer): StructField;
    begin
      if Kind ≠ reflect.Struct then
        raise new Exception('Wrong type, it needs to be struct');
      {$IF ISLAND}
      var lFields := fRealType.Fields.ToList();
      if i ≥ lFields.Count then
        raise new IndexOutOfRangeException('Index out of range');
      {$ELSEIF ECHOES}
      var lFields := fRealType.GetFields();
      if i ≥ lFields.Length then
        raise new IndexOutOfRangeException('Index out of range');
      {$ENDIF}
      result := new StructFieldImpl(lFields[i]);
    end;

    method FiedlByIndex(i: builtin.Slice<Integer>): StructField;
    begin
      if Kind ≠ reflect.Struct then
        raise new Exception('Wrong type, it needs to be struct');

      var lType := self;
      for lIndex: Integer := 0 to i.Length - 1 do begin
        result := lType.Field(i[lIndex]);
        lType := TypeImpl(result.Type);
      end;
    end;

    method FieldByName(aname: String): tuple of (StructField, Boolean);
    begin
      var lField: &PlatformField;
      {$IF ISLAND}
      lField := fRealType.Fields.Where(a->a.Name = aname).FirstOrDefault;
      {$ELSEIF ECHOES}
      lField := System.Array.Find(fRealType.GetFields, a->a.Name = aname);
      {$ENDIF}
      exit(new StructFieldImpl(lField), lField ≠ nil);
    end;

    method FieldByNameFunc(match: delegate(aName: String): Boolean): tuple of (StructField, Boolean);
    begin
      var lField: &PlatformField;
      {$IF ISLAND}
      lField := fRealType.Fields.Where(match).FirstOrDefault;
      {$ELSEIF ECHOES}
      lField := System.Array.Find(fRealType.GetFields, (a) -> match(a.Name));
      {$ENDIF}
      exit(new StructFieldImpl(lField), lField ≠ nil);
    end;

    method &In(i: Integer): &Type;
    begin
      if Kind ≠ reflect.Func then
        raise new Exception('Wrong type, it needs to be Func');
      {$IF ISLAND}
      var lMethod := fRealType.Methods.Where(a -> a.Name = 'Invoke').FirstOrDefault;
      var lParameters := lMethod.Arguments.ToList();
      if lParameters.Count ≤ i then
        raise new IndexOutOfRangeException('Index out of range');
      result := new TypeImpl(lParameters[i].Type);
      {$ELSEIF ECHOES}
      var lMethod := fRealType.GetMethod('Invoke');
      var lParameters := lMethod.GetParameters();
      if lParameters.Length ≤ i then
        raise new IndexOutOfRangeException('Index out of range');
      result := new TypeImpl(lParameters[i].ParameterType);
      {$ENDIF}
    end;

    method Key: &Type;
    begin
    end;

    method Len: Integer;
    begin
    end;

    method NumField: Integer;
    begin
      if Kind ≠ reflect.Struct then
        raise new Exception('Wrong type, it needs to be struct');
      {$IF ISLAND}
      result := fRealType.Fields.Count;
      {$ELSEIF ECHOES}
      result := fRealType.GetFields().Length;
      {$ENDIF}
    end;

    method NumIn: Integer;
    begin
      if Kind ≠ reflect.Func then
        raise new Exception('Wrong type, it needs to be Func');
      {$IF ISLAND}
      var lMethod := fRealType.Methods.Where(a -> a.Name = 'Invoke').FirstOrDefault;
      result := lMethod.Arguments.Count;
      {$ELSEIF ECHOES}
      var lMethod := fRealType.GetMethod('Invoke');
      result := lMethod.GetParameters().Length;
      {$ENDIF}
    end;

    method NumOut: Integer;
    begin
      if Kind ≠ reflect.Func then
        raise new Exception('Wrong type, it needs to be Func');
      {$IF ISLAND}
      var lMethod := fRealType.Methods.Where(a -> a.Name = 'Invoke').FirstOrDefault;
      result := lMethod.Arguments.Count;
      {$ELSEIF ECHOES}
      var lMethod := fRealType.GetMethod('Invoke');
      result := lMethod.ReturnType.GetFields.Length;
      {$ENDIF}
    end;

    method &Out(i: Integer): &Type;
    begin
      if Kind ≠ reflect.Func then
        raise new Exception('Wrong type, it needs to be Func');
      {$IF ISLAND}
      var lMethod := fRealType.Methods.Where(a -> a.Name = 'Invoke').FirstOrDefault;
      var lParameters := lMethod.Arguments.ToList();
      if lParameters.Count ≤ i then
        raise new IndexOutOfRangeException('Index out of range');
      result := new TypeImpl(lParameters[i].Type);
      {$ELSEIF ECHOES}
      var lMethod := fRealType.GetMethod('Invoke');
      var lParameters := lMethod.GetParameters;
      if lParameters.Length ≤ i then
        raise new IndexOutOfRangeException('Index out of range');
      result := new TypeImpl(lParameters[i].ParameterType);
      {$ENDIF}
    end;
  end;

  method DeepEqual(a, b: Object): Boolean;public;
  begin
    raise new NotImplementedException;
  end;

  Method &New(aType: &Type): Value;public;
  begin
    exit new Value(new builtin.Reference<Object>(Zero(aType)), aType);
  end;

  method Zero(aType: &Type): Value;public;
  begin
    {$IFDEF ISLAND}
    exit new Value(TypeImpl(aType).RealType.Instantiate());
    {$ELSE}
    exit new Value(Activator.CreateInstance(TypeImpl(aType).RealType));
    {$ENDIF}
  end;

  method PtrTo(t: &Type): &Type; public;
  begin
    raise new NotImplementedException;
  end;

  method ValueOf(i: Object): Value;public;
  begin
    exit new Value(i);
  end;

  method Indirect(v: Value): Value;public;
  begin
    exit new Value(new builtin.Reference<Object>(v.fValue), v.fType);
  end;

  method TypeOf(v: Object): &Type;public;
  begin
    {$IF ISLAND OR ECHOES}
    result := new TypeImpl(v.GetType());
    {$ENDIF}
  end;

  method Swapper(aslice: Object): Action<Integer, Integer>; public;
  begin
    exit new Action<Integer, Integer>(builtin.ISlice(aslice).Swap);
  end;

  method MakeMap(t: &Type): Value; public;
  begin
    raise new NotImplementedException;
  end;

  method Copy(dst: Value; src: Value): Integer;
  begin
    raise new NotImplementedException;
  end;

  method MakeSlice(t: &Type; len, cap: Integer): Value;
  begin
    raise new NotImplementedException;
  end;

  method MakeFunc(typ: &Type; fn: delegate(args: builtin.Slice<Value>): builtin.Slice<Value>): Value;
  begin
    raise new NotImplementedException;
  end;

end.
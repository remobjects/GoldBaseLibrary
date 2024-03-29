﻿namespace go.reflect;

{$IF ECHOES}
uses
  System.Reflection, System.Linq;
{$ENDIF}

type
  Kind = public type go.builtin.uint;
  ChanDir = public type go.builtin.int;
  PlatformEnumerator = {$IF ISLAND}IEnumerator<tuple of (go.reflect.Value, go.reflect.Value)>{$ELSEIF ECHOES}System.Collections.Generic.IEnumerator<tuple of (go.reflect.Value, go.reflect.Value)>{$ENDIF};

  SliceCtor = procedure(aInst: Object; aCount: Integer);
  SliceObjectCtor = procedure(aInst: Object; aObject: Object);

  ZeroFunction = method: Object;

  {$IF ISLAND}
  TEqualsMethod = public method(a: Object; b: Object): Boolean;
  {$ENDIF}

  SliceAlias = record
    VMT: IntPtr;
    aVal: Object;
  end;

  MemoryExt<T> = extension record(Memory<T>)
  public
    class method Get(aVal: Memory<T>): T;
    begin
      exit aVal^;
    end;
  end;

  [ValueTypeSemantics]
  MapIter = public class
  private
    fEnumerator: PlatformEnumerator;
  public
    constructor(aEnum: PlatformEnumerator);
    begin
      fEnumerator := aEnum;
    end;

    method Key: Value;
    begin
      result := fEnumerator.Current[0];
    end;

    method Value: Value;
    begin
      result := fEnumerator.Current[1];
    end;

    method Next: Boolean;
    begin
      result := fEnumerator.MoveNext;
    end;
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
  &Array: Kind = Kind(17);
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
  PlatformExtendedType = {$IF ISLAND}RemObjects.Elements.System.MemberInfo{$ELSEIF ECHOES}System.Reflection.MemberInfo{$ENDIF};

  ValueExtendedInfo = public (None, Slice);

  [ValueTypeSemantics]
  Value = public class
  private
  assembly
    fValue: Object;
    fType: &Type;
    fPtr: Object;
    fExtended: PlatformExtendedType; // basically for struct fields
    fExtendedInfo: ValueExtendedInfo;
    fExtendedObject: Object;
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
        if aValue ≠ nil then
          fType := TypeOf(aValue);
      fPtr := aValue;
    end;

    constructor(aValue: Object; aType: &Type; aPtr: Object; aExtendedInfo: PlatformExtendedType := nil);
    begin
      constructor(aValue, aType);
      fPtr := aPtr;
      fExtended := aExtendedInfo;
    end;

    constructor(aValue: Object; aValueExtendedInfo: ValueExtendedInfo; aExtendedPtr: Object; aExtendedObject: Object);
    begin
      constructor(aValue);
      fExtendedInfo := aValueExtendedInfo;
      fExtendedObject := aExtendedObject;
      fPtr := aExtendedPtr;
    end;

    class var fZero: Value := new Value();
    class property Zero: Value := fZero; published;

    method String: String;
    begin
      exit (if fValue is IMemory then IMemory(fValue).GetValue else fValue).ToString;
    end;

    method Int: Int64;
    begin
      var lValue := InternalGetValue;
      if lValue is IMemory then
        lValue := IMemory(lValue).GetValue;
      {$IFDEF ISLAND}
      exit RemObjects.Elements.System.Convert.ToInt64(lValue);
      {$ELSE}
      if lValue is IConvertible then
        exit System.Convert.ToInt64(lValue)
      else
        if lValue is System.IntPtr then
          exit System.IntPtr(lValue).ToInt64
        else
          raise new Exception("Can not convert value");
      {$ENDIF}
    end;

    method Uint: UInt64;
    begin
      var lValue := InternalGetValue;
      if lValue is IMemory then
        lValue := IMemory(lValue).GetValue;

      {$IFDEF ISLAND}
      exit RemObjects.Elements.System.Convert.ToUInt64(lValue);
      {$ELSE}
      if lValue is IConvertible then
        exit System.Convert.ToUInt64(lValue)
      else
        if lValue is System.UIntPtr then
          exit System.UIntPtr(lValue).ToUInt64
        else
          raise new Exception("Can not convert value");
      {$ENDIF}
    end;
    method Float: Double;
    begin
      exit {$IFDEF ISLAND}RemObjects.Elements.System.Convert{$ELSE}System.Convert{$ENDIF}.ToDouble(if fValue is IMemory then IMemory(fValue).GetValue else fValue);
    end;

    method IsNil: Boolean;
    begin
      case fType.Kind of
        Chan, Func, Map, go.reflect.Interface, UnsafePointer, __Global.Slice, go.reflect.Ptr: // missing &Interface Kind(20) --> &Interface
          exit (if fValue is IMemory then IMemory(fValue).GetValue else fValue) = nil;

        else
          raise new Exception('Wrong value type');
      end;
    end;

    method Complex: go.builtin.complex128;
    begin
      exit go.builtin.complex128(if fValue is IMemory then IMemory(fValue).GetValue else fValue);
    end;

    method Bool: Boolean;
    begin
      exit {$IFDEF ISLAND}RemObjects.Elements.System.Convert{$ELSE}System.Convert{$ENDIF}.ToBoolean(if fValue is IMemory then IMemory(fValue).GetValue else fValue);
    end;

    method Convert(aTo: &Type): Value;
    begin
      raise new NotImplementedException;
    end;

    method IsValid: Boolean;
    begin
      if fValue = nil then
        exit false;

      var lValue := if fValue is IMemory then IMemory(fValue).GetValue else fValue;
      result := lValue ≠ go.reflect.Zero(fType);
    end;

    method CanSet: Boolean;
    begin
      result := CanAddr;
    end;

    method Recv(): tuple of (Value, Boolean);
    begin
      raise new NotImplementedException();
    end;

    method MapIndex(key: Value): Value;
    begin
      if fType.Kind ≠ Map then
        raise new Exception('Wrong type, need a map');

      result := go.builtin.IMap(fValue).GetReflectValue(key);
    end;

    method MapIter: Memory<MapIter>;
    begin
      if fType.Kind ≠ Map then
        raise new Exception('Wrong type, need a map');

      var lIter := new MapIter(go.builtin.IMap(fValue).GetReflectSequence().GetEnumerator());
      result := new Memory<MapIter>(lIter);
    end;

    method MapKeys: go.builtin.Slice<Value>;
    begin
      if fType.Kind ≠ Map then
        raise new Exception('Wrong type, need a map');

      result := go.builtin.IMap(fValue).GetReflectKeys();
    end;

    method CanInterface(): Boolean;
    begin
      result := true;
      // TODO check, should be false for unexported struct fields or methods.
    end;

    method Slice(i, j: Integer): Value;
    begin
      case fType.Kind of
        go.reflect.Slice:
          exit go.builtin.ISlice(fValue).getReflectSlice(i, j);

        go.reflect.String: begin
          var lString := fValue as go.builtin.string;
          exit new Value(new go.builtin.Slice<Byte>(lString.Value, i, j-i));
        end;

        else
          raise new Exception('Wrong type, need a Map or String');
      end;
    end;

    method Slice3(i, j, k: Integer): Value;
    begin
      // TODO
    end;

    method &Method(i: Int64): Value;
    begin
      raise new NotImplementedException;
    end;

    method Pointer(): UInt64;
    begin
      var lValue := InternalGetValue;
      {$IF ISLAND}
      exit RemObjects.Elements.System.UInt64(InternalCalls.Cast(lValue));
      {$ELSEIF ECHOES}
      //exit System.Convert.ToUInt64(lValue);
      exit 0;
      {$ENDIF}
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

    method FieldByIndex(idx: go.builtin.Slice<Int64>): Value;
    begin
      raise new NotImplementedException;
    end;

    method SetCap(n: Integer);
    begin
      raise new NotImplementedException;
    end;

    method SetLen(n: Integer);
    begin
      var lKind := Kind;
      if (lKind <> &Array) and (lKind <> go.reflect.Slice) then
        raise new Exception("Wrong type, need array or slice");
      go.builtin.ISlice(fValue).setLen(n);
    end;

    method Cap: Integer;
    begin
      var lKind := Kind;
      if (lKind <> &Array) and (lKind <> go.reflect.Slice) then
        raise new Exception("Wrong type, need array or slice");

      exit go.builtin.ISlice(fValue).getCap;
    end;

    method &Set(aVal: Value);
    begin
      var lValue := aVal.fValue;

      if TypeImpl(aVal.fType).RealType <> TypeImpl(self.fType).RealType then
        if not CanSet or not fType.AssignableTo(TypeOf(lValue)) then
          raise new Exception('Can not set object');

      if fExtendedInfo = ValueExtendedInfo.Slice then begin
        go.builtin.ISlice(fPtr).setAtIndex(Integer(fExtendedObject), lValue);
      end
      else begin
        if fExtended <> nil then begin // struct field
          //(fExtended as FieldInfo).SetValue(go.builtin.IReference(fPtr).Get, lValue);
          if fPtr is IMemory then
            (fExtended as FieldInfo).SetValue(IMemory(fPtr).GetValue, lValue)
          else
            (fExtended as FieldInfo).SetValue(fPtr, lValue);
          fValue := lValue;
        end
        else begin
          //if fPtr is go.builtin.IReference then
            //go.builtin.IReference(fPtr).Set(lValue);
          if fPtr is IMemory then
            IMemory(fPtr).SetValue(lValue);
          fValue := lValue;
        end;
      end;
    end;

    method InternalSet(aValue: Object); private;
    begin
      if fExtendedInfo = ValueExtendedInfo.Slice then begin
        go.builtin.ISlice(fPtr).setAtIndex(Integer(fExtendedObject), aValue);
      end
      else begin
        if fExtended <> nil then begin // struct field
          //(fExtended as FieldInfo).SetValue(go.builtin.IReference(fPtr).Get, aValue);
          if fPtr is IMemory then
            (fExtended as FieldInfo).SetValue(IMemory(fPtr).GetValue, aValue)
          else
            (fExtended as FieldInfo).SetValue(fPtr, aValue);
        end
        else begin
          //go.builtin.IReference(fPtr).Set(aValue);
          IMemory(fPtr).SetValue(aValue);
          fValue := aValue;
        end;
      end;
    end;

    method SetBytes(aVal: go.builtin.Slice<Byte>);
    begin
      var lValue := fValue as go.builtin.Slice<Byte>;
      if lValue = nil then
        raise new Exception('Wrong type, need a Slice of bytes');

      lValue.Assign(aVal);
    end;

    method &SetInt(aVal: Int64);
    begin
      if (not CanSet) or not (Integer(Kind) in [Integer(go.reflect.Int)..Integer(go.reflect.Int64)])  then
        raise new Exception('Can not set object to integer value');

      {$IF ECHOES}
      if (aVal ≥ :go.math.MinInt32) and (aVal ≤ :go.math.MaxInt32) then // .net runtime fails if a Int64 value try to set in a Int32 field, even if fit.
        InternalSet(Integer(aVal))
      else
        InternalSet(aVal);
      {$ELSE}
      InternalSet(aVal);
      {$ENDIF}
    end;

    method &SetBool(aVal: Boolean);
    begin
      if (not CanSet) or (Kind ≠ go.reflect.Bool) then
        raise new Exception('Can not set object to bool value');

      InternalSet(aVal);
    end;

    method &SetUint(aVal: UInt64);
    begin
      if (not CanSet) or not (Integer(Kind) in [Integer(go.reflect.Uint)..Integer(go.reflect.Uint64)])  then
        raise new Exception('Can not set object to unsigned integer value');

      InternalSet(aVal);
    end;

    method &SetFloat(aVal: Double);
    begin
      if (not CanSet) or ((Kind ≠ go.reflect.Float32) and (Kind ≠ go.reflect.Float64)) then
        raise new Exception('Can not set object to float value');

      InternalSet(aVal);
    end;

    method &SetComplex(aVal: go.builtin.complex128);
    begin
      raise new NotImplementedException;
    end;

    method &SetString(aVal: go.builtin.string);
    begin
      if (not CanSet) or (Kind ≠ go.reflect.String) then
        raise new Exception('Can not set object to string value');

      InternalSet(aVal);
    end;

    method &Type: &Type;
    begin
      result := fType;
    end;

    method Bytes: go.builtin.Slice<Byte>;
    begin
      var lValue := InternalGetValue;
      if lValue is go.builtin.Slice<Byte> then
        exit lValue as go.builtin.Slice<Byte>
      else
        raise new Exception('Wrong type, need a Slice of bytes');
    end;

    method Kind: Kind;
    begin
      if fType = nil then
        result := go.reflect.Invalid
      else
        result := fType.Kind;
    end;

    method Len: Integer;
    begin
      var lKind := Kind();
      var lValue := InternalGetValue;

      case lKind of
        go.reflect.Slice:
          exit go.builtin.ISlice(lValue).getLen();

        go.reflect.Array:
          exit System.Array(lValue).Length;

        go.reflect.Map:
          exit go.builtin.IMap(lValue).GetLen();

        go.reflect.String:
          exit go.builtin.string(lValue).Length;

        go.reflect.Chan:
          exit go.builtin.IChannel(lValue).Length;

        else
          raise new Exception("Wrong type calling reflect.Len method");
      end;
    end;

    method InternalGetValue: Object; private;
    begin
      var lType := TypeImpl(fType).RealType;
      if lType.IsValueType then begin
        {$IF ECHOES}
        var lFieldValue := lType.GetField('Value');
        {$ELSE}
        var lFieldValue := lType.Fields.FirstOrDefault(a -> a.Name = 'Value');
        {$ENDIF}
        if lFieldValue = nil then
          exit fValue;
        var lValue: Object;
        if fExtended <> nil then begin
          //lValue := (fExtended as FieldInfo).GetValue(if fPtr is go.builtin.IReference then go.builtin.IReference(fPtr).Get else fPtr);
          lValue := (fExtended as FieldInfo).GetValue(if fPtr is IMemory then IMemory(fPtr).GetValue else fPtr);
        end
        else
          lValue := fValue;
        exit lFieldValue.GetValue(lValue);
      end
      else
        exit fValue;
    end;

    method &Index(i: Integer): Value;
    begin
      var lKind := Kind;
      if (lKind <> &Array) and (lKind <> go.reflect.Slice) and (lKind <> go.reflect.String) then
        raise new Exception("Wrong type, need array, slice or string");

      //var lValue := if fValue is Memory<Object> then Memory<Object>.Get(Memory<Object>(fValue)) else fValue;
      var lValue := InternalGetValue;
      // TODO need to create and return a reference here???
      case lKind of
        go.reflect.Slice:
          result := new Value(go.builtin.ISlice(lValue).getAtIndex(i), ValueExtendedInfo.Slice, lValue, i);

        go.reflect.Array:
          {$IF ISLAND}
          result := new Value(System.Array(lValue).Get(i));
          {$ELSEIF ECHOES}
          result := new Value(System.Array(lValue).GetValue(i));
          {$ENDIF}

        go.reflect.String:
          result := new Value(go.builtin.string(lValue)[i]);
      end;
    end;

    method SetMapIndex(key: Value; val: Value);
    begin
      if Kind ≠ go.reflect.Map then
        raise new Exception("Wrong type, need a map");

      go.builtin.IMap(fValue).SetReflectKeyValue(key, val);
    end;

    method NumField: Integer;
    begin
      result := fType.NumField;
    end;

    method NumMethod: Integer;
    begin
      result := fType.NumMethod;
    end;

    method Field(i: Integer): Value;
    begin
      {$IF ISLAND}
      var lFields := TypeImpl(fType).fTrueType.Fields.ToArray();
      var lValue := InternalGetValue;
      result := new Value(lFields[i].GetValue(lValue), new TypeImpl(lFields[i].Type), new Memory<Object>(lValue), lFields[i]);
      {$ELSEIF ECHOES}
      var lFields := System.Reflection.TypeInfo(TypeImpl(fType).fTrueType).DeclaredFields.ToArray();
      var lValue := InternalGetValue;
      result := new Value(lFields[i].GetValue(lValue), new TypeImpl(lFields[i].FieldType), new Memory<Object>(lValue), lFields[i]);
      {$ENDIF}
    end;

    method FieldByName(name: String): tuple of (StructField, Boolean);
    begin
      var lField: &PlatformField;
      {$IF ISLAND}
      lField := TypeImpl(fType).fTrueType.Fields.Where(a->a.Name = name).FirstOrDefault;
      {$ELSEIF ECHOES}
      lField := System.Reflection.TypeInfo(TypeImpl(fType).fTrueType).DeclaredFields.Where(a->a.Name = name).FirstOrDefault;
      {$ENDIF}
      if lField ≠ nil then
        exit(new StructFieldImpl(lField), true)
      else
        exit(nil, false);
    end;

    /*method FieldByName(name: go.builtin.string): Value;
    begin
      raise new NotImplementedException;
    end;*/

    method CanAddr: Boolean;
    begin
      result := true;
      // TODO check when returns false
      //raise new NotImplementedException;
    end;

    method Call(inn: go.builtin.Slice<Value>): go.builtin.Slice<Value>;
    begin
      raise new NotImplementedException;
    end;

    method Addr: Value;
    begin
      result := new Memory<Value>(fValue);
    end;

    method MapRange() :Memory<MapIter>;
    begin
      if fType.Kind ≠ Map then
        raise new Exception('Wrong type, need a map');

      var lIter := new MapIter(go.builtin.IMap(fValue).GetReflectSequence().GetEnumerator());
      result := new Memory<MapIter>(lIter);
    end;

    method &Interface: Object;
    begin
      exit fValue;
    end;

    method Elem: Value;
    begin
      if fValue is IMemory then begin
        var lType := TypeImpl(fType).RealType;
        var lRealType: PlatformType;
        {$IF ISLAND}
        lRealType := lType.GenericArguments.FirstOrDefault;
        {$ELSEIF ECHOES}
        lRealType := lType.GenericTypeArguments[0];
        {$ENDIF}
        //exit new Value(go.builtin.IReference(fValue).Get, new TypeImpl(lRealType), fValue);
        exit new Value(IMemory(fValue).GetValue, new TypeImpl(lRealType), fValue);
      end;
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
    method FieldByIndex(i: go.builtin.Slice<Int64>): StructField;
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

    constructor(aValue: String);
    begin
      Value := aValue;
    end;

    method Get(key: String): String;
    begin
      var lResult := Lookup(key);
      result := lResult[0];
    end;

    method Lookup(key: String): tuple of (String, Boolean);
    begin
      var lPos := Value.IndexOf(key + ':');
      if lPos ≥ 0 then begin
        var lResult := Value.Substring(lPos + key.Length + 1).Trim(['"', '''', ' ']);
        exit (lResult, true);
      end
      else
        result := ('', false);
    end;
  end;

  StructField = public interface
    method IsValid: Boolean;
    method &Interface: Object;
    property Name: String read;
    property PkgPath: String read;
    property &Type: &Type read;
    property Tag: StructTag read;
    property Offset: UIntPtr read;
    property &Index: go.builtin.Slice<Int64> read;
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
      PkgPath := '';
      var lTag := '';
      if aField ≠ nil then begin
        {$IF ISLAND}
        var lAttrs := aField.Attributes.Where(b->b.Type = TypeOf(go.builtin.TagAttribute)).ToList;
        if (lAttrs ≠ nil) and (lAttrs.Count > 0) then
          lTag := go.builtin.PlatformString(lAttrs[0].Arguments[0].Value);
        {$ELSEIF ECHOES}
        var lAttrs := aField.GetCustomAttributes(true);
        if lAttrs.Length > 0 then begin
          if lAttrs[0] is go.builtin.TagAttribute then
            lTag := (lAttrs[0] as go.builtin.TagAttribute).Tag;
        end;
        {$ENDIF}
      end;
      Tag := new StructTag(lTag);
      &Index := new go.builtin.Slice<Int64>(1);
    end;

    constructor(aField: PlatformField; aIndex: Integer);
    begin
      constructor(aField);
      &Index[0] := aIndex;
    end;

    method IsValid: Boolean;
    begin
      result := (fField ≠ nil) and (fField.Name ≠ '');
    end;

    method &Interface: Object;
    begin
      result := self;
    end;

    property Name: String read fField.Name;
    property PkgPath: String read;
    property &Type: &Type read {$IF ISLAND}new TypeImpl(fField.&Type){$ELSEIF ECHOES}new TypeImpl(fField.FieldType){$ENDIF};
    property Tag: StructTag read;
    property Offset: UIntPtr read;
    property &Index: go.builtin.Slice<Int64> read;
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
  TypeImpl = public class(&Type)
  private
  assembly
    fRealType: PlatformType;
    fTrueType: PlatformType; // used for ValueType

    method IsInteger: Boolean;
    begin
      var lKind := self.Kind;
      result := (Integer(lKind) ≥ Integer(go.reflect.Bool)) and (Integer(lKind) ≤ Integer(go.reflect.Uint64));
    end;

    method IsFloatOrComplex: Boolean;
    begin
      var lKind := self.Kind;
      result := (Integer(lKind) ≥ Integer(go.reflect.Float32)) and (Integer(lKind) ≤ Integer(go.reflect.Complex128));
    end;

  public

    property RealType: PlatformType read fRealType;

    constructor(aType: PlatformType);
    begin
      fRealType := aType;
      {$IF ISLAND}
      var lCtors := fRealType.Methods.Where(a -> (MethodFlags.Constructor in a.Flags)).ToArray;
      var lFields := fRealType.Fields.ToArray;
      if fRealType.IsValueType and (lCtors.Count = 2) and (lFields.Count = 1) then
        fTrueType := lFields[0].Type
      else
        fTrueType := fRealType;
      {$ELSEIF ECHOES}
      if fRealType.IsValueType and (fRealType.GetConstructors().Count = 2) and (fRealType.GetFields().Count = 1) then
        fTrueType := fRealType.GetFields()[0].FieldType
      else
        fTrueType := fRealType;
      {$ENDIF}
    end;

    method Align: Integer;
    begin
      raise new NotImplementedException;
    end;

    method FieldAlign: Integer;
    begin
      raise new NotImplementedException;
    end;

    method &Method(i: Integer): &Method;
    begin
      if (i < 0) or (i ≥ NumMethod) then
        raise new Exception('Wrong method index');

      {$IF ISLAND}
      result := new MethodImpl(fTrueType.Methods.ToList[i]);
      {$ELSEIF ECHOES}
      result := new MethodImpl(fTrueType.GetMethods[i]);
      {$ENDIF}
    end;

    method MethodByName(s: String): tuple of (&Method, Boolean);
    begin
      var lMethod: &PlatformMethod;
      {$IF ISLAND}
      lMethod := fTrueType.Methods.Where(a->a.Name = s).FirstOrDefault;
      {$ELSEIF ECHOES}
      lMethod := System.Array.Find(fTrueType.GetMethods, a->a.Name = s);
      {$ENDIF}
      exit(new MethodImpl(lMethod), lMethod ≠ nil);
    end;

    method NumMethod: Integer;
    begin
      {$IF ISLAND}
      if Kind = go.reflect.Interface then
        exit 0
      else
        result := fTrueType.Methods.Count;
      {$ELSEIF ECHOES}
      // TODO!! do this in a better way
      if Kind = go.reflect.Interface then
        exit 0
      else
        result := fTrueType.GetMethods.Length;
      {$ENDIF}
    end;

    method Name: String;
    begin
      result := fRealType.Name;
    end;

    method PkgPath: String;
    begin
      raise new NotImplementedException;
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
      result := fRealType.Name;
    end;

    method Kind: Kind;
    begin
      if fTrueType = nil then
        exit go.reflect.Invalid;
      {$IF ISLAND}
      if (fTrueType = TypeOf(go.builtin.string)) and not ((fTrueType.Flags and IslandTypeFlags.TypeKindMask) = IslandTypeFlags.Array) then
        exit go.reflect.String;

      if fTrueType.IsDelegate then
        exit go.reflect.Func;

      if fTrueType.Name.StartsWith('gt2_@') then begin
      //if (fTrueType.Flags and IslandTypeFlags.TypeKindMask) = IslandTypeFlags.Array  then begin
        exit go.reflect.Array;
      end;

      if (fTrueType.GenericArguments <> nil) and (fTrueType.GenericArguments.Count > 0) then begin
        if fTrueType.Name.Contains('go.builtin.Slice') then
          exit go.reflect.Slice;

        if fTrueType.Name.Contains('go.builtin.BidirectionalChannel') then
          exit go.reflect.Map
        else
          exit go.reflect.Ptr;
      end;

      if fTrueType = TypeOf(Object) then
        exit go.reflect.Interface;

      case fTrueType.Code of
        TypeCodes.Boolean: result := go.reflect.Bool;
        TypeCodes.Char: result := go.reflect.Uint16;
        TypeCodes.SByte: result := go.reflect.Int8;
        TypeCodes.Byte: result := go.reflect.UInt8;
        TypeCodes.Int16: result := go.reflect.Int16;
        TypeCodes.UInt16: result := go.reflect.Uint16;
        TypeCodes.Int32: result := go.reflect.Int32;
        TypeCodes.UInt32: result := go.reflect.Uint32;
        TypeCodes.Int64: result := go.reflect.Int64;
        TypeCodes.UInt64: result := go.reflect.Uint64;
        TypeCodes.Single: result := go.reflect.Float32;
        TypeCodes.Double: result := go.reflect.Float64;
        TypeCodes.UIntPtr: result := go.reflect.UintPtr;
        TypeCodes.IntPtr: result := go.reflect.Ptr;
        TypeCodes.String: result := go.reflect.String;
        TypeCodes.Object: result := go.reflect.Struct;
        TypeCodes.None: begin
          case (fTrueType.Flags and IslandTypeFlags.TypeKindMask) of
            IslandTypeFlags.Array: exit go.reflect.Array;
            IslandTypeFlags.Struct: exit go.reflect.Struct;
            IslandTypeFlags.Interface: exit go.reflect.Interface;
            IslandTypeFlags.Generic: exit go.reflect.Ptr;
            default: exit go.reflect.Struct;
          end;
        end;
      end;
      {$ELSEIF ECHOES}
      if (fTrueType = TypeOf(go.builtin.string)) and (not fTrueType.IsArray) then
        exit go.reflect.String;

      if fTrueType.IsArray then
        exit go.reflect.Array;

      if fTrueType.IsInterface then
        exit go.reflect.Interface;

      if fTrueType.BaseType = TypeOf(System.MulticastDelegate) then
        exit go.reflect.Func;

      if fTrueType.GenericTypeArguments.Length > 0 then
        if fTrueType.AssemblyQualifiedName.StartsWith('go.builtin.Slice') then
          exit go.reflect.Slice
        else
          if fTrueType.AssemblyQualifiedName.StartsWith('go.builtin.BidirectionalChannel') then
            exit go.reflect.Map
          else
            exit go.reflect.Ptr;

      if fTrueType = TypeOf(System.Object) then
        exit go.reflect.Interface;

      if fTrueType = TypeOf(System.UIntPtr) then
        exit go.reflect.Uintptr;

      case System.Type.GetTypeCode(fTrueType) of
        TypeCode.Boolean: result := go.reflect.Bool;
        TypeCode.Byte: result := go.reflect.UInt8;
        TypeCode.SByte: result := go.reflect.Int8;
        TypeCode.Int16: result := go.reflect.Int16;
        TypeCode.UInt16: result := go.reflect.Uint16;
        TypeCode.Int32: result := go.reflect.Int32;
        TypeCode.UInt32: result := go.reflect.Uint32;
        TypeCode.Int64: result := go.reflect.Int64;
        TypeCode.UInt64: result := go.reflect.Uint64;
        TypeCode.Single: result := go.reflect.Float32;
        TypeCode.Double: result := go.reflect.Float64;
        TypeCode.String: result := go.reflect.String;
        TypeCode.Char: result := go.reflect.Uint16;
        TypeCode.Object:
        begin
          // check ValueType
          var lTrueType: PlatformType;
          if fRealType.IsValueType {and (fRealType.GetConstructors().Count = 2)} and (fRealType.GetFields().Count = 1) then
            lTrueType := fRealType.GetFields()[0].FieldType
          else
            exit go.reflect.Struct;
          exit new &TypeImpl(lTrueType).Kind;
        end;
        TypeCode.Empty: result := go.reflect.Invalid;
      end;
      {$ENDIF}
    end;

    method Implements(u: &Type): Boolean;
    begin
      result := fRealType.IsSubclassOf(TypeImpl(u).fRealType);
    end;

    method AssignableTo(u: &Type): Boolean;
    begin
      if u = nil then
        raise new Exception('nil type in AssignableTo');

      if Kind = go.reflect.interface then
        result := true
      else
        result := TypeImpl(u).fRealType.IsAssignableFrom(self.fRealType);
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

      var lUKind := u.Kind;
      if (IsInteger or (Kind = go.reflect.String) or (Kind = go.reflect.Slice)) and (lUKind = go.reflect.String) then
        exit(true);

      if (Kind = go.reflect.String) and (TypeImpl(u).IsInteger or (lUKind = go.reflect.String) or (lUKind = go.reflect.Slice)) then
        exit(true);

      exit(false);
    end;

    method Comparable: Boolean;
    begin
      result := Kind <> go.reflect.Func;
    end;

    method Bits: Integer;
    begin
      if IsInteger or IsFloatOrComplex then
        result := sizeOf(fTrueType) * 8 // size in bits...
      else
        raise new Exception("Wrong type calling Bits method");
    end;

    method ChanDir: ChanDir;
    begin
      raise new NotImplementedException;
    end;

    method IsVariadic: Boolean;
    begin
      raise new NotImplementedException;
    end;

    method Elem: &Type;
    begin
      //if IsMemoryType(fTrueType) then begin
      var lKind := Kind;
      if (lKind = go.reflect.ptr) or (lKind = go.reflect.slice) or (lKind = go.reflect.chan) then begin
        var lRealType: PlatformType;
        {$IF ISLAND}
        lRealType := fTrueType.GenericArguments.FirstOrDefault;
        {$ELSEIF ECHOES}
        lRealType := fTrueType.GenericTypeArguments[0];
        {$ENDIF}
        exit new TypeImpl(lRealType);
      end;
    end;

    method Field(i: Integer): StructField;
    begin
      if Kind ≠ go.reflect.Struct then
        raise new Exception('Wrong type, it needs to be struct');
      {$IF ISLAND}
      var lFields := fTrueType.Fields.ToList();
      if i ≥ lFields.Count then
        raise new IndexOutOfRangeException('Index out of range');
      {$ELSEIF ECHOES}
      var lFields := System.Reflection.TypeInfo(fTrueType).DeclaredFields.ToArray();
      if i ≥ lFields.Length then
        raise new IndexOutOfRangeException('Index out of range');
      {$ENDIF}
      result := new StructFieldImpl(lFields[i], i);
    end;

    method FieldByIndex(i: go.builtin.Slice<Int64>): StructField;
    begin
      if Kind ≠ go.reflect.Struct then
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
      lField := fTrueType.Fields.Where(a->a.Name = aname).FirstOrDefault;
      {$ELSEIF ECHOES}
      lField := System.Reflection.TypeInfo(fTrueType).DeclaredFields.Where(a->a.Name = aname).FirstOrDefault;
      {$ENDIF}
      // TODO field index
      exit(new StructFieldImpl(lField), lField ≠ nil);
    end;

    method FieldByNameFunc(match: delegate(aName: String): Boolean): tuple of (StructField, Boolean);
    begin
      var lField: &PlatformField;
      {$IF ISLAND}
      lField := fTrueType.Fields.Where(a -> match(a.Name)).FirstOrDefault;
      {$ELSEIF ECHOES}
      lField := TypeInfo(fTrueType).DeclaredFields.Where((a) -> match(a.Name)).FirstOrDefault;
      {$ENDIF}
      // TODO field index
      exit(new StructFieldImpl(lField), lField ≠ nil);
    end;

    method &In(i: Integer): &Type;
    begin
      if Kind ≠ go.reflect.Func then
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
      raise new NotImplementedException;
    end;

    method Len: Integer;
    begin
      raise new NotImplementedException;
    end;

    method NumField: Integer;
    begin
      if Kind ≠ go.reflect.Struct then
        raise new Exception('Wrong type, it needs to be struct');
      {$IF ISLAND}
      result := fTrueType.Fields.Count;
      {$ELSEIF ECHOES}
      result := System.Reflection.TypeInfo(fTrueType).DeclaredFields.ToArray().Length;
      {$ENDIF}
    end;

    method NumIn: Integer;
    begin
      if Kind ≠ go.reflect.Func then
        raise new Exception('Wrong type, it needs to be Func');
      {$IF ISLAND}
      var lMethod := fTrueType.Methods.Where(a -> a.Name = 'Invoke').FirstOrDefault;
      result := lMethod.Arguments.Count;
      {$ELSEIF ECHOES}
      var lMethod := fTrueType.GetMethod('Invoke');
      result := lMethod.GetParameters().Length;
      {$ENDIF}
    end;

    method NumOut: Integer;
    begin
      if Kind ≠ go.reflect.Func then
        raise new Exception('Wrong type, it needs to be Func');
      {$IF ISLAND}
      var lMethod := fTrueType.Methods.Where(a -> a.Name = 'Invoke').FirstOrDefault;
      if lMethod.Type.GenericArguments.Count > 0 then
        result := lMethod.Type.Fields.Count
      else
        result := 1;
      {$ELSEIF ECHOES}
      var lMethod := fTrueType.GetMethod('Invoke');
      if System.Reflection.TypeInfo(lMethod.ReturnType).IsGenericType and (System.Reflection.TypeInfo(lMethod.ReturnType).FullName.StartsWith('System.Tuple')) then
        result := System.Reflection.TypeInfo(lMethod.ReturnType).DeclaredFields.ToArray().Length
      else
        result := 1;
      {$ENDIF}
    end;

    method &Out(i: Integer): &Type;
    begin
      if Kind ≠ go.reflect.Func then
        raise new Exception('Wrong type, it needs to be Func');
      {$IF ISLAND}
      var lMethod := fTrueType.Methods.Where(a -> a.Name = 'Invoke').FirstOrDefault;
      var lParameters := lMethod.Type.Fields.ToList();
      if lParameters.Count ≤ i then
        raise new IndexOutOfRangeException('Index out of range');
      result := new TypeImpl(lParameters[i].Type);
      {$ELSEIF ECHOES}
      var lMethod := fTrueType.GetMethod('Invoke');
      var lTotal := 1;
      if System.Reflection.TypeInfo(lMethod.ReturnType).IsGenericType and (System.Reflection.TypeInfo(lMethod.ReturnType).FullName.StartsWith('System.Tuple')) then
        lTotal := System.Reflection.TypeInfo(lMethod.ReturnType).DeclaredFields.ToArray().Length;

      if lTotal < i then
        raise new IndexOutOfRangeException('Index out of range');

      if lTotal > 1 then
        result := new TypeImpl(System.Reflection.TypeInfo(lMethod.ReturnType).DeclaredFields.ToArray()[i].FieldType)
      else
        result := new TypeImpl(System.Reflection.TypeInfo(lMethod.ReturnType));
      {$ENDIF}
    end;
  end;

  method DeepEqual(a, b: Object): Boolean; public;
  begin
    var lAType := TypeOf(a);
    var lBType := TypeOf(b);

    if (lAType = lBType) and (lAType.Kind = go.reflect.Struct) then begin
      {$IF ISLAND}
      var lAFields := TypeImpl(lAType).fTrueType.Fields.ToArray();
      var lBFields := TypeImpl(lBType).fTrueType.Fields.ToArray();
      {$ELSEIF ECHOES}
      var lAFields := System.Reflection.TypeInfo(TypeImpl(lAType).fTrueType).DeclaredFields.ToArray();
      var lBFields := System.Reflection.TypeInfo(TypeImpl(lBType).fTrueType).DeclaredFields.ToArray();
      {$ENDIF}
      if lAFields.Length ≠ lBFields.Length then
        exit false;
      for i: Integer := 0 to lAFields.Length - 1 do begin
        var lAValue := lAFields[i].GetValue(a);
        var lBValue := lBFields[i].GetValue(b);
        result := DeepEqual(lAValue, lBValue);
        if not result then
          exit;
      end;
    end
    else begin
      var lRealAType := TypeImpl(lAType).fTrueType;
      {$IF ISLAND}
      var lMethod := lRealAType.Methods.Where(m -> m.Name = 'op_Equality').FirstOrDefault;
      if lMethod ≠ nil then begin
        //result := lMethod.Invoke(lRealAType, [a, b]) as Boolean
        var lCaller := TEqualsMethod(lMethod.Pointer);
        result := lCaller(a, b);
      end
      else
        result := a.Equals(b);
      {$ELSEIF ECHOES}
      var lMethod := System.Array.Find(lRealAType.GetMethods, m -> m.Name = 'op_Equality');
      if lMethod ≠ nil then
        result := lMethod.Invoke(lRealAType, [a, b]) as Boolean
      else
        result := Object.Equals(a, b);
      {$ENDIF}
    end;
  end;

  Method &New(aType: &Type): Value;public;
  begin
    exit new Value(new Memory<Object>(Zero(aType)), aType);
  end;

  method Zero(aType: &Type): Value;public;
  begin
    {$IFDEF ISLAND}
    if aType.Kind = go.reflect.string then
      exit new Value(go.builtin.string.Zero);

    var lZero := TypeImpl(aType).fRealType.Properties.Where(a->a.Name = 'Zero').FirstOrDefault;
    if lZero <> nil then
      exit new Value(ZeroFunction(lZero.Read.Pointer)());

    if not TypeImpl(aType).RealType.IsValueType and (TypeImpl(aType).RealType.Methods.Any(a -> a.Name = '__Set')) then
      exit new Value(TypeImpl(aType).RealType.Instantiate())
    else begin
      if TypeImpl(aType).fRealType.IsValueType then
        exit new Value(InternalCalls.Cast<Object>(DefaultGC.New(TypeImpl(aType).RealType.RTTI, sizeOf(^Void) + TypeImpl(aType).RealType.SizeOfType)))
      else
        exit new Value(nil);
    end;
    {$ELSE}
    if TypeImpl(aType).fRealType = System.Type.GetType('go.builtin.string') then
      exit new Value(go.builtin.string.Zero) // String .net does not have a constructor with no arguments.
    else begin
      var lZero := TypeImpl(aType).fRealType.GetProperty('Zero');
      if lZero <> nil then
        exit new Value(lZero.GetValue(nil));
    end;

    if not TypeImpl(aType).RealType.IsValueType and (TypeImpl(aType).RealType.GetMethods.Any(a -> a.Name = '__Set')) then
      exit new Value(Activator.CreateInstance(TypeImpl(aType).RealType))
    else
      if TypeImpl(aType).fRealType.IsValueType then
        exit new Value(Activator.CreateInstance(TypeImpl(aType).fRealType))
      else
        exit new Value(nil);
    {$ENDIF}
  end;

  method PtrTo(t: &Type): Memory<&Type>; public;
  begin
    result := new Memory<&Type>(t);
  end;

  method ValueOf(i: Object): Value;public;
  begin
    exit new Value(i);
  end;

  method Indirect(v: Value): Value;public;
  begin
    exit new Value(new Memory<Object>(v.fValue), v.fType);
  end;

  method TypeOf(v: Object): &Type;public;
  begin
    result := new TypeImpl(v.GetType());
  end;

  method Swapper(aslice: Object): delegate(arg0: go.builtin.int; arg1: go.builtin.int); public;
  begin
    exit @go.sort.Interface(aslice).Swap;
  end;

  method MakeMap(t: &Type): Value; public;
  begin
    raise new NotImplementedException;
  end;

  method MakeMapWithSize(t: &Type;n: Integer): Value; public;
  begin
    raise new NotImplementedException;
  end;

  method InternalGetValue(aVal: Value): Object;
  begin
    var lType := TypeImpl(aVal.fType).RealType;
    if lType.IsValueType then begin
      {$IF ECHOES}
      var lFieldValue := lType.GetField('Value');
      {$ELSE}
      var lFieldValue := lType.Fields.FirstOrDefault(a -> a.Name = 'Value');
      {$ENDIF}
      var lValue: Object;
      if aVal.fExtended <> nil then begin
        //lValue := (aVal.fExtended as FieldInfo).GetValue(if aVal.fPtr is go.builtin.IReference then go.builtin.IReference(aVal.fPtr).Get else aVal.fPtr);
        lValue := (aVal.fExtended as FieldInfo).GetValue(if aVal.fPtr is IMemory then IMemory(aVal.fPtr).GetValue else aVal.fPtr);
      end
      else
        lValue := aVal.fValue;
      exit lFieldValue.GetValue(lValue);
    end
    else
      exit aVal.fValue;
  end;

  method Copy(dst: Value; src: Value): Integer;
  begin
    var lDstKind := dst.Kind;
    var lSrcKind := src.Kind;
    if not (((lDstKind = go.reflect.Slice) and (lSrcKind = go.reflect.Slice)) or ((lDstKind = go.reflect.Array) and (lSrcKind = go.reflect.Array))
      or ((lDstKind = go.reflect.Slice) and (lSrcKind = go.reflect.String))) then
        raise new Exception("Wrong type on reflect.copy method");

    var lDst: go.builtin.ISlice;
    if dst.fExtendedInfo = ValueExtendedInfo.Slice then begin
      var lTmp := go.builtin.ISlice(dst.fPtr).getAtIndex(Integer(dst.fExtendedObject));
      lDst := go.builtin.ISlice(InternalGetValue(new Value(lTmp)));
    end
    else
      lDst := go.builtin.ISlice(InternalGetValue(dst));
    var lSrc := go.builtin.ISlice(InternalGetValue(src));

    result := Math.Min(if lSrc = nil then 0 else lSrc.getLen, if lDst = nil then 0 else lDst.getLen);
    for i: Integer := 0 to result -1 do
      lDst.setAtIndex(i, lSrc.getAtIndex(i));
  end;

  method InstantiateSlice(aType: PlatformType; aCount: Integer): Object; private;
  begin
    {$IF ISLAND}
    if aType.IsValueType then begin
      var lCtors := aType.Methods.Where(a -> (MethodFlags.Constructor in a.Flags)).ToArray;
      var lFields := aType.Fields.ToArray;
      if (lCtors.Count = 2) and (lFields.Count = 1) then begin
        //var lCtorType: MethodInfo := aType.Methods.where(a -> (MethodFlags.Constructor in a.Flags) and (a.Arguments.Count = 1) and (a.Arguments.ToArray[0].Type = lFields[0].Type)).FirstOrDefault;
        var lNewType := DefaultGC.New(aType.RTTI, aType.SizeOfType);
        result := InternalCalls.Cast<Object>(lNewType);
        ^SliceAlias(lNewType)^.aVal := InstantiateSlice(lFields[0].Type, aCount);
        exit;
      end;
    end;

    var lCtor: MethodInfo := aType.Methods.FirstOrDefault(a -> (MethodFlags.Constructor in a.Flags) and (a.Arguments.Count = 1) and (a.Arguments.ToArray[0].Type.IsInteger));
    var lRealCtor := SliceCtor(lCtor.Pointer);
    var lNew := DefaultGC.New(aType.RTTI, aType.SizeOfType);
    result := InternalCalls.Cast<Object>(lNew);
    lRealCtor(result, aCount);
    {$ELSEIF ECHOES}
    if aType.IsValueType and (aType.GetConstructors().Count = 2) and (aType.GetFields().Count = 1) then begin
      exit Activator.CreateInstance(aType, [InstantiateSlice(aType.GetFields()[0].FieldType, aCount)]);
    end;
    exit Activator.CreateInstance(aType, [aCount]);
    {$ENDIF}
  end;

  method MakeSlice(t: &Type; len, cap: Integer): Value;
  begin
    result := new Value(InstantiateSlice(TypeImpl(t).fRealType, cap), new TypeImpl(TypeImpl(t).fRealType));
  end;

  method MakeFunc(typ: &Type; fn: delegate(args: go.builtin.Slice<Value>): go.builtin.Slice<Value>): Value;
  begin
    raise new NotImplementedException;
  end;

  operator Equal(a, b: &Type): Boolean; public;
  begin
    if (a is TypeImpl) and (b is TypeImpl) then exit (TypeImpl(a).fRealType = TypeImpl(b).fRealType);
    exit Object.ReferenceEquals(a, b);
  end;

  operator NotEqual(a, b: &Type): Boolean;public;
  begin
    exit not (a = b);
  end;

  operator Equal(a: &Type; b: TypeImpl): Boolean;public;
  begin
    if not assigned(a) and not assigned(b) then
      exit true;

    if not assigned(a) or not assigned(b) then
      exit false;

    if (a is TypeImpl) then exit (TypeImpl(a).fRealType = b.fRealType);
    exit Object.ReferenceEquals(a, b);
  end;

  operator Equal(a: TypeImpl; b: &Type): Boolean;public;
  begin
    if (b is TypeImpl) then exit (a.fRealType = TypeImpl(b).fRealType);
    exit Object.ReferenceEquals(a, b);
  end;

  operator Equal(a: TypeImpl; b: TypeImpl): Boolean;public;
  begin
    exit (a.fRealType = b.fRealType);
    exit Object.ReferenceEquals(a, b);
  end;

  method Append(s: Value; params x: array of Value): Value;
  begin
    var lSlice := go.builtin.ISlice(s.fValue);
    var lNewValue: go.reflect.Value;
    for each lValue in x do
      lNewValue := lSlice.AppendObject(lValue.fValue);

    exit lNewValue;
  end;

  method Append(s: Value; x: go.builtin.Slice<Value>): Value;
  begin
    raise new NotImplementedException;
  end;

  method AppendSlice(s: Value; x: Value): Value;
  begin
    raise new NotImplementedException;
  end;

  method SliceOf(t: &Type): &Type;
  begin
    raise new NotImplementedException;
  end;

  method NewAt(t: &Type; p: go.unsafe.Pointer): Value;
  begin
    raise new NotImplementedException;
  end;

  method IsMemoryType(aType: PlatformType): Boolean; assembly;
  begin
    {$IF ECHOES}
    if aType.FullName.StartsWith('RemObjects.Elements.System.Memory') then
      exit true;
    {$ELSE}
    if aType.Name.StartsWith('RemObjects.Elements.System.Memory`1') then
      exit true;
    {$ENDIF}
    result := false;
  end;

end.
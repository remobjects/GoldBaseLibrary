﻿namespace go.builtin;

uses
  go.builtin
{$IFDEF ECHOES}  , System.Linq, System.Collections, System.Collections.Generic{$ENDIF}

  ;

type
  [AttributeUsage(AttributeTargets.Assembly, AllowMultiple := true)]
  PackageNameAttribute = public class(Attribute)
  public
    constructor(aNamespace, aName: System.String);
    begin
      &Namespace := aNamespace;
      Name := aName;
    end;

    property Name: System.String; readonly;
    property &Namespace: System.String; readonly;
  end;


  VTCheck<V> = class
  public
    class var IsVT := false; readonly;

    class constructor;
    begin
      var lType := typeOf(V);
      {$IFDEF ISLAND}
      if not lType.IsValueType and (lType.Methods.Any(a -> a.Name = '__Set')) then
        IsVT := true;
      {$ELSE}
      if not lType.IsValueType and (lType.GetMethods.Any(a -> a.Name = '__Set')) then
        IsVT := true;
      {$ENDIF}
    end;
  end;

  CloneHelper<T> = class
    {$IF ISLAND}
    class var CloneMethod: MethodInfo := typeOf(T).Methods.FirstOrDefault(a -> a.Name = '__Clone'); readonly;
    {$ELSE}
    class var CloneMethod: System.Reflection.MethodInfo := typeOf(T).GetMethods.FirstOrDefault(a -> a.Name = '__Clone'); readonly;
    {$ENDIF}
  end;

  IMap = public interface
    method GetReflectSequence: sequence of tuple of(go.reflect.Value, go.reflect.Value);
    method GetReflectValue(aKey: go.reflect.Value): go.reflect.Value;
    method GetReflectKeys: Slice<go.reflect.Value>;
    method SetReflectKeyValue(aKey: go.reflect.Value; aValue: go.reflect.Value);
    method GetLen: Integer;
  end;

  [ValueTypeSemantics]
  Map<K, V> = public class(IMap)
  private
  {$IFDEF ECHOES}
    fDict: System.Collections.Generic.Dictionary<K, V> := new System.Collections.Generic.Dictionary<K, V>;
  {$ELSEIF ISLAND}
    fDict: Dictionary<K, V> := new Dictionary<K, V>;
  {$ELSE}
  {$ERROR NOT SUPPORTED}
  {$ENDIF}

    method set_Item(aItem: K; aVal: V);
    begin
      fDict[aItem] := aVal;
    end;

  public
    method __Set(v: Object);
    begin
      if (v <> nil) and (v <> self) then begin
        fDict.Clear();
        for each el in Map<K, V>(v):fDict do
          fDict.Add(el.Key, el.Value);
      end;
    end;

    constructor(aArgs: array of tuple of (K, V));
    begin
      for each el in aArgs do
        fDict[el[0]] := el[1];
    end;

    constructor(aCap: Integer);
    begin
      //fDict.Capacity := aCap;
    end;

    constructor(aCap: go.builtin.int);
    begin
      //fDict.Capacity := aCap;
    end;

    constructor();
    begin
    end;
    {$IFDEF ECHOES}
    class operator implicit(aVal:  System.Collections.Generic.Dictionary<K, V>): Map<K, V>;
    begin
      result := new Map<K, V>;
      for each el in aVal do
        result.fDict.Add(el.Key, el.Value);
    end;

    class operator implicit(aVal: Map<K, V>):  System.Collections.Generic.Dictionary<K, V>;
    begin
      result := new System.Collections.Generic.Dictionary<K, V>;

      for each el in aVal.fDict do
        result.Add(el.Key, el.Value);
    end;
    {$ELSEIF ISLAND}
    class operator implicit(aVal:  Dictionary<K, V>): Map<K, V>;
    begin
      result := new Map<K, V>;
      for each el in aVal do
        result.fDict.Add(el.Key, el.Value);
    end;

    class operator implicit(aVal: Map<K, V>):  Dictionary<K, V>;
    begin
      result := new Dictionary<K, V>;

      for each el in aVal.fDict do
        result.Add(el.Key, el.Value);
    end;
    {$ELSE}
    {$ERROR NOT SUPPORTED}
    {$ENDIF}

    constructor(aKeys: array of K; aValues: array of V);
    begin
      if aKeys.Length <> aValues.Length then raise new Exception('Keys/Values do not match!');
      for i: Integer := 0 to aKeys.Length -1 do
        fDict[aKeys[i]] := aValues[i];
    end;

    class var fZero: Map<K, V> := new Map<K, V>();
    class property Zero: Map<K, V> := fZero; published;

    method __Clone: Map<K, V>;
    begin
      exit self;
    end;

    class operator IsNil(aVal: Map<K, V>): Boolean;
    begin
      result := (Object(aVal) = nil) or (Object(aVal) = Object(fZero));
    end;

    class operator Equal(Value1, Value2: Map<K, V>): Boolean;
    begin
      if ((Object(Value1) = nil) and (Object(Value2) = Object(fZero))) or ((Object(Value1) = Object(fZero)) and (Object(Value2) = nil)) then
        exit true;

      exit Object(Value1) = Object(Value2);
    end;

    class operator NotEqual(Value1, Value2: Map<K, V>): Boolean;
    begin
      result := not (Value1 = Value2);
    end;

    property Item[aItem: K]: V write set_Item; default;
    property Item[aItem: K]: tuple of (V, Boolean) read get_Item; default;

    method Get(aItem: K): V;
    begin
      exit Item[aItem][0];
    end;

    method Add(a: K; b: V);
    begin
      fDict[a] := b;
    end;

    method get_Item(aItem: K): tuple of (V, Boolean);
    begin
      var val: V;
      if fDict.TryGetValue(aItem,out val) then
        exit (val, true);

      {$IFDEF ISLAND}
      if VTCheck<V>.IsVT  then
        exit (typeOf(V).Instantiate as V, false);
      {$ELSE}
      if VTCheck<V>.IsVT then
        exit (Activator.CreateInstance<V>(), false);
      {$ENDIF}
      var lZero := go.reflect.Zero(new go.reflect.TypeImpl(typeOf(V)));
      if lZero.fValue <> nil then
        exit (lZero.fValue as V, false);

      exit (default(V), false);
    end;

    method Delete(aKey: K);
    begin
      fDict.Remove(aKey);
    end;

    method GetLen: Integer;
    begin
      result := Length;
    end;

    property Length: Integer read fDict.Count;

    method GetSequence: sequence of tuple of (K, V);
    begin
      {$IFDEF ISLAND}
      exit fDict.GetSequence.Select(a -> (a.Key, a.Value));
      {$ELSE}
      exit fDict.Select(a -> (a.Key, a.Value));
      {$ENDIF}
    end;

    method GetReflectSequence: sequence of tuple of(go.reflect.Value, go.reflect.Value);
    begin
      {$IFDEF ISLAND}
      exit fDict.GetSequence.Select(a -> (new go.reflect.Value(a.Key), new go.reflect.Value(a.Value)));
      {$ELSE}
      exit fDict.Select(a -> (new go.reflect.Value(a.Key), new go.reflect.Value(a.Value)));
      {$ENDIF}
    end;

    method GetReflectValue(aKey: go.reflect.Value): go.reflect.Value;
    begin
      result := new go.reflect.Value(Item[K(aKey.fValue)]);
    end;

    method GetReflectKeys: Slice<go.reflect.Value>;
    begin
      {$IFDEF ISLAND}
      exit fDict.GetSequence.Select(a -> (new go.reflect.Value(a.Key))).ToArray;
      {$ELSE}
      exit fDict.Select(a -> (new go.reflect.Value(a.Key))).ToArray;
      {$ENDIF}
    end;

    method SetReflectKeyValue(aKey: go.reflect.Value; aValue: go.reflect.Value);
    begin
      if aValue.IsValid then
        &Add(aKey.fValue as K, aValue.fValue as V)
      else
        Delete(aKey.fValue as K);
    end;
  end;

{$IFDEF ISLAND}
  IndexOutOfRangeException = public class(Exception) end;
{$ENDIF}
  ISlice = public interface
    method getAtIndex(i: Integer): Object;
    method setAtIndex(i: Integer; aValue: Object);
    method getCap: Integer;
    method setCap: Integer;
    method getLen: Integer;
    method setLen(aValue: Integer): Integer;
    method setFrom(aSrc: ISlice);
    method getReflectSlice(i: Integer; j: Integer): go.reflect.Value;
    method AppendObject(aObject: Object): go.reflect.Value;
    method CloneElems: Object;
  end;


  [ValueTypeSemantics]
  Slice<T> = public class(go.sort.Interface, ISlice)
  assembly
    fArray: array of T;
    fStart, fCount: Integer;

    method get_Item(i: Integer): T;
    begin
      if (i < 0) or (i ≥ fCount) then raise new IndexOutOfRangeException('Index out of range');
      {$IFDEF ISLAND}
      if VTCheck<T>.IsVT and (Object(fArray[i + fStart]) = nil) then
        fArray[i + fStart] := typeOf(T).Instantiate as T;
      {$ELSE}
      if VTCheck<T>.IsVT and (Object(fArray[i + fStart]) = nil) then
        fArray[i + fStart] := Activator.CreateInstance<T>();
      {$ENDIF}
      exit fArray[i + fStart];
    end;

    method set_Item(i: Integer; aVal: T);
    begin
      if (i < 0) or (i ≥ Capacity) then raise new IndexOutOfRangeException('Index out of range');
      fArray[i + fStart] := aVal;
    end;
    class var EmptyArray: array of T := [];
  public

    constructor(aArray: array of T; aStart, aCount: Integer);
    begin
      if (aStart < 0) or (aStart + aCount > aArray.Length) then raise new IndexOutOfRangeException('Index out of range');
      fArray := aArray;
      fStart := aStart;
      fCount := aCount;
    end;

    method Ref(i: int64): Memory<T>; unsafe;
    begin
      exit @fArray[i];
    end;

    constructor;
    begin
      constructor(EmptyArray, 0, 0);
    end;

    constructor(params aArray: array of T);
    begin
      constructor(aArray, 0, aArray.Length);
    end;

    constructor(aSize, aCap: go.builtin.int);
    begin
      if aCap < aSize then aCap := aSize;
      constructor(new T[aCap], 0, aSize);
    end;

    constructor(aSize, aCap: int64);
    begin
      if aCap < aSize then aCap := aSize;
      constructor(new T[aCap], 0, aSize);
    end;

    constructor(aSize: go.builtin.int; aCap: int64);
    begin
      if aCap < aSize then aCap := aSize;
      constructor(new T[aCap], 0, aSize);
    end;
    constructor(aSize: int64; aCap: go.builtin.int);
    begin
      if aCap < aSize then aCap := aSize;
      constructor(new T[aCap], 0, aSize);
    end;

    constructor(aSize: go.builtin.int);
    begin
      constructor(aSize, aSize);
    end;

    constructor(aSize: int64);
    begin
      constructor(aSize, aSize);
    end;

    class var fZero: Slice<T> := new Slice<T>;
    //class property Zero: Slice<T> := fZero; published;
    class property Zero: Slice<T> read new Slice<T>;

    class operator IsNil(aVal: Slice<T>): Boolean;
    begin
      result := (Object(aVal) = nil) or (Object(aVal) = Object(fZero)) or ((aVal.fArray = EmptyArray) and (aVal.Length = 0) and (aVal.Capacity = 0));
    end;

    method Assign(aOrg: array of T);
    begin
      if aOrg <> nil then
        for i: Integer := 0 to aOrg. Length -1 do begin
          self[i] := aOrg[i];
        end;
    end;

    method Assign(aOrg: Slice<T>);
    begin
      if aOrg <> nil then
      for i: Integer := 0 to aOrg. Length -1 do begin
        self[i] := aOrg[i];
      end;
    end;

    method getAtIndex(i: Integer): Object;
    begin
      result := get_Item(i);
    end;

    method AppendObject(aObject: Object): go.reflect.Value;
    begin
      exit new go.reflect.Value(append(self, T(aObject)));
    end;

    method setAtIndex(i: Integer; aValue: Object);
    begin
      set_Item(i, T(aValue));
    end;

    method getCap: Integer;
    begin
      result := Capacity;
    end;

    method setCap: Integer;
    begin

    end;

    method setLen(aValue: Integer): Integer;
    begin
      fCount := aValue;
    end;

    method getLen: Integer;
    begin
      result := Length;
    end;

    method setFrom(aSrc: go.builtin.ISlice);
    begin
      fArray := new T[aSrc.getCap];
      fStart := 0;
      //fStart := aSrc.fStart;
      fCount := aSrc.getLen;
    end;

    method ToArray: array of T;
    begin
      result := new T[Length];
      &Array.Copy(fArray, fStart, result, 0, fCount);
    end;

    method Len: go.builtin.int;
    begin
      result := fCount;
    end;

    method getReflectSlice(i: Integer; j: Integer): go.reflect.Value;
    begin
      result := new go.reflect.Value(new Slice<T>(fArray, i, j-i));
    end;

    method Less(a, b: go.builtin.int): go.builtin.bool;
    begin

    end;

    method Swap(a, b: go.builtin.int);
    begin
      var p := self[a];
      self[a] := self[b];
      self[b] := p;
    end;

    // helper; for contructor calls.
    method Add(a: Integer; b: T);
    begin
      Item[a] := b;
    end;

    property Capacity: Integer read fArray.Length - fStart;
    property Length: Integer read fCount;
    property Item[i: Integer]: T read get_Item write set_Item; default;

    class method Copy(aSource, aDest: Slice<T>);
    begin
      var lCopy := Math.Min(aSource.Length, aDest.Length);
      for i: Integer := 0 to lCopy -1 do
        aDest[i] := aSource[i];
    end;

    method CloneElems: Object;
    begin
      if CloneHelper<T>.CloneMethod <> nil then begin
        var lNewArray := new T[Capacity];
        for i: Integer := 0 to fArray.Length -1 do
          if fArray[i] <> nil then
            lNewArray[i] := T(CloneHelper<T>.CloneMethod.Invoke(fArray[i], []))
          else
            lNewArray[i] := nil;

        exit new Slice<T>(lNewArray, fStart, fCount);
      end
      else
        exit self;
    end;

    method Grow(aNewLen: Integer): Slice<T>;
    begin
      if aNewLen > Capacity then raise new ArgumentException('Length larger than capacity!');

      exit new Slice<T>(fArray, fStart, aNewLen);
    end;

    class operator implicit(aVal: array of T): Slice<T>;
    begin
      exit new Slice<T>(aVal);
    end;

    method GetSequence: sequence of tuple of (Integer, T); iterator;
    begin
      for i: Integer := 0 to Length -1 do
        yield (i, self[i]);
    end;

    class operator implicit(aVal: Slice<T>): array of T;
    begin
      if aVal = nil then
        exit new T[0];

      exit aVal.ToArray();
    end;

    class operator Equal(Value1, Value2: Slice<T>): Boolean; published;
    begin
      // Compare also if both are nil, sice fZero is not the same for all instances.
      if ((Object(Value1) = nil) and (Object(Value2) = Object(fZero))) or ((Object(Value1) = Object(fZero)) and (Object(Value2) = nil)) or
      (((Value1.fArray = EmptyArray) and (Value1.Length = 0) and (Value1.Capacity = 0)) and ((Value2.fArray = EmptyArray) and (Value2.Length = 0) and (Value2.Capacity = 0))) then
        exit true;

      exit Object(Value1) = Object(Value2);
    end;

    class operator NotEqual(Value1, Value2: Slice<T>): Boolean;
    begin
      result := not (Value1 = Value2);
    end;

    /*method Get(idxs: Slice<go.builtin.int32>; idx1: go.builtin.int32; idx2: go.builtin.int32): T;
    begin
      raise new NotImplementedException;
    end;

    method Get(idxs: Slice<go.builtin.int32>; idx1: go.builtin.int32): T;
    begin
      raise new NotImplementedException;
    end;*/

    method Get(idx1: go.builtin.int32; idx2: go.builtin.int32): T;
    begin
      raise new NotImplementedException;
    end;


  end;

  error = public soft interface
    method Error: string;
  end;


  IWaitMessage = public interface
    method Cancel;
    method Start(aNotifier: Func<Func<Boolean>, Boolean>): Boolean;
  end;

  IWaitSendMessage = public interface(IWaitMessage)
  end;

  IWaitReceiveMessage<T> = public interface(IWaitMessage)
    method TryHandOff(aVal: T): Boolean;
    property Data: tuple of (T, Boolean) read;
  end;

  IChannel = public interface
    property Length: Integer read;
  end;

  Channel<T> = public interface
    property Capacity: Integer read;
    method Close;
  end;

  ReceivingChannel<T> = public interface(Channel<T>)
    method Receive: tuple of (T, Boolean);
    method TryReceive: IWaitReceiveMessage<T>;
    method GetSequence: sequence of T;
  end;

  SendingChannel<T> = public interface(Channel<T>)
    method Send(aVal: T);
    method TrySend(aVal: T): IWaitSendMessage;
  end;

  GoException = public class(Exception)
  public
    property Value: Object; readonly;
    constructor(aVal: Object);
    begin
      inherited constructor(aVal.ToString);
      Value := aVal;
    end;
  end;

  method copy<T>(dst, src: Slice<T>): Integer;
  begin
    result := Math.Min(if src = nil then 0 else src.Length, if dst = nil then 0 else dst.Length);
    for i: Integer := 0 to result -1 do
      dst[i] := src[i];
  end;

  method copy(dst: Slice<byte>; src: string): Integer;
  begin
    {$IFDEF ISLAND}
    exit copy(dst, new Slice<byte>(Encoding.UTF8.GetBytes(src)));
    {$ELSE}
    exit copy(dst, new Slice<byte>(System.Text.Encoding.UTF8.GetBytes(src)));
    {$ENDIF}
  end;

  method append<T>(sl: Slice<T>; elems: T): Slice<T>;
  begin
    var slc := if sl = nil then 0 else sl.Length;
    var lNew := new T[slc + 1];
    for i: Integer := 0 to slc -1 do
      lNew[i] := sl[i];

    if (elems is IList) then begin
      {$IF ECHOES}
      var lType := typeOf(T);
      var lElementsType := lType.GetElementType();
      var CloneMethod: System.Reflection.MethodInfo := lElementsType.GetMethods.FirstOrDefault(a -> a.Name = '__Clone');
      var lTmp := Array.CreateInstance(lElementsType, IList(elems).Count);
      for i: Integer := 0 to IList(elems).Count - 1 do begin
        if CloneMethod <> nil then
          lTmp.SetValue(CloneMethod.Invoke(IList(elems)[i], []), i)
        else
          lTmp.SetValue(IList(elems)[i], i);
      end;
      {$ELSE}
      var lType := typeOf(sl);
      var lGeneric := lType.GenericArguments.First;
      var lElementsType := lGeneric.GenericArguments.First;
      var CloneMethod: MethodInfo := lElementsType.Methods.FirstOrDefault(a -> a.Name = '__Clone');
      var lTmp := InternalCalls.Cast<&Array>(Utilities.NewArray(lGeneric.RTTI, lElementsType.SizeOfType, IList(elems).Count));
      for i: Integer := 0 to IList(elems).Count - 1 do begin
        if CloneMethod <> nil then
          IList(lTmp)[i] := CloneMethod.Invoke(IList(elems)[i], [])
        else
          IList(lTmp)[i]:= IList(elems)[i];
        end;
      {$ENDIF}
      lNew[slc] := T(lTmp);
    end
    else
      //if (elems is go.builtin.ISlice) then begin
        //lNew[slc] := T(go.builtin.ISlice(elems).CloneElems);
      //end
      //else
          lNew[slc] := elems;

    exit lNew;
  end;

  method append<T>(sl: Slice<T>; a: T; params elems: array of T): Slice<T>;
  begin
    var c := if elems = nil then 0 else IList<T>(elems).Count;
    var slc := if sl = nil then 0 else sl.Length;
    if c + slc + 1 ≤ sl.Capacity then begin
      sl[slc] := a;
      for i: Integer := 0 to c -1 do
        sl[slc + i + 1] := IList<T>(elems)[i];
      sl.setLen(slc + c + 1);
      exit sl;
    end
    else begin
      var lNew := new T[slc + c + 1];
      for i: Integer := 0 to slc -1 do
        lNew[i] := sl[i];
      lNew[slc] := a;
      for i: Integer := 0 to c -1 do
        lNew[i + slc + 1] := IList<T>(elems)[i];
      exit lNew;
    end;
  end;

  method append<T>(sl, elems: Slice<T>): Slice<T>;
  begin
    var c := if elems = nil then 0 else elems.Length;
    var slc := if sl = nil then 0 else sl.Length;
    var slCap := if sl = nil then 0 else sl.Capacity;
    var lNew := new T[if (slc + c) <= slCap then slCap else slc + c];
    for i: Integer := 0 to slc -1 do
      lNew[i] := sl[i];
    for i: Integer := 0 to c -1 do
      lNew[i + slc] := elems[i];
    exit new Slice<T>(lNew, 0, slc + c);
  end;

  method append(sl: Slice<byte>; elems: string): Slice<byte>;
  begin
    exit append(sl, elems.Value);
  end;

  method close<T>(v: Channel<T>); public;
  begin
    v.Close;
  end;

  method cap<T>(v: Channel<T>): Integer; public;
  begin
    if v = nil then exit 0;
    exit v.Capacity;
  end;

  method cap<T>(v: Slice<T>): Integer; public;
  begin
    if Object(v) = nil then exit -1;
    exit v.Capacity;
  end;

  method len(v: string): Integer; public;
  begin
    //exit v.Value.Length;
    exit v.Length;
  end;

  method len<T>(v: array of T): Integer; public;
  begin
    exit length(v);
  end;

  method len<T>(v: Slice<T>): Integer; public;
  begin
    if v = nil then exit 0;
    exit v.Length;
  end;

  method len<K, V>(v: Map<K, V>): Integer; public;
  begin
    if v = nil then exit 0;
    exit v.Length;
  end;

  method Start(v: Action); public;
  begin
    {$IFDEF ISLAND}
    Task.Run(v);
    {$ELSE}
    System.Threading.Tasks.Task.Factory.StartNew(v);
    {$ENDIF}
  end;

  method AssignArray<T>(aDest, aSource: array of T); public;
  begin
    for i: Integer := 0 to Math.Min(length(aDest), length(aSource)) -1 do
      aDest[i] := aSource[i];
  end;

  method Send<T>(aChannel: SendingChannel<T>; aVal: T); public;
  begin
    if aChannel ≠ nil then
      aChannel.Send(aVal);
  end;

  method Receive<T>(aChannel: ReceivingChannel<T>): tuple of (T, Boolean); public;
  begin
    if aChannel = nil then
      exit (nil, false);

    exit aChannel.Receive();
  end;

  method delete<K,V>(aMap: Map<K, V>; aKey: K); public;
  begin
    aMap.Delete(aKey);
  end;

  method Slice<T>(aSlice: Slice<T>; aStart, aEnd: nullable Integer): Slice<T>; public;
  begin
    if aSlice = nil then
      exit nil;
    var lStart := valueOrDefault(aStart, 0);
    var lEnd := valueOrDefault(aEnd, aSlice.Length);
    //if Integer(lEnd) > aSlice.Length then lEnd := aSlice.Length;
    if (lStart = 0) and (lEnd = aSlice.Length) then exit aSlice;
    lStart := lStart + aSlice.fStart;
    lEnd := lEnd + aSlice.fStart;
    exit new Slice<T>(aSlice.fArray, lStart, lEnd - lStart);
  end;

  method Slice<T>(aSlice: Slice<T>; aStart, aEnd: nullable Integer; aCap: Integer): Slice<T>; public;
  begin
    var lStart := valueOrDefault(aStart, 0);
    var lEnd := valueOrDefault(aEnd, aSlice.Length);
    var lCap := aCap - aStart;
    if Integer(lEnd) > aSlice.Length then lEnd := aSlice.Length;
    if (lStart = 0) and (lEnd = aSlice.Length) then exit aSlice;
    lStart := lStart + aSlice.fStart;
    lEnd := lEnd + aSlice.fStart;
    if lCap > lEnd then begin
      var
        lSlice := new T[lCap];
        Array.Copy(aSlice.fArray, lStart, lSlice, 0, lEnd - lStart);
        exit new Slice<T>(lSlice, lStart, lEnd - lStart);
    end;
    exit new Slice<T>(aSlice.fArray, lStart, lEnd - lStart);
  end;

  method Slice<T>(aSlice: array of T; aStart, aEnd: nullable Integer; aCap: Integer): Slice<T>; public;
  begin
    var lStart := valueOrDefault(aStart, 0);
    var lEnd := valueOrDefault(aEnd, aSlice.Length);
    var lCap := aCap - aStart;
    if Integer(lEnd) > aSlice.Length then lEnd := aSlice.Length;
    if (lStart = 0) and (lEnd = aSlice.Length) then exit aSlice;
    if lCap > lEnd then begin
      var
      lSlice := new T[lCap];
      Array.Copy(aSlice, lStart, lSlice, 0, lEnd - lStart);
      exit new Slice<T>(lSlice, lStart, lEnd - lStart);
    end;
    exit new Slice<T>(aSlice, lStart, lEnd - lStart);
  end;


  method Slice(aSlice: string; aStart, aEnd: nullable Integer): string; public;
  begin
    var lStart := valueOrDefault(aStart, 0);
    var lEnd := valueOrDefault(aEnd, aSlice.Length);
    if Integer(lEnd) > aSlice.Length then lEnd := aSlice.Length;
    if (lStart = 0) and (lEnd = aSlice.Length) then exit aSlice;
    exit new string(new Slice<byte>(aSlice.Value, lStart, lEnd - lStart));
  end;

  method Slice<T>(aSlice: array of T; aStart, aEnd: nullable Integer): Slice<T>; public;
  begin
    exit Slice(new Slice<T>(aSlice), aStart, aEnd);
  end;

  method TypeAssert<T>(v: Object): tuple of (T, Boolean);
  begin
    if (v ≠ nil) and (v is Memory<T>) then begin
      exit (Memory<T>(v)^, true);
    end;

    if v is T then
      exit (T(v), true);

    if v is IMemory then begin
      if IMemory(v).GetValue is T then
        exit (IMemory(v).GetValue as T, true);
    end;
    {$IFDEF ISLAND}
    if VTCheck<T>.IsVT  then
      exit (typeOf(T).Instantiate as T, false);
    {$ELSE}
    if VTCheck<T>.IsVT then
      exit (Activator.CreateInstance<T>(), false);
    {$ENDIF}
    var lZero := go.reflect.Zero(new go.reflect.TypeImpl(typeOf(T)));
    if lZero.fValue <> nil then
      exit (lZero.fValue as T, false);

    exit (default(T), false); // for integers, T(V) cast would fail otherwise.
  end;

  method TypeAssertReference<T>(v: Object): tuple of (&Memory<T>, Boolean);
  begin
    result := TypeAssert<Memory<T>>(v);
    if result[1] then exit;
    if v is T then
      exit (new Memory<T>(T(v)), true);
  end;

  method panic(v: Object);
  begin
    raise new GoException(v);
  end;

  method recover: Object;
  begin
    exit nil;
  end;

  extension method ISequence<T>.GoldIterate: sequence of tuple of (Integer, T); iterator; public;
  begin
    for each el in self index n do
      yield (n, el);
  end;

type
  IntExtension = extension class(Integer, go.fmt.Stringer)
  public
    method String: string;
    begin
      exit self.ToString;
    end;
  end;

  [AttributeUsage(AttributeTargets.Field)]
  TagAttribute = public class(Attribute)
  private
    fTag: string;
  public
    constructor(aTag: PlatformString);
    begin
      fTag := aTag;
    end;

    property Tag: string read fTag;
  end;

  go.crypto.internal.subtle.__Global = public partial class
  public
    class method InexactOverlap(x, y: go.builtin.Slice<byte>): Boolean;
    begin
      if (x.Length = 0) or (y.Length = 0) or (x.fArray <> y.fArray) or ((x.fArray = y.fArray) and (x.fStart = y.fStart)) then
        exit false;

      if (x.fArray = y.fArray) and ((x.fStart ≤ (y.fStart + y.Length)) and (y.fStart ≤ (x.fStart + x.Length))) then
        exit true
      else
        exit false;
    end;
  end;

  [assembly:GoldAspect.GoldFixer]


  extension method go.reflect.Kind.String(): go.builtin.string; public;
  begin
    case Integer(self) of
      0: exit 'Invalid';
      1: exit 'Bool';
      2: exit 'Int';
      3: exit 'Int8';
      4: exit 'Int16';
      5: exit 'Int32';
      6: exit 'Int64';
      7: exit 'Uint';
      8: exit 'Uint8';
      9: exit 'Uint16';
      10: exit 'Uint32';
      11: exit 'Uint64';
      12: exit 'Uintptr';
      13: exit 'Float32';
      14: exit 'Float64';
      15: exit 'Complex64';
      16: exit 'Complex128';
      17: exit '&Array';
      18: exit 'Chan';
      19: exit 'Func';
      20: exit '&Interface';
      21: exit 'Map';
      22: exit 'Ptr';
      23: exit 'Slice';
      24: exit 'String';
      25: exit 'Struct';
      26: exit 'UnsafePointer';
    end;
    exit 'Unknown';
  end;



end.
namespace go.builtin;

uses
  go.builtin
{$IFDEF ECHOES}  , System.Linq, System.Collections.Generic{$ENDIF}

  ;

type
  [ValueTypeSemantics]
  Map<K, V> = public class
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

    class var IsVT := false;

    class constructor;
    begin
      var lType := typeOf(V);
      {$IFDEF ISLAND}
      if not lType.IsValueType and (lType.Methods.Any(a -> a.Name = '__Set')) then
        IsVT := true;
      {$ELSE}
      if not lType.IsValueType and (lType.GetMethod('__Set') <> nil) then
        IsVT := true;
      {$ENDIF}
    end;
  public
    constructor(aArgs: array of tuple of (K, V));
    begin
      for each el in aArgs do
        fDict[el[0]] := el[1];
    end;

    constructor(aCap: Integer);
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
      if IsVT  then
        exit (typeOf(V).Instantiate as V, false);
      {$ELSE}
      if IsVT then
        exit (Activator.CreateInstance<V>(), false);
      {$ENDIF}
      exit (default(V), false);
    end;

    method Delete(aKey: K);
    begin
      fDict.Remove(aKey);
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
    method setLen: Integer;
    method setFrom(aSrc: ISlice);
  end;
  //Slice<T> = public class(ISlice)
  Slice<T> = public class(go.sort.Interface, ISlice)
  assembly
    fArray: array of T;
    fStart, fCount: Integer;

    method get_Item(i: Integer): T;
    begin
      if (i < 0) or (i ≥ fCount) then raise new IndexOutOfRangeException('Index out of range');
      {$IFDEF ISLAND}
      if IsVT and (Object(fArray[i + fStart]) = nil) then
        fArray[i + fStart] := typeOf(T).Instantiate as T;
      {$ELSE}
      if IsVT and (Object(fArray[i + fStart]) = nil) then
        fArray[i + fStart] := Activator.CreateInstance<T>();
      {$ENDIF}
      exit fArray[i + fStart];
    end;

    method set_Item(i: Integer; aVal: T);
    begin
      if (i < 0) or (i ≥ fCount) then raise new IndexOutOfRangeException('Index out of range');
      fArray[i + fStart] := aVal;
    end;
    class var EmptyArray: array of T := [];
    class var IsVT := false;

    class constructor;
    begin
      var lType := typeOf(T);
      {$IFDEF ISLAND}
      if not lType.IsValueType and (lType.Methods.Any(a -> a.Name = '__Set')) then
        IsVT := true;
      {$ELSE}
      if not lType.IsValueType and (lType.GetMethod('__Set') <> nil) then
        IsVT := true;
      {$ENDIF}
    end;
  public

    constructor(aArray: array of T; aStart, aCount: Integer);
    begin
      if (aStart < 0) or (aStart + aCount > aArray.Length) then raise new IndexOutOfRangeException('Index out of range');
      fArray := aArray;
      fStart := aStart;
      fCount := aCount;
    end;

    constructor;
    begin
      constructor(EmptyArray, 0, 0);
    end;

    constructor(params aArray: array of T);
    begin
      constructor(aArray, 0, aArray.Length);
    end;

    constructor(aSize, aCap: Integer);
    begin
      if aCap < aSize then aCap := aSize;
      constructor(new T[aCap], 0, aSize);
    end;

    constructor(aSize: Integer);
    begin
      constructor(aSize, aSize);
    end;

    method getAtIndex(i: Integer): Object;
    begin
      result := get_Item(i);
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

    method setLen: Integer;
    begin

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

    method Less(a, b: Integer): go.builtin.bool;
    begin

    end;

    method Swap(a, b: Integer);
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
      exit aVal.ToArray();
    end;
  end;

  error = public interface
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

  Channel<T> = public interface
    property Capacity: Integer read;
    method Close;
  end;

  ReceivingChannel<T> = public interface(Channel<T>)
    method Receive: tuple of (T, Boolean);
    method TryReceive: IWaitReceiveMessage<T>;
  end;

  SendingChannel<T> = public interface(Channel<T>)
    method Send(aVal: T);
    method TrySend(aVal: T): IWaitSendMessage;
  end;

  IReference = public interface
    method Get: Object;
    method &Set(o: Object);
  end;

  [TransparentType]
  &Reference<T> = public class(IReference)
  public
    constructor(aRead: Func<T>; aWrite: Action<T>);
    begin
      &Read := aRead;
      &Write := aWrite;
    end;

    constructor(aValue: T);
    begin
      var lValue := aValue;
      &Read := -> lValue;
      &Write := a -> begin lValue := a; end;
    end;
    method Get: Object;
    begin
      if self = nil then
        exit default(T);

      exit Object(Value);
    end;

    method &Set(o: Object);
    begin
      Value := T(o);
    end;

    property &Read: Func<T>; readonly;
    property &Write: Action<T>; readonly;

    property Value: T read &Read() write value -> &Write(value);

    class method &Set(aVal: Reference<T>; aValue: T);
    begin
      aVal.Value := aValue;
    end;

    class method &Get(aVal: Reference<T>): T;
    begin
      if aVal = nil then
        exit default(T);

      exit aVal.Value;
    end;

    class operator Implicit(aVal: Reference<T>): T;
    begin
      if aVal = nil then
        exit nil
      else
        exit aVal.Value;
    end;

    class operator Implicit(aVal: T): Reference<T>;
    begin
      exit new Reference<T>(aVal);
    end;
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
    exit copy(dst, Encoding.UTF8.GetBytes(src));
    {$ELSE}
    exit copy(dst, System.Text.Encoding.UTF8.GetBytes(src));
    {$ENDIF}
  end;

  method append<T>(sl: Slice<T>; elems: T): Slice<T>;
  begin
    var slc := if sl = nil then 0 else sl.Length;
    var lNew := new T[slc + 1];
    for i: Integer := 0 to slc -1 do
      lNew[i] := sl[i];
      lNew[slc] := elems;
    exit lNew;
  end;
  method append<T>(sl: Slice<T>; a: T; params elems: array of T): Slice<T>;
  begin
    var c := if elems = nil then 0 else IList<T>(elems).Count;
    var slc := if sl = nil then 0 else sl.Length;
    var lNew := new T[slc + c + 1];
    for i: Integer := 0 to slc -1 do
      lNew[i] := sl[i];
      lNew[slc + 1] := a;
    for i: Integer := 0 to c -1 do
      lNew[i + slc + 1] := IList<T>(elems)[i];
    exit lNew;
  end;

  {method append<T>(sl: Slice<T>; elems: Object): Slice<T>;
  begin
    if elems is Slice<T> then
      exit appendSlice(sl, elems as Slice<T>);
    var c := if elems = nil then 0 else IList<T>(elems).Count;
    var lNew := new T[(if sl = nil then 0 else sl.Length) + c];
    var slc := if sl = nil then 0 else sl.Length;
    for i: Integer := 0 to slc -1 do
      lNew[i] := sl[i];
    for i: Integer := 0 to c -1 do
      lNew[i + slc] := IList<T>(elems)[i];
    exit lNew;
  end;}

  method append<T>(sl: Slice<T>; elems: Object): Slice<T>;
  begin
    if elems is Slice<T> then
      exit appendSlice(sl, elems as Slice<T>);
    var c := if elems = nil then 0 else IList<T>(elems).Count;
    var slc := if sl = nil then 0 else sl.Length;
    var slCap := if sl = nil then 0 else sl.Capacity;
    var lNew := new T[if (slc + c) <= slCap then slCap else slc + c];

    for i: Integer := 0 to slc -1 do
      lNew[i] := sl[i];
    for i: Integer := 0 to c -1 do
      lNew[i + slc] := IList<T>(elems)[i];
    exit new Slice<T>(lNew, 0, slc + c);
  end;

  {method appendSlice<T>(sl, elems: Slice<T>): Slice<T>;
  begin
    var c := if elems = nil then 0 else elems.Length;
    var slc := if sl = nil then 0 else sl.Length;
    var lNew := new T[slc + c];
    for i: Integer := 0 to slc -1 do
      lNew[i] := sl[i];
    for i: Integer := 0 to c -1 do
      lNew[i + slc] := elems[i];
    exit lNew;
  end;}

  method appendSlice<T>(sl, elems: Slice<T>): Slice<T>;
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
    {$IFDEF ISLAND}
    exit append(sl, Encoding.UTF8.GetBytes(elems));
    {$ELSE}
    exit append(sl, System.Text.Encoding.UTF8.GetBytes(elems));
    {$ENDIF}
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
    if v = nil then exit 0;
    exit v.Capacity;
  end;


  method len(v: string): Integer; public;
  begin
    exit length(v);
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

  method Send<T>(aChannel: SendingChannel<T>; aVal: T); public;
  begin
    aChannel.Send(aVal);
  end;

  method Receive<T>(aChannel: ReceivingChannel<T>): tuple of (T, Boolean); public;
  begin
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
    exit aSlice.Substring(lStart, lEnd - lStart);
  end;

  method Slice<T>(aSlice: array of T; aStart, aEnd: nullable Integer): Slice<T>; public;
  begin
    exit Slice(new Slice<T>(aSlice), aStart, aEnd);
  end;

  method TypeAssert<T>(v: Object): tuple of (T, Boolean);
  begin
    if v is T then
      exit (T(v), true);
    exit (default(T), false); // for integers, T(V) cast would fail otherwise.
  end;


  method panic(v: Object);
  begin
    raise new GoException(v);
  end;

  operator implicit(aVal: string): Slice<Char>; public;
  begin
    exit new Slice<Char>(aVal.ToArray);
  end;

  operator implicit(aVal: string): Slice<go.builtin.rune>; public;
  begin
    exit new Slice<go.builtin.rune>(aVal.Select(a -> go.builtin.rune(a)).ToArray);
  end;

  operator implicit(aVal: byte): string; public;
  begin
    exit Char(aVal).ToString();
  end;

  operator Implicit(aVal: Slice<byte>): string; public;
  begin
    {$IFDEF ISLAND}
    exit Encoding.UTF8.GetString(aVal.fArray, aVal.fStart, aVal.fCount);
    {$ELSE}
    exit System.Text.Encoding.UTF8.GetString(aVal.fArray, aVal.fStart, aVal.fCount);
    {$ENDIF}
  end;

  method recover: Object;
  begin
    exit nil;
  end;

  operator Implicit(aVal: Slice<Char>): string; public;
  begin
    {$IF ISLAND}
    exit string.FromCharArray(aVal.ToArray());
    {$ELSEIF ECHOES}
    exit new string(aVal.ToArray());
    {$ENDIF}
  end;

  operator Implicit(aVal: Slice<rune>): string; public;
  begin
  {$IF ISLAND}
  exit string.FromCharArray(aVal.ToArray().Select(a -> Char(a.Value)).ToArray());
  {$ELSEIF ECHOES}
  exit new string(aVal.ToArray());
  {$ENDIF}
  end;

  operator Explicit(aVal: string): Slice<byte>; public;
  begin
    {$IFDEF ISLAND}
    exit new Slice<byte>(Encoding.UTF8.GetBytes(aVal));
    {$ELSE}
    exit new Slice<byte>(System.Text.Encoding.UTF8.GetBytes(aVal));
    {$ENDIF}
  end;
  operator Explicit(aVal: string): go.net.http.htmlSig; public;
  begin
    var q: go.builtin.Slice<byte> := (aVal as go.builtin.Slice<byte>);
    exit new go.net.http.htmlSig(Value := q);
  end;

  extension method ISequence<T>.GoldIterate: sequence of tuple of (Integer, T); iterator; public;
  begin
    for each el in self index n do
      yield (n, el);
  end;

  type
    System.StrExt = public extension class(string)
    public
      constructor(aVal: array of go.builtin.rune);
      begin
        {$IF ISLAND}
        exit string.FromCharArray(aVal.Select(a -> :RemObjects.Elements.System.Char(a.Value)).ToArray());
        {$ELSEIF ECHOES}
        exit new string(aVal.Select(a -> :System.Char(a.Value)).ToArray());
        {$ENDIF}
      end;

     method GoldIterate: sequence of tuple of (Integer, go.builtin.rune); iterator; public;
      begin
        for each el in self index n do
          yield (n, go.builtin.rune(el));
      end;
    end;

type
  IntExtension = extension class(Integer, go.fmt.Stringer)
  public
    method String: string;
    begin
      exit self.ToString;
    end;
  end;

  go.builtin.int32 = public partial record
  public
    operator implicit(aVal: go.builtin.int32): nullable Integer;
    begin
      exit Integer(aVal);
    end;
  end;

  [AttributeUsage(AttributeTargets.Field)]
  TagAttribute = public class(Attribute)
  private
    fTag: string;
  public
    constructor(aTag: string);
    begin
      fTag := aTag;
    end;

    property Tag: string read fTag;
  end;

  go.crypto.internal.subtle.__Global = public partial class
  public
    class method InexactOverlap(x, y: go.builtin.Slice<byte>): Boolean;
    begin
      {if x.fArray <> y.fArray then exit false;
      if x.fStart > y.fStart + y.fCount then exit false;
      if y.fStart > x.fStart + x.fCount then exit false;
      exit true;}
      {if x.fArray <> y.fArray then exit true;
      if x.fStart > y.fStart + y.fCount then exit true;
      if y.fStart > x.fStart + x.fCount then exit true;}
      exit false;
    end;
  end;

  [assembly:GoldAspect.GoldFixer]


end.
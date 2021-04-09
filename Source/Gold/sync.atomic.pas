namespace go.sync.atomic;
uses
  go.builtin;

method AddInt64(addr: Memory<int64>; delta: int64): int64; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.Add(var addr^.Value, delta.Value);
  {$ELSE}
  exit System.Threading.Interlocked.Add(var addr^.Value, delta.Value);
  {$ENDIF}
end;

method AddInt32(addr: Memory<int32>; delta: int32): int32; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.Add(var addr^, delta);
  {$ELSE}
  exit System.Threading.Interlocked.Add(var addr^, delta);
  {$ENDIF}
end;
method AddUint32(addr: Memory<uint32>; delta: uint32): uint32; public; unsafe;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.Add(var ^Integer(@(addr^))^, delta);
  {$ELSE}
  exit System.Threading.Interlocked.Add(var ^Integer(@addr)^, delta);
  {$ENDIF}
end;

method AddUint64(addr: Memory<uint64>; delta: uint64): uint64; public; unsafe;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.Add(var ^int(@(addr^))^, delta);
  {$ELSE}
  exit System.Threading.Interlocked.Add(var ^int(@addr)^, delta);
  {$ENDIF}
end;

method CompareAndSwapInt64(addr: Memory<int64>; aold, anew: int64): bool; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.CompareExchange(var addr^.Value, anew.Value, aold.Value) = aold;
  {$ELSE}
  exit System.Threading.Interlocked.CompareExchange(var addr.Value, anew.Value, aold.Value) = aold;
  {$ENDIF}
end;

method CompareAndSwapInt32(addr: Memory<int32>; aold, anew: int32): bool; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.CompareExchange(var addr^, anew, aold) = aold;
  {$ELSE}
  exit System.Threading.Interlocked.CompareExchange(var addr^, anew, aold) = aold;
  {$ENDIF}
end;

method CompareAndSwapUint32(addr: Memory<uint32>; aold, anew: uint32): bool; public; unsafe;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.CompareExchange(var ^Integer(@addr)^, anew, aold) = aold;
  {$ELSE}
  exit System.Threading.Interlocked.CompareExchange(var ^Integer(@addr)^, anew, aold) = aold;
  {$ENDIF}
end;

method CompareAndSwapUint64(addr: Memory<uint64>; aold, anew: uint64): bool; public; unsafe;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.CompareExchange(var ^int(@(addr^))^, anew, aold) = aold;
  {$ELSE}
  exit System.Threading.Interlocked.CompareExchange(var ^int(@addr)^, anew, aold) = aold;
  {$ENDIF}
end;


method LoadInteger(addr: Memory<int>): int; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.VolatileRead(var addr^);
  {$ELSE}
  exit :System.Threading.Volatile.Read(var addr^);
  {$ENDIF}
end;

method LoadInt64(addr: Memory<int64>): int64; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.VolatileRead(var addr^.Value);
  {$ELSE}
  exit :System.Threading.Volatile.Read(var addr^.Value);
  {$ENDIF}
end;

method LoadInt32(addr: Memory<int32>): int32; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.VolatileRead(var addr^);
  {$ELSE}
  exit System.Threading.&Volatile.Read(var addr^);
  {$ENDIF}
end;

method LoadUint32(addr: Memory<uint32>): uint32; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.VolatileRead(var addr^);
  {$ELSE}
  exit System.Threading.&Volatile.Read(var addr^);
  {$ENDIF}
end;

method LoadUint64(addr: Memory<uint64>): uint64; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.VolatileRead(var addr^.Value);
  {$ELSE}
  exit System.Threading.&Volatile.Read(var addr^.Value);
  {$ENDIF}
end;

method StoreInt64(addr: Memory<int64>; val: int64);
begin
  {$IFDEF ISLAND}
  InternalCalls.VolatileWrite(var addr^.Value, val.Value);
  {$ELSE}
  System.Threading.&Volatile.Write(var addr^.Value, val.Value);
  {$ENDIF}
end;


method StoreInteger(addr: Memory<int>; val: int);
begin
  {$IFDEF ISLAND}
  InternalCalls.VolatileWrite(var addr^, val);
  {$ELSE}
  System.Threading.&Volatile.Write(var addr^, val);
  {$ENDIF}
end;

method StoreInt32(addr: Memory<int32>; val: int32);
begin
  {$IFDEF ISLAND}
  InternalCalls.VolatileWrite(var addr^, val);
  {$ELSE}
  System.Threading.&Volatile.Write(var addr^, val);
  {$ENDIF}
end;

method StoreUint32(addr: Memory<uint32>; val: uint32);
begin
  {$IFDEF ISLAND}
  InternalCalls.VolatileWrite(var addr^, val);
  {$ELSE}
  System.Threading.&Volatile.Write(var addr^, val);
  {$ENDIF}
end;

method StoreUint64(addr: Memory<uint64>; val: uint64);
begin
  {$IFDEF ISLAND}
  InternalCalls.VolatileWrite(var addr^.Value, val.Value);
  {$ELSE}
  System.Threading.&Volatile.Write(var addr^.Value, val.Value);
  {$ENDIF}
end;

method SwapInt32(addr: Memory<int64>; anew: int64): int64; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.Exchange(var addr^.Value, anew.Value);
  {$ELSE}
  exit System.Threading.Interlocked.Exchange(var addr^.Value, anew.Value);
  {$ENDIF}
end;

method SwapInt64(addr: Memory<int32>; anew: int32): int32; public;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.Exchange(var addr^, anew);
  {$ELSE}
  exit System.Threading.Interlocked.Exchange(var addr^, anew);
  {$ENDIF}
end;

method SwapUint32(addr: Memory<uint32>; anew: uint32): uint32; public; unsafe;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.Exchange(var ^Integer(@(addr^))^, anew);
  {$ELSE}
  exit System.Threading.Interlocked.Exchange(var ^Integer(@(addr^))^, anew);
  {$ENDIF}
end;

method SwapUint64(addr: Memory<uint64>; anew: uint64): uint64; public; unsafe;
begin
  {$IFDEF ISLAND}
  exit InternalCalls.Exchange(var ^int(@(addr^))^, anew);
  {$ELSE}
  exit System.Threading.Interlocked.Exchange(var ^int(@(addr^))^, anew);
  {$ENDIF}
end;


type
  [ValueTypeSemantics]
  Value = public class
  private
    fLock: Object := new Object;
    fValue: Object;
  public
    method Load: Object;
    begin
      locking self do
        exit fValue;
    end;

    method Store(val: Object);
    begin
      locking self do
        fValue := val;
    end;
  end;


end.
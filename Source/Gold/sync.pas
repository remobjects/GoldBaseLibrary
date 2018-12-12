namespace sync;
type
  Locker = public interface
    method Lock();
    method Unlock();
  end;

  [ValueTypeSemantics]
  Mutex = public class(Locker)
  assembly
    {$IFDEF ISLAND}
    fMutex: Monitor := new Monitor;
    {$ELSE}
    fMutex: Object := new Object;
    {$ENDIF}
  public
    method Lock();
    begin
      {$IFDEF Island}
      fMutex.Wait;
      {$ELSE}
      System.Threading.Monitor.Enter(fMutex);
      {$ENDIF}
    end;

    method Unlock();
    begin
      {$IFDEF ISLAND}
      fMutex.Release;
      {$ELSE}
      System.Threading.Monitor.Exit(fMutex);
      {$ENDIF}
    end;
  end;

  Cond = public class
  private
    fMutex: Locker;
    {$IFDEF ISLAND}
    fCond: ConditionalVariable := new ConditionalVariable();
    {$ENDIF}
  public
    constructor(aMutex: Mutex);
    begin
      fMutex := aMutex;
    end;

    property L: Locker read fMutex write fMutex;

    method Wait;
    begin
      {$IFDEF ISLAND}
      fCond.Wait(fMutex.fMutex);
      {$ELSE}
      System.Threading.Monitor.Wait(Mutex(fMutex).fMutex);
      {$ENDIF}
    end;

    method Broadcast;
    begin
      {$IFDEF ISLAND}
      fCond.Broadcast;
      {$ELSE}
      System.Threading.Monitor.PulseAll(Mutex(fMutex).fMutex);
      {$ENDIF}
    end;

    method Signal;
    begin
      {$IFDEF ISLAND}
      fCond.Signal;
      {$ELSE}
      System.Threading.Monitor.Pulse(Mutex(fMutex).fMutex);
      {$ENDIF}
    end;
  end;

  method NewCond(aLocker: Locker): Cond;
  begin
    exit new Cond(aLocker as Mutex);
  end;

type
  [ValueTypeSemantics]
  RWMutex = public class(Locker)
  private
  {$IFDEF ISLAND}
    fRealLock: ReadWriteLock := new ReadWriteLock;
  {$ELSE}
    fRealLock: System.Threading.ReaderWriterLockSlim := new System.Threading.ReaderWriterLockSlim;
  {$ENDIF}
    fLocker: Locker := new class Locker (Lock := method
    begin
      self.Lock;
    end,
    Unlock := method
    begin
      self.Unlock
    end);
  public

    method Lock;
    begin
      fRealLock.EnterWriteLock;
    end;

    method RLock;
    begin
      fRealLock.EnterReadLock;
    end;

    method RUnlock;
    begin
      fRealLock.ExitReadLock;
    end;

    method Unlock;
    begin
      fRealLock.ExitWriteLock;
    end;

    method RLocker: Locker;
    begin
      exit fLocker;
    end;
  end;
  [ValueTypeSemantics]
  Map = public class
  private

    {$IFDEF ISLAND}
    fValue:Dictionary<Object, Object> := new Dictionary<Object, Object>;
    fLock: Monitor := new Monitor;
    {$ELSE}
    fValue: System.Collections.Generic.Dictionary<Object, Object> := new System.Collections.Generic.Dictionary<Object, Object>;
    fLock: Object := new Object;
    {$ENDIF}
  public
    method Delete(aKey: Object);
    begin
      locking fLock do
        fValue.Remove(aKey);
      end;
    method Load(aKey: Object): tuple of (Object, Boolean);
    begin
      locking fLock do begin
        if fValue.TryGetValue(aKey, out var res) then
          exit (res, true);
        exit (nil, false);
      end;
    end;

    method Range(f: Func<Object, Object, Boolean>);
    begin
      locking fLock do
        for each el in fValue do
          f(el.Key, el.Value);
    end;

    method LoadOrStore(aKey, aValue: Object): tuple of (Object, Boolean);
    begin
      locking fLock do begin
        if fValue.TryGetValue(aKey, out var res) then
          exit (res, true);
        fValue[aKey] := aValue;
        exit (aValue, false);
      end;
    end;

    method Store(aKey, aValue: Object);
    begin
      locking fLock do
        fValue[aKey] := aValue;
    end;
  end;
  [ValueTypeSemantics]
  Once = public class
  private
    fDone: Integer;
    {$IFDEF ISLAND}
    fLock: Monitor := new Monitor;
    {$ELSE}
    fLock: Object := new Object;
    {$ENDIF}
  public
    method &Do(a: Action);
    begin
      if fDone = 1 then exit;
      locking fLock do begin
        if fDone = 1 then exit;
        a();
        fDone := 1;
      end;
    end;
  end;
  [ValueTypeSemantics]
  Pool = public class
  private
    {$IFDEF ISLAND}
    fLock: Monitor := new Monitor;
    fItems: List<Object> := new List<Object>;
    {$ELSE}
    fLock: Object := new Object;
    fItems: System.Collections.Generic.List<Object> := new System.Collections.Generic.List<Object>;
    {$ENDIF}

  public
    property &New: Func<Object>;
    method Put(x: Object);
    begin
      locking fLock do
          fItems.Add(x);
    end;

    method Get: Object;
    begin
      locking fLock do begin
        if fItems.Count = 0 then begin
          if &New = nil then exit nil;
          exit &New();
        end;
        result := fItems[0];
        fItems.RemoveAt(0);
      end;
    end;

  end;

  [ValueTypeSemantics]
  WaitGroup = public class
  private
    fMutex: Mutex := new Mutex;
    fCond: Cond;
    fCounter: Integer;
  public
    constructor;
    begin
      fCond := new Cond(fMutex);
    end;

    method Add(aDelta: Integer);
    begin
      fMutex.Lock;
      fCounter := fCounter + aDelta;
      fCond.Broadcast;
      fMutex.Unlock;
    end;

    method Done;
    begin
      Add(-1);
    end;

    method Wait;
    begin
      if fCounter = 0 then exit;
      fMutex.Lock;
      if fCounter = 0 then begin
        fMutex.Unlock;
        exit;
      end;
      loop begin
        fCond.Wait;
        if fCounter = 0 then break;
      end;

      fMutex.Unlock;
    end;
  end;
end.
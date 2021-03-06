﻿namespace go.runtime;

{$IFDEF ECHOES}
uses
  System.IO, System.Text, System.Collections.Generic;
{$ENDIF}

type
  [ValueTypeSemantics]
  Frame = public partial class
  public
    PC: go.builtin.uintptr;
    Func: Memory<Func>;
    &Function: String;
    File: String;
    Line: Integer;
    Entry: go.builtin.uintptr;
  end;
  [ValueTypeSemantics]
  Frames = public partial class
  public
    method Next(): tuple of (Frame, Boolean);
    begin
      exit (nil, false);
    end;
  end;
  [ValueTypeSemantics]
  Func = public partial class

  end;

method SetFinalizer(aObj: Object; aFinalizer: Object);
begin
  // empty
end;

method Callers(&skip: Integer; pc: go.builtin.Slice<go.builtin.uintptr>): Integer;
begin
  exit 0;
end;

method CallersFrames(acallers: go.builtin.Slice<go.builtin.uintptr>): Memory<Frames>;
begin
  exit new Memory<Frames>(new Frames);
end;

method Stack(buf: go.builtin.Slice<Byte>; all: Boolean): Integer; public;
begin
  exit 0;
end;

var GOOS: String := {$IFDEF ECHOES}if Environment.OSVersion.Platform.ToString.ToLower.Contains('win32nt') then 'windows' else Environment.OSVersion.Platform.ToString{$ELSEIF (ISLAND AND WINDOWS)}'windows'{$ELSE}Environment.OSName{$ENDIF};
var GOARCH: String := 'unknown';

method GOROOT: String;
begin
  raise new NotImplementedException;
end;

method StartTrace: go.builtin.error;
begin
  exit go.Errors.New('Not supported');
end;

method StopTrace;
begin
  raise new NotImplementedException;
end;

method ReadTrace: go.builtin.Slice<Byte>;
begin
  raise new NotImplementedException;
end;

method Caller(skip: Integer): tuple of (UIntPtr, String, Integer, Boolean);
begin
  exit (0,'',0, false);
end;

type
  go.builtin.__Global = public partial class
  private
    {$IFDEF ISLAND}
    class var dtbase : DateTime := new DateTime(1970, 1, 1, 0, 0, 0, 0);
    {$ELSEIF ECHOES}
    class var dtbase : DateTime := new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
    {$ENDIF}

    class method now(): tuple of (Int64, Int32, Int64); assembly;
    begin
      {$IF ISLAND AND WINDOWS}
      var q := new DateTime(DateTime.UtcNow.Ticks - dtbase.Ticks);
      exit (Int64(q.Ticks / DateTime.TicksPerSecond), (q.Ticks * 100) mod 1 000 000 000, rtl.GetTickCount  * DateTime.TicksPerMillisecond * 100);
      {$ELSEIF ISLAND AND POSIX}
      var ts: rtl.__struct_timespec;
      rtl.clock_gettime({$IF ISLAND AND DARWIN}rtl.clockid_t._CLOCK_MONOTONIC{$ELSE}rtl.CLOCK_MONOTONIC{$ENDIF}, @ts);
      var lTickCount := ts.tv_sec * 1000 + ts.tv_nsec / 1000000;

      var q := new DateTime(DateTime.UtcNow.Ticks - dtbase.Ticks);
      exit (Int64(q.Ticks / DateTime.TicksPerSecond), (q.Ticks * 100) mod 1 000 000 000, lTickCount  * DateTime.TicksPerMillisecond * 100);
      //exit (Int64(q.Ticks / DateTime.TicksPerMillisecond), (q.Ticks * 100) mod 1 000 000 000, lTickCount  * 100);
      {$ELSEIF ECHOES}
      var q := DateTime.UtcNow - dtbase;
      exit (Int64(q.TotalSeconds), (q.Ticks * 100) mod 1 000 000 000, System.Diagnostics.StopWatch.GetTimestamp  * 100);
      {$ENDIF}
    end;

  end;

type
  go.runtime.trace.__Global = public partial class
  public
    class method userTaskCreate(id, parentID: UInt64; taskType: String);
    begin
      raise new NotImplementedException;
    end;


    class method userTaskEnd(id: UInt64);
    begin
      raise new NotImplementedException;
    end;


    class method userRegion(id, mode: UInt64; regionType: String);
    begin
      raise new NotImplementedException;
    end;

    class method userLog(id: UInt64; category, message: String);
    begin
      raise new NotImplementedException;
    end;
  end;
  Go.&unsafe.__Global = public partial class
  public
    class method Sizeof<T>(o: T): Integer; inline;
    begin
      exit RemObjects.Elements.System.sizeOf(T);
    end;
  end;


  [AliasSemantics]
  go.syscall.Errno = public record(go.builtin.error)
  public
    Value: UIntPtr;

    constructor(aValue: UIntPtr);
    begin
      self.Value := aValue;
    end;

    method Error: go.builtin.string;
    begin
      exit Value.ToString;
    end;

    method &Is(target: go.builtin.error): Boolean;
    begin
      // TODO
    end;
  /*func (e Errno) Is(target error) bool {
    switch target {
    case oserror.ErrPermission:
      return e == ERROR_ACCESS_DENIED
    case oserror.ErrExist:
      return e == ERROR_ALREADY_EXISTS ||
        e == ERROR_DIR_NOT_EMPTY ||
        e == ERROR_FILE_EXISTS
    case oserror.ErrNotExist:
      return e == ERROR_FILE_NOT_FOUND ||
        e == _ERROR_BAD_NETPATH ||
        e == ERROR_PATH_NOT_FOUND
    }
    return false
  }*/
  end;


  [AliasSemantics]
  go.runtime.Error = public record(go.builtin.error)
  public
    Value: String;

    constructor(aValue: String);
    begin
      self.Value := aValue;
    end;
    method Error: go.builtin.string;
    begin
      exit Value;
    end;
  end;

  [ValueTypeSemantics]
  go.syscall.SysProcAttr = public class
  public
    HideWindow: Boolean;
    CmdLine: String; // used if non-empty, else the windows command line is built by escaping the arguments passed to StartProcess
    CreationFlags: UInt32;
  end;

  go.internal.testlog.__Global = public partial class
  public
    class method Getenv(s: String); empty;
    class method Open(s: String); empty;
    class method Stat(s: String); empty;

  end;


  go.syscall.__Global = public partial class
  public

    class method Getenv(sn: String): tuple of (go.builtin.string, Boolean);
    begin
      var s := Environment.GetEnvironmentVariable(sn);
      if s = nil then
        exit ('', false);
      exit (s, true);
    end;

    class method Unsetenv(s: String): go.builtin.error;
    begin
      Environment.SetEnvironmentVariable(s, nil);
    end;

    class method Clearenv: go.builtin.error;
    begin
      {$IF ISLAND}
      for each el in Environment.GetEnvironmentVariables() do
        Unsetenv(String(el.Key));
      {$ELSEIF ECHOES}
      for each el: System.Collections.DictionaryEntry in Environment.GetEnvironmentVariables() do
        Unsetenv(String(el.Key));
      {$ENDIF}
    end;

    class method Environ: go.builtin.Slice<go.builtin.string>;
    begin
      {$IF ISLAND}
      var lRes := new List<String>;
      for each el in Environment.GetEnvironmentVariables() do
        lRes.Add(el.Key +'='+el.Value);
      {$ELSEIF ECHOES}
      var lRes := new System.Collections.Generic.List<String>;
      for each el: System.Collections.DictionaryEntry in Environment.GetEnvironmentVariables() do
        lRes.Add(el.Key.ToString() +'='+el.Value);
      {$ENDIF}
      exit go.builtin.string.PlatformStringArrayToGoSlice(lRes.ToArray);
    end;

    class method &Exit(i: Integer);
    begin
      {$IF ISLAND}
      raise new NotImplementedException;
      {$ELSEIF ECHOES}
      Environment.Exit(i);
      {$ENDIF}
    end;

    class method Getuid: Integer;
    begin
      exit -1;
    end;

    class method Geteuid: Integer;
    begin
      exit -1;
    end;

    class method Getgid: Integer;
    begin
      exit -1;
    end;

    class method Getegid: Integer;
    begin
      exit -1;
    end;

    class method Getppid: Integer;
    begin
      exit -1;
    end;

    class method Getpid: Integer;
    begin
      {$IF ISLAND}
      exit Process.CurrentProcessId;
      {$ELSEIF ECHOES}
      exit System.Diagnostics.Process.GetCurrentProcess().Id;
      {$ENDIF}
    end;

    class method Getgroups: tuple of (go.builtin.Slice<Integer>, go.builtin.error);
    begin
      exit (new go.builtin.Slice<Integer>, go.Errors.New('Not supported'));
    end;

    class var
      ENOENT : go.syscall.Errno := new go.syscall.Errno(1); readonly;
    const
      O_RDONLY   = $00000;
      O_WRONLY   = $00001;
      O_RDWR     = $00002;
      O_CREAT    = $00040;
      O_EXCL     = $00080;
      O_NOCTTY   = $00100;
      O_TRUNC    = $00200;
      O_NONBLOCK = $00800;
      O_APPEND   = $00400;
      O_SYNC     = $01000;
      O_ASYNC    = $02000;
      O_CLOEXEC  = $80000;


    class var ENOTDIR: go.syscall.Errno := new go.syscall.Errno(2); readonly;

    class var EINVAL: go.syscall.Errno := new go.syscall.Errno(22); readonly; //NewError("bad arg in system call")


    class method Setenv(key: String; value: String): go.builtin.error;
    begin
      var lRes := true;
      if defined('ISLAND') then
        lRes := Environment.SetEnvironmentVariable(key, value)
      else
        if defined('ECHOES') then
          Environment.SetEnvironmentVariable(key, value);

      if lRes = true then
        exit nil
      else
        exit new ExceptionError(new Exception('Error setting environment variable'));
    end;
  end;

  ExceptionError = public class(go.builtin.error)
  public
    constructor(err: Exception);
    begin
      Exception := err;
    end;
    method Error: go.builtin.string; begin exit Exception.ToString; end;
    property Exception: Exception; readonly;
  end;

  PlatformTimer = public {$IF ECHOES}System.Timers.Timer{$ELSEIF ISLAND}RemObjects.Elements.System.Timer{$ENDIF};
  go.time.runtimeTimer = public partial class
  assembly
    property pt: PlatformTimer;
  end;
  go.time.TimerPool = static class
  private

  public
    class method AddTimer(aTimer: Memory<go.time.runtimeTimer>);
    begin
      var lInterval := (aTimer.when - go.time.runtimeNano()) div 1000000; // ns to ms
      if lInterval < 0 then
        lInterval := go.math.MaxInt32;
      var lTimer := aTimer.pt;
      if lTimer = nil then begin
        lTimer := new PlatformTimer;
        aTimer.pt := lTimer;
      end;
      {$IF ISLAND}
      lTimer.Repeat := false;
      lTimer.Interval := lInterval;
      lTimer.Elapsed := (a)-> begin aTimer.f(aTimer.arg, aTimer.seq); end;
      {$ELSEIF ECHOES}
      lTimer.AutoReset := false;
      lTimer.Interval := lInterval;
      lTimer.Elapsed += new System.Timers.ElapsedEventHandler((s, e)-> begin aTimer.f(aTimer.arg, aTimer.seq); end);
      {$ENDIF}
      aTimer.pt := lTimer;
      lTimer.Start;
    end;

    class method StopTimer(aTimer: Memory<go.time.runtimeTimer>): Boolean;
    begin
      var lTimer := aTimer.pt;
      if lTimer = nil then exit;

      var lRes := lTimer.Enabled;
      if lRes then
        lTimer.Stop;
      exit lRes;
    end;
  end;

  go.time.__Global = public class
  assembly
    class var zoneSources: go.builtin.Slice<go.builtin.string> := GetZoneSources();

    class method GetZoneSources: go.builtin.Slice<go.builtin.string>;
    begin
      exit new go.builtin.Slice<go.builtin.string>(["/usr/share/zoneinfo/",
      "/usr/share/lib/zoneinfo/",
      "/usr/lib/locale/TZ/"]);
    end;

    class method initLocal;
    begin
      var (tz, ok) := go.syscall.Getenv("TZ");
      if (not ok) then begin
        var (z, err) := loadLocation("localtime", new go.builtin.Slice<go.builtin.string>(["/etc/"]));
        if err = nil then begin
          //localLoc := Memory<go.time.Location>.Get(z);
          localLoc := z^;
          localLoc.name := "Local";
          exit;
        end;
      end;
      if (tz <> '') and (tz <> 'UTC') then begin
         var (z, err) := loadLocation(tz, zoneSources);

        if err = nil  then begin
          //localLoc := Memory<go.time.Location>.Get(z);
          localLoc := z^;
          exit;
        end;
      end;

    // Fall back to UTC.
      localLoc.name := "UTC";
    end;

    class method open(name: String): tuple of (Stream, go.builtin.error);
    begin
      try
        {$IF ISLAND}
        if not RemObjects.Elements.System.File.Exists(name) then
          exit (nil, new ExceptionError(new Exception('File does not exists!')));
        {$ENDIF}
        exit (new FileStream(name, FileMode.Open, FileAccess.Read), nil);
      except
        on e: Exception do
          exit (nil, new ExceptionError(e));
       end;
    end;

    class method closefd(fs: Stream);
    begin
      fs.Close;
    end;

    class method preadn(fd: Stream; buff: go.builtin.Slice<Byte>; off: Integer): go.builtin.error;
    begin
      if off < 0 then
        fd.Position := fd.Length + off
       else
        fd.Position := off;
      fd.Read(buff.fArray, buff.fStart, buff.Length);
      exit nil;
    end;


    class method read(fd: Stream; buff: go.builtin.Slice<Byte>): tuple of (Integer, go.builtin.error);
    begin
      exit (fd.Read(buff.fArray, buff.fStart, buff.Length), nil);
    end;
  public
    class method startTimer(t: Memory<go.time.runtimeTimer>);
    begin
      go.time.TimerPool.AddTimer(t);
    end;

    class method stopTimer(t: Memory<go.time.runtimeTimer>): Boolean;
    begin
      exit go.time.TimerPool.StopTimer(t);
    end;

    class method runtimeNano(): Int64;
    begin
      exit DateTime.Now.Ticks * 100;
    end;

    class method Sleep(x: go.time.Duration);
    begin
      {$IF ISLAND}
      Thread.Sleep(x.Nanoseconds / 1000000);
      {$ELSEIF ECHOES}
      System.Threading.Thread.Sleep(x.Nanoseconds / 1000000);
      {$ENDIF}
    end;
  end;

  go.internal.bytealg.__Global = public partial class
  public

    class method Equal(a, b: go.builtin.Slice<Byte>): Boolean;
    begin
      if a = nil then a := new go.builtin.Slice<Byte>;
      if b = nil then b := new go.builtin.Slice<Byte>;
      if a.Length <> b.Length then exit false;

      for i: Integer := 0 to a.Length -1 do
        if a[i] <> b[i] then exit false;
      exit true;
    end;
  end;


  go.bytes.__Global = public partial class
  public
    /*class method IndexByte(b: go.builtin.Slice<Byte>; c: Byte): Integer;
    begin
      for i: Integer := 0 to b.Length -1 do
        if b[i] = c then exit i;
      exit -1;
    end;

    class method Equal(a, b: go.builtin.Slice<Byte>): Boolean;
    begin
      if a = nil then a := new go.builtin.Slice<Byte>;
      if b = nil then b := new go.builtin.Slice<Byte>;
      if a.Length <> b.Length then exit false;

      for i: Integer := 0 to a.Length -1 do
        if a[i] <> b[i] then exit false;
      exit true;
    end;

    class method Compare(a,b: go.builtin.Slice<Byte>) :Integer;
    begin
      if a = nil then a := new go.builtin.Slice<Byte>;
      if b = nil then b := new go.builtin.Slice<Byte>;
      for i: Integer := 0 to Math.Min(a.Length, b.Length) -1 do begin
        if a[i] < b[i] then exit -1;
        if a[i] > b[i] then exit 1;
      end;
      if a.Length < b.Length then
        exit -1;

      if a.Length > b.Length then
        exit 1;
      exit 0;
    end;*/

  end;

  go.path.filepath.__Global = public partial class
  public
    class method volumeNameLen(s: String): Integer;
    begin
      if defined('ECHOES') or defined('WINDOWS') then begin
        if defined('ECHOES') and (Environment.OSVersion.Platform = PlatformID.Win32NT) then begin
        end else exit 0;
        if length(s) < 0 then exit 0;
        if s[1] = ':' then exit 2;
      end ;
      exit 0;
    end;

    class method sameWord(a, b: String): Boolean;
    begin
      if defined('WINDOWS') or (defined('ECHOES') and (Environment.OSVersion.Platform = PlatformID.Win32NT)) then
        exit a.ToLowerInvariant = b.ToLowerInvariant;

      exit a = b;
    end;

  end;

  go.internal.bytealg.__Global = public partial class
  public
    const MaxBruteForce = 64;
    const MaxLen = Int32.MaxValue;

    class method Compare(a, b: go.builtin.Slice<Byte>): Integer;
    begin
      //exit go.bytes.Compare(a, b);
      if a = nil then a := new go.builtin.Slice<Byte>;
      if b = nil then b := new go.builtin.Slice<Byte>;
      for i: Integer := 0 to Math.Min(a.Length, b.Length) -1 do begin
        if a[i] < b[i] then exit -1;
        if a[i] > b[i] then exit 1;
      end;
      if a.Length < b.Length then
        exit -1;

      if a.Length > b.Length then
        exit 1;
      exit 0;
    end;
    class method Count(b: go.builtin.Slice<Byte>; c: Byte): Integer;
    begin
      for i: Integer := 0 to b.Length -1 do
        if b[i] = c then inc(resulT);
    end;

    class method CountString(b: String; c: Byte): Integer;
    begin
      for i: Integer := 0 to b.Length -1 do
        if b[i] = Char(c) then inc(resulT);
    end;

    class method IndexByte(b: go.builtin.Slice<Byte>; c: Byte): Integer;
    begin
      for i: Integer := 0 to b.Length -1 do
        if b[i] = c then exit i;
        exit -1;
    end;

    class method IndexByteString(b: String; c: Byte): Integer;
    begin
      for i: Integer := 0 to b.Length -1 do
        if b[i] = Char(c) then exit i;
        exit -1;
    end;

    class method &Index(a, b: go.builtin.Slice<Byte>): Integer;
    begin
      if b.Len > a.Len then
        exit(-1);

      for i: Integer := 0 to (a.Len - b.Len) do begin
        var lFound := true;
        for j: Integer := 0 to b.Len - 1 do begin
          if a[i+j] ≠ b[j] then begin
            lFound := false;
            break;
          end;
        end;
        if lFound then
          exit i;
      end;
      exit -1;
    end;

    class method IndexString(a, b: String): Integer;
    begin
      exit a.IndexOf(b);
    end;

    class method Cutover(nn: Integer): Integer;
    begin
      result :=  (nn + 16) / 8;
    end;
  end;

  go.strings.__Global= public partial class
  public

    class method IndexByte(b: String; c: Byte): Integer;
    begin
      for i: Integer := 0 to b.Length -1 do
        if b[i] = Char(c) then exit i;
        exit -1;
    end;
  end;

  [ValueTypeSemantics]
  go.strings.Builder = public class(go.io.Writer)
  private
    fStr: StringBuilder := new StringBuilder;
  public
    method Grow(i: Integer);
    begin
      fStr.Capacity := i;
    end;

    method Cap: Integer;
    begin
      exit fStr.Capacity;
    end;

    method Len: Integer;
    begin
      exit fStr.Length;
    end;

    method Reset;
    begin
      fStr.Clear;
    end;

    method String: String;
    begin
      exit fStr.ToString;
    end;

    method WriteString(s: String);
    begin
      fStr.Append(s);
    end;

    method WriteRune(c: Char);
    begin
      fStr.Append(c);
    end;

    method WriteByte(b: Byte);
    begin
      fStr.Append(Char(b));
    end;

    method Write(p: go.builtin.Slice<Byte>): tuple of (go.builtin.int, go.builtin.error);
    begin
      fStr.Append(Encoding.UTF8.GetString(p.fArray, p.fStart, p.fCount));
      exit (p.fCount, nil);
    end;
  end;

type
  [valueTypeSemantics]
  MemStats = public partial class
  public
  end;

  method ReadMemStats(m: Memory<MemStats>);
  begin

  end;

end.
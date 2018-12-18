namespace os;
{$IFDEF ECHOES}
uses
  System.IO, System.Diagnostics, System.Linq;
{$ENDIF}



// Flags to OpenFile wrapping those of the underlying system. Not all
// flags may be implemented on a given system.
const
    // Exactly one of O_RDONLY, O_WRONLY, or O_RDWR must be specified.
O_RDONLY : Integer = syscall.O_RDONLY; // open the file read-only.
O_WRONLY : Integer = syscall.O_WRONLY; // open the file write-only.
O_RDWR   : Integer = syscall.O_RDWR  ; // open the file read-write.
    // The remaining values may be or'ed in to control behavior.
O_APPEND : Integer = syscall.O_APPEND; // append data to the file when writing.
O_CREATE : Integer = syscall.O_CREAT ; // create a new file if none exists.
O_EXCL   : Integer = syscall.O_EXCL  ; // used with O_CREATE, file must not exist.
O_SYNC   : Integer = syscall.O_SYNC  ; // open for synchronous I/O.
O_TRUNC  : Integer = syscall.O_TRUNC ; // if possible, truncate file when opened.


// Seek whence values.
//
// Deprecated: Use io.SeekStart, io.SeekCurrent, and io.SeekEnd.

SEEK_SET : Integer = 0; // seek relative to the origin of the file
SEEK_CUR : Integer = 1; // seek relative to the current offset
SEEK_END : Integer = 2; // seek relative to the end



// A FileMode represents a file's mode and permission bits.
// The bits have the same definition on all systems, so that
// information about files can be moved from one system
// to another portably. Not all bits apply to all systems.
// The only required bit is ModeDir for directories.
type
  ProcessType = public {$IFDEF ECHOES}System.Diagnostics.Process{$ELSE}RemObjects.Elements.System.Process{$ENDIF};

  [AliasSemantics]
  FileMode = public record
  public
    Value: UInt32;
    method IsDir: Boolean;
    begin
      exit 0 <> (Value and ModeDir);
    end;

    method IsRegular: Boolean;
    begin
      exit 0 =  (Value and ModeType);
    end;

    method Perm: FileMode;
    begin
      exit Value and ModePerm;
    end;
  end;



// The defined file mode bits are the most significant bits of the FileMode.
// The nine least-significant bits are the standard Unix rwxrwxrwx permissions.
// The values of these bits should be considered part of the public API and
// may be used in wire protocols or disk representations: they must not be
// changed, although new bits might be added.
const
    // The single letters are the abbreviations
    // used by the String method's formatting.
ModeDir    :FileMode  = 1 shl (32 - 1 - 0); // d: is a directory
ModeAppend :FileMode= 1 shl (32 - 1 - 1); //a: append-only
ModeExclusive :FileMode = 1 shl (32 - 1 - 2); //l: exclusive use
ModeTemporary :FileMode = 1 shl (32 - 1 - 3); //T: temporary file; Plan 9 only
ModeSymlink :FileMode = 1 shl (32 - 1 - 4); //L: symbolic link
ModeDevice :FileMode = 1 shl (32 - 1 - 5); //D: device file
ModeNamedPipe :FileMode = 1 shl (32 - 1 - 6); //p: named pipe (FIFO)
ModeSocket  :FileMode= 1 shl (32 - 1 - 7); //S: Unix domain socket
ModeSetuid :FileMode = 1 shl (32 - 1 - 8); //u: setuid
ModeSetgid  :FileMode= 1 shl (32 - 1 - 9); //g: setgid
ModeCharDevice :FileMode = 1 shl (32 - 1 - 10); //c: Unix character device, when ModeDevice is set
ModeSticky :FileMode = 1 shl (32 - 1 - 11); //t: sticky
ModeIrregular  :FileMode= 1 shl(32 - 1 - 12); //non-regular file; nothing else is known about this file

    // Mask for the type bits. For regular files, none will be set.
ModeType :FileMode = ModeDir or ModeSymlink or ModeNamedPipe or ModeSocket or ModeDevice or ModeCharDevice or ModeIrregular;

ModePerm :FileMode= $1FF;// 0777calc // Unix permission bits



type
  internal.cpu.__Global = public partial class
  public
    const CacheLinePadSize = 32;

    class method doinit(); assembly;
    begin

    end;
  end;
  internal.poll.__Global = public partial class
  public

    class var ErrNoDeadline := errors.New("file type does not support deadline");
  end;
  __Global = public partial class
  public
    {$IF ISLAND}
    {$WARNING TODO FIX}
    class property Stdin: File := new File(fs := nil); lazy;
    class property Stderr: File := new File(fs := nil); lazy;
    class property Stdout: File := new File(fs := nil); lazy;
    {$ELSEIF ECHOES}
    class property Stdin: File := new File(fs := Console.OpenStandardInput); lazy;
    class property Stderr: File := new File(fs := Console.OpenStandardError); lazy;
    class property Stdout: File := new File(fs := Console.OpenStandardOutput); lazy;
    {$ENDIF}
  end;
  File = public partial class(io.ReaderAt, io.Reader, io.Writer)
  public
    fs: Stream;
    path: String;

    method Name: String;
    begin
      exit path;
    end;

    method ReadAt(p: builtin.Slice<builtin.byte>; off: Int64): tuple of (builtin.int, builtin.error);
    begin
      var pp := fs.Position;
      fs.Position := off;
      try
        var lStart := p.fStart;
        var lCount := p.fCount;
        while lCount > 0 do begin
          var c := fs.Read(p.fArray, lStart, lCount);
          if c = 0  then
            exit (p.fCount - lCount, errors.New('EOF'));
          lStart := lStart + c;
          lCount := lCount - c;
        end;
      except
        on e: Exception do
         exit (-1, errors.New(e.Message));
      end;
      fs.Position := pp;
      exit (p.fCount, nil);
    end;

    method Readdirnames(n: Integer): tuple of (builtin.Slice<String>, builtin.error);
    begin
      if n < 0 then n := Int32.MaxValue;
      try
        {$IF ISLAND}
        var lFolder := new Folder(path);
        var lFiles := lFolder.GetFiles;
        var lSubDirs := lFolder.GetSubfolders;
        var res := new String[lFiles.Count + lSubDirs.Count];
        for i: Integer := 0 to lFiles.Count - 1 do
          res[i] := lFiles[i].ToString;
        for i: Integer := 0 to lSubDirs.Count - 1 do
          res[i + lFiles.Count] := lSubDirs[i].ToString;
        {$ELSEIF ECHOES}
        var res := Directory.GetFileSystemEntries(path);
        {$ENDIF}

        if res.Length > n then begin
          var r := new String[n];
          Array.Copy(res, r, n);
          res := r;
        end;
        exit (new builtin.Slice<String>(res), nil);
      except
        on e: Exception do
          exit (nil, Errors.New(e.Message));
      end;
    end;


    method Readdir(n: Integer): tuple of (builtin.Slice<FileInfo>, builtin.error);
    begin
      if n < 0 then n := Int32.MaxValue;
      try
        {$IF ISLAND}
        var lFolder := new Folder(path);
        var lFiles := lFolder.GetFiles;
        var lSubDirs := lFolder.GetSubfolders;
        var res := new String[lFiles.Count + lSubDirs.Count];
        for i: Integer := 0 to lFiles.Count - 1 do
          res[i] := lFiles[i].ToString;
        for i: Integer := 0 to lSubDirs.Count - 1 do
          res[i + lFiles.Count] := lSubDirs[i].ToString;
        {$ELSEIF ECHOES}
        var res := Directory.GetFileSystemEntries(path);
        {$ENDIF}

        if n > res.Length then n := res.Length;
        var lRes := new FileInfo[n];
        for i: Integer := 0 to n -1 do
          lRes[i] := new MyFileInfo(res[i]);
        exit (new builtin.Slice<FileInfo>(lRes), nil);
      except
        on e: Exception do
          exit (nil, Errors.New(e.Message));
      end;
    end;

    method Stat: tuple of (FileInfo, builtin.error);
    begin
      exit (new MyFileInfo(path), nil);
    end;

    method Close: builtin.error;
    begin
      disposeAndNil(fs);

      exit nil;
    end;

    method &Read(p: builtin.Slice<builtin.byte>): tuple of (builtin.int, builtin.error);
    begin
      try
        var b := fs.Read(p.fArray, p.fStart, p.fCount);
        if b = -1 then exit (0, errors.New('EOF'));
        exit (b, nil);

      except
        on e: Exception do
          exit (0, Errors.New(e.Message));
      end;
    end;

    method &Write(p: builtin.Slice<builtin.byte>): tuple of (builtin.int, builtin.error);
    begin
      try
         fs.Write(p.fArray, p.fStart, p.fCount);
        exit (p.fCount, nil);

      except
        on e: Exception do
          exit (0, Errors.New(e.Message));
      end;
    end;

    method &Seek(offset: Int64; whence: Integer): tuple of (Int64, builtin.error);
    begin
      try
        exit (fs.Seek(offset, if whence = 0 then SeekOrigin.Begin else if whence = 2 then SeekOrigin.End else SeekOrigin.Current), nil);
     except
       on e: Exception do
         exit (0, Errors.New(e.Message));
     end;
    end;
  end;
  method Getwd: tuple of (string, builtin.error); public;
  begin
    exit (Environment.CurrentDirectory, nil);
  end;

  method executable(): tuple of (string, builtin.error); public;
  begin
    {$IF ISLAND AND WINDOWS}
    var lBuffer := new Char[rtl.MAX_PATH + 1];
    rtl.GetModuleFileName(nil, @lBuffer[0], length(lBuffer));
    result := (string.FromPChar(@lBuffer[0]), nil);
    {$ELSEIF ECHOES}
    var asm :=  &System.Reflection.Assembly.GetEntryAssembly();
    if asm = nil then exit (nil, Errors.New('Unknown entry assembly'));
    exit (asm.Location, nil);
    {$ENDIF}
  end;

  method Mkdir(name: string; perm :FileMode): builtin.error;
  begin
    try
      {$IF ISLAND}
      Folder.CreateFolder(name, false);
      {$ELSEIF ECHOES}
      System.IO.Directory.CreateDirectory(name);
      {$ENDIF}
      exit nil;
    except
      on e: Exception do
        exit errors.New(e.Message);
      end;
  end;

  method Remove(s: string): builtin.error;
  begin
    try
      {$IF ISLAND}
      var lFolder := new Folder(s);
      lFolder.Delete;
      {$ELSEIF ECHOES}
      if System.IO.File.Exists(s) then
        System.IO.File.Delete(s)
      else if System.IO.Directory.Exists(s) then
        System.IO.Directory.Delete(s)
      else
        exit errors.New('Not found');
      {$ENDIF}
      exit nil;
    except
      on e: Exception do
        exit errors.New(e.Message);
    end;
  end;

  method fixRootDirectory(s: string): string;
  begin
    if defined('WINDOWS') or (defined('ECHOES') and (Environment.OSVersion.Platform = PlatformID.Win32NT)) then begin
      if s.Length <3 then
        s := s +'\';
    end;
    exit s;
  end;

method &Create(name: string): tuple of (File, builtin.error); public;
begin
  try
  {$IF ISLAND}
  exit (new File(fs := new FileStream(name, RemObjects.Elements.System.FileMode.Create, FileAccess.ReadWrite), path := name), nil);
  {$ELSEIF ECHOES}
  exit (new File(fs := System.IO.File.Create(name), path := name), nil);
  {$ENDIF}
  except
    on e: Exception do
      exit (nil, errors.New(e.Message));
   end;
end;


method NewFile(fd: uint64; name: string): File;public;
begin
  raise new NotSupportedException;
end;


method &Open(name: string): tuple of (File, builtin.error);public;
begin
  try
    {$IF ISLAND}
    exit (new File(fs := new FileStream(name, RemObjects.Elements.System.FileMode.Open, FileAccess.Read), path := name), nil);
    {$ELSEIF ECHOES}
    exit (new File(fs := System.IO.File.OpenRead(name), path := name), nil);
    {$ENDIF}
  except
    on e: Exception do
      exit (nil, errors.New(e.Message));
   end;
end;

method &OpenFile(name: string; aFlags: Integer; perm: FileMode): tuple of (File, builtin.error);public;
begin
  try
    {$IF ISLAND}

    {$ERROR FIX THIS}
    exit (new File(fs := new FileStream(name, RemObjects.Elements.System.FileMode.Open, FileAccess.Read), path := name), nil);
    {$ELSEIF ECHOES}
    var lCreate := if (O_CREATE and aFlags) <> 0 then (if (O_EXCL and aFlags) <> 0 then System.IO.FileMode.CreateNew else System.IO.FileMode.Create) else
      if( O_APPEND and aFlags) <>0 then System.IO.FileMode.Append else System.IO.FileMode.Open;
    var lAccess :=
    if (O_RDONLY and aFlags) <> 0 then System.IO.FileAccess.Read else
      if (O_WRONLY and aFlags) <> 0 then System.IO.FileAccess.Write else System.IO.FileAccess.ReadWrite;
    exit (new File(fs := new System.IO.FileStream(name, lCreate, lAccess), path := name), nil);
    {$ENDIF}
  except
    on e: Exception do
      exit (nil, errors.New(e.Message));
  end;
end;
method hostname: tuple of (string, builtin.error);
begin
  {$IF ISLAND}
  raise new NotImplementedException;
  {$ELSEIF ECHOES}
  exit (Environment.MachineName, nil);
  {$ENDIF}
end;

var Args:  builtin.Slice<String> := new builtin.Slice<String>({$IF ISLAND}''{raise new NotImplementedException}{$ELSEIF ECHOES}Environment.GetCommandLineArgs{$ENDIF});

method &Exit(i: Integer);
begin
  {$IF ISLAND}
  raise new NotImplementedException;
  {$ELSEIF ECHOES}
  Environment.Exit(i);
  {$ENDIF}
end;

method lstatNolog(fn: string): tuple of(FileInfo, builtin.error);
begin
  {$IF ISLAND}
  var lFile := new RemObjects.Elements.System.File(fn);
  var lFolder := new Folder(fn);
  if lFile.Exists or lFolder.Exists then
    exit (new MyFileInfo(fn), nil);
  {$ELSEIF ECHOES}
  if System.IO.File.Exists(fn) or System.IO.Directory.Exists(fn) then
    exit (new MyFileInfo(fn), nil);
  {$ENDIF}
  exit (nil, errors.New('Not found '+fn));
end;

method statNolog(fn: string): tuple of (FileInfo, builtin.error);
begin
  {$IF ISLAND}
  var lFile := new RemObjects.Elements.System.File(fn);
  var lFolder := new Folder(fn);
  if lFile.Exists or lFolder.Exists then
    exit (new MyFileInfo(fn), nil);
  {$ELSEIF ECHOES}
  if System.IO.File.Exists(fn) or System.IO.Directory.Exists(fn) then
    exit (new MyFileInfo(fn), nil);
  {$ENDIF}
  exit (nil, errors.New('Not found '+fn));
end;

type

  FileInfo = public interface
    method Name: String;
    method Size: Int64;
    method Mode: FileMode;
    method ModTime: time.Time;
    method IsDir: Boolean;
    method Sys: Object;
  end;

  MyFileInfo = class(FileInfo)
  private
    fFile: String;
  public
    constructor(aFile: String); begin fFile := aFile; end;
    method Name: String; begin exit Path.GetFilename(fFile); end;
    method Size: Int64; begin {$IF ISLAND}exit new RemObjects.Elements.System.File(fFile).Length;{$ELSEIF ECHOES}exit new System.IO.FileInfo(fFile).Length;{$ENDIF} end;
    method Mode: FileMode;
    begin
      {$IF ISLAND}
      raise new NotImplementedException;
      {$ELSEIF ECHOES}
      var lAtt := System.IO.File.GetAttributes(fFile);
      result := new FileMode(Value := 0);
      if FileAttributes.Directory in lAtt then
        result.Value := result.Value or Integer(ModeDir);
      {$ENDIF}
    end;
    method ModTime: time.Time;
    begin
      {$IF ISLAND}
      raise new NotImplementedException;
      {$ELSEIF ECHOES}
      var lLast :=  System.IO.File.GetLastWriteTimeUtc(fFile);
      exit time.Date(lLast.Year, lLast.Month, lLast.Day, lLast.Hour, lLast.Minute, lLast.Second, lLast.Millisecond * 1000000, time.UTC);
      {$ENDIF}
    end;
    method IsDir: Boolean; begin {$IF ISLAND}exit new Folder(fFile).Exists;{$ELSEIF ECHOES}exit FileAttributes.Directory in System.IO.File.GetAttributes(fFile);{$ENDIF} end;
    method Sys: Object; begin exit fFile; end;
  end;

  [ValueTypeSemantics]
  fileStat = public class
  end;
  var PathSeparator: Char := {$IF ISLAND}Path.DirectorySeparatorChar{$ELSEIF ECHOES}System.IO.Path.DirectorySeparatorChar{$ENDIF}; readonly; public;
  var PathListSeparator:  Char := {$IF ISLAND}Path.ListSeparator{$ELSEIF ECHOES}System.IO.Path.PathSeparator{$ENDIF}; readonly;public;

  method IsPathSeparator(c: Char): Boolean; begin exit c = PathSeparator; end;
  method Readlink(name: string): tuple of (string, builtin.error);
  begin
    exit (nil, Errors.New('Not supported'));
  end;
type
  DiscardWriter = class(io.Writer)
  public
    method &Write(p: builtin.Slice<builtin.byte>): tuple of (builtin.int, builtin.error);
    begin
      exit (p.Length, nil);
    end;
  end;
  MyNopCloser = class(io.ReadCloser)
  private
    fReader: io.Reader;
  public
    constructor(aReader: io.Reader);
    begin
      fReader := aReader;
    end;

    method &Read(p: builtin.Slice<builtin.byte>): tuple of (builtin.int, builtin.error);
    begin
      exit fReader.Read(p);
    end;

    method Close: builtin.error;
    begin
      exit nil;
    end;

  end;
  io.ioutil.__Global = public partial class

  public
    class var Discard: io.Writer := new DiscardWriter;

    class method TempFile(dir, pattern: String): tuple of (builtin.Reference<os.File>, builtin.error);
    begin
      if String.IsNullOrEmpty(dir) then
        dir := Path.GetTempPath;
      exit (new builtin.Reference<os.File>(new os.File(fs := System.IO.File.Create(System.IO.Path.GetTempFileName))), nil);
    end;

    class method NopCloser(r: io.Reader): io.ReadCloser;
    begin
      exit new MyNopCloser(r);
    end;

    class method ReadFile(fn: String): tuple of (builtin.Slice<Byte>, builtin.error);
    begin
      var res := Open(fn);
      if res.Item2 <> nil then exit (nil, res.Item2);
      try
        exit ReadAll(res.Item1);
      finally
        res.Item1.Close;
      end;
    end;

    class method ReadAll(r: io.Reader): tuple of (builtin.Slice<Byte>, builtin.error);
    begin
      var ms := new MemoryStream;
      var b := new builtin.Slice<Byte>(512);
      loop begin
        var (res, i) := r.Read(b);
        if i <> nil then exit (nil, i);
        if res ≤ 0 then break;
        ms.Write(b.fArray, 0, res);
      end;
    end;
  end;

[ValueTypeSemantics]
LinkError = public class(builtin.error)
public
  Op: String;
  &Old: String;
  &New: String;
  Err: builtin.error;
  method Error(): String;
  begin
    exit Op + " " + &Old + " " + &New + ": " + &Err.Error()
  end;
end;

[ValueTypeSemantics]
Process= public partial class
public
  Process: ProcessType;
  property Pid: Integer read Process.Id;
  method Kill: builtin.error;
  begin
    try
      {$IF ISLAND}
      Process.Stop;
      {$ELSEIF ECHOES}
      Process.Kill;
      {$ENDIF}
      exit nil;
    except
      on e: Exception do
        exit errors.New(e.Message);
    end;
  end;

  method Release: builtin.error;
  begin
    Process.Dispose;
    exit nil;
  end;

  method Signal: builtin.error;
  begin
    exit errors.New('Not supported');
  end;

  method Wait: tuple of (builtin.Reference<ProcessState>, builtin.error);
  begin
    try
      {$IF ISLAND}
      Process.WaitFor;
      {$ELSEIF ECHOES}
      Process.WaitForExit;
      {$ENDIF}
      exit (new ProcessState(Process), nil);
    except
      on e: Exception do
        exit (nil, errors.New(e.Message));
    end;
  end;
end;
[ValueTypeSemantics]
ProcAttr = public class
public
  constructor; empty;
  Dir: String;
  Env: builtin.Slice<String>;
end;

method IntStartProcess(name: string; argv: builtin.Slice<string>; attr: builtin.Reference<ProcAttr>): tuple of (Reference<Process>, builtin.error);
begin
  var lPSI := new System.Diagnostics.ProcessStartInfo(name);
  if argv <> nil then begin
    for each el in argv do
      if string.IsNullOrEmpty(lPSI.Arguments) then begin
        lPSI.Arguments := '"'+el.Item2+'"';
      end else begin
        lPSI.Arguments := lPSI.Arguments+' "'+el.Item2+'"';
      end;
  end;
  lPSI.UseShellExecute := false;
  if (attr <> nil) then begin
    var p := builtin.Reference<ProcAttr>.Get(attr);
    if p <> nil then begin
      if p.Dir <> nil then
        lPSI.WorkingDirectory := p.Dir;
      if p.Env <> nil then
        for each el in p.Env do begin
          var n := el.Item2.Split(['='], 2);
          if n.Length <> 2 then continue;
          lPSI.EnvironmentVariables.Add(n[0], n[1]);
        end;
    end;
  end;
  try
    {$IF ISLAND}
    exit (new Process(Process := ProcessType.Run(lPSI)), nil);
    {$ELSEIF ECHOES}
    exit (new Process(Process := ProcessType.Start(lPSI)), nil);
    {$ENDIF}
  except
    on e: Exception do
      exit (nil, errors.New(e.Message));
  end;
end;

method StartProcess(name: string; argv: builtin.Slice<string>; attr: builtin.Reference<ProcAttr>): tuple of (Reference<Process>, builtin.error);
begin
  exit IntStartProcess(name, argv, attr);
end;

method FindProcess(pid: Integer): tuple of (builtin.Reference<Process>, builtin.error);
begin
  try
    var p := ProcessType.GetProcessById(pid);
    if p = nil then
      exit (nil, errors.New('No such process'));;
    exit (new Process(Process := p), nil);
  except
    on e: Exception do
      exit (nil, errors.New(e.Message));
  end;
  //exit (nil, errors.New('Not implemented'));
end;

end.
namespace go.os;

{$IF ISLAND}
uses
  RemObjects.Elements.System
{$IF DARWIN}
  , CoreFoundation, Security,
{$ENDIF}
  ;
{$ELSEIF ECHOES}
uses
  System.IO, System.Diagnostics, System.Collections.Generic, System.Linq;
{$ENDIF}



// Flags to OpenFile wrapping those of the underlying system. Not all
// flags may be implemented on a given system.
const
    // Exactly one of O_RDONLY, O_WRONLY, or O_RDWR must be specified.
O_RDONLY : Integer = go.syscall.O_RDONLY; // open the file read-only.
O_WRONLY : Integer = go.syscall.O_WRONLY; // open the file write-only.
O_RDWR   : Integer = go.syscall.O_RDWR  ; // open the file read-write.
    // The remaining values may be or'ed in to control behavior.
O_APPEND : Integer = go.syscall.O_APPEND; // append data to the file when writing.
O_CREATE : Integer = go.syscall.O_CREAT ; // create a new file if none exists.
O_EXCL   : Integer = go.syscall.O_EXCL  ; // used with O_CREATE, file must not exist.
O_SYNC   : Integer = go.syscall.O_SYNC  ; // open for synchronous I/O.
O_TRUNC  : Integer = go.syscall.O_TRUNC ; // if possible, truncate file when opened.


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
    constructor; empty;
    constructor(aValue: UInt32); begin Value := aValue;end;
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
  go.internal.cpu.__Global = public partial class
  public
    const CacheLinePadSize = 32;

    class method doinit(); assembly;
    begin

    end;
  end;
  go.internal.poll.__Global = public partial class
  public
    class var ErrNoDeadline := go.errors.New("file type does not support deadline");
  end;

  __Global = public partial class
  public
    {$IF ISLAND AND WINDOWS}
    class property Stdin: File := new File(fs := new FileStream(rtl.GetStdHandle(rtl.STD_INPUT_HANDLE), FileAccess.Read)); lazy; readonly;
    class property Stderr: File := new File(fs := new FileStream(rtl.GetStdHandle(rtl.STD_ERROR_HANDLE), FileAccess.Write)); lazy; readonly;
    class property Stdout: File := new File(fs := new FileStream(rtl.GetStdHandle(rtl.STD_OUTPUT_HANDLE), FileAccess.Write)); lazy; readonly;
    {$ELSEIF ISLAND AND ANDROID}
    class property Stdin: File := new File(fs := new NullStream()); lazy; readonly;
    class property Stderr: File := new File(fs := new NullStream()); lazy; readonly;
    class property Stdout: File := new File(fs := new NullStream()); lazy; readonly;
    {$ELSEIF ISLAND AND POSIX}
    class property Stdin: File := new File(fs := new FileStream(rtl.stdin, FileAccess.Read)); lazy; readonly;
    class property Stderr: File := new File(fs := new FileStream(rtl.stderr, FileAccess.Write)); lazy; readonly;
    class property Stdout: File := new File(fs := new FileStream(rtl.stdout, FileAccess.Write)); lazy; readonly;
    {$ELSEIF ECHOES}
    class property Stdin: File := new File(fs := Console.OpenStandardInput); lazy; readonly;
    class property Stderr: File := new File(fs := Console.OpenStandardError); lazy; readonly;
    class property Stdout: File := new File(fs := Console.OpenStandardOutput); lazy; readonly;
    {$ENDIF}

    {$IF (NOT ECHOES) AND NOT (ISLAND AND WINDOWS)}
    class method removeAll(path: String): go.builtin.error;
    begin
      // TODO
    end;
    {$ENDIF}
  end;

  File = public partial class(go.io.ReaderAt, go.io.Reader, go.io.Writer)
  unit
    {$IF ECHOES}
    fs: Stream;
    {$ELSE}
    fs: RemObjects.Elements.System.Stream;
    {$ENDIF}
    path: String;

  public
    method Name: String;
    begin
      exit path;
    end;

    method ReadAt(p: go.builtin.Slice<go.builtin.byte>; off: go.builtin.int64): tuple of (go.builtin.int, go.builtin.error);
    begin
      var pp := fs.Position;
      fs.Position := off;
      try
        var lStart := p.fStart;
        var lCount := p.fCount;
        while lCount > 0 do begin
          var c := fs.Read(p.fArray, lStart, lCount);
          if c = 0  then
            exit (p.fCount - lCount, go.errors.New('EOF'));
          lStart := lStart + c;
          lCount := lCount - c;
        end;
      except
        on e: Exception do
         exit (-1, go.errors.New(e.Message));
      end;
      fs.Position := pp;
      exit (p.fCount, nil);
    end;

    method Readdirnames(n: Integer): tuple of (go.builtin.Slice<go.builtin.string>, go.builtin.error);
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
        exit (go.builtin.string.PlatformStringArrayToGoSlice(res), nil);
      except
        on e: Exception do
          exit (nil, go.Errors.New(e.Message));
      end;
    end;


    method Readdir(n: go.builtin.int): tuple of (go.builtin.Slice<FileInfo>, go.builtin.error);
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
        exit (new go.builtin.Slice<FileInfo>(lRes), nil);
      except
        on e: Exception do
          exit (nil, go.Errors.New(e.Message));
      end;
    end;

    method Stat: tuple of (FileInfo, go.builtin.error);
    begin
      exit (new MyFileInfo(path), nil);
    end;

    method Close: go.builtin.error;
    begin
      disposeAndNil(fs);

      exit nil;
    end;

    method Sync();
    begin

    end;

    method &Read(p: go.builtin.Slice<go.builtin.byte>): tuple of (go.builtin.int, go.builtin.error);
    begin
      try
        var b := fs.Read(p.fArray, p.fStart, p.fCount);
        if b = -1 then exit (0, go.Errors.New('EOF'));
        exit (b, nil);

      except
        on e: Exception do
          exit (0, go.Errors.New(e.Message));
      end;
    end;

    method &Write(p: go.builtin.Slice<go.builtin.byte>): tuple of (go.builtin.int, go.builtin.error);
    begin
      try
         fs.Write(p.fArray, p.fStart, p.fCount);
        exit (p.fCount, nil);

      except
        on e: Exception do
          exit (0, go.Errors.New(e.Message));
      end;
    end;

    method WriteString(p: go.builtin.string): tuple of (go.builtin.int, go.builtin.error);
    begin
      exit &Write(p.Value);
    end;

    method &Seek(offset: go.builtin.int64; whence: go.builtin.int): tuple of (go.builtin.int64, go.builtin.error);
    begin
      try
        exit (fs.Seek(offset, if whence = 0 then SeekOrigin.Begin else if whence = 2 then SeekOrigin.End else SeekOrigin.Current), nil);
     except
       on e: Exception do
         exit (0, go.Errors.New(e.Message));
     end;
    end;
  end;
  method Getwd: tuple of (go.builtin.string, go.builtin.error); public;
  begin
    exit (Environment.CurrentDirectory, nil);
  end;

  method Chdir(p: String): go.builtin.error;
  begin
    try
      {$IFDEF ECHOES}
      Environment.CurrentDirectory := p;
      {$ELSE}
      raise new NotImplementedException;
      {$ENDIF}
    except
      on e: Exception do
        exit go.Errors.New(e.Message);
    end;
  end;

  method Getgid: Int64; public; empty;
  method Getuid: Int64; public; empty;
  method Geteuid: Int64; public; empty;
  method Getpid: Int64; public; empty;
  method Getppid: Int64; public; empty;

  method executable(): tuple of (go.builtin.string, go.builtin.error); public;
  begin
    {$IF ISLAND AND WINDOWS}
    var lBuffer := new Char[rtl.MAX_PATH + 1];
    rtl.GetModuleFileName(nil, @lBuffer[0], length(lBuffer));
    result := (new go.builtin.string(lBuffer), nil);
    {$ELSEIF ECHOES}
    var asm :=  &System.Reflection.Assembly.GetEntryAssembly();
    if asm = nil then exit ('', go.Errors.New('Unknown entry assembly'));
    exit (asm.Location, nil);
    {$ENDIF}
  end;

  method Mkdir(name: go.builtin.string; perm :FileMode): go.builtin.error;
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
        exit go.errors.New(e.Message);
      end;
  end;

  method Remove(s: go.builtin.string): go.builtin.error;
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
        exit go.errors.New('Not found');
      {$ENDIF}
      exit nil;
    except
      on e: Exception do
        exit go.errors.New(e.Message);
    end;
  end;

  method fixRootDirectory(s: go.builtin.string): go.builtin.string;
  begin
    if defined('WINDOWS') or (defined('ECHOES') and (Environment.OSVersion.Platform = PlatformID.Win32NT)) then begin
      if s.Length <3 then
        s := s +'\';
    end;
    exit s;
  end;

  method &Create(name: go.builtin.string): tuple of (File, go.builtin.error); public;
begin
  try
  {$IF ISLAND}
  exit (new File(fs := new FileStream(name, RemObjects.Elements.System.FileMode.Create, FileAccess.ReadWrite), path := name), nil);
  {$ELSEIF ECHOES}
  exit (new File(fs := System.IO.File.Create(name), path := name), nil);
  {$ENDIF}
  except
    on e: Exception do
      exit (nil, go.errors.New(e.Message));
   end;
end;


method NewFile(fd: go.builtin.uint64; name: go.builtin.string): File;public;
begin
  raise new NotSupportedException;
end;


method &Open(name: go.builtin.string): tuple of (File, go.builtin.error);public;
begin
  try
    {$IF ISLAND}
    exit (new File(fs := new FileStream(name, RemObjects.Elements.System.FileMode.Open, FileAccess.Read), path := name), nil);
    {$ELSEIF ECHOES}
    exit (new File(fs := System.IO.File.OpenRead(name), path := name), nil);
    {$ENDIF}
  except
    on e: Exception do
      exit (nil, go.errors.New(e.Message));
   end;
end;

method &OpenFile(name: go.builtin.string; aFlags: Integer; perm: FileMode): tuple of (File, go.builtin.error);public;
begin
  try
    {$IF ISLAND}
    var lCreate := if (O_CREATE and aFlags) <> 0 then (if (O_EXCL and aFlags) <> 0 then RemObjects.Elements.System.FileMode.CreateNew else RemObjects.Elements.System.FileMode.Create) else
      if( O_APPEND and aFlags) <> 0 then RemObjects.Elements.System.FileMode.Open else RemObjects.Elements.System.FileMode.Truncate;
    var lAccess :=
    if (O_RDONLY and aFlags) <> 0 then RemObjects.Elements.System.FileAccess.Read else
      if (O_WRONLY and aFlags) <> 0 then RemObjects.Elements.System.FileAccess.Write else RemObjects.Elements.System.FileAccess.ReadWrite;
    exit (new File(fs := new FileStream(name, lCreate, lAccess), path := name), nil);
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
      exit (nil, go.errors.New(e.Message));
  end;
end;
method hostname: tuple of (go.builtin.string, go.builtin.error);
begin
  {$IF ISLAND}
  raise new NotImplementedException;
  {$ELSEIF ECHOES}
  exit (Environment.MachineName, nil);
  {$ENDIF}
end;

{$IF ISLAND}
method GetArgs: array of String;
begin
  {$IF WINDOWS}
  var lTotal: Int32;
  var lRawArgs := rtl.CommandLineToArgvW(rtl.GetCommandLineW(), @lTotal);
  var lArgs := new String[lTotal - 1];
  for i: Integer := 1 to lTotal - 1 do
    lArgs[i-1] := String.FromPChar(lRawArgs[i]);
  exit lArgs;
  {$ELSE}
  var lArgs := new String[ExternalCalls.nargs];
  for i: Integer := 0 to ExternalCalls.nargs - 1 do
    lArgs[i] := String.FromPAnsiChars(ExternalCalls.args[i]);
  exit lArgs;
  {$ENDIF}
end;
{$ENDIF}

var Args: go.builtin.Slice<go.builtin.string> := go.builtin.string.PlatformStringArrayToGoSlice({$IF ISLAND}GetArgs{$ELSEIF ECHOES}Environment.GetCommandLineArgs{$ENDIF});

method &Exit(i: Integer);
begin
  {$IF ISLAND}
  raise new NotImplementedException;
  {$ELSEIF ECHOES}
  Environment.Exit(i);
  {$ENDIF}
end;

method lstatNolog(fn: go.builtin.string): tuple of(FileInfo, go.builtin.error);
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
  exit (nil, go.errors.New('Not found '+fn));
end;

method statNolog(fn: go.builtin.string): tuple of (FileInfo, go.builtin.error);
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
  exit (nil, go.errors.New('Not found '+fn));
end;

type

  FileInfo = public interface
    method Name: go.builtin.string;
    method Size: go.builtin.int64;
    method Mode: FileMode;
    method ModTime: go.time.Time;
    method IsDir: Boolean;
    method Sys: Object;
  end;

  MyFileInfo = class(FileInfo)
  private
    fFile: String;
  public
    constructor(aFile: String); begin fFile := aFile; end;
    method Name: go.builtin.string; begin exit Path.GetFileName(fFile); end;
    method Size: go.builtin.int64; begin {$IF ISLAND}exit new RemObjects.Elements.System.File(fFile).Length;{$ELSEIF ECHOES}exit new System.IO.FileInfo(fFile).Length;{$ENDIF} end;
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
    method ModTime: go.time.Time;
    begin
      {$IF ISLAND}
      raise new NotImplementedException;
      {$ELSEIF ECHOES}
      var lLast :=  System.IO.File.GetLastWriteTimeUtc(fFile);
      exit go.time.Date(lLast.Year, lLast.Month, lLast.Day, lLast.Hour, lLast.Minute, lLast.Second, lLast.Millisecond * 1000000, go.time.UTC);
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
  method Readlink(name: go.builtin.string): tuple of (go.builtin.string, go.builtin.error);
  begin
    exit ('', go.Errors.New('Not supported'));
  end;
type
  DiscardWriter = class(go.io.Writer)
  public
    method &Write(p: go.builtin.Slice<go.builtin.byte>): tuple of (go.builtin.int, go.builtin.error);
    begin
      exit (p.Length, nil);
    end;
  end;
  MyNopCloser = class(go.io.ReadCloser)
  private
    fReader: go.io.Reader;
  public
    constructor(aReader: go.io.Reader);
    begin
      fReader := aReader;
    end;

    method &Read(p: go.builtin.Slice<go.builtin.byte>): tuple of (go.builtin.int, go.builtin.error);
    begin
      exit fReader.Read(p);
    end;

    method Close: go.builtin.error;
    begin
      exit nil;
    end;

  end;
  go.io.ioutil.__Global = public partial class

  public
    class var Discard: go.io.Writer := new DiscardWriter;
    class method TempDir(dir, aPrefix: String): tuple of (go.builtin.string, go.builtin.error);
    begin
      {$IF ISLAND}
      if String.IsNullOrEmpty(dir) then
        dir := Environment.TempFolder.FullName;
      {$ELSEIF ECHOES}
      if String.IsNullOrEmpty(dir) then
        dir := Path.GetTempPath;
      {$ENDIF}

      dir := Path.Combine(dir, aPrefix+Guid.NewGuid.ToString.Replace('{','').Replace('}', '').Replace('-', ''));
      exit (dir, nil);
    end;
    class method WriteFile(filename: String; data: go.builtin.Slice<Byte>; per: go.os.FileMode): go.builtin.error;
    begin
      var res := OpenFile(filename, O_RDWR or O_CREATE, per); // 0755
      if res.Item2 <> nil then exit res.Item2;
      try
        var res2 := res.Item1.Write(data);
        if (res2.Item2 <> nil) then
          exit res2.Item2;
      finally
        res.Item1.Close;
      end;
      exit nil;
    end;
    class method ReadDir(dir: String): tuple of (go.builtin.Slice<go.os.FileInfo>, go.builtin.error);
    begin
      try
        exit new File(path := dir).Readdir(-1);
      except
        on e: Exception do
          exit (nil, go.errors.New(e.Message));
      end;
    end;

    class method TempFile(dir, pattern: String): tuple of (Memory<go.os.File>, go.builtin.error);
    begin
      {$IF ISLAND}
      if String.IsNullOrEmpty(dir) then
        dir := Environment.TempFolder.FullName;
      exit (new Memory<go.os.File>(new go.os.File(fs := new FileStream(Path.Combine(dir, pattern+Guid.NewGuid.ToString.Replace('{','').Replace('}', '').Replace('-', '')), :System.FileMode.Create, :System.FileAccess.ReadWrite))), nil);
      // TODO
      {$ELSEIF ECHOES}
      if String.IsNullOrEmpty(dir) then
        dir := Path.GetTempPath;
      exit (new Memory<go.os.File>(new go.os.File(fs := System.IO.File.Create(System.IO.Path.GetTempFileName))), nil);
      {$ENDIF}
    end;

    class method NopCloser(r: go.io.Reader): go.io.ReadCloser;
    begin
      exit new MyNopCloser(r);
    end;

    class method ReadFile(fn: String): tuple of (go.builtin.Slice<Byte>, go.builtin.error);
    begin
      var res := Open(fn);
      if res.Item2 <> nil then exit (nil, res.Item2);
      try
        exit ReadAll(res.Item1);
      finally
        res.Item1.Close;
      end;
    end;

    class method ReadAll(r: go.io.Reader): tuple of (go.builtin.Slice<Byte>, go.builtin.error);
    begin
      var ms := new MemoryStream;
      var b := new go.builtin.Slice<Byte>(512);
      loop begin
        var (res, i) := r.Read(b);
        if i <> nil then begin
          ms.Write(b.fArray, 0, res);
          if (i is go.errors.errorString) and (i.Error() = "EOF") then
            exit (ms.ToArray(), nil)
          else
            exit (ms.ToArray(), i);
        end;
        if res ≤ 0 then break;
        ms.Write(b.fArray, 0, res);
      end;
      exit(ms.ToArray(), nil);
    end;
  end;

[ValueTypeSemantics]
LinkError = public class(go.builtin.error)
public
  Op: String;
  &Old: String;
  &New: String;
  Err: go.builtin.error;
  method Error(): go.builtin.string;
  begin
    exit Op + " " + &Old + " " + &New + ": " + &Err.Error()
  end;
end;

[ValueTypeSemantics]
Process= public partial class
public
  Process: ProcessType;
  property Pid: Integer read Process.Id;
  method Kill: go.builtin.error;
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
        exit go.errors.New(e.Message);
    end;
  end;

  method Release: go.builtin.error;
  begin
    {$IF ISLAND}
    // TODO
    {$ELSEIF ECHOES}
    Process.Dispose;
    {$ENDIF}
    exit nil;
  end;

  method Signal: go.builtin.error;
  begin
    exit go.errors.New('Not supported');
  end;

  method Wait: tuple of (Memory<ProcessState>, go.builtin.error);
  begin
    try
      {$IF ISLAND}
      Process.WaitFor;
      {$ELSEIF ECHOES}
      Process.WaitForExit;
      {$ENDIF}
      exit (Memory<ProcessState>(new ProcessState(Process)), nil);
    except
      on e: Exception do
        exit (nil, go.errors.New(e.Message));
    end;
  end;
end;
[ValueTypeSemantics]
ProcAttr = public class
public
  constructor; empty;
  Dir: String;
  Env: go.builtin.Slice<go.builtin.string>;
end;

method IntStartProcess(name: go.builtin.string; argv: go.builtin.Slice<go.builtin.string>; attr: Memory<ProcAttr>): tuple of (Memory<Process>, go.builtin.error);
begin
  var lArgv := new List<String>();
  if argv <> nil then begin
    for each el in argv do
      lArgv.Add(el[1]);
  end;

  var lEnv := new Dictionary<String, String>();
  var lWorkingDir := '';
  if (attr <> nil) then begin
    var p := attr^;
    if p <> nil then begin
      if p.Dir <> nil then
        lWorkingDir := p.Dir;
      if p.Env <> nil then
        for each el in p.Env do begin
          var n := go.strings.SplitN(el[1], '=', 2);
          if n.Length <> 2 then continue;
          lEnv.Add(n[0], n[1]);
        end;
    end;
  end;
  {$IF ECHOES}
  var lPSI := new System.Diagnostics.ProcessStartInfo(name);
  for each el in lArgv do
    if go.builtin.string.IsNullOrEmpty(lPSI.Arguments) then begin
      lPSI.Arguments := '"'+ el +'"';
    end else begin
      lPSI.Arguments := lPSI.Arguments+' "' + el + '"';
    end;

  lPSI.UseShellExecute := false;
  lPSI.WorkingDirectory := lWorkingDir;

  for each el in lEnv do
    lPSI.EnvironmentVariables.Add(el.Key, el.Value);
  {$ENDIF}
  try
    {$IF ISLAND}
    var lProcess := new ProcessType(name, lArgv, lEnv, lWorkingDir);
    lProcess.RedirectOutput := true;
    lProcess.Start;
    exit (Memory<Process>(new Process(Process := lProcess)), nil);
    {$ELSEIF ECHOES}
    exit (Memory<Process>(new Process(Process := ProcessType.Start(lPSI))), nil);
    {$ENDIF}
  except
    on e: Exception do
      exit (nil, go.errors.New(e.Message));
  end;
end;

method StartProcess(name: go.builtin.string; argv: go.builtin.Slice<go.builtin.string>; attr: Memory<ProcAttr>): tuple of (Memory<Process>, go.builtin.error);
begin
  exit IntStartProcess(name, argv, attr);
end;

method FindProcess(pid: Integer): tuple of (Memory<Process>, go.builtin.error);
begin
  try
    {$IF ISLAND}
    var p: ProcessType := nil; // TODO
    {$ELSEIF ECHOES}
    var p := ProcessType.GetProcessById(pid);
    {$ENDIF}
    if p = nil then
      exit (nil, go.errors.New('No such process'));;
    exit (Memory<Process>(new Process(Process := p)), nil);
  except
    on e: Exception do
      exit (nil, go.errors.New(e.Message));
  end;
end;

type
go.crypto.x509.__Global = public partial class
{$IF ISLAND AND DARWIN AND NOT (IOS OR TVOS OR WATCHOS)}
  class method FetchPEMRoots(pemRoots: ^CFDataRef; untrustedPemRoots: ^CFDataRef): Integer;
  begin
    var domains: array of SecTrustSettingsDomain := [SecTrustSettingsDomain.kSecTrustSettingsDomainSystem, SecTrustSettingsDomain.kSecTrustSettingsDomainAdmin,
                                                     SecTrustSettingsDomain.kSecTrustSettingsDomainUser];
    var numDomains := sizeOf(domains) / sizeOf(SecTrustSettingsDomain);
    if pemRoots = nil then
      exit -1;

    var policy: CFStringRef := CFStringCreateWithCString(NULL, "kSecTrustSettingsResult", CFStringBuiltInEncodings.kCFStringEncodingUTF8);
    var combinedData: CFMutableDataRef := CFDataCreateMutable(kCFAllocatorDefault, 0);
    var combinedUntrustedData: CFMutableDataRef := CFDataCreateMutable(kCFAllocatorDefault, 0);
    var appendTo: CFMutableDataRef;
    for i: Integer := 0 to numDomains - 1 do begin
      var j: Integer;
      var certs: CFArrayRef := nil;
      var err: OSStatus := SecTrustSettingsCopyCertificates(domains[i], @certs);
      if err <> rtl.noErr then
        continue;

      var untrusted: Integer := 0;
      var trustAsRoot: Integer := 0;
      var trustRoot: Integer := 0;
      var numCerts: CFIndex := CFArrayGetCount(certs);

      for j: Integer := 0 to  numCerts - 1 do begin
        var data: CFDataRef := nil;
        var errRef: CFErrorRef := nil;
        var trustSettings: CFArrayRef := nil;
        var cert: SecCertificateRef := SecCertificateRef(CFArrayGetValueAtIndex(certs, j));
        if cert = nil then
          continue;
        // We only want trusted certs.
        untrusted := 0;
        trustAsRoot := 0;
        trustRoot := 0;
        if i = 0 then
          trustAsRoot := 1
        else begin
          var k: Integer;
          var m: CFIndex;
          // Certs found in the system domain are always trusted. If the user
          // configures "Never Trust" on such a cert, it will also be found in the
          // admin or user domain, causing it to be added to untrustedPemRoots. The
          // Go code will then clean this up.

          // Trust may be stored in any of the domains. According to Apple's
          // SecTrustServer.c, "user trust settings overrule admin trust settings",
          // so take the last trust settings array we find.
          // Skip the system domain since it is always trusted.
          for k := i to numDomains - 1 do begin
            var domainTrustSettings: CFArrayRef := nil;
            err := SecTrustSettingsCopyTrustSettings(cert, domains[k], @domainTrustSettings);
            if (err = errSecSuccess) and (domainTrustSettings <> nil) then begin
              if trustSettings ≠ nil then
                CFRelease(trustSettings);
              trustSettings := domainTrustSettings;
            end;
          end;

          if trustSettings = nil then
            // "this certificate must be verified to a known trusted certificate"; aka not a root.
            continue;

          for m := 0 to CFArrayGetCount(trustSettings) - 1 do begin
            var cfNum: CFNumberRef;
            var tSetting: CFDictionaryRef := CFDictionaryRef(CFArrayGetValueAtIndex(trustSettings, m));
            if CFDictionaryGetValueIfPresent(tSetting, policy, @cfNum) then begin
              var lResult: SecTrustSettingsResult := SecTrustSettingsResult.kSecTrustSettingsResultUnspecified;
              CFNumberGetValue(cfNum, CFNumberType.kCFNumberSInt32Type, ^Void(@lResult));
              // TODO: The rest of the dictionary specifies conditions for evaluation.
              if lResult = SecTrustSettingsResult.kSecTrustSettingsResultDeny then
                untrusted := 1
              else
                if lResult = SecTrustSettingsResult.kSecTrustSettingsResultTrustAsRoot then
                  trustAsRoot := 1
                else
                  if lResult = SecTrustSettingsResult.kSecTrustSettingsResultTrustRoot then
                    trustRoot := 1
            end;
          end;
          CFRelease(trustSettings);
        end;

        if trustRoot > 0 then begin
          // We only want to add Root CAs, so make sure Subject and Issuer Name match
          var subjectName: CFDataRef := SecCertificateCopyNormalizedSubjectContent(cert, @errRef);
          if errRef ≠ nil then begin
            CFRelease(errRef);
            continue;
          end;
          var issuerName: CFDataRef := SecCertificateCopyNormalizedIssuerContent(cert, @errRef);
          if errRef ≠ nil then begin
            CFRelease(subjectName);
            CFRelease(errRef);
            continue;
          end;
          var equal: Boolean := CFEqual(subjectName, issuerName);
          CFRelease(subjectName);
          CFRelease(issuerName);
          if not equal then
            continue;
        end;

        err := SecItemExport(cert, SecExternalFormat.kSecFormatX509Cert, SecItemImportExportFlags.kSecItemPemArmour, nil, @data);
        if err ≠ rtl.noErr then
          continue;

        if data ≠ nil then begin
          if (trustRoot = 0) and (trustAsRoot = 0) then
            untrusted := 1;

          appendTo := if untrusted = 1 then combinedUntrustedData else combinedData;
          CFDataAppendBytes(appendTo, CFDataGetBytePtr(data), CFDataGetLength(data));
          CFRelease(data);
        end;
      end;
      CFRelease(certs);
    end;

    CFRelease(policy);
    pemRoots^ := combinedData;
    untrustedPemRoots^ := combinedUntrustedData;
    exit(0);
  end;

  class method loadSystemRoots: tuple of (Memory<go.crypto.x509.CertPool>, go.builtin.error);
  begin
    var roots := NewCertPool();
    var data: CFDataRef := 0;
    var untrustedData: CFDataRef := 0;
    var err := FetchPEMRoots(@data, @untrustedData);
    if err = -1 then
      exit (nil, go.errors.New("crypto/x509: failed to load darwin system roots with cgo"));

    var buf := CFDataGetBytePtr(data);
    var lTotal := CFDataGetLength(data);
    var lSlice := new go.builtin.Slice<go.builtin.byte>(lTotal);
    for i: Integer := 0 to lTotal - 1 do begin
      lSlice[i] := buf^;
      inc(buf);
    end;

    //roots.AppendCertsFromPEM(lSlice);
    go.crypto.x509.CertPool.AppendCertsFromPEM(roots, lSlice);
    if untrustedData = nil then begin
      CFRelease(data);
      exit (roots, nil);
    end;
    buf := CFDataGetBytePtr(untrustedData);
    lTotal := CFDataGetLength(untrustedData);
    var untrustedRoots := NewCertPool();
    lSlice := new go.builtin.Slice<go.builtin.byte>(lTotal);
    for i: Integer := 0 to lTotal - 1 do begin
      lSlice[i] := buf^;
      inc(buf);
    end;
    //untrustedRoots.AppendCertsFromPEM(lSlice);
    go.crypto.x509.CertPool.AppendCertsFromPEM(untrustedRoots, lSlice);
    var trustedRoots := go.crypto.x509.NewCertPool();
    for lCert in roots.certs do
      //if not untrustedRoots.contains(lCert[1]) then begin
      if not go.crypto.x509.CertPool.contains(untrustedRoots, lCert[1]) then begin
        //trustedRoots.AddCert(lCert[1]);
        go.crypto.x509.CertPool.AddCert(trustedRoots, lCert[1]);
      end;

    CFRelease(data);
    CFRelease(untrustedData);
    exit (trustedRoots, nil);
  end;
{$ENDIF}
end;

end.
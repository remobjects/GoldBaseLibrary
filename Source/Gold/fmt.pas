namespace go.fmt;

uses go.fmt {$IFDEF CLR}, System.Linq {$ENDIF};

method Errorf(fmt: String; params x: array of Object): builtin.error; public;
begin
  exit errors.New(Sprintf(fmt, x));
end;

method Fprintf(w: io.Writer; fmt: String; params x: array of Object): tuple of (Integer, builtin.error); public;
begin
  {$IFDEF CLR}
  exit w.Write(new builtin.Slice<Byte>(System.Text.Encoding.UTF8.GetBytes(Sprintf(fmt, x))));
  {$ELSE}
  exit w.Write(new builtin.Slice<Byte>(Encoding.UTF8.GetBytes(Sprintf(fmt, x))));
  {$ENDIF}
end;

method Fprintln(w: io.Writer;  params x: array of Object): tuple of (Integer, builtin.error); public;
begin
  {$IFDEF CLR}
  exit w.Write(new builtin.Slice<Byte>(System.Text.Encoding.UTF8.GetBytes(Sprint(x) + Environment.NewLine)));
  {$ELSE}
  exit w.Write(new builtin.Slice<Byte>(Encoding.UTF8.GetBytes(Sprint(x)+ Environment.NewLine)));
  {$ENDIF}
end;

method Fprint(w: io.Writer;  params x: array of Object): tuple of (Integer, builtin.error); public;
begin
  {$IFDEF CLR}
  exit w.Write(new builtin.Slice<Byte>(System.Text.Encoding.UTF8.GetBytes(Sprint(x))));
  {$ELSE}
  exit w.Write(new builtin.Slice<Byte>(Encoding.UTF8.GetBytes(Sprint(x))));
  {$ENDIF}
end;

method Sprintln(params x: array of Object): String; public;
begin
  exit Sprint(x)+Environment.NewLine;
end;

method Sprintf(fmt: String; params x: array of Object): String; public;
begin
  raise new NotImplementedException();
end;

method Sprint(params x: array of Object): String; public;
begin
  if length(x) = 0 then exit '';
  var s := coalesce(x[0]:ToString, '');
  var lastwasstring := x[0] is String;
  for i: Integer := 1 to length(x) -1 do begin
    var val := coalesce(x[i]:ToString, '');
    if not (x[i] is String) and not (lastwasstring) then
      s := s + ' ' + val
    else
      s := s + val;
    lastwasstring := s[i] is String;
  end;
  exit s;
end;

method Println(params x: array of Object); public;
begin
  writeLn(Sprint(x));
end;

method Print(params x: array of Object); public;
begin
  write(Sprint(x));
end;

method Printf(s: String; params x: array of Object); public;
begin
  writeLn(Sprintf(s, x));
end;


method Sscan(str: String; params args: array of Object): tuple of (Integer, builtin.error);
begin
  var v := str.Split([#9, #32], StringSplitOptions.RemoveEmptyEntries);
  for i: Integer := 0 to Math.Min(args.Length, v.Length) -1 do begin
    if args[i] is builtin.IReference then
      builtin.IReference(args[i]).Set(v[i])
    else
      args[i] := v[i];
  end;

  if v.Length > args.Length then begin
    exit (args.Length, Errors.new('Got '+v.Length+' items'));
  end;
  exit (v.Length, nil);
end;

method Sscanf(str, fmt: String; params args: array of Object): tuple of (Integer, builtin.error);
begin
  exit Sscan(str, args);
end;

method Sscanln(str: String; params args: array of Object): tuple of (Integer, builtin.error);
begin
  exit Sscan(str.TrimEnd([#13, #10]), args);
end;

type
  Stringer = public interface
    method String(): builtin.string;
  end;
  GoStringer = public interface
    method GoString(): builtin.string;
  end;
end.
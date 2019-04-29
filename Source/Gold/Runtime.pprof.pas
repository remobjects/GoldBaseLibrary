namespace go.runtime.pprof;

method StartCPUProfile(w: go.io.Writer): go.builtin.error;
begin
end;

method StopCPUProfile;
begin
end;

method Lookup(name: go.builtin.string): go.builtin.Reference<Profile>;
begin
end;

type
  Profile = public partial class
  public
    method WriteTo(w: go.io.Writer; debug: Integer): go.builtin.error;
    begin

    end;
  end;

end.
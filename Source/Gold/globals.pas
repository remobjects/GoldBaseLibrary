namespace go.google.golang.org.protobuf.internal.impl;
//namespace go.google.golang.org.protobuf.runtime.protoimpl;

//go.google.golang.org.protobuf.runtime.protoimpl.Pointer
type
  Pointer = public partial record
    operator Explicit<T>(aVal: Pointer): go.builtin.Reference<T>;
    begin
      // TODO
    end;

    operator Implicit<T>(aVal: go.builtin.Reference<T>): Pointer;
    begin
      // TODO
    end;

    operator Implicit<T>(aVal: Pointer): go.builtin.Reference<T>;
    begin
      // TODO
    end;
  end;

{type
  go.google.golang.org.protobuf.runtime.protoimpl.Pointer = public partial record

  end;}

{type
  go.google.golang.org.protobuf.runtime.protoimpl.__Global = public partial class
    operator implicit<T>(aVal: go.google.golang.org.protobuf.runtime.protoimpl.Pointer): go.builtin.Reference<T>;
    begin
      // TODO
    end;

    operator Implicit<T>(aVal: go.builtin.Reference<T>): go.google.golang.org.protobuf.runtime.protoimpl.Pointer;
    begin

    end;
  end;}


end.
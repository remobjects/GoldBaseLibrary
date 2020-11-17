namespace go.unsafe;

type
  ArbiraryType = go.builtin.int;

  Pointer = public class(go.builtin.Reference<go.builtin.int>)
  public
    constructor(aInt: go.builtin.int);
    begin
      inherited(aInt);
    end;

    class operator Implicit(aVal: go.builtin.int): Pointer;
    begin
      result := new Pointer(aVal);
    end;

    class operator Implicit(aVal: Pointer): go.builtin.string;
    begin

    end;

    class operator Implicit(aVal: Pointer): go.builtin.bool; public;
    begin

    end;

    class operator Implicit(aVal: Object): Pointer; public;
    begin

    end;

    /*class operator Explicit(aVal: Pointer): go.builtin.Reference<go.builtin.bool>; public;
    begin

    end;

    class operator implicit(aVal: Pointer): go.builtin.Reference<go.builtin.bool>; public;
    begin

    end;*/


    //class operator explicit(aVal: Pointer): go.builtin.Reference<go.builtin.bool>; public;
    //begin

    //end;
  end;

  {operator implicit(aVal: go.builtin.int): Pointer; public;
  begin

  end;

  operator Explicit(aVal: Pointer): go.builtin.Reference<System.Boolean>;
  begin

  end;}

  //operator Implicit(aVal: go.builtin.Reference<ArbiraryType>): go.builtin.Reference<go.builtin.bool>; public;
  //begin

  //end;

{  type
  go.unsafe.__Global = public partial class
  operator Explicit(aVal: Pointer): go.builtin.Reference<Boolean>; public;
  begin

  end;
  end;
}
  {operator Explicit(aVal: go.builtin.Reference<go.builtin.int>): go.builtin.Reference<go.builtin.bool>; public;
  begin

  end;}

  {operator Implicit(aVal: go.builtin.Reference<go.builtin.int>): go.builtin.Reference<Boolean>; public;
  begin

  end;

  operator Implicit(aVal: go.builtin.Reference<go.builtin.int>): go.builtin.Reference<go.builtin.bool>; public;
  begin

  end;}




  //func Sizeof(x ArbitraryType) uintptr
  //func Sizeof(x ArbitraryType) uintptr
  //func Alignof(x ArbitraryType) uintptr

end.
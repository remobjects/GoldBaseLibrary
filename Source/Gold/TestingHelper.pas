namespace go.testing;

{$IF ECHOES}
uses
  System.Reflection, System.Collections.Generic;
{$ENDIF}

type
  TestHelper = public partial class
  private
    class method DiscoverTestsFrom(aType: System.Type): List<MethodInfo>;
    begin

    end;

  public
    class var AllTests: Dictionary<String, List<MethodInfo>> := new Dictionary<String, List<MethodInfo>>();
    class method DiscoverTests;
    begin
      {$IF ISLAND}
      // TODO
      {$ELSEIF ECHOES}
      var lAllTypes := &Assembly.GetExecutingAssembly().GetTypes();
      var lTests: List<MethodInfo>;
      for each lType in lAllTypes do begin
        if lType.Name.EndsWith('.__Global') then begin
          lTests := DiscoverTestsFrom(lType);
          if lTests.Count > 0 then
            AllTests.Add(lType.Name, lTests);
        end;
      end;
      {$ENDIF}
    end;
  end;

end.
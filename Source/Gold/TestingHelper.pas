namespace go.testing;

{$IF ECHOES}
uses
  System.Reflection, System.Collections.Generic;
{$ENDIF}

type
  TestHelper = public partial class
  private
    class method DiscoverTestsFrom(aType: System.Type): go.builtin.Slice<InternalTest>;
    begin
      writeLn('-----------------Discover: ' + aType.FullName);
      var lTests := new List<InternalTest>();
      for each lMethod in aType.GetMethods do begin
        if lMethod.Name.StartsWith('Test') then begin
          var lTest := new InternalTest();
          lTest.Name := lMethod.Name;
          lTest.F := (t)-> lMethod.Invoke(aType, [t]);
          lTests.Add(lTest);
          //result.Add(lMethod);
          writeLn(lMethod.Name);
        end;
      end;
      result := new go.builtin.Slice<InternalTest>(lTests.ToArray);
    end;

  public
    class var AllTests: Dictionary<String, go.builtin.Slice<InternalTest>> := new Dictionary<String, go.builtin.Slice<InternalTest>>();
    class method DiscoverTests;
    begin
      {$IF ISLAND}
      // TODO
      {$ELSEIF ECHOES}
      var lAllTypes := &Assembly.GetExecutingAssembly().GetTypes();
      var lTests: go.builtin.Slice<InternalTest>;
      for each lType in lAllTypes do begin
        if lType.FullName.EndsWith('.__Global') then begin
          lTests := DiscoverTestsFrom(lType);
          if lTests.Length > 0 then
            AllTests.Add(lType.FullName, lTests);
        end;
      end;
      {$ENDIF}
    end;

    class method GetTestsFor(aSuite: String): go.builtin.Slice<InternalTest>;
    begin
      result := AllTests[aSuite];
    end;
  end;

end.
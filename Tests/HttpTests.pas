namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  HttpTests = public class(Test)
  public
    method Get;
    begin
      {$IF NOT LINUX}
      TestApplication2.DoGetTest();
      {$ENDIF}
    end;

    method SSLGet;
    begin
      {$IF NOT LINUX}
      TestApplication2.DoSSLGetTest();
      {$ENDIF}
    end;

  end;

end.
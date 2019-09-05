namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  HttpTests = public class(Test)
  public
    method Get;
    begin
      TestApplication2.DoGetTest();
    end;

    method SSLGet;
    begin
      {$IF ECHOES}
      TestApplication2.DoSSLGetTest();
      {$ELSE}
      raise new Exception('Fails or Island');
      {$ENDIF}
    end;

  end;

end.
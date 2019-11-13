﻿namespace GoldLibrary.Tests.Shared;

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
      TestApplication2.DoSSLGetTest();
    end;

  end;

end.
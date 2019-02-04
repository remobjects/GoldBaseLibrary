namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  HtmlTests = public class(Test)
  public
    method HtmlUnescapeStringTest;
    begin
      Assert.AreEqual(TestApplication2.DoHtmlUnescapeStringTest(), """Fran & Freddie's Diner"" <tasty@example.com>");
    end;
  end;

end.
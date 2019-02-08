namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  HtmlTests = public class(Test)
  public
    method HtmlUnescapeStringTest;
    begin
      Assert.AreEqual(TestApplication2.DoHtmlUnescapeStringTest(), """Fran & Freddie's Diner"" <tasty@example.com>");
      Assert.AreEqual(TestApplication2.DoHtmlEscapeStringTest("&"), "&amp;");
      Assert.AreEqual(TestApplication2.DoHtmlEscapeStringTest("&<ok"), "&amp;&lt;ok");
    end;

    method HtmlTemplateTest;
    begin
      TestApplication2.DoHtmlTemplatesTest();
    end;
  end;

end.
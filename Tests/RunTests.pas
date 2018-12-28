namespace GoldLibrary.Tests.Shared;

interface

uses
  RemObjects.Elements.EUnit;

method RunTests;

implementation

method RunTests;
begin
  var lTests := Discovery.DiscoverTests();
  Runner.RunTests(lTests) withListener(Runner.DefaultListener);
end;

end.
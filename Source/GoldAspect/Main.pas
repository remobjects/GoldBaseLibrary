namespace GoldAspect;


uses
  System.Linq,
  RemObjects.Elements.Cirrus.*;

type
  // we use this class to work around compiler issues in Gold.
  [AttributeUsage(AttributeTargets.Assembly)]
  GoldFixer = public partial class(Attribute, IAssemblyInterfaceDecorator)
  public
    method HandleInterface(Services: IServices);
    begin
      var lType := Services.GetType('net.http.atomicBool');
      // Patch these functions
      var lIsSet := lType.GetMethods('isSet').First as IMethodDefinition;
      lIsSet.ReplaceMethodBody(
        new ExitStatement(
        new BinaryValue(new ProcValue(new TypeValue(Services.GetType('sync.atomic.__Global')), 'LoadInteger', [new FieldValue(new SelfValue(), lType, 'Value')]), new DataValue(0), BinaryOperator.NotEqual)
        ));
      var lsetTrue := lType.GetMethods('setTrue').First as IMethodDefinition;
      lsetTrue.ReplaceMethodBody(
      new StandaloneStatement(
      new ProcValue(new TypeValue(Services.GetType('sync.atomic.__Global')), 'StoreInteger', [new FieldValue(new SelfValue(), lType, 'Value'), new DataValue(1)])
      ));
    end;
  end;

end.
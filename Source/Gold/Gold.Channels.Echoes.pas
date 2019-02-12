namespace go.builtin;
{$IFDEF ECHOES}
uses
  System.Threading.Tasks,
  System.Collections.Generic,
  System.Linq;
{$ENDIF}

type
  Message<T> = class(IWaitSendMessage)
  assembly
    fOwner: BidirectionalChannel<T>;
    fNotifier: Func<Func<Boolean>, Boolean>;
  public
    constructor(aVal: T; aOwner: BidirectionalChannel<T>);
    begin
      Data := aVal;
      fOwner := aOwner;
    end;

    property Data: T; readonly;

    method IntReceive(aReceiver: IWaitReceiveMessage<T>): Boolean;
    begin
      // If we can can't remove it, it's not valid because someone else already took it.
      if fOwner.RemoveItem(self, -> aReceiver.TryHandOff(Data)) then begin
        exit true;
      end;
      exit false;
    end;

    method Receive(aReceiver: IWaitReceiveMessage<T>): Boolean;
    begin
      var lNot := fNotifier;
      if lNot = nil then exit IntReceive(aReceiver);
      exit lNot(-> IntReceive(aReceiver));
    end;

    method Cancel;
    begin
      fOwner.RemoveItem(self, -> true);
    end;

    method Start(aNotifier: Func<Func<Boolean>, Boolean>): Boolean;
    begin
      fNotifier := aNotifier;
      exit fOwner.AddItem(self);
    end;
  end;

  ReceiveMessage<T> = class(IWaitReceiveMessage<T>)
  assembly
    fOwner: BidirectionalChannel<T>;
    fNotifier: Func<Func<Boolean>, Boolean>;
    fHaveValue: Boolean;
    fReceivedValue: T;
  public
    constructor(aOwner: BidirectionalChannel<T>);
    begin
      fOwner := aOwner;
    end;

    property Data: tuple of (T, Boolean) read (fReceivedValue, fHaveValue);

    method Cancel;
    begin
      fOwner.RemoveItem(self, -> begin end);
    end;

    method IntTryHandOff(aVal: T): Boolean;
    begin
      exit fOwner.RemoveItem(self, -> begin
        fHaveValue := true;
        fReceivedValue := aVal;
      end);
    end;

    method TryHandOff(aVal: T): Boolean;
    begin
      var lNot := fNotifier;
      if lNot = nil then
        exit IntTryHandOff(aVal);
      exit lNot(-> IntTryHandOff(aVal));
    end;

    method Start(aNotifier: Func<Func<Boolean>,Boolean>): Boolean;
    begin
      fNotifier := aNotifier;
      exit fOwner.AddItem(self);
    end;
  end;


  BidirectionalChannel<T> = public class(SendingChannel<T>, ReceivingChannel<T>)
  assembly
  {$IFDEF ISLAND}
    fLock: Monitor := new Monitor;
    fCS: ConditionalVariable;
  {$ELSE}
    fLock: Object := new Object;
  {$ENDIF}
    fClosed: Integer; volatile;
    fQueueSize: Integer;
    fData: List<Message<T>> := new List<Message<T>>;
    fWaiting: List<ReceiveMessage<T>> := new List<ReceiveMessage<T>>();

    method AddItem(aVal: ReceiveMessage<T>): Boolean;
    begin
      if fClosed <> 0 then raise new Exception('Channel closed!');
      locking fLock do begin
        fWaiting.Add(aVal);
        for i: Integer := 0 to fData.Count -1 do begin
          if fData[i].Receive(aVal) then begin // will remove inside the handoff.
            exit true;
          end;
        end;
        {$IFDEF ISLAND}
        fCS.Signal;
        {$ELSE}
        System.Threading.Monitor.Pulse(fLock);
        {$ENDIF}
        exit false;
      end;
    end;

    method RemoveItem(aVal: ReceiveMessage<T>; aNot: Action): Boolean;
    begin
      locking fLock do begin
        if not fWaiting.Contains(aVal) then exit false;
        aNot:Invoke();
        fWaiting.Remove(aVal);
        exit true;
      end;
    end;


    method AddItem(aVal: Message<T>): Boolean;
    begin
      if fClosed <> 0 then raise new Exception('Channel closed!');
      locking fLock do begin
         fData.Add(aVal);
        for i: Integer := 0 to fWaiting.Count -1 do begin
          if aVal.Receive(fWaiting[i]) then
            exit true;
        end;
        if fData.Count < fQueueSize then begin
          aVal.fNotifier:Invoke(-> begin end);
          exit true;
        end;
      end;
      exit false;
    end;

    method RemoveItem(aVal: Message<T>; aNotifier: Func<Boolean>): Boolean;
    begin
      locking fLock do begin
        if not fData.Contains(aVal) then exit false;

        if not aNotifier() then exit false;
        fData.Remove(aVal);

        for i: Integer := Math.Min(fData.Count, fQueueSize) -1 downto 0 do begin
          fData[i].fNotifier:Invoke(-> begin end);
          fData[i].fNotifier := nil;
        end;

        exit true;
      end;
    end;

  public
    constructor(aQueueSize: Integer := 0);
    begin
      fQueueSize := aQueueSize + 1;
    end;

    property Capacity: Integer read fQueueSize -1;

    method Send(aVal: T);
    begin
      var lSig := TrySend(aVal);
      {$IFDEF ISLAND}
      var lLock := new Monitor;
      var lCV := new ConditionalVariable;
      {$ELSE}
      var lLock := new Object;
      {$ENDIF}
      var lDone := false;
      if lSig.Start(a-> begin
        locking lLock do begin
          if not a() then exit false;
          lDone := true;
          {$IFDEF ISLAND}
          lCV.Signal;
          {$ELSE}
          System.Threading.Monitor.Pulse(lLock);
          {$ENDIF}
          exit true;
        end;
      end) then exit;
      loop begin
        if lDone then break;
        if fLock = nil then raise new Exception('Channel closed!');
        locking lLock do begin
          {$IFDEF ISLAND}
          lCV.Wait(lLock);
          {$ELSE}
          System.Threading.Monitor.Wait(lLock);
          {$ENDIF}
        end;
      end;
    end;


    method Receive: tuple of (T, Boolean);
    begin
      {$IFDEF ISLAND}
      var lLock := new Monitor;
      var lCV := new ConditionalVariable;
      {$ELSE}
      var lLock := new Object;
      {$ENDIF}
      var lDone := false;
      var lRes := TryReceive();
      lRes.Start(a -> begin
        locking lLock do begin
          if not a() then exit false;
          lDone := true;
          {$IFDEF ISLAND}
          lCV.Signal;
          {$ELSE}
          System.Threading.Monitor.Pulse(lLock);
          {$ENDIF}
          exit true;
        end;
      end);

      loop begin
        if lDone then break;
        if fClosed <> 0 then exit (nil, false);
        locking lLock do begin
          {$IFDEF ISLAND}
          lCV.Wait(lLock);
          {$ELSE}
          System.Threading.Monitor.Wait(lLock);
          {$ENDIF}
        end;
      end;

      exit lRes.Data;
    end;


    method TryReceive: IWaitReceiveMessage<T>;
    begin
      if fClosed <> 0 then raise new Exception('Channel closed!');
      exit new ReceiveMessage<T>(self);
    end;

    method TrySend(aVal: T): IWaitSendMessage;
    begin
      if fClosed <> 0 then raise new Exception('Channel closed!');
      exit new Message<T>(aVal, self);
    end;

    method GetSequence: sequence of T; iterator;
    begin
      var lData: T;
      var lReceiver := new class IWaitReceiveMessage<T>(
        Cancel := method begin end,
        get_Data := -> (lData, true),
        Start := a -> begin end,
        TryHandOff := a -> begin lData := a; exit true; end
      );
      loop begin
        locking fLock do begin
          if fData.Count = 0 then begin
            if fClosed <> 0 then exit;
            {$IFDEF ISLAND}
            fCS.Wait(fLock);
            {$ELSE}
            System.Threading.Monitor.Wait(fLock);
            {$ENDIF}
            end;
          for i: Integer := 0 to fData.Count -1 do begin
            if fData[0].Receive(lReceiver) then
              yield lData;
          end;
        end;
      end;
    end;

    method Close;
    begin
      var lClosed := fClosed;
      fClosed := 1;
      if lClosed <> 0 then exit;
      locking fLock do begin
        for i: Integer := 0 to fData.Count -1 do
          fData[i].fNotifier:Invoke(-> true);
        for i: Integer := 0 to fWaiting.Count -1 do
          fWaiting[i].fNotifier:Invoke(-> true);
      end;
    end;
  end;


  method Channel_Select(aHandles: array of IWaitMessage; aBlock: Boolean): Integer; public;
  begin
    {$IFDEF ISLAND}
    var lLock := new Monitor;
    var lWake := new ConditionalVariable;
  {$ELSE}
    var lLock := new Object;
  {$ENDIF}
    var lDone := -1;
    locking lLock do begin
      for i: Integer := 0 to aHandles.Count -1 do begin
        var ci := i;
        if aHandles[i].Start(a -> begin
          locking lLock do begin
            if lDone <> -1 then exit false;
            if not a() then exit false;
            lDone := ci;
            {$IFDEF ISLAND}
            lWake.Signal;
            {$ELSE}
            System.Threading.Monitor.Pulse(lLock);
            {$ENDIF}

            exit true;
          end;
        end) then begin
          // start returns true if it's already done, if so, we can return that one and cancel the previous ones.
          for j: Integer := 0 to i -1 do
            aHandles[i].Cancel;
          exit i;
        end;
      end;
    end;
    if not aBlock then
      exit -1;
    loop begin
      locking lLock do begin
        if lDone <> -1 then break;
        {$IFDEF ISLAND}
        lWake.Wait(lLock);
        {$ELSE}
        System.Threading.Monitor.Wait(lLock);
        {$ENDIF}
      end;
    end;
    for j: Integer := 0 to aHandles.Count -1 do
      if j <> lDone then
        aHandles[j].Cancel;
    exit lDone;
  end;


end.
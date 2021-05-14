// based on the golang sources
namespace go.net;
uses
  {$IF ISLAND}
  RemObjects.Elements.System,
  {$ELSEIF ECHOES}
  System.Net,
  System.Net.Sockets,
  {$ENDIF}
  System.Linq,
  go.builtin;

type
  ipStackCapabilities = public partial class
  public
    method probe;
    begin
      var a := Dns.GetHostAddresses(Dns.GetHostName());
      for i: Integer := 0 to a.Length -1 do begin
        if a[i].AddressFamily = AddressFamily.InterNetworkV6 then
          ipv6Enabled := true;
        if a[i].AddressFamily = AddressFamily.InterNetwork then
          ipv4Enabled := true;
      end;
    end;
  end;
  [AliasSemantics]
  Flags = public record
  public
    Value: uint;

    constructor; empty;
    constructor(aValue: uint); begin Value := aValue;end;
  end;

  const
    FlagUp           :&Flags = 1 shl 0;
    FlagBroadcast   :&Flags = 1 shl 1;
    FlagLoopback     :&Flags = 1 shl 2;
    FlagPointToPoint :&Flags = 1 shl 3;
    FlagMulticast    :&Flags = 1 shl 4;

// Various errors contained in OpError.
    var
  // For connection setup operations.
errNoSuitableAddress := go.errors.New("no suitable address found");

  // For connection setup and write operations.
  errMissingAddress := go.errors.New("missing address");

  // For both read and write operations.
  errCanceled         := go.errors.New("operation was canceled");
  ErrWriteToConnected := go.errors.New("use of WriteTo with pre-connected connection");


type
  buffersWriter = public interface
    method writeBuffers(v: Memory<Buffers>): tuple of (int64, go.builtin.error);
  end;
  Error = public partial interface (go.builtin.error)
    method Timeout(): Boolean;
    method Temporary(): Boolean;
  end;

  temporary = interface
    method Temporary(): Boolean;
 end;

  timeout = interface
    method Timeout(): Boolean;
  end;


type
  Addr = public interface
    method Network(): string;
    method String(): string;
  end;

  [ValueTypeSemantics]
  IPAddr = public class(Addr)
  public
    IP: IP;
    Zone: string; // IPv6 scoped addressing zone; added in Go 1.1

    method Network: string; begin exit 'ip'; end;
    method String: string; begin exit IP.String(); end;
  end;

  [ValueTypeSemantics]
  TCPAddr = public class(Addr)
  public
    IP: IP;
    Port: Integer;
    Zone: string; // IPv6 scoped addressing zone; added in Go 1.1

    method Network: string; begin exit 'tcp'; end;
    method String: string; begin exit IP.String()+':'+Port; end;
  end;
  [ValueTypeSemantics]
  UDPAddr = public class(Addr)
  public
    IP: IP;
    Port: Integer;
    Zone: string; // IPv6 scoped addressing zone; added in Go 1.1

    method Network: string; begin exit 'udp'; end;
    method String: string; begin exit IP.String()+':'+Port; end;
  end;
  [ValueTypeSemantics]
  UnixAddr = public class(Addr)
  public
    Name: string;
    Net: string;

    method Network: string; begin exit 'unix'; end;
    method String: string; begin exit Name; end;
  end;
  [ValueTypeSemantics]
  AddrError = public partial class(go.net.Error, go.builtin.error)
  public
    constructor; begin end;
    constructor(aErr, aAddr: string); begin Err := aErr; Addr := aAddr; end;
    Err:  string;
    Addr: string;

    method Error(): string;
    begin
      var s := self.Err;
      if self.Addr <> "" then begin
        s := "address " + Addr + ": " + s
      end;
      exit s;
    end;
    method Temporary(): Boolean; empty;
    method Timeout(): Boolean; empty;
  end;
  [AliasSemantics]
  UnknownNetworkError = public partial record(go.net.Error, go.builtin.error)
  public
    constructor; begin end;
    constructor(aValue: string); begin Value := aValue; end;
    Value: string;
    method Error: string; begin exit 'unknown network '+Value; end;

    method Temporary(): Boolean; empty;
    method Timeout(): Boolean; empty;
  end;

  [AliasSemantics]
  DNSConfigError = public partial record(go.net.Error, go.builtin.error)
  public
    constructor; begin end;
    constructor(aValue: go.builtin.error); begin Err := aValue; end;
    Err: go.builtin.error;
    method Error: string; begin exit 'error reading DNS config: '+Err.Error(); end;

    method Temporary(): Boolean; empty;
    method Timeout(): Boolean; empty;
  end;
  [ValueTypeSemantics]
  ParseError = public partial class(go.builtin.error)
  public
    constructor; begin end;
    constructor(aValue, aText: string); begin &Type := aValue; Text := aText end;
    &Type: string;
    Text: string;
    method Error: string; begin exit "invalid " + &Type + ": " + Text; end;
  end;
  [ValueTypeSemantics]
  DNSError = public partial class(go.builtin.error, go.net.Error)
  public
    constructor; begin end;
    constructor(aErr, aName, aServer: string; aIsTimeout, aIsTemporary: Boolean); begin Err := aErr; Name := aName; Server := aServer; IsTimeout := aIsTimeout; IsTemporary := aIsTemporary; end;
    Err :        string;
    Name :       string;
    Server:      string;
    IsTimeout: Boolean;
    IsTemporary: Boolean;

    method Temporary(): Boolean; begin exit IsTemporary; end;
    method Timeout(): Boolean; begin exit IsTimeout; end;

    method Error: string;
    begin
      var s := "lookup " + Name;
      if Server <> "" then begin
        s := s + " on " + Server;
      end;
      s := s +": " + Err;
      exit s;
    end;
  end;


  [AliasSemantics]
  InvalidAddrError = public partial record(go.net.Error, go.builtin.error)
  public
    constructor; begin end;
    constructor(aValue: string); begin Value := aValue; end;
    Value: string;
    method Error: string; begin exit Value; end;

    method Temporary(): Boolean; empty;
    method Timeout(): Boolean; empty;
  end;


  [ValueTypeSemantics]
  OpError = public partial class(go.net.Error, go.builtin.error)
  public
    constructor; begin end;
    constructor(aOp, aNet: string;
    aSource: Addr;
    aAddr: Addr;
    aErr: go.builtin.error);
    begin
      Op := aOp;
      Net := aNet;
      Source := aSource;
      Addr := aAddr;
      Err := aErr;
    end;

    Op, Net: string;
    Source: Addr;
    Addr: Addr;
    Err: go.builtin.error;

    method Error(): string;
    begin
      var s := Op;
      if Net <> "" then begin
        s := s + " " + Net;
      end;
      if Source <> nil then begin
        s := s+ " " + Source.String();
      end;
      if Addr <> nil then begin
        if Source <> nil then begin
          s :=s+ "->";
        end else begin
          s :=s+ " ";
        end;
        s := s + Addr.String();
      end;
      s := s + ": " + Err.Error();
      exit s;
    end;
    method Temporary(): Boolean;
    begin
      if Err is temporary then
        exit (Err as temporary).Temporary;
      exit false;
    end;
    method Timeout(): Boolean;
    begin
      if Err is timeout then
        exit (Err as timeout).Timeout;
      exit false;
    end;

  end;

  [AliasSemantics]
  Buffers = public partial record(go.io.Reader)
  public
    constructor; begin end;
    constructor(aValue: Slice<Slice<byte>>); begin Value := aValue; end;
    Value: Slice<Slice<byte>>;



    method WriteTo(w: go.io.Writer): tuple of (int64, go.builtin.error);
    begin
      var bw := buffersWriter(w);
      if bw <> nil then
        exit bw.writeBuffers(Memory<Buffers>(self));
      var n: int64 := 0;
      for i: Integer := 0 to Value.Length -1 do begin
        var (c, err) := w.Write(Value[i]);
        n := n + c;
        if (err <> nil) then begin
          consume(n);
          exit (n, err);
        end;
      end;
      consume(n);
      exit (n, nil);
    end;

    method &Read(p: Slice<byte>): tuple of (int,go. builtin.error);
    begin
      var n: int64 := 0;
      var err: go.builtin.error := nil;
      while (p.Length > 0) and (Value.Length > 0) do begin
        var n0 := copy(p, self.Value[0]);
        consume(int64(n0));
        p := go.builtin.Slice(p, n0, nil);
        n := n+ n0;
      end;
      if self.Value.Length = 0 then begin
        err := go.io.EOF;
      end;
      exit (n, err);
    end;

    method consume(n: int64);
    begin
      while Value.Length > 0 do begin
        var ln0 := int64(Value[0].Length);
        if ln0 > n then begin
          Value[0] := Slice(Value[0], n, nil);
          exit;
        end;
        n := n -ln0;
        Value := Slice(Value, 1, nil);
      end;
    end;

  end;



  method LookupIP(host: string): tuple of (Slice<IP>, go.builtin.error);
  begin
    try
      var h := Dns.GetHostEntry(host);
      if h.AddressList.Length = 0 then exit (nil, new DNSError('Empty address list', host, '', false, false));
      exit (new Slice<IP>(h.AddressList.Select(a -> new IP(a.GetAddressBytes)).ToArray), nil);
    except
      on e: Exception do
        exit (nil, new DNSError(e.Message, host, '', false, false));
    end;
  end;
type
Listener = public interface
  method Accept(): tuple of (Conn, go.builtin.error);
  method Close(): go.builtin.error;
  method Addr: Addr;
end;

method FileListener(f: Memory<go.os.File>): tuple of (Listener, go.builtin.error);
begin
  exit (nil, go.Errors.New('not supported'));
end;

type
  TCPListener = public class(Listener)
  private
    fSock: Socket;
  public
    constructor(aSock: Socket);
    begin
      fSock := aSock;
    end;

    method Accept: tuple of (Conn, go.builtin.error);
    begin
      try
        exit (new IPConn(fSock.Accept()), nil);
      except
        on e: Exception do
          exit (nil, go.Errors.New(e.Message));
      end;
    end;
    method AcceptTCP: tuple of (TCPConn, go.builtin.error);
    begin
      try
        exit (new TCPConn(fSock.Accept()), nil);
      except
        on e: Exception do
          exit (nil, go.Errors.New(e.Message));
      end;
    end;
    method Close: go.builtin.error;
    begin
      try
        fSock.Close;
        exit nil;
      except
        on e: Exception do
          exit go.Errors.New(e.Message);
      end;
    end;

    method Addr: Addr;
    begin
      var lAddr := IPEndPoint(fSock.LocalEndPoint);

      exit new TCPAddr(Port := lAddr.Port, IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));
    end;
  end;
  TCPConn = public IPConn;
  UDPConn = public IPConn;
  UnixConn = public IPConn;
  Conn = public partial interface
    // Read reads data from the connection.
            // Read can be made to time out and return an Error with Timeout() == true
            // after a fixed time limit; see SetDeadline and SetReadDeadline.
    method &Read(b: Slice<byte>): tuple of (int, go.builtin.error);

            // Write writes data to the connection.
            // Write can be made to time out and return an Error with Timeout() == true
            // after a fixed time limit; see SetDeadline and SetWriteDeadline.
    method  &Write(b: Slice<byte>): tuple of (int, go.builtin.error);

            // Close closes the connection.
            // Any blocked Read or Write operations will be unblocked and return errors.
    method Close(): go.builtin.error;

            // LocalAddr returns the local network address.
    method LocalAddr(): Addr;

            // RemoteAddr returns the remote network address.
    method RemoteAddr(): Addr;

            // SetDeadline sets the read and write deadlines associated
            // with the connection. It is equivalent to calling both
            // SetReadDeadline and SetWriteDeadline.
            //
            // A deadline is an absolute time after which I/O operations
            // fail with a timeout (see type Error) instead of
            // blocking. The deadline applies to all future and pending
            // I/O, not just the immediately following call to Read or
            // Write. After a deadline has been exceeded, the connection
            // can be refreshed by setting a deadline in the future.
            //
            // An idle timeout can be implemented by repeatedly extending
            // the deadline after successful Read or Write calls.
            //
            // A zero value for t means I/O operations will not time out.
    method SetDeadline(tt: go.time.Time): go.builtin.error;

            // SetReadDeadline sets the deadline for future Read calls
            // and any currently-blocked Read call.
            // A zero value for t means Read will not time out.
    method SetReadDeadline(tt: go.time.Time): go.builtin.error;

            // SetWriteDeadline sets the deadline for future Write calls
            // and any currently-blocked Write call.
            // Even if write times out, it may return n > 0, indicating that
            // some of the data was successfully written.
            // A zero value for t means Write will not time out.
    method SetWriteDeadline(t: go.time.Time): go.builtin.error;
  end;


  IPConn = public partial class(Conn)
  private
    fSock: Socket;
    method CreateNetOpError(aOp: string; aCall: string; e: Exception): go.net.OpError;
    begin
      result := new go.net.OpError();
      result.Op := aOp;
      result.Net := e.Message;
      {$IF ECHOES}
      if e is SocketException then begin
        var lE := SocketException(e);
        var err: go.syscall.Errno;
        err := lE.ErrorCode;
        result.Err := new go.os.SyscallError(aCall, err);
      end;
      {$ENDIF}
    end;
  public
    constructor(aSock: Socket);
    begin
      fSock := aSock;
    end;

    method &Read(b: Slice<byte>): tuple of (go.builtin.int, go.builtin.error);
    begin
      try
        exit (fSock.Receive(b.fArray, b.fStart, b.fCount, SocketFlags.None), nil);
      except
        on e: Exception do
          exit (0, CreateNetOpError('read', 'wsarecv', e));
      end;
    end;

    method &Write(b: Slice<byte>): tuple of (go.builtin.int, go.builtin.error);
    begin
      try
        fSock.Send(b.fArray, b.fStart, b.fCount, SocketFlags.None);
        exit (b.fCount, nil);
      except
        on e: Exception do
          exit (0, CreateNetOpError('write', 'wsasend', e));
      end;
    end;

    method LocalAddr: Addr;
    begin
      var lAddr := IPEndPoint(fSock.LocalEndPoint);
      if fSock.SocketType = SocketType.Stream then
      exit new TCPAddr(Port := lAddr.Port, IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));
      exit new UDPAddr(Port := lAddr.Port, IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));
    end;

    method RemoteAddr: Addr;
    begin
      var lAddr := IPEndPoint(fSock.RemoteEndPoint);

      if fSock.SocketType = SocketType.Stream then
        exit new TCPAddr(Port := lAddr.Port, IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));
      exit new UDPAddr(Port := lAddr.Port, IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));
    end;

    method SetDeadline(tt: go.time.Time): go.builtin.error;
    begin
      SetReadDeadline(tt);
      SetWriteDeadline(tt);
    end;

    method SetReadDeadline(tt: go.time.Time): go.builtin.error;
    begin
      {$IF ISLAND}
      fSock.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReceiveTimeout, tt.Nanosecond() / 1000);
      {$ELSEIF ECHOES}
      if tt = nil then
        fSock.ReceiveTimeout := 0
      else
        fSock.ReceiveTimeout := tt.Nanosecond() / 1000;
      {$ENDIF}
    end;

    method SetWriteDeadline(t: go.time.Time): go.builtin.error;
    begin
      {$IF ISLAND}
      fSock.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.SendTimeout, t.Nanosecond() / 1000);
      {$ELSEIF ECHOES}
      if t = nil then
        fSock.SendTimeout := 0
      else
        fSock.SendTimeout := t.Nanosecond() / 1000;
      {$ENDIF}
    end;

    method Close: go.builtin.error;
    begin
      try
        fSock.Close();
      except
        on e: Exception do
          exit go.Errors.New(e.Message);
      end;
    end;


    method File(): tuple of (Memory<go.os.File>, go.builtin.error);
    begin
      exit (nil, go.Errors.New('Not supported'));
    end;
    method ReadFrom(b: Slice<byte>): tuple of  (int, Addr, go.builtin.error);
    begin
      try
        var ep: EndPoint;
        var n := fSock.ReceiveFrom(b.fArray, b.fStart, b.fCount, SocketFlags.None, var ep);
        var a: Addr;
        var lAddr := IPEndPoint(ep);
        if fSock.SocketType = SocketType.Stream then
          a := new TCPAddr(Port := lAddr.Port, IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));
        a := new UDPAddr(Port := lAddr.Port, IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));

        exit (n, a, nil);
      except
        on e: Exception do
          exit (0, nil, go.Errors.New(e.Message));
      end;
    end;
    method ReadFromUDP(b: Slice<byte>): tuple of  (int, Memory<UDPAddr>, go.builtin.error);
    begin
      try
        var ep: EndPoint;
        var n := fSock.ReceiveFrom(b.fArray, b.fStart, b.fCount, SocketFlags.None, var ep);
        var a: UDPAddr;
        var lAddr := IPEndPoint(ep);
        a := new UDPAddr(Port := lAddr.Port, IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));

        exit (n, Memory<UDPAddr>(a), nil);
      except
        on e: Exception do
          exit (0, nil, go.Errors.New(e.Message));
      end;
    end;

    method ReadFromIP(b: Slice<byte>): tuple of  (int, Memory<IPAddr>, go.builtin.error);
    begin
      try
        var ep: EndPoint;
        var n := fSock.ReceiveFrom(b.fArray, b.fStart, b.fCount, SocketFlags.None, var ep);
        var a: IPAddr;
        var lAddr := IPEndPoint(ep);
        a := new IPAddr(IP := new IP(Value := new Slice<byte>(lAddr.Address.GetAddressBytes)));

        exit (n, Memory<IPAddr>(a), nil);
      except
        on e: Exception do
          exit (0, nil, go.Errors.New(e.Message));
      end;
    end;
    method SetReadBuffer(bytes: int):  go.builtin.error;
    begin
      try
        {$IF ISLAND}
        fSock.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReceiveBuffer, bytes);
        {$ELSEIF ECHOES}
        fSock.ReceiveBufferSize := bytes;
        {$ENDIF}
      except
        on e: Exception do
          exit go.Errors.New(e.Message);
      end;
    end;
    method SetWriteBuffer(bytes: int):  go.builtin.error;
    begin
      try
        {$IF ISLAND}
        fSock.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.SendBuffer, bytes);
        {$ELSEIF ECHOES}
        fSock.SendBufferSize := bytes;
        {$ENDIF}
      except
        on e: Exception do
          exit go.Errors.New(e.Message);
      end;
    end;
    method SyscallConn(): tuple of  (go.syscall.RawConn, go.builtin.error);
    begin
      exit (nil, go.Errors.New('Not supported'));
    end;
    method CloseRead(): go.builtin.error;
    begin
      try
        fSock.Shutdown(SocketShutdown.Receive);
      except
        on e: Exception do
        exit go.Errors.New(e.Message);
      end;
    end;
    method CloseWrite(): go.builtin.error;
    begin
      try
        fSock.Shutdown(SocketShutdown.Send);
      except
        on e: Exception do
          exit go.Errors.New(e.Message);
      end;
    end;

    method SetKeepAlive(b: Boolean): go.builtin.error;
    begin
      try
        fSock.SetSocketOption(SocketOptionLevel.Socket,  SocketOptionName.KeepAlive, b);
      except
        on e: Exception do
          exit go.Errors.New(e.Message);
      end;
    end;


    method SetNoDelay(b: Boolean):go. builtin.error;
    begin
      try
        fSock.SetSocketOption(SocketOptionLevel.Socket,  SocketOptionName.NoDelay, b);
      except
        on e: Exception do
          exit go.Errors.New(e.Message);
      end;
    end;


    method SetLinger(b: Integer): go.builtin.error;
    begin
      try
        fSock.SetSocketOption(SocketOptionLevel.Socket,  SocketOptionName.Linger, b);
      except
        on e: Exception do
          exit go.Errors.New(e.Message);
      end;
    end;

    method SetKeepAlivePeriod(d: go.time.Duration): go.builtin.error;
    begin
      exit nil;
    end;



    method &WriteTo(b: Slice<byte>; addr: Addr): tuple of (go.builtin.int, go.builtin.error);
    begin
      try
        var lAddr := UDPAddr(addr);
        var rep := new IPEndPoint(
        new IPAddress(lAddr.IP.Value.fArray),
        lAddr.Port);
        fSock.SendTo(b.fArray, b.fStart, b.fCount, SocketFlags.None, rep);
        exit (b.fCount, nil);
      except
        on e: Exception do
          exit (0, go.Errors.New(e.Message));
      end;
    end;

    /*
    method WriteToIP(b: Slice<byte>; addr: Memory<IPAddr>): tuple of  (int, builtin.error);
    method WriteTo(b: Slice<byte>; addr: Addr): tuple of  (int, builtin.error);

    method ReadFromUnix(b: Slice<byte>): tuple of  (int, Memory<UnixAddr>, builtin.error)
    method ReadMsgUnix(b: Slice<byte>; oob: Slice<byte>): tuple of  (n, oobn, flags int, Memory<UnixAddr>, err builtin.error)
    method WriteMsgUnix(b: Slice<byte>; oob: Slice<byte>; addr Memory<UnixAddr>): tuple of  (n, oobn int, err builtin.error) ;
    method WriteToUnix(b: Slice<byte>;addr Memory<UnixAddr>): tuple of  (int, builtin.error) ;*/
  end;

method ParseAddress(s: string): tuple of (string, Integer);
begin
  var n := go.strings.LastIndex(s, ':');
  var q := go.strings.LastIndex(s, ']');
  if n < q then n := -1;
  if( n >= 0) and Integer.TryParse(s.Substring(n+1), out var port) then begin
    s := s.Substring(0, n);
  end;
  exit (s, port);
end;

method Listen(network, address: string): tuple of (Listener, go.builtin.error);
begin
  try
    var s: Socket;
    var p := ParseAddress(address);
    var lCurrentAddr: IPAddress;
    if string.IsNullOrEmpty(p[0]) then begin
      p := ('0.0.0.0', p[1]);
      lCurrentAddr := IPAddress.Parse(p[0]);
    end
    else begin
      var addr := Dns.GetHostEntry (p[0]);
      lCurrentAddr := addr.AddressList[0];
    end;

    case network of
      'tcp': begin
          if lCurrentAddr.AddressFamily = AddressFamily.InterNetworkV6 then goto ipv6;
          goto ipv4;
        end;
      'tcp4':
      begin
        ipv4:;
        s := new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        s.Bind(new IPEndPoint(lCurrentAddr, p[1]));
        s.Listen(10);
      end;

      'tcp6':
      begin
        ipv6:;
        s := new Socket(AddressFamily.InterNetworkV6, SocketType.Stream, ProtocolType.Tcp);
        s.Bind(new IPEndPoint(lCurrentAddr, p[1]));
        s.Listen(10);
      end;
    else exit (nil, go.Errors.New('only tcp, tcp4 and tcp6 supported'));
    end;
    exit (new TCPListener(s), nil);
  except
  on e: Exception do
    exit (nil, go.Errors.New(e.Message));
  end;
end;

type
  [ValueTypeSemantics]
  Dialer = public partial class
  public
    constructor;
    begin
      self.Resolver := Resolver.Default;
      Deadline := new go.time.Time;
    end;
    // Timeout is the maximum amount of time a dial will wait for
    // a connect to complete. If Deadline is also set, it may fail
    // earlier.
    //
    // The default is no timeout.
    //
    // When using TCP and dialing a host name with multiple IP
    // addresses, the timeout may be divided between them.
    //
    // With or without a timeout, the operating system may impose
    // its own earlier timeout. For instance, TCP timeouts are
    // often around 3 minutes.
    Timeout: go.time.Duration;

    // Deadline is the absolute point in time after which dials
    // will fail. If Timeout is set, it may fail earlier.
    // Zero means no deadline, or dependent on the operating system
    // as with the Timeout option.
    Deadline: go.time.Time;

    // LocalAddr is the local address to use when dialing an
    // address. The address must be of a compatible type for the
    // network being dialed.
    // If nil, a local address is automatically chosen.
    LocalAddr: Addr;

    // DualStack enables RFC 6555-compliant "Happy Eyeballs"
    // dialing when the network is "tcp" and the host in the
    // address parameter resolves to both IPv4 and IPv6 addresses.
    // This allows a client to tolerate networks where one address
    // family is silently broken.
    DualStack: bool; // Go 1.2

    // FallbackDelay specifies the length of time to wait before
    // spawning a fallback connection, when DualStack is enabled.
    // If zero, a default delay of 300ms is used.
    FallbackDelay: go.time.Duration; // Go 1.5

    // KeepAlive specifies the keep-alive period for an active
    // network connection.
    // If zero, keep-alives are not enabled. Network protocols
    // that do not support keep-alives ignore this field.
    KeepAlive: go.time.Duration; // Go 1.3

    // Resolver optionally specifies an alternate resolver to use.
    Resolver: Memory<Resolver>; // Go 1.8

    // If Control is not nil, it is called after creating the network
    // connection but before actually dialing.
    //
    // Network and address parameters passed to Control method are not
    // necessarily the ones passed to Dial. For example, passing "tcp" to Dial
    // will cause the Control function to be called with "tcp4" or "tcp6".
    Control: method(network, address: string; c: go.syscall.RawConn): go.builtin.error; // Go 1.11

    method Dial(network, address: string): tuple of (Conn, go.builtin.error);
    begin
      exit DialContext(nil, network, address);
    end;

    method DialContext(ctx: go.context.Context; network, address: string): tuple of (Conn, go.builtin.error);
    begin
      var p := go.strings.SplitN(address, ':', 2);
      if p.Length <> 2 then exit (nil, go.Errors.New('Port missing; address/ip:port'));
      try
        //var lPort := coalesce(Reference<Resolver>.Get(self.Resolver), go.net.Resolver.Default).LookupPort(ctx, network, p[1]);
        var lPort := coalesce(self.Resolver^, go.net.Resolver.Default).LookupPort(ctx, network, p[1]);
        if lPort.Item2 <> nil then exit (nil, lPort.Item2);
        var lHost := coalesce(self.Resolver^, go.net.Resolver.Default).LookupIPAddr(ctx, p[0]);
        if lHost.Item2 <> nil then exit (Nil, lPort.Item2);

        var lRep: IPEndPoint;
        var lAF: AddressFamily;
        var lST: SocketType;
        //new Socket(
        //var lST := System.Net;
        //var lIP:

        case network of
          'tcp4': begin
              tcp4:;
              lRep := new IPEndPoint(new IPAddress(lHost.Item1.GetSequence.FirstOrDefault(a -> a.Item2.IP.To4.Value <> nil).Item2.IP.To4.Value.fArray), lPort[0]);
              lAF := AddressFamily.InterNetwork;
              lST := SocketType.Stream;
            end;
          'tcp6': begin
              tcp6:;
              lRep := new IPEndPoint(new IPAddress(lHost.Item1.GetSequence.FirstOrDefault(a -> a.Item2.IP.To4.Value = nil).Item2.IP.Value.fArray), lPort[0]);
              lAF := AddressFamily.InterNetworkV6;
              lST := SocketType.Stream;
            end;
          'tcp': begin
              if lHost.Item1.GetSequence.FirstOrDefault(a -> a.Item2.IP.To4.Value <> nil) <> nil then goto tcp4;
              goto tcp6;
          end;
          'udp4': begin
              udp4:;
              lRep := new IPEndPoint(new IPAddress(lHost.Item1.GetSequence.FirstOrDefault(a -> a.Item2.IP.To4.Value <> nil).Item2.IP.To4.Value.fArray), lPort[0]);
              lAF := AddressFamily.InterNetwork;
              lST := SocketType.Dgram;
          end;
          'ud6': begin
              udp6:;
              lRep := new IPEndPoint(new IPAddress(lHost.Item1.GetSequence.FirstOrDefault(a -> a.Item2.IP.To4.Value = nil).Item2.IP.Value.fArray), lPort[0]);
              lAF := AddressFamily.InterNetworkV6;
              lST := SocketType.Dgram;
          end;
          'udp': begin
              if lHost.Item1.GetSequence.FirstOrDefault(a -> a.Item2.IP.To4.Value <> nil) <> nil then goto udp4;
              goto udp6;
          end;
        else
          exit (nil, go.Errors.New('Unknown network'));
        end;
        var lSock := new Socket(lAF, lST, if lST = SocketType.Dgram then ProtocolType.Udp else ProtocolType.Tcp);
        lSock.Connect(lRep);
        exit (new IPConn(lSock), nil);
      except
        on e: Exception do
          exit (nil, go.Errors.New(e.Message));
      end;
    end;
  end;

  method Dial(network, address: string): tuple of (Conn, go.builtin.error);
  begin
    var dc := new Dialer;
    exit dc.Dial(network, address);
  end;

  method DialTimeout(network, address: string; dt: go.time.Duration): tuple of (Conn, go.builtin.error);
  begin
    var dc := new Dialer;
    dc.Timeout := dt;
    exit dc.Dial(network, address);
  end;

type
  [ValueTypeSemantics]
  Resolver = public class
  public
    PreferGo: Boolean;
    StrictErrors: Boolean;
    method LookupPort(ctx: go.context.Context; network, service: string): tuple of (Integer, go.builtin.error);
    begin
      if Integer.TryParse(service, out var res) then begin
        exit (res, nil);
      end;
      exit (0, go.Errors.New('Unknown port'));
    end;
    method LookupIPAddr(ctx: go.context.Context; host: string): tuple of (Slice<IPAddr>, go.builtin.error);
    begin
      try
        var h := Dns.GetHostEntry(host);
        if h.AddressList.Length = 0 then exit (nil, new DNSError('Empty address list', host, '', false, false));
        exit (new Slice<IPAddr>(h.AddressList.Select(a -> new IPAddr(IP := new IP(a.GetAddressBytes))).ToArray), nil);
      except
        on e: Exception do
          exit (nil, new DNSError(e.Message, host, '', false, false));
      end;
    end;

    method lookupIPAddr(ctx: go.context.Context; net: string; host: string): tuple of (Slice<IPAddr>, go.builtin.error);
    begin
      // TODO
    end;

    class var &Default: Resolver := new Resolver;
  end;

/*
type Dialer
method (d *Dialer) Dial(network, address string) (Conn, error)
method (d *Dialer) DialContext(ctx context.Context, network, address string) (Conn, error)
method ResolveIPAddr(network, address string) (*IPAddr, error)

    type Resolver
        method (r *Resolver) LookupAddr(ctx context.Context, addr string) (names []string, err error)
        method (r *Resolver) LookupCNAME(ctx context.Context, host string) (cname string, err error)
        method (r *Resolver) LookupHost(ctx context.Context, host string) (addrs []string, err error)
        method (r *Resolver) LookupMX(ctx context.Context, name string) ([]*MX, error)
        method (r *Resolver) LookupNS(ctx context.Context, name string) ([]*NS, error)
        method (r *Resolver) LookupSRV(ctx context.Context, service, proto, name string) (cname string, addrs []*SRV, err error)
        method (r *Resolver) LookupTXT(ctx context.Context, name string) ([]string, error)



method InterfaceAddrs(): tuple of (Slice<Addr>, error);
begin
end;


*/
end.
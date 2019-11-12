namespace;

type
  go.context.cancelCtx = public partial class(go.context.canceler, go.context.Context) end;
  go.context.valueCtx = public partial class(go.context.Context) end;
  go.context.emptyCtx = public partial record (go.context.Context) end;

  go.errors.errorString = public partial class(go.builtin.error) end;
  go.context.deadlineExceededError = public partial class(go.builtin.error) end;
  go.archive.tar.headerError = public partial record(go.builtin.error) end;
  go.time.ParseError = public partial class(go.builtin.error) end;
  go.strconv.NumError = public partial class(go.builtin.error) end;
  go.time.fileSizeError = public partial record(go.builtin.error) end;
  go.database.sql.driverConn = public partial class(go.database.sql.finalCloser) end;
  go.database.sql.driverResult = public partial class(go.database.sql.Result) end;
  go.database.sql.Stmt = public partial class(go.database.sql.finalCloser) end;
  go.database.sql.Tx = public partial class(go.database.sql.stmtConnGrabber) end;
  go.database.sql.Conn = public partial class(go.database.sql.stmtConnGrabber) end;
  go.io.eofReader = public partial class(go.io.Reader) end;
  go.io.multiReader = public partial class(go.io.Reader) end;
  go.io.LimitedReader = public partial class(go.io.Reader) end;
  go.io.multiWriter = public partial class(go.io.Writer, go.io.StringWriter) end;
  go.io.teeReader = public partial class(go.io.Reader) end;
  go.database.sql.driver.noRows = public partial class(go.database.sql.driver.&Result) end;
  go.database.sql.driver.boolType = public partial class(go.database.sql.driver.ValueConverter) end;
  go.database.sql.driver.int32Type = public partial class(go.database.sql.driver.ValueConverter) end;
  go.database.sql.driver.defaultConverter = public partial class(go.database.sql.driver.ValueConverter) end;
  go.database.sql.dsnConnector = public partial class(go.database.sql.driver.Connector) end;
  go.archive.zip.headerFileInfo = public partial class(go.os.FileInfo) end;
  go.archive.tar.headerFileInfo = public partial class(go.os.FileInfo) end;
  go.compress.flate.CorruptInputError = public partial record(go.builtin.error) end;
  go.compress.flate.InternalError = public partial record(go.builtin.error) end;
  go.compress.bzip2.StructuralError = public partial record(go.builtin.error) end;
  go.archive.tar.Reader = public partial class(go.io.Reader) end;
  go.archive.tar.Writer = public partial class(go.io.Writer) end;
  go.archive.tar.zeroReader = public partial class(go.io.Reader) end;
  go.archive.tar.fileWriter = public partial interface(go.io.Writer) end;
  go.archive.tar.sparseFileWriter = public partial class(go.archive.tar.fileWriter) end;
  go.archive.tar.regFileWriter = public partial class(go.archive.tar.fileWriter) end;
  go.archive.tar.sparseFileReader = public partial class(go.archive.tar.fileReader) end;
  go.archive.tar.regFileReader = public partial class(go.archive.tar.fileReader) end;
  go.io.SectionReader = public partial class(go.io.Reader) end;
  go.bufio.Reader = public partial class(go.io.Reader, go.image.reader) end;
  go.archive.zip.checksumReader = public partial class(go.io.ReadCloser) end;
  go.archive.zip.pooledFlateReader = public partial class(go.io.ReadCloser) end;
  go.archive.zip.fileWriter = public partial class(go.io.Writer) end;
  go.compress.lzw.decoder = public partial class(go.io.ReadCloser) end;
  go.compress.flate.dictWriter = public partial class(go.io.Writer) end;
  go.compress.lzw.errWriteCloser = public partial class(go.io.WriteCloser) end;
  go.archive.zip.pooledFlateWriter = public partial class(go.io.WriteCloser) end;
  go.bufio.Reader = public partial class(go.compress.flate.Reader) end;
  go.bufio.Writer = public partial class(go.io.Writer, go.image.jpeg.writer) end;
  go.compress.bzip2.reader = public partial class(go.io.Reader) end;
  go.compress.flate.byLiteral = public partial record(go.sort.Interface) end;
  go.compress.flate.byFreq = public partial record(go.sort.Interface) end;
  go.sort.reverse = public partial class(go.sort.Interface) end;
  go.compress.flate.decompressor = public partial class(go.io.ReadCloser) end;
  go.compress.lzw.encoder = public partial class(go.io.WriteCloser) end;
  go.compress.lzw.writer = public partial interface(go.io.ByteWriter) end;
  go.archive.zip.nopCloser = public partial class(go.io.WriteCloser) end;

  go.sort.IntSlice = public partial record(go.sort.Interface) end;
  go.sort.Float64Slice = public partial record(go.sort.Interface) end;
  go.sort.StringSlice = public partial record(go.sort.Interface) end;

  go.archive.zip.dirWriter = public partial class(go.io.Writer) end;
  go.archive.zip.countWriter= public partial class(go.io.Writer) end;
  go.io.ReaderFrom = public partial interface(go.io.Writer) end;
  go.strings.singleStringReplacer = public partial class(go.strings.«replacer») end;
  go.strings.genericReplacer = public partial class(go.strings.«replacer») end;
  go.strings.byteStringReplacer = public partial class(go.strings.«replacer») end;
  go.strings.byteReplacer = public partial record(go.strings.«replacer») end;

  go.os.SyscallError = public partial class(go.builtin.error) end;
  go.bufio.Writer = public partial class(go.compress.lzw.writer) end;

  go.hash.fnv.sum64a = public partial record(go.hash.Hash64, go.hash.Hash) end;
  go.hash.fnv.sum64 = public partial record(go.hash.Hash64, go.hash.Hash) end;
  go.hash.crc64.digest = public partial class(go.hash.Hash64, go.hash.Hash) end;
  go.hash.crc32.digest = public partial class(go.hash.Hash32, go.hash.Hash) end;
  go.hash.adler32.digest = public partial record(go.hash.Hash32, go.hash.Hash) end;
  go.hash.fnv.sum32a = public partial record(go.hash.Hash32, go.hash.Hash) end;
  go.hash.fnv.sum32 = public partial record(go.hash.Hash32, go.hash.Hash) end;
  go.hash.fnv.sum128 = public partial record(go.hash.Hash) end;
  go.hash.fnv.sum128a = public partial record(go.hash.Hash) end;

  go.os.PathError = public partial class(go.builtin.error) end;
  go.text.template.ExecError = public partial class(go.builtin.error) end;

  go.strings.appendSliceWriter = public partial record(go.io.Writer) end;
  go.strings.stringWriter = public partial class(go.io.StringWriter) end;

  go.compress.zlib.reader =  partial class(go.io.ReadCloser) end;
  go.compress.gzip.reader = public partial class(go.io.Reader) end;
  go.compress.gzip.writer = public partial class(go.io.Writer) end;
  go.compress.flate.writer = public partial class(go.io.Writer) end;


  go.flag.durationValue = public partial record(go.flag.Value) end;
  go.flag.float64Value = public partial record(go.flag.Value) end;
  go.flag.stringValue = public partial record(go.flag.Value) end;
  go.flag.uint64Value = public partial record(go.flag.Value) end;
  go.flag.uintValue = public partial record(go.flag.Value) end;
  go.flag.int64Value = public partial record(go.flag.Value) end;
  go.flag.intValue = public partial record(go.flag.Value) end;
  go.flag.boolValue = public partial record(go.flag.Value) end;


  go.regexp.inputReader = public partial class(go.regexp.input) end;
  go.regexp.inputString = public partial class(go.regexp.input) end;
  go.regexp.inputBytes = public partial class(go.regexp.input) end;
  go.regexp.syntax.Error = public partial class(go.builtin.error) end;

  go.index.suffixarray.suffixSortable = public partial class(go.sort.Interface) end;

  go.regexp.runeSlice = public partial record(go.sort.Interface) end;
  go.regexp.syntax.ranges = public partial class(go.sort.Interface) end;

  go.text.template.parse.VariableNode = public partial class(go.text.template.parse.Node) end;
  go.text.template.parse.ChainNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.FieldNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.NumberNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.CommandNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.PipeNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.RangeNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.ListNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.ActionNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.IdentifierNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.TemplateNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.TextNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.DotNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.NilNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.BoolNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.StringNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.endNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.elseNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.IfNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.WithNode = public partial class(go.text.template.parse.Node);
  go.text.template.parse.BranchNode = public partial class(go.text.template.parse.Node);

  go.html.template.Error = public partial class(go.builtin.error);

  go.bytes.Buffer = public partial class(go.io.Writer);
  go.bytes.Reader = public partial class(go.io.Reader, go.compress.flate.Reader);

  go.net.url.Error = public partial class(go.builtin.error);
  go.net.url.EscapeError = public partial record(go.builtin.error);
  go.net.url.InvalidHostError = public partial record(go.builtin.error);

  go.encoding.json.UnmarshalTypeError = public partial class(go.builtin.error);
  go.encoding.base64.CorruptInputError = public partial record(go.builtin.error);
  go.encoding.base64.encoder = public partial class(go.io.WriteCloser);
  go.encoding.base64.newlineFilteringReader = public partial class(go.io.Reader);
  go.encoding.base64.decoder = public partial class(go.io.Reader);
  go.encoding.json.InvalidUnmarshalError = public partial class(go.builtin.error);
  go.encoding.json.UnsupportedValueError = public partial class(go.builtin.error);
  go.encoding.json.UnsupportedTypeError = public partial class(go.builtin.error);
  go.encoding.json.SyntaxError = public partial class(go.builtin.error);
  go.encoding.json.MarshalerError = public partial class(go.builtin.error);
  go.encoding.json.byIndex = public partial record(go.sort.Interface);
  go.encoding.json.RawMessage = public partial record(:go.encoding.json.Marshaler, :go.encoding.json.Unmarshaler);

  go.image.color.NRGBA = public partial class(go.image.color.Color);
  go.image.color.RGBA = public partial class(go.image.color.Color);
  go.image.color.NRGBA64 = public partial class(go.image.color.Color);
  go.image.color.RGBA64 = public partial class(go.image.color.Color);
  go.image.color.Alpha = public partial class(go.image.color.Color);
  go.image.color.Alpha16 = public partial class(go.image.color.Color);
  go.image.color.Gray = public partial class(go.image.color.Color);
  go.image.color.Gray16 = public partial class(go.image.color.Color);

  go.image.color.CMYK = public partial class(go.image.color.Color);

  go.image.NRGBA = public partial class(go.image.Image);
  go.image.RGBA = public partial class(go.image.Image);
  go.image.NRGBA64 = public partial class(go.image.Image);
  go.image.RGBA64 = public partial class(go.image.Image);
  go.image.Alpha = public partial class(go.image.Image);
  go.image.Alpha16 = public partial class(go.image.Image);
  go.image.Gray = public partial class(go.image.Image);
  go.image.Gray16 = public partial class(go.image.Image);
  go.image.CMYK = public partial class(go.image.Image);

  go.image.color.YCbCr = public partial class(go.image.color.Color);
  go.image.YCbCr = public partial class(go.image.Image);


  go.image.color.NYCbCrA = public partial class(go.image.color.Color);
  go.image.NYCbCrA = public partial class(go.image.Image);


  go.image.Paletted  = public partial class(go.image.Image);
  go.image.Paletted  = public partial class(go.image.draw.Image);
  go.image.jpeg.UnsupportedError = public partial record(go.builtin.error);
  go.image.jpeg.FormatError = public partial record(go.builtin.error);
  go.image.png.UnsupportedError = public partial record(go.builtin.error);
  go.image.png.FormatError = public partial record(go.builtin.error);
  go.image.png.decoder = public partial class(go.io.Reader);
  go.image.Uniform = public partial class(go.image.color.Model);
  go.image.color.Palette = public partial record(go.image.color.Model);
  go.image.color.modelFunc = public partial class(go.image.color.Model);
  go.image.draw.floydSteinberg = public partial class(go.image.draw.Drawer);



  go.crypto.tls.helloRequestMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.clientHelloMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.serverHelloMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.newSessionTicketMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.certificateMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.certificateRequestMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.certificateStatusMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.serverKeyExchangeMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.serverHelloDoneMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.clientKeyExchangeMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.certificateVerifyMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.nextProtoMsg = public partial class(go.crypto.tls.handshakeMessage) end;
  go.crypto.tls.finishedMsg = public partial class(go.crypto.tls.handshakeMessage) end;

  go.net.textproto.ProtocolError = public partial record(go.builtin.error) end;
  go.net.textproto.Error = public partial class(go.builtin.error) end;
  go.strings.Reader = public partial class(go.io.Reader) end;
  go.crypto.rsa.PSSOptions = public partial class(go.crypto.SignerOpts);
  //crypto.tls.Conn = public partial class(go.net.Conn);
  go.crypto.x509.ConstraintViolationError = public partial class(go.builtin.error) end;
  go.crypto.x509.CertificateInvalidError = public partial class(go.builtin.error) end;
  go.crypto.x509.SystemRootsError = public partial class(go.builtin.error) end;
  go.crypto.x509.UnknownAuthorityError = public partial class(go.builtin.error) end;
  go.crypto.x509.HostnameError = public partial class(go.builtin.error) end;
  go.crypto.x509.UnhandledCriticalExtension = public partial class(go.builtin.error) end;
  go.golang.org.x.net.http2.hpack.DecodingError = public partial class(go.builtin.error) end;
  go.strings.Reader = public partial class(go.io.ByteScanner) end;
  go.net.http.internal.chunkedWriter =public partial class(go.io.WriteCloser) end;
  go.net.http.internal.chunkedReader =public partial class(go.io.Reader) end;
  go.net.http.ResponseWriter = public partial interface(go.io.Writer) end;
  go.net.smtp.cramMD5Auth = public partial class(go.net.smtp.Auth) end;
  go.net.smtp.plainAuth = public partial class(go.net.smtp.Auth) end;
  go.net.OpError = public partial class(go.builtin.error) end;
  go.crypto.tls.RecordHeaderError = public partial class(go.builtin.error) end;
  go.net.http.http2MetaHeadersFrame = public partial class(go.net.http.http2Frame) end;

  //net.http.http2ErrCode = public partial record(go.builtin.error) end;
  go.net.http.htmlSig = public partial record(go.net.http.sniffSig) end;
  go.net.http.exactSig = public partial class(go.net.http.sniffSig) end;
  go.net.http.maskedSig = public partial class(go.net.http.sniffSig) end;
  go.crypto.tls.alert = public partial record(go.builtin.error) end;
  //net.http.httputil.noBody = public class(go.io.ReadCloser) end;
  go.bytes.Buffer = public partial class(go.io.Reader) end;
  go.net.http.httputil.neverEnding = public partial record(go.io.Reader) end;
  go.io.PipeWriter = public partial class(go.io.Writer) end;
  go.io.PipeReader = public partial class(go.io.Reader) end;
  go.net.http.httputil.failureToReadBody = public partial class(go.io.ReadCloser) end;
  go.net.http.http2bufferedWriter = public partial class(go.io.Writer) end;

  go.crypto.Hash = public partial record(go.crypto.SignerOpts) end;
  go.io.ReadWriteCloser = public partial interface(go.io.Closer) end;

  go.encoding.hex.InvalidByteError = public partial record(go.builtin.error);
  go.encoding.hex.encoder = public partial class(go.io.Writer);
  go.encoding.hex.decoder = public partial class(go.io.Reader);
  go.encoding.hex.dumper = public partial class(go.io.WriteCloser);

  go.fmt.State = public partial interface(go.io.Writer) end;
  go.net.http.http2writePushPromise = public partial class(go.net.http.http2writeFramer) end;
  go.net.http.http2writeWindowUpdate = public partial class(go.net.http.http2writeFramer) end;
  go.net.http.http2write100ContinueHeadersFrame = public partial class(go.net.http.http2writeFramer) end;
  go.net.http.http2writeResHeaders = public partial class(go.net.http.http2writeFramer) end;
  go.net.http.http2handlerPanicRST = public partial class(go.net.http.http2writeFramer) end;
  //net.http.http2responseWriter = public partial class(go.net.http.ResponseWriter) end;

  go.net.http.badStringError = public partial class(go.builtin.error) end;

  go.expvar.Int = public partial class(go.expvar.Var);

  go.expvar.Float = public partial class(go.expvar.Var);
  go.expvar.Map = public partial class(go.expvar.Var);
  go.expvar.Func = public partial record(go.expvar.Var);

  go.encoding.binary.bigEndian = public partial class(:go.encoding.binary.ByteOrder);
  go.encoding.binary.littleEndian = public partial class(:go.encoding.binary.ByteOrder);
  go.net.http.httpError = public partial class(go.builtin.error);
  go.net.http.http2ConnectionError = public partial record(go.builtin.error);

  go.net.http.http2StreamError = public partial class(go.builtin.error);

  //go.mime.multipart.Part = public partial class(go.io.Reader); // defined in partials.cs
  go.bytes.Reader = public partial class(go.io.ReaderAt);

  go.net.http.noBody = public partial class(go.io.ReadCloser);
  go.net.http.body = public partial class(go.io.ReadCloser);

  go.golang.org.x.net.idna.labelError = public partial class(go.builtin.error);
  go.builtin.rune = public partial record
    public
    class operator Implicit(c: Char): go.builtin.rune;
      begin
        exit new go.builtin.rune(Value := Integer(c));
      end;
    class operator Implicit(c: Int32): go.builtin.rune;
      begin
        exit new go.builtin.rune(Value := c);
      end;

    class operator Implicit(c: go.builtin.rune): Int32;
      begin
        exit Int32(c.Value);
      end;
    end;
  go.net.http.http2DataFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2SettingsFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2PingFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2GoAwayFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2UnknownFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2WindowUpdateFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2HeadersFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2PriorityFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2RSTStreamFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2ContinuationFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2PushPromiseFrame = public partial class(go.net.http.http2Frame);
  go.net.http.http2writePingAck = public partial class(go.net.http.http2writeFramer);
  go.net.http.http2StreamError = public partial class(go.net.http.http2writeFramer);
  go.net.http.http2writeGoAway = public partial class(go.net.http.http2writeFramer);
  go.net.http.http2writeSettingsAck = public partial class(go.net.http.http2writeFramer);
  go.net.http.http2flushFrameWriter = public partial class(go.net.http.http2writeFramer);
  go.net.http.http2chunkWriter = public partial class(go.io.Writer);

  go.net.http.http2requestBody = public partial class(go.io.ReadCloser);


  go.crypto.sha256.digest = public partial class(go.hash.Hash, :go.encoding.BinaryMarshaler, :go.encoding.BinaryUnmarshaler);
  go.crypto.sha512.digest = public partial class(go.hash.Hash);
  go.crypto.sha1.digest = public partial class(go.hash.Hash);
  go.crypto.tls.tls10MAC = public partial class(go.crypto.tls.macFunction);
  go.crypto.tls.ssl30MAC = public partial class(go.crypto.tls.macFunction);

  //net.http.ResponseWriter = public partial interface(go.net.http.Handler);
  go.net.http.redirectHandler= public partial class(go.net.http.Handler);
  go.net.http.timeoutHandler= public partial class(go.net.http.Handler);

  go.net.http.ProtocolError = public partial class(go.builtin.error) end;

  go.fmt.pp = public partial class(go.fmt.State);
  go.fmt.ss = public partial class(go.fmt.ScanState);

  go.golang.org.x.net.idna.runeError = public partial record(go.builtin.error);
  //golang.org.x.net.idna.rune = public class(go.builtin.error);
  go.golang.org.x.text.transform.discard = public partial class(go.golang.org.x.text.transform.Transformer);
  go.golang.org.x.text.transform.nop = public partial class(go.golang.org.x.text.transform.Transformer);
  go.golang.org.x.text.transform.chain = public partial class(go.golang.org.x.text.transform.Transformer);
  //golang.org.x.text.transform.rune = public partial class(go.golang.org.x.text.transform.Transformer);

  go.math.big.byteReader = public partial class(go.io.ByteScanner);
  go.bytes.Reader = public partial class(go.io.ByteScanner);
  go.mime.multipart.part = public partial class(go.io.Writer);
  go.net.http.fakeLocker = public partial class(go.sync.Locker);
  go.golang.org.x.text.unicode.norm.normWriter = public partial class(go.io.WriteCloser);
  go.golang.org.x.text.unicode.norm.normReader = public partial class(go.io.Reader);



  go.net.http.http2dataBuffer = public partial class(go.net.http.http2pipeBuffer);
  go.net.http.http2transportResponseBody = public partial class(go.io.ReadCloser);
  go.net.http.http2gzipReader = public partial class(go.io.ReadCloser);
  go.net.http.http2GoAwayError = public partial class(go.builtin.error);
  go.net.http.http2writeData = public partial class(go.net.http.http2writeFramer);
  go.net.http.http2sortPriorityNodeSiblings = public partial record(go.sort.Interface);
  go.net.http.stringWriter = public partial class(go.io.StringWriter);


  go.net.http.http2clientConnPool = public partial class(go.net.http.http2clientConnPoolIdleCloser);
  go.net.http.http2noDialClientConnPool = public partial class(go.net.http.http2clientConnPoolIdleCloser);
  go.net.http.http2noDialClientConnPool = public partial class(go.net.http.http2ClientConnPool);
  go.net.http.http2erringRoundTripper = public partial class(go.net.http.RoundTripper);
  go.net.http.http2Transport = public partial class(go.net.http.RoundTripper);
  go.net.http.http2noDialH2RoundTripper = public partial class(go.net.http.RoundTripper);
  go.net.http.http2connError = public partial class(go.builtin.error);

  //go.net.http.response = public partial class(go.net.http.writerOnly);
  go.net.http.connReader = public partial class(go.io.Reader);
  go.net.http.badRequestError = public partial record(go.builtin.error);
  go.net.http.timeoutWriter = public partial class(go.io.Writer);
  go.net.http.checkConnErrorWriter = public partial class(go.io.Writer);
  go.net.http.expectContinueReader = public partial class(go.io.ReadCloser);

  go.net.http.ServeMux = public partial class(go.net.http.Handler);
  go.net.http.globalOptionsHandler = public partial class(go.net.http.Handler);

  go.encoding.asn1.StructuralError = public partial class(go.builtin.error);
  go.encoding.asn1.multiEncoder = public partial record(:go.encoding.asn1.encoder);
  go.encoding.asn1.bytesEncoder = public partial record(:go.encoding.asn1.encoder);
  go.encoding.asn1.oidEncoder = public partial record(:go.encoding.asn1.encoder);
  go.encoding.asn1.stringEncoder = public partial record(:go.encoding.asn1.encoder);
  go.encoding.asn1.bitStringEncoder = public partial record(:go.encoding.asn1.encoder);
  go.encoding.asn1.int64Encoder = public partial record(:go.encoding.asn1.encoder);

  go.fmt.stringReader = public partial record(go.io.Reader);

  go.math.big.Float = public partial class(go.fmt.Formatter, go.fmt.Scanner);
  go.math.big.Int = public partial class(go.fmt.Formatter, go.fmt.Scanner);
  go.math.big.Rat = public partial class(go.fmt.Scanner);
  go.net.IPConn = public partial class(go.net.http.closeWriter);
  go.net.http.Dir = public partial record(go.net.http.FileSystem);

  go.golang.org.x.text.unicode.bidi.bracketPairs = public partial record(go.sort.Interface);
  go.net.http.http2sorter = public partial class(go.sort.Interface);
  go.net.http.headerSorter = public partial class(go.sort.Interface);
  go.net.http.http2headerFieldValueError = public partial record(go.builtin.error);
  go.net.http.http2headerFieldNameError = public partial record(go.builtin.error);
  go.net.http.http2pseudoHeaderError = public partial record(go.builtin.error);
  go.golang.org.x.net.http2.hpack.InvalidIndexError = public partial record(go.builtin.error);

  go.net.http.http2HeadersFrame = public partial class(go.net.http.http2headersOrContinuation);
  go.net.http.http2ContinuationFrame = public partial class(go.net.http.http2headersOrContinuation);

  go.io.PipeReader = public partial class(go.io.ReadCloser);


  go.crypto.aes.KeySizeError = public partial record(go.builtin.error);
  go.crypto.aes.aesCipher = public partial class(go.crypto.cipher.Block);
  go.crypto.cipher.ctr = public partial class(go.crypto.cipher.Stream);
  go.crypto.cipher.ofb = public partial class(go.crypto.cipher.Stream);
  go.crypto.cipher.gcm = public partial class(go.crypto.cipher.AEAD);

  go.net.http.http2MetaHeadersFrame =public partial class(go.net.http.http2Frame);
  go.net.http.socksAddr = public partial class(go.net.Addr);
  go.net.http.byteReader = public partial class(go.io.Reader);
  go.net.http.bodyLocked = public partial class(go.io.Reader);
  go.net.http.finishAsyncByteRead = public partial class(go.io.Reader);
  go.net.http.transferBodyReader = public partial class(go.io.Reader);
  go.encoding.asn1.SyntaxError = public partial class(go.builtin.error);

  go.net.http.fcgi.streamWriter = public partial class(go.io.Writer);
  go.crypto.rc4.KeySizeError = public partial record(go.builtin.error);
  go.crypto.tls.rsaKeyAgreement = public partial class(go.crypto.tls.keyAgreement);
  go.crypto.tls.ecdheKeyAgreement = public partial class(go.crypto.tls.keyAgreement);
  go.net.http.fcgi.streamWriter = public partial class(go.io.Closer);

  go.golang.org.x.crypto.chacha20poly1305.chacha20poly1305 = public partial class(go.crypto.cipher.AEAD);
  go.golang.org.x.crypto.internal.chacha20.Cipher = public partial class(go.crypto.cipher.Stream);

  go.crypto.tls.lruSessionCache = public partial class(go.crypto.tls.ClientSessionCache);
  go.net.http.httputil.delegateReader = public partial class(go.io.Reader);
  go.net.http.httputil.dumpConn = public partial class(go.net.Conn);

  go.net.http.http2responseWriter = public partial class(go.net.http.Pusher);
  go.net.http.http2httpError = public partial class(go.builtin.error);
  go.net.http.http2responseWriter = public partial class(go.net.http.CloseNotifier, go.net.http.Flusher, go.net.http.http2stringWriter);
  go.net.http.http2noCachedConnError = public partial class(go.builtin.error);
  go.net.http.http2badStringError = public partial class(go.builtin.error);
  go.net.http.http2priorityWriteScheduler = public partial class(go.net.http.http2WriteScheduler);
  go.net.http.http2randomWriteScheduler = public partial clasS(go.net.http.http2WriteScheduler);
  go.net.http.noBody = public partial class(go.io.WriterTo);
  go.net.http.maxBytesReader= public partial class(go.io.ReadCloser);

  go.net.http.fileHandler = public partial class(go.net.http.Handler);
  go.net.http.countingWriter = public partial record(go.io.Writer);
  go.crypto.x509.InsecureAlgorithmError = public partial record(go.builtin.error);

  go.net.textproto.dotReader = public partial class(go.io.Reader);
  go.net.textproto.dotWriter = public partial class(go.io.WriteCloser);

  go.net.http.httputil.maxLatencyWriter = public partial class(go.io.Writer);


  go.net.http.http2goAwayFlowError = public partial class(go.builtin.error);
  go.io.ReadWriteCloser = public partial interface(go.io.ReadCloser);
  go.net.http.transportReadFromServerError = public partial class(go.builtin.error);
  go.net.http.bodyEOFSignal = public partial class(go.io.ReadCloser);
  go.net.http.gzipReader = public partial class(go.io.ReadCloser);


  go.crypto.tls.fixedNonceAEAD = public partial class(go.crypto.cipher.AEAD, go.crypto.tls.aead);
  go.crypto.tls.xorNonceAEAD = public partial class(go.crypto.cipher.AEAD, go.crypto.tls.aead);
  go.crypto.tls.cthWrapper = public partial class(go.hash.Hash);

  go.net.http.fileTransport = public partial class(go.net.http.RoundTripper);
  go.net.http.Transport = public partial class(go.net.http.RoundTripper);

  go.encoding.asn1.byteEncoder = public partial record(:go.encoding.asn1.encoder);
  go.encoding.asn1.taggedEncoder = public partial class(:go.encoding.asn1.encoder);
  go.encoding.pem.lineBreaker = public partial class(go.io.Writer);


  go.crypto.cipher.StreamReader = public partial class(go.io.Reader);
  go.crypto.elliptic.CurveParams = public partial class(go.crypto.elliptic.Curve);
  go.crypto.elliptic.p256Curve = public partial class(go.crypto.elliptic.Curve);
  go.crypto.elliptic.p224Curve = public partial class(go.crypto.elliptic.Curve);
  go.crypto.hmac.hmac = public partial class(go.hash.Hash);
  go.crypto.md5.digest = public partial class(go.hash.Hash);

  go.crypto.des.KeySizeError = public partial record(go.builtin.error);
  go.crypto.des.tripleDESCipher = public partial class(go.crypto.cipher.Block);

  go.mime.multipart.partReader = public partial class(go.io.Reader);
  go.mime.quotedprintable.Reader = public partial class(go.io.Reader);
  go.net.http.cancelTimerBody = public partial class(go.io.ReadCloser);
  go.os.File = public partial class(go.io.ReadSeeker);

  go.crypto.cipher.cbcEncrypter = public partial record(go.crypto.cipher.BlockMode);
  go.crypto.cipher.cfb = public partial class(go.crypto.cipher.Stream);

  go.crypto.des.desCipher = public partial class(go.crypto.cipher.Block);
  go.mime.multipart.stickyErrorReader = public partial class(go.io.Reader);


  go.fmt.readRune = public partial class(go.io.RuneScanner);
  go.golang.org.x.text.transform.nop = public partial class(go.golang.org.x.text.transform.SpanningTransformer);
  go.golang.org.x.text.transform.removeF = public partial record(go.golang.org.x.text.transform.Transformer);

  go.net.mail.charsetError = public partial record(go.builtin.error);
  go.net.http.persistConn = public partial class(go.io.Reader);
  go.net.http.persistConnWriter = public partial class(go.io.Writer);
  go.mime.multipart.sectionReadCloser = public partial class(go.mime.multipart.File);
  go.crypto.cipher.cbcDecrypter= public partial record(go.crypto.cipher.BlockMode);
  go.os.File = public partial class(go.mime.multipart.File, go.net.http.File);
  go.net.http.errorReader = public partial class(go.io.Reader);
  go.net.http.fcgi.response = public partial class(go.net.http.ResponseWriter);

  go.net.http.http2MetaHeadersFrame = public partial class(go.net.http.http2Frame);
  go.net.http.populateResponse = public partial class(go.net.http.ResponseWriter);

  go.net.http.http2duplicatePseudoHeaderError = public partial record(go.builtin.error);
  go.net.http.http2responseWriter = public partial class(go.net.http.ResponseWriter);
  go.net.http.http2serverConn = public partial class(go.net.http.http2writeContext);
  go.net.http.http2ConnectionError = public partial record(go.builtin.error);
  go.net.http.http2stickyErrWriter = public partial class(go.io.Writer);
  go.net.Conn = public partial interface(go.io.ReadWriter);
  go.net.http.File = public partial interface(go.io.ReadSeeker);
  go.net.http.cgi.response = public partial class(go.net.http.ResponseWriter);

  go.net.http.chunkWriter = public partial class(go.io.Writer);
  go.net.http.http2Transport = public partial class(go.net.http.h2Transport);

  go.net.http.http2writeSettings = public partial record(go.net.http.http2writeFramer);
  go.io.ReadCloser = public partial soft interface end;

  go.net.http.initNPNRequest = public partial class(go.net.http.Handler);

  go.net.http.timeoutWriter = public partial class(go.net.http.ResponseWriter);
  go.net.http.HandlerFunc = public partial record(go.net.http.Handler);
  go.net.http.response = public partial class(go.net.http.ResponseWriter);
  go.net.http.tlsHandshakeTimeoutError = public partial class(go.builtin.error);
  go.crypto.tls.timeoutError = public partial class(go.builtin.error);
  go.expvar.String = public partial class(go.expvar.Var);
  go.time.Time = public partial class(go.fmt.Stringer);
  go.math.rand.rngSource = public partial class(:go.math.rand.Source, :go.math.rand.Source64);

  go.crypto.ecdsa.PrivateKey = public partial class(:go.crypto.Signer);
  go.crypto.rsa.PrivateKey = public partial class(:go.crypto.Signer);

  go.golang.org.x.net.websocket.Addr = public partial class(:go.net.Addr);
  go.golang.org.x.net.internal.socks.Addr = public partial class(:go.net.Addr);
  go.golang.org.x.net.webdav.internal.xml.Name = public partial class(go.encoding.xml.Name);
  go.golang.org.x.net.webdav.memFileInfo = public partial class(:go.os.FileInfo);
end.
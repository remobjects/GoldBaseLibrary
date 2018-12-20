namespace;
type
  context.cancelCtx = public partial class(context.canceler, context.Context) end;
  context.valueCtx = public partial class(context.Context) end;
  context.emptyCtx = public partial record (context.Context) end;

  errors.errorString = public partial class(builtin.error) end;
  context.deadlineExceededError = public partial class(builtin.error) end;
  archive.tar.headerError = public partial record(builtin.error) end;
  time.ParseError = public partial class(builtin.error) end;
  strconv.NumError = public partial class(builtin.error) end;
  time.fileSizeError = public partial record(builtin.error) end;
  database.sql.driverConn = public partial class(database.sql.finalCloser) end;
  database.sql.driverResult = public partial class(database.sql.Result) end;
  database.sql.Stmt = public partial class(database.sql.finalCloser) end;
  database.sql.Tx = public partial class(database.sql.stmtConnGrabber) end;
  database.sql.Conn = public partial class(database.sql.stmtConnGrabber) end;
  io.eofReader = public partial class(io.Reader) end;
  io.multiReader = public partial class(io.Reader) end;
  io.LimitedReader = public partial class(io.Reader) end;
  io.multiWriter = public partial class(io.Writer, io.StringWriter) end;
  io.teeReader = public partial class(io.Reader) end;
  database.sql.driver.noRows = public partial class(database.sql.driver.&Result) end;
  database.sql.driver.boolType = public partial class(database.sql.driver.ValueConverter) end;
  database.sql.driver.int32Type = public partial class(database.sql.driver.ValueConverter) end;
  database.sql.driver.defaultConverter = public partial class(database.sql.driver.ValueConverter) end;
  database.sql.dsnConnector = public partial class(database.sql.driver.Connector) end;
  archive.zip.headerFileInfo = public partial class(os.FileInfo) end;
  archive.tar.headerFileInfo = public partial class(os.FileInfo) end;
  compress.flate.CorruptInputError = public partial record(builtin.error) end;
  compress.flate.InternalError = public partial record(builtin.error) end;
  compress.bzip2.StructuralError = public partial record(builtin.error) end;
  archive.tar.Reader = public partial class(io.Reader) end;
  archive.tar.Writer = public partial class(io.Writer) end;
  archive.tar.zeroReader = public partial class(io.Reader) end;
  archive.tar.fileWriter = public partial interface(io.Writer) end;
  archive.tar.sparseFileWriter = public partial class(archive.tar.fileWriter) end;
  archive.tar.regFileWriter = public partial class(archive.tar.fileWriter) end;
  archive.tar.sparseFileReader = public partial class(archive.tar.fileReader) end;
  archive.tar.regFileReader = public partial class(archive.tar.fileReader) end;
  io.SectionReader = public partial class(io.Reader) end;
  bufio.Reader = public partial class(io.Reader, image.reader) end;
  archive.zip.checksumReader = public partial class(io.ReadCloser) end;
  archive.zip.pooledFlateReader = public partial class(io.ReadCloser) end;
  archive.zip.fileWriter = public partial class(io.Writer) end;
  compress.lzw.decoder = public partial class(io.ReadCloser) end;
  compress.flate.dictWriter = public partial class(io.Writer) end;
  compress.lzw.errWriteCloser = public partial class(io.WriteCloser) end;
  archive.zip.pooledFlateWriter = public partial class(io.WriteCloser) end;
  bufio.Reader = public partial class(compress.flate.Reader) end;
  bufio.Writer = public partial class(io.Writer, image.jpeg.writer) end;
  compress.bzip2.reader = public partial class(io.Reader) end;
  compress.flate.byLiteral = public partial record(sort.Interface) end;
  compress.flate.byFreq = public partial record(sort.Interface) end;
  sort.reverse = public partial class(sort.Interface) end;
  compress.flate.decompressor = public partial class(io.ReadCloser) end;
  compress.lzw.encoder = public partial class(io.WriteCloser) end;
  compress.lzw.writer = public partial interface(io.ByteWriter) end;
  archive.zip.nopCloser = public partial class(io.WriteCloser) end;

  sort.IntSlice = public partial record(sort.Interface) end;
  sort.Float64Slice = public partial record(sort.Interface) end;
  sort.StringSlice = public partial record(sort.Interface) end;

  archive.zip.dirWriter = public partial class(io.Writer) end;
  archive.zip.countWriter= public partial class(io.Writer) end;
  io.ReaderFrom = public partial interface(io.Writer) end;
  strings.singleStringReplacer = public partial class(strings.«replacer») end;
  strings.genericReplacer = public partial class(strings.«replacer») end;
  strings.byteStringReplacer = public partial class(strings.«replacer») end;
  strings.byteReplacer = public partial record(strings.«replacer») end;

  os.SyscallError = public partial class(builtin.error) end;
  bufio.Writer = public partial class(compress.lzw.writer) end;

  hash.fnv.sum64a = public partial record(hash.Hash64, hash.Hash) end;
  hash.fnv.sum64 = public partial record(hash.Hash64, hash.Hash) end;
  hash.crc64.digest = public partial class(hash.Hash64, hash.Hash) end;
  hash.crc32.digest = public partial class(hash.Hash32, hash.Hash) end;
  hash.adler32.digest = public partial record(hash.Hash32, hash.Hash) end;
  hash.fnv.sum32a = public partial record(hash.Hash32, hash.Hash) end;
  hash.fnv.sum32 = public partial record(hash.Hash32, hash.Hash) end;
  hash.fnv.sum128 = public partial record(hash.Hash) end;
  hash.fnv.sum128a = public partial record(hash.Hash) end;

  os.PathError = public partial class(builtin.error) end;
  text.template.ExecError = public partial class(builtin.error) end;

  strings.appendSliceWriter = public partial record(io.Writer) end;
  strings.stringWriter = public partial class(io.StringWriter) end;

  compress.zlib.reader =  public partial class(io.ReadCloser) end;



  flag.durationValue = public partial record(flag.Value) end;
  flag.float64Value = public partial record(flag.Value) end;
  flag.stringValue = public partial record(flag.Value) end;
  flag.uint64Value = public partial record(flag.Value) end;
  flag.uintValue = public partial record(flag.Value) end;
  flag.int64Value = public partial record(flag.Value) end;
  flag.intValue = public partial record(flag.Value) end;
  flag.boolValue = public partial record(flag.Value) end;


  regexp.inputReader = public partial class(regexp.input) end;
  regexp.inputString = public partial class(regexp.input) end;
  regexp.inputBytes = public partial class(regexp.input) end;
  regexp.syntax.Error = public partial class(builtin.error) end;

  &index.suffixarray.suffixSortable = public partial class(sort.Interface) end;

  regexp.runeSlice = public partial record(sort.Interface) end;
  regexp.syntax.ranges = public partial class(sort.Interface) end;

  text.template.parse.VariableNode = public partial class(text.template.parse.Node) end;
  text.template.parse.ChainNode = public partial class(text.template.parse.Node);
  text.template.parse.FieldNode = public partial class(text.template.parse.Node);
  text.template.parse.NumberNode = public partial class(text.template.parse.Node);
  text.template.parse.CommandNode = public partial class(text.template.parse.Node);
  text.template.parse.PipeNode = public partial class(text.template.parse.Node);
  text.template.parse.RangeNode = public partial class(text.template.parse.Node);
  text.template.parse.ListNode = public partial class(text.template.parse.Node);
  text.template.parse.ActionNode = public partial class(text.template.parse.Node);
  text.template.parse.IdentifierNode = public partial class(text.template.parse.Node);
  text.template.parse.TemplateNode = public partial class(text.template.parse.Node);
  text.template.parse.TextNode = public partial class(text.template.parse.Node);
  text.template.parse.DotNode = public partial class(text.template.parse.Node);
  text.template.parse.NilNode = public partial class(text.template.parse.Node);
  text.template.parse.BoolNode = public partial class(text.template.parse.Node);
  text.template.parse.StringNode = public partial class(text.template.parse.Node);
  text.template.parse.endNode = public partial class(text.template.parse.Node);
  text.template.parse.elseNode = public partial class(text.template.parse.Node);
  text.template.parse.IfNode = public partial class(text.template.parse.Node);
  text.template.parse.WithNode = public partial class(text.template.parse.Node);
  text.template.parse.BranchNode = public partial class(text.template.parse.Node);

  html.template.Error = public partial class(builtin.error);

  bytes.Buffer = public partial class(io.Writer);
  bytes.Reader = public partial class(io.Reader);

  net.url.Error = public partial class(builtin.error);
  net.url.EscapeError = public partial record(builtin.error);
  net.url.InvalidHostError = public partial record(builtin.error);

  encoding.json.UnmarshalTypeError = public partial class(builtin.error);
  encoding.base64.CorruptInputError = public partial record(builtin.error);
  encoding.base64.encoder = public partial class(io.WriteCloser);
  encoding.base64.newlineFilteringReader = public partial class(io.Reader);
  encoding.base64.decoder = public partial class(io.Reader);
  encoding.json.InvalidUnmarshalError = public partial class(builtin.error);
  encoding.json.UnsupportedValueError = public partial class(builtin.error);
  encoding.json.UnsupportedTypeError = public partial class(builtin.error);
  encoding.json.SyntaxError = public partial class(builtin.error);
  encoding.json.MarshalerError = public partial class(builtin.error);
  encoding.json.byIndex = public partial record(sort.Interface);
  encoding.json.RawMessage = public partial record(:encoding.json.Marshaler, :encoding.json.Unmarshaler);

  image.color.NRGBA = public partial class(image.color.Color);
  image.color.RGBA = public partial class(image.color.Color);
  image.color.NRGBA64 = public partial class(image.color.Color);
  image.color.RGBA64 = public partial class(image.color.Color);
  image.color.Alpha = public partial class(image.color.Color);
  image.color.Alpha16 = public partial class(image.color.Color);
  image.color.Gray = public partial class(image.color.Color);
  image.color.Gray16 = public partial class(image.color.Color);

  image.color.CMYK = public partial class(image.color.Color);

  image.NRGBA = public partial class(image.Image);
  image.RGBA = public partial class(image.Image);
  image.NRGBA64 = public partial class(image.Image);
  image.RGBA64 = public partial class(image.Image);
  image.Alpha = public partial class(image.Image);
  image.Alpha16 = public partial class(image.Image);
  image.Gray = public partial class(image.Image);
  image.Gray16 = public partial class(image.Image);
  image.CMYK = public partial class(image.Image);

  image.color.YCbCr = public partial class(image.color.Color);
  image.YCbCr = public partial class(image.Image);


  image.color.NYCbCrA = public partial class(image.color.Color);
  image.NYCbCrA = public partial class(image.Image);


  image.Paletted  = public partial class(image.Image);
  image.Paletted  = public partial class(image.draw.Image);
  image.jpeg.UnsupportedError = public partial record(builtin.error);
  image.jpeg.FormatError = public partial record(builtin.error);
  image.png.UnsupportedError = public partial record(builtin.error);
  image.png.FormatError = public partial record(builtin.error);
  image.png.decoder = public partial class(io.Reader);
  image.Uniform = public partial class(image.color.Model);
  image.color.Palette = public partial record(image.color.Model);
  image.color.modelFunc = public partial class(image.color.Model);
  image.draw.floydSteinberg = public partial class(image.draw.Drawer);



  crypto.tls.helloRequestMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.clientHelloMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.serverHelloMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.newSessionTicketMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.certificateMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.certificateRequestMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.certificateStatusMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.serverKeyExchangeMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.serverHelloDoneMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.clientKeyExchangeMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.certificateVerifyMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.nextProtoMsg = public partial class(crypto.tls.handshakeMessage) end;
  crypto.tls.finishedMsg = public partial class(crypto.tls.handshakeMessage) end;

  net.textproto.ProtocolError = public partial record(builtin.error) end;
  net.textproto.Error = public partial class(builtin.error) end;
  strings.Reader = public partial class(io.Reader) end;
  crypto.rsa.PSSOptions = public partial class(crypto.SignerOpts);
  //crypto.tls.Conn = public partial class(net.Conn);
  crypto.x509.ConstraintViolationError = public partial class(builtin.error) end;
  crypto.x509.CertificateInvalidError = public partial class(builtin.error) end;
  crypto.x509.SystemRootsError = public partial class(builtin.error) end;
  crypto.x509.UnknownAuthorityError = public partial class(builtin.error) end;
  crypto.x509.HostnameError = public partial class(builtin.error) end;
  crypto.x509.UnhandledCriticalExtension = public partial class(builtin.error) end;
  golang_org.x.net.http2.hpack.DecodingError = public partial class(builtin.error) end;
  strings.Reader = public partial class(io.ByteScanner) end;
  net.http.internal.chunkedWriter =public partial class(io.WriteCloser) end;
  net.http.internal.chunkedReader =public partial class(io.Reader) end;
  net.http.ResponseWriter = public partial interface(io.Writer) end;
  net.smtp.cramMD5Auth = public partial class(net.smtp.Auth) end;
  net.smtp.plainAuth = public partial class(net.smtp.Auth) end;
  net.OpError = public partial class(builtin.error) end;
  crypto.tls.RecordHeaderError = public partial class(builtin.error) end;
  net.http.http2MetaHeadersFrame = public partial class(net.http.http2Frame) end;

  //net.http.http2ErrCode = public partial record(builtin.error) end;
  net.http.htmlSig = public partial record(net.http.sniffSig) end;
  crypto.tls.alert = public partial record(builtin.error) end;
  //net.http.httputil.noBody = public class(io.ReadCloser) end;
  bytes.Buffer = public partial class(io.Reader) end;
  net.http.httputil.neverEnding = public partial record(io.Reader) end;
  io.PipeWriter = public partial class(io.Writer) end;
  io.PipeReader = public partial class(io.Reader) end;
  net.http.httputil.failureToReadBody = public partial class(io.ReadCloser) end;
  net.http.http2bufferedWriter = public partial class(io.Writer) end;

  crypto.Hash = public partial record(crypto.SignerOpts) end;
  io.ReadWriteCloser = public partial interface(io.Closer) end;

  encoding.hex.InvalidByteError = public partial record(builtin.error);
  encoding.hex.encoder = public partial class(io.Writer);
  encoding.hex.decoder = public partial class(io.Reader);
  encoding.hex.dumper = public partial class(io.WriteCloser);

  fmt.State = public partial interface(io.Writer) end;
  net.http.http2writePushPromise = public partial class(net.http.http2writeFramer) end;
  net.http.http2writeWindowUpdate = public partial class(net.http.http2writeFramer) end;
  net.http.http2write100ContinueHeadersFrame = public partial class(net.http.http2writeFramer) end;
  net.http.http2writeResHeaders = public partial class(net.http.http2writeFramer) end;
  net.http.http2handlerPanicRST = public partial class(net.http.http2writeFramer) end;
  //net.http.http2responseWriter = public partial class(net.http.ResponseWriter) end;

  net.http.badStringError = public partial class(builtin.error) end;

  expvar.Int = public partial class(expvar.Var);

  expvar.Float = public partial class(expvar.Var);
  expvar.Map = public partial class(expvar.Var);
  expvar.Func = public partial record(expvar.Var);

  encoding.binary.bigEndian = public partial class(:encoding.binary.ByteOrder);
  encoding.binary.littleEndian = public partial class(:encoding.binary.ByteOrder);
  net.http.httpError = public partial class(builtin.error);
  net.http.http2ConnectionError = public partial record(builtin.error);

  net.http.http2StreamError = public partial class(builtin.error);

  mime.multipart.Part = public partial class(io.Reader);
  bytes.Reader = public partial class(io.ReaderAt);

  net.http.noBody = public partial class(io.ReadCloser);
  net.http.body = public partial class(io.ReadCloser);

  golang_org.x.net.idna.labelError = public partial class(builtin.error);
  builtin.rune = public partial record
  public
    class operator Implicit(c: Char): builtin.rune;
    begin
      exit new builtin.rune(Value := c);
    end;
    class operator Implicit(c: Int32): builtin.rune;
    begin
      exit new builtin.rune(Value := Char(c));
    end;

    class operator Implicit(c: builtin.rune): Int32;
    begin
      exit Int32(c.Value);
    end;
  end;
  net.http.http2DataFrame = public partial class(net.http.http2Frame);
  net.http.http2SettingsFrame = public partial class(net.http.http2Frame);
  net.http.http2PingFrame = public partial class(net.http.http2Frame);
  net.http.http2GoAwayFrame = public partial class(net.http.http2Frame);
  net.http.http2UnknownFrame = public partial class(net.http.http2Frame);
  net.http.http2WindowUpdateFrame = public partial class(net.http.http2Frame);
  net.http.http2HeadersFrame = public partial class(net.http.http2Frame);
  net.http.http2PriorityFrame = public partial class(net.http.http2Frame);
  net.http.http2RSTStreamFrame = public partial class(net.http.http2Frame);
  net.http.http2ContinuationFrame = public partial class(net.http.http2Frame);
  net.http.http2PushPromiseFrame = public partial class(net.http.http2Frame);
  net.http.http2writePingAck = public partial class(net.http.http2writeFramer);
  net.http.http2StreamError = public partial class(net.http.http2writeFramer);
  net.http.http2writeGoAway = public partial class(net.http.http2writeFramer);
  net.http.http2writeSettingsAck = public partial class(net.http.http2writeFramer);
  net.http.http2flushFrameWriter = public partial class(net.http.http2writeFramer);
  net.http.http2chunkWriter = public partial class(io.Writer);

  net.http.http2requestBody = public partial class(io.ReadCloser);


  crypto.sha256.digest = public partial class(hash.Hash);
  crypto.sha512.digest = public partial class(hash.Hash);
  crypto.sha1.digest = public partial class(hash.Hash);
  crypto.tls.tls10MAC = public partial class(crypto.tls.macFunction);
  crypto.tls.ssl30MAC = public partial class(crypto.tls.macFunction);

  //net.http.ResponseWriter = public partial interface(net.http.Handler);
  net.http.redirectHandler= public partial class(net.http.Handler);
  net.http.timeoutHandler= public partial class(net.http.Handler);

  net.http.ProtocolError = public partial class(builtin.error) end;

  fmt.pp = public partial class(fmt.State);
  fmt.ss = public partial class(fmt.ScanState);

  golang_org.x.net.idna.runeError = public partial record(builtin.error);
  //golang_org.x.net.idna.rune = public class(builtin.error);
  golang_org.x.text.transform.discard = public partial class(golang_org.x.text.transform.Transformer);
  golang_org.x.text.transform.nop = public partial class(golang_org.x.text.transform.Transformer);
  golang_org.x.text.transform.chain = public partial class(golang_org.x.text.transform.Transformer);
  //golang_org.x.text.transform.rune = public partial class(golang_org.x.text.transform.Transformer);

  math.big.byteReader = public partial class(io.ByteScanner);
  bytes.Reader = public partial class(io.ByteScanner);
  mime.multipart.part = public partial class(io.Writer);
  net.http.fakeLocker = public partial class(sync.Locker);
  golang_org.x.text.unicode.norm.normWriter = public partial class(io.WriteCloser);
  golang_org.x.text.unicode.norm.normReader = public partial class(io.Reader);



  net.http.http2dataBuffer = public partial class(net.http.http2pipeBuffer);
  net.http.http2transportResponseBody = public partial class(io.ReadCloser);
  net.http.http2gzipReader = public partial class(io.ReadCloser);
  net.http.http2GoAwayError = public partial class(builtin.error);
  net.http.http2writeData = public partial class(net.http.http2writeFramer);
  net.http.http2sortPriorityNodeSiblings = public partial record(sort.Interface);
  net.http.stringWriter = public partial class(io.StringWriter);


  net.http.http2clientConnPool = public partial class(net.http.http2clientConnPoolIdleCloser);
  net.http.http2noDialClientConnPool = public partial class(net.http.http2clientConnPoolIdleCloser);
  net.http.http2noDialClientConnPool = public partial class(net.http.http2ClientConnPool);
  net.http.http2erringRoundTripper = public partial class(net.http.RoundTripper);
  net.http.http2Transport = public partial class(net.http.RoundTripper);
  net.http.http2noDialH2RoundTripper = public partial class(net.http.RoundTripper);
  net.http.http2connError = public partial class(builtin.error);

  net.http.response = public partial class(net.http.writerOnly);
  net.http.connReader = public partial class(io.Reader);
  net.http.badRequestError = public partial record(builtin.error);
  net.http.timeoutWriter = public partial class(io.Writer);
  net.http.checkConnErrorWriter = public partial class(io.Writer);
  net.http.expectContinueReader = public partial class(io.ReadCloser);

  net.http.ServeMux = public partial class(net.http.Handler);
  net.http.globalOptionsHandler = public partial class(net.http.Handler);

  encoding.asn1.StructuralError = public partial class(builtin.error);
  encoding.asn1.multiEncoder = public partial record(:encoding.asn1.encoder);
  encoding.asn1.bytesEncoder = public partial record(:encoding.asn1.encoder);
  encoding.asn1.oidEncoder = public partial record(:encoding.asn1.encoder);
  encoding.asn1.stringEncoder = public partial record(:encoding.asn1.encoder);
  encoding.asn1.bitStringEncoder = public partial record(:encoding.asn1.encoder);
  encoding.asn1.int64Encoder = public partial record(:encoding.asn1.encoder);

  fmt.stringReader = public partial record(io.Reader);

  math.big.Float = public partial class(fmt.Formatter, fmt.Scanner);
  math.big.Int = public partial class(fmt.Formatter, fmt.Scanner);
  math.big.Rat = public partial class(fmt.Scanner);
  net.IPConn = public partial class(net.http.closeWriter);
  net.http.Dir = public partial record(net.http.FileSystem);

  golang_org.x.text.unicode.bidi.bracketPairs = public partial record(sort.Interface);
  net.http.http2sorter = public partial class(sort.Interface);
  net.http.headerSorter = public partial class(sort.Interface);
  net.http.http2headerFieldValueError = public partial record(builtin.error);
  net.http.http2headerFieldNameError = public partial record(builtin.error);
  net.http.http2pseudoHeaderError = public partial record(builtin.error);
  golang_org.x.net.http2.hpack.InvalidIndexError = public partial record(builtin.error);

  net.http.http2HeadersFrame = public partial class(net.http.http2headersOrContinuation);
  net.http.http2ContinuationFrame = public partial class(net.http.http2headersOrContinuation);

  io.PipeReader = public partial class(io.ReadCloser);


  crypto.aes.KeySizeError = public partial record(builtin.error);
  crypto.aes.aesCipher = public partial class(crypto.cipher.Block);
  crypto.cipher.ctr = public partial class(crypto.cipher.Stream);
  crypto.cipher.ofb = public partial class(crypto.cipher.Stream);
  crypto.cipher.gcm = public partial class(crypto.cipher.AEAD);

  net.http.http2MetaHeadersFrame =public partial class(net.http.http2Frame);
  net.http.socksAddr = public partial class(net.Addr);
  net.http.byteReader = public partial class(io.Reader);
  net.http.bodyLocked = public partial class(io.Reader);
  net.http.finishAsyncByteRead = public partial class(io.Reader);
  net.http.transferBodyReader = public partial class(io.Reader);
  encoding.asn1.SyntaxError = public partial class(builtin.error);

  net.http.fcgi.streamWriter = public partial class(io.Writer);
  crypto.rc4.KeySizeError = public partial record(builtin.error);
  crypto.tls.rsaKeyAgreement = public partial class(crypto.tls.keyAgreement);
  crypto.tls.ecdheKeyAgreement = public partial class(crypto.tls.keyAgreement);
  net.http.fcgi.streamWriter = public partial class(io.Closer);

  golang_org.x.crypto.chacha20poly1305.chacha20poly1305 = public partial class(crypto.cipher.AEAD);
  golang_org.x.crypto.internal.chacha20.Cipher = public partial class(crypto.cipher.Stream);

  crypto.tls.lruSessionCache = public partial class(crypto.tls.ClientSessionCache);
  net.http.httputil.delegateReader = public partial class(io.Reader);
  net.http.httputil.dumpConn = public partial class(net.Conn);

  net.http.http2responseWriter = public partial class(net.http.Pusher);
  net.http.http2httpError = public partial class(builtin.error);
  net.http.http2responseWriter = public partial class(net.http.CloseNotifier, net.http.Flusher, net.http.http2stringWriter);
  net.http.http2noCachedConnError = public partial class(builtin.error);
  net.http.http2badStringError = public partial class(builtin.error);
  net.http.http2priorityWriteScheduler = public partial class(net.http.http2WriteScheduler);
  net.http.http2randomWriteScheduler = public partial clasS(net.http.http2WriteScheduler);
  net.http.noBody = public partial class(io.WriterTo);
  net.http.maxBytesReader= public partial class(io.ReadCloser);

  net.http.fileHandler = public partial class(net.http.Handler);
  net.http.countingWriter = public partial record(io.Writer);
  crypto.x509.InsecureAlgorithmError = public partial record(builtin.error);

  net.textproto.dotReader = public partial class(io.Reader);
  net.textproto.dotWriter = public partial class(io.WriteCloser);

  net.http.httputil.maxLatencyWriter = public partial class(io.Writer);


  net.http.http2goAwayFlowError = public partial class(builtin.error);
  io.ReadWriteCloser = public partial interface(io.ReadCloser);
  net.http.transportReadFromServerError = public partial class(builtin.error);
  net.http.bodyEOFSignal = public partial class(io.ReadCloser);
  net.http.gzipReader = public partial class(io.ReadCloser);


  crypto.tls.fixedNonceAEAD = public partial class(crypto.cipher.AEAD);
  crypto.tls.xorNonceAEAD = public partial class(crypto.cipher.AEAD);
  crypto.tls.cthWrapper = public partial class(hash.Hash);

  net.http.fileTransport = public partial class(net.http.RoundTripper);
  net.http.Transport = public partial class(net.http.RoundTripper);

  encoding.asn1.byteEncoder = public partial record(:encoding.asn1.encoder);
  encoding.asn1.taggedEncoder = public partial class(:encoding.asn1.encoder);
  encoding.pem.lineBreaker = public partial class(io.Writer);


  crypto.cipher.StreamReader = public partial class(io.Reader);
  crypto.elliptic.CurveParams = public partial class(crypto.elliptic.Curve);
  crypto.elliptic.p256Curve = public partial class(crypto.elliptic.Curve);
  crypto.elliptic.p224Curve = public partial class(crypto.elliptic.Curve);
  crypto.hmac.hmac = public partial class(hash.Hash);
  crypto.md5.digest = public partial class(hash.Hash);

  crypto.des.KeySizeError = public partial record(builtin.error);
  crypto.des.tripleDESCipher = public partial class(crypto.cipher.Block);

  mime.multipart.partReader = public partial class(io.Reader);
  mime.quotedprintable.Reader = public partial class(io.Reader);
  net.http.cancelTimerBody = public partial class(io.ReadCloser);
  os.File = public partial class(io.ReadSeeker);

  crypto.cipher.cbcEncrypter = public partial record(crypto.cipher.BlockMode);
  crypto.cipher.cfb = public partial class(crypto.cipher.Stream);

  crypto.des.desCipher = public partial class(crypto.cipher.Block);
  mime.multipart.stickyErrorReader = public partial class(io.Reader);


  fmt.readRune = public partial class(io.RuneScanner);
  golang_org.x.text.transform.nop = public partial class(golang_org.x.text.transform.SpanningTransformer);
  golang_org.x.text.transform.removeF = public partial record(golang_org.x.text.transform.Transformer);

  net.mail.charsetError = public partial record(builtin.error);
  net.http.persistConn = public partial class(io.Reader);
  net.http.persistConnWriter = public partial class(io.Writer);
  mime.multipart.sectionReadCloser = public partial class(mime.multipart.File);
  crypto.cipher.cbcDecrypter= public partial record(crypto.cipher.BlockMode);
  os.File = public partial class(mime.multipart.File, net.http.File);
  net.http.errorReader = public partial class(io.Reader);
  net.http.fcgi.response = public partial class(net.http.ResponseWriter);

  net.http.http2MetaHeadersFrame = public partial class(net.http.http2Frame);
  net.http.populateResponse = public partial class(net.http.ResponseWriter);

  net.http.http2duplicatePseudoHeaderError = public partial record(builtin.error);
  net.http.http2responseWriter = public partial class(net.http.ResponseWriter);
  net.http.http2serverConn = public partial class(net.http.http2writeContext);
  net.http.http2ConnectionError = public partial record(builtin.error);
  net.http.http2stickyErrWriter = public partial class(io.Writer);
  net.Conn = public partial interface(io.ReadWriter);
  net.http.File = public partial interface(io.ReadSeeker);
  net.http.cgi.response = public partial class(net.http.ResponseWriter);

  net.http.chunkWriter = public partial class(io.Writer);
  net.http.http2Transport = public partial class(net.http.h2Transport);

  net.http.http2writeSettings = public partial record(net.http.http2writeFramer);
  io.ReadCloser = public partial soft interface end;

  net.http.initNPNRequest = public partial class(net.http.Handler);

  net.http.timeoutWriter = public partial class(net.http.ResponseWriter);
  net.http.HandlerFunc = public partial record(net.http.Handler);
  net.http.response = public partial class(net.http.ResponseWriter);
  net.http.tlsHandshakeTimeoutError = public partial class(builtin.error);
  crypto.tls.timeoutError = public partial class(builtin.error);
  expvar.String = public partial class(expvar.Var);
  time.Time = public partial class(fmt.Stringer);
end.
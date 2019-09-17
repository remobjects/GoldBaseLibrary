using go.builtin;
#if ECHOES
using System.Security.Cryptography.X509Certificates;
#endif


namespace go.math {
	namespace rand {
		partial class rngSource: global::go.math.rand.Source {}
		partial class lockedSource: global::go.math.rand.Source {}
	}
}

namespace go.net {
	public partial interface Conn: go.io.ReadWriteCloser, go.io.Reader, go.io.Writer {}

	//public partial class pipe: net.Conn { }

}
namespace go.crypto {
	namespace x509 {
		public partial class __Global {
			public static (Reference<CertPool>, go.builtin.error) loadSystemRoots()
			{
				#if ECHOES
				var lRoots = go.crypto.x509.NewCertPool();
				X509Store lStore = new X509Store(StoreName.Root, StoreLocation.LocalMachine);
				lStore.Open(OpenFlags.ReadOnly);
				foreach(var lCertificate in lStore.Certificates)
				{
					var lRawCert = lCertificate.RawData;
					var lNewData = new byte[lRawCert.Length];
					Array.Copy(lRawCert, lNewData, lRawCert.Length);
					var (lNewCert, lErr) = go.crypto.x509.ParseCertificate(lRawCert);
					if (lErr == null)
					{
						lRoots.AddCert(lNewCert);
					}
				}
				lStore.Close();

				return (lRoots, null);
				#else
				return (null, null);
				#endif
			}
		}
		public partial class Certificate {
			public (Slice<Slice<Reference<crypto.x509.Certificate>>>, go.builtin.error) systemVerify(Reference<go.crypto.x509.VerifyOptions> opts)
			{
				#if ECHOES
				var lHasDNSName = (opts != null) && (opts.DNSName.Length > 0);
				X509Certificate2 lCert = new X509Certificate2(this.Raw);
				X509Chain lChain = new X509Chain();
				if (lChain.Build(lCert))
				{
					var lResult = new Slice<Slice<Reference<go.crypto.x509.Certificate>>>(1);
					var lNewChain = new Slice<Reference<go.crypto.x509.Certificate>>(lChain.ChainElements.Count);
					for (var i = 0; i < lChain.ChainElements.Count; i++)
					{
						var lCertificate = lChain.ChainElements[i].Certificate;
						var lRawCert = lCertificate.RawData;
						var lNewData = new byte[lRawCert.Length];
						Array.Copy(lRawCert, lNewData, lRawCert.Length);
						var (lNewCert, lErr) = go.crypto.x509.ParseCertificate(lRawCert);
						if (lErr == null)
						{
							lNewChain[i] = lNewCert;
						}
					}
					lResult[0] = lNewChain;
					return(lResult, null);
				}
				else
				{
					return(null, go.errors.New("Wrong certificate"));
				}
				#else
				return (null, null);
				#endif
			}
		}
	}
	namespace tls {
		public partial class Conn: go.net.Conn { }
	}
}


namespace go.image {
	namespace png {
		public partial class encoder: go.io.Writer {}
	}
}


namespace go.path
{
	namespace filepath {

		static Slice<go.builtin.string> splitList(string s) {
			#if ECHOES
			return go.builtin.string.PlatformStringArrayToGoSlice(s.Split(new[] {go.os.PathListSeparator}, StringSplitOptions.RemoveEmptyEntries));
			#else
			return go.builtin.string.PlatformStringArrayToGoSlice(s.Split(go.os.PathListSeparator, true));
			#endif
		}

		static (string, error) evalSymlinks(string s) {
			return (null, go.errors.New("Not supported"));
		}

		static go.builtin.string join(Slice<go.builtin.string> s) {
			return String.Join(go.os.PathSeparator.ToString(), s.ToArray());
		}

		static (string, error) abs(string s) {
			try {
				#if ECHOES
				return (System.IO.Path.GetFullPath(s), null);
				#else
				return (Path.GetFullPath(s), null);
				#endif
			} catch(Exception e) {
				return (null, go.errors.New(e.Message));
			}
		}

		public static bool IsAbs(string s) {
			return abs(s)[0] == s;
		}
	}

}

namespace go.os {

	bool isExist(error err){
		throw new NotImplementedException();
	}

	bool isNotExist(error err){
		throw new NotImplementedException();
	}


	bool isPermission(error err) {
		throw new NotImplementedException();
	}



	[ValueTypeSemantics]
	public class ProcessState {
		private ProcessType fProc;

		public ProcessState() {}
		public ProcessState(
		ProcessType         proc) {
			fProc = proc;
		}

		public
		int Pid()
		{
			return fProc.Id;
		}

		public bool exited()
		{
			#if ECHOES
			return fProc.HasExited;
			#else
			return !fProc.IsRunning;
			#endif
		}

		public bool success() { return exited() && (fProc.ExitCode == 0); }

		public object sys() { return fProc; }
		public object sysUsage() { return fProc; }
		public string String()
		{
			#if ECHOES
			return fProc.StartInfo.FileName;
			#else
			return fProc.Command;
			#endif
		}

		public int ExitCode(){ return fProc.ExitCode; }
		public time.Duration userTime() {
			#if ECHOES
			return (time.Duration)fProc.UserProcessorTime.Ticks * 100;
			#else
			throw new NotImplementedException();
			#endif
		}

		public time.Duration systemTime() {
			#if ECHOES
			return (time.Duration)fProc.TotalProcessorTime.Ticks * 100;
			#else
			throw new NotImplementedException();
			#endif
		}

	}

	namespace exec {
		public partial class __Global {
			public static (go.builtin.string, builtin.error) LookPath(go.builtin.string file) {
				#if ECHOES
				if (System.IO.File.Exists(file)) return (file, null);
				foreach (var el in go.strings.Split(go.os.Getenv("PATH"), System.IO.Path.PathSeparator)) {
					var p = System.IO.Path.Combine(el[1], file);
					if (System.IO.File.Exists(p)) return (p, null);
				}
				#else
				if (new RemObjects.Elements.System.File(file).Exists()) return (file, null);
				foreach (var el in go.strings.Split(go.os.Getenv("PATH"), Path.DirectorySeparatorChar)) {
					var p = RemObjects.Elements.System.Path.Combine(el[1], file);
					if (new RemObjects.Elements.System.File(p).Exists()) return (p, null);
				}
				#endif
				return ("", go.errors.New("Could not find file"));
			}
			public static Reference<Cmd> Command(string name, params go.builtin.string[] args) {
				return new Cmd {
					Path = name,
					Args = args
				};
			}
		}

		[ValueTypeSemantics]
		public partial class Cmd {
			public go.builtin.string Path;
			public Slice<go.builtin.string> Args;
			public Slice<go.builtin.string> Env;
			public go.builtin.string Dir;
			public io.Reader Stdin;
			public io.Writer Stdout;
			public io.Writer Stderr;

			public Slice<Reference<os.File>> ExtraFiles; // not used!
			public Reference<os.Process> Process;
			public Reference<os.ProcessState> ProcessState;

			public builtin.error Start() {
				var pp = StartProcess(Path, Args, new ProcAttr {
					Dir = Dir,
					Env = Env
				});
				if (pp.Item2 != null) return pp.Item2;
				Process = pp.Item1;
				ProcessState = new Reference<os.ProcessState>(new os.ProcessState(pp.Item1.Process));
				return null;
			}

			public builtin.error Wait() {
				try {
					Process.Wait();
				} catch(Exception e){
					return go.errors.New(e.Message);
				}
			}

			public (go.io.ReadCloser, go.builtin.error) StdoutPipe() {
				return (null, go.errors.New("not implemented"));
			}

			public (go.io.WriteCloser, go.builtin.error) StdinPipe() {
				return (null, go.errors.New("not implemented"));
			}

			public (Slice<byte>, go.builtin.error) Output() {
				return (null, go.errors.New("not implemented"));
			}

			// stdoutpipe

		}
	}
}
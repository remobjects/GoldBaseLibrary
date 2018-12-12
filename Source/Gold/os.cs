using builtin;


namespace math {
	namespace rand {
		partial class rngSource: global::math.rand.Source {}
		partial class lockedSource: global::math.rand.Source {}
	}
}

namespace net {
	public partial interface Conn: io.ReadWriteCloser, io.Reader, io.Writer {}

	//public partial class pipe: net.Conn { }

}
namespace crypto {
	namespace x509 {
		public partial class __Global {
			public static (Reference<CertPool>, builtin.error) loadSystemRoots()
			{

				return (null, null);
			}
		}
		public partial class Certificate {
			public (Slice<Slice<Reference<crypto.x509.Certificate>>>, builtin.error) systemVerify(Reference<crypto.x509.VerifyOptions> opts) {
				return (null, null);
			}
		}
	}
	namespace tls {
		public partial class Conn: net.Conn { }
	}
}


namespace image {
	namespace png {
		public partial class encoder: io.Writer {}
	}
}


namespace path
{
	namespace filepath {

		static Slice<String> splitList(string s) {
			#if ECHOES
			return new builtin.Slice<String>(s.Split(new[] {os.PathListSeparator}, StringSplitOptions.RemoveEmptyEntries));
			#else
			return new builtin.Slice<String>(s.Split(os.PathListSeparator, true));
			#endif
		}

		static (string, error) evalSymlinks(string s) {
			return (null, errors.New("Not supported"));
		}

		static String join(Slice<string> s) {
			return String.Join(os.PathSeparator.ToString(), s.ToArray());
		}

		static (string, error) abs(string s) {
			try {
				#if ECHOES
				return (System.IO.Path.GetFullPath(s), null);
				#else
				return (Path.GetFullPath(s), null);
				#endif
			} catch(Exception e) {
				return (null, errors.New(e.Message));
			}
		}
	}

}

namespace os {

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
			public static (string, builtin.error) LookPath(String file) {
				if (System.IO.File.Exists(file)) return (file, null);
				foreach (var el in os.Getenv("PATH").Split(System.IO.Path.PathSeparator)) {
					var p = System.IO.Path.Combine(el, file);
					if (System.IO.File.Exists(p)) return (p, null);
				}
				return (null, errors.New("Could not find file"));
			}
			public static Reference<Cmd> Command(string name, params string[] args) {
				return new Cmd {
					Path = name,
					Args = args
				};
			}
		}

		[ValueTypeSemantics]
		public partial class Cmd {
			public string Path;
			public Slice<string> Args;
			public Slice<string> Env;
			public string Dir;
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
					return errors.New(e.Message);
				}
			}

			public (io.ReadCloser, builtin.error) StdoutPipe() {
				return (null, errors.New("not implemented"));
			}

			public (Slice<byte>, builtin.error) Output() {
				return (null, errors.New("not implemented"));
			}

			// stdoutpipe

		}
	}
}
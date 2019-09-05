﻿namespace go.math
{

    using go.builtin;
    public static partial class __Global {

        public const double E   = 2.71828182845904523536028747135266249775724709369995957496696763;  // https://oeis.org/A001113
        public const double Pi  = 3.14159265358979323846264338327950288419716939937510582097494459; // https://oeis.org/A000796
        public const double Phi = 1.61803398874989484820458683436563811772030917980576286213544862; // https://oeis.org/A001622

        public const double e   = 2.71828182845904523536028747135266249775724709369995957496696763;  // https://oeis.org/A001113
        public const double pi  = 3.14159265358979323846264338327950288419716939937510582097494459; // https://oeis.org/A000796
        public const double phi = 1.61803398874989484820458683436563811772030917980576286213544862; // https://oeis.org/A001622

        public const double Sqrt2   = 1.41421356237309504880168872420969807856967187537694807317667974; // https://oeis.org/A002193
        public const double SqrtE   = 1.64872127070012814684865078781416357165377610071014801157507931; // https://oeis.org/A019774
        public const double SqrtPi  = 1.77245385090551602729816748334114518279754945612238712821380779; // https://oeis.org/A002161
        public const double SqrtPhi = 1.27201964951406896425242246173749149171560804184009624861664038; // https://oeis.org/A139339

        public const double Ln2    = 0.693147180559945309417232121458176568075500134360255254120680009; // https://oeis.org/A002162
        public const double Log2E  = 1 / Ln2;
        public const double Ln10   = 2.30258509299404568401799145468436420760110148862877297603332790; // https://oeis.org/A002392
        public const double Log10E = 1 / Ln10;

        public const double MaxFloat32             = 3.40282346638528859811704183484516925440e+38 ;  // 2**127 * (2**24 - 1) / 2**23
        public const double SmallestNonzeroFloat32 = 1.401298464324817070923729583289916131280e-45;  // 1 / 2**(127 - 1 + 23)

        public const double MaxFloat64             = 1.797693134862315708145274237317043567981e+308;  // 2**1023 * (2**53 - 1) / 2**52
        public const double SmallestNonzeroFloat64 = 4.940656458412465441765687928682213723651e-324;  // 1 / 2**(1023 - 1 + 52)
    }
}
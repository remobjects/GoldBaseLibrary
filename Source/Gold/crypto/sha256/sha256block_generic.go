﻿// Copyright 2016 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build !amd64,!386,!s390x,!ppc64le
//##,!arm64

package sha256

var block = blockGeneric
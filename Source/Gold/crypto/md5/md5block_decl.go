﻿// Copyright 2013 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build amd64 amd64p32 386 arm ppc64le ppc64 s390x
//##arm64

package md5

const haveAsm = true

//go:noescape

func block(dig *digest, p []byte)
#  Copyright (C) 2003-2008 Fons Adriaensen <fons@kokkinizita.net>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published
#  by the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


# Modify as required.
#
PREFIX = /usr/local
SUFFIX := $(shell uname -m | sed -e 's/^unknown/$//' -e 's/^i.86/$//' -e 's/^x86_64/$/64/')
LIBDIR = lib$(SUFFIX)


MAJVERS = 2
MINVERS = 4.0
VERSION = $(MAJVERS).$(MINVERS)
DISTDIR = clthreads-$(VERSION)


CPPFLAGS += -Wall -I. -fpic -D_REENTRANT -D_POSIX_PTHREAD_SEMANTICS -O2 
LDLFAGS += 
LDLIBS +=


CLTHREADS_SO = libclthreads.so
CLTHREADS_MAJ = $(CLTHREADS_SO).$(MAJVERS)
CLTHREADS_MIN = $(CLTHREADS_MAJ).$(MINVERS)
CLTHREADS_DEP = -lpthread
CLTHREADS_O = p_thread.o a_thread.o itc_mesg.o itc_ip1q.o itc_ctrl.o textmsg.o
CLTHREADS_H = clthreads.h


$(CLTHREADS_MIN): $(CLTHREADS_O)
	g++ -shared $(LDFLAGS) -Wl,-soname,$(CLTHREADS_MAJ) -o $(CLTHREADS_MIN) $(CLTHREADS_O) $(CLTHREADS_DEP)


install:	$(CLTHREADS_MIN)
	/usr/bin/install -d $(PREFIX)/$(LIBDIR)
	/usr/bin/install -m 644 $(CLTHREADS_H) $(PREFIX)/include
	/usr/bin/install -m 755 $(CLTHREADS_MIN) $(PREFIX)/$(LIBDIR)
	/sbin/ldconfig -n $(PREFIX)/$(LIBDIR)
	ln -sf $(CLTHREADS_MIN) $(PREFIX)/$(LIBDIR)/$(CLTHREADS_SO)


clean:
	/bin/rm -f *~ *.o *.a *.d *.so.*


tarball:
	cd ..; \
	/bin/rm -f -r $(DISTDIR)*; \
	svn export clthreads $(DISTDIR); \
	tar cvf $(DISTDIR).tar $(DISTDIR); \
	bzip2 $(DISTDIR).tar; \
	/bin/rm -f -r $(DISTDIR);


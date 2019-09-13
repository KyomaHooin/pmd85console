.PHONY:	all clean

# Settings

MAKEFLAGS += --no-builtin-rules --no-builtin-variables

SVN_ROOT := $(shell svn info .. | sed -n "s/^URL: \(.*\)$$/\1/p")
SVN_REVISION := $(shell svn info $(SVN_ROOT) | sed -n "s/^Revision: \(.*\)$$/\1/p")

BASE := simpmd-$(SVN_REVISION)

# Targets

all:
	# Export current sources
	svn export $(SVN_ROOT) $(BASE)

	# Customize spec file
	sed "s/__VERSION__/$(SVN_REVISION)/g ; s/__DESCRIPTION__/$(shell cat ../ABOUT)/g" Specfile > $(BASE)/simpmd.spec

	# Compress sources
	tar cf $(BASE).tar $(BASE)
	bzip2 -9 $(BASE).tar
	rm -rf $(BASE)

	# Build all
	rpmbuild -ta $(BASE).tar.bz2

clean:
	rm -f *.rpm
	rm -f *.tar.bz2


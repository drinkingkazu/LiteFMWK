
ifndef MYSW_BASEDIR
ERROR_MESSAGE := $(error MYSW_BASEDIR is not set... run configure.sh!)
endif

OSNAME          = $(shell uname -s)
HOST            = $(shell uname -n)
OSNAMEMODE      = $(OSNAME)

include $(MYSW_BASEDIR)/Makefile/Makefile.${OSNAME}

SUBDIRS := Example

.phony: all clean

all:
	@echo "Start building..."
	@for i in $(SUBDIRS); do ( echo "" && echo "Compiling $$i..." && $(MAKE) --directory=$$i) || exit $$?; done
	@echo "Done!"
clean:
	@echo "Cleaning..."
	@for i in $(SUBDIRS); do ( echo "" && echo "Cleaning $$i..." && $(MAKE) clean --directory=$$i) || exit $$?; done
	@echo "Done!"


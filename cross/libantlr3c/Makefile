PKG_NAME = libantlr3c
PKG_VERS = 3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.antlr3.org/download/C/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.antlr3.org/
COMMENT  = ANother Tool for Language Recognition, is a language tool that provides a framework for constructing recognizers, interpreters, compilers, and translators from grammatical descriptions containing actions in a variety of target languages.
LICENSE  = 3-clause BSD

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-abiflags

include ../../mk/spksrc.cross-cc.mk

# Enable 64-bit support in libantlr3c for 64-bit architectures (amd64 and arm64)
ifeq ($(findstring $(ARCH),$(x64_ARCHS) $(ARMv8_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += --enable-64bit
endif

PKG_NAME = forked-daapd
PKG_VERS = 27.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ejurgensen/forked-daapd/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libunistring cross/zlib cross/libconfuse cross/curl
DEPENDS += cross/mxml cross/sqlite cross/libevent cross/json-c
DEPENDS += cross/libantlr3c cross/libgcrypt
DEPENDS += cross/ffmpeg
DEPENDS += cross/avahi
DEPENDS += cross/libplist
DEPENDS += cross/libwebsockets
DEPENDS += cross/alsa-lib cross/gnutls cross/protobuf-c
 
HOMEPAGE = http://ejurgensen.github.io/forked-daapd/
COMMENT  = Linux/FreeBSD DAAP (iTunes) and MPD media server with support for AirPlay devices (multiroom), Apple Remote (and compatibles), Chromecast, Spotify and internet radio. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -std=c99

CONFIGURE_ARGS += --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libgcrypt-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-chromecast

PRE_CONFIGURE_TARGET = forked-daapd_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: forked-daapd_pre_configure
forked-daapd_pre_configure:
	$(RUN) autoreconf -i -v

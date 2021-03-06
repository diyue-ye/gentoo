# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils xdg-utils

DESCRIPTION="Enlightenment Foundation Libraries all-in-one package"
HOMEPAGE="https://www.enlightenment.org"
SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${P}.tar.xz"

LICENSE="BSD-2 GPL-2 LGPL-2.1 ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="+bmp dds connman debug drm +eet elogind examples fbcon +fontconfig fribidi gif gles2 glib gnutls gstreamer harfbuzz hyphen +ico ibus jpeg2k libressl libuv luajit neon nls opengl ssl pdf physics postscript +ppm +psd pulseaudio raw scim sdl sound static-libs svg +system-lz4 systemd tga tiff tslib unwind v4l valgrind vlc vnc wayland webp X xcf xim xine xpm xpresent zeroconf"

REQUIRED_USE="
	?? ( elogind systemd )
	?? ( gles2 opengl )
	fbcon? ( !tslib )
	gles2? (
		|| ( wayland X )
		!sdl
	)
	ibus? ( glib )
	opengl? ( X )
	pulseaudio? ( sound )
	sdl? ( opengl )
	vnc? ( fbcon X )
	wayland? ( gles2 !opengl )
	xim? ( X )
	xpresent? ( X )
"

RDEPEND="
	net-misc/curl
	media-libs/libpng:0=
	sys-apps/dbus
	sys-apps/util-linux
	virtual/jpeg:0=
	connman? ( net-misc/connman )
	drm? (
		dev-libs/libinput
		media-libs/mesa[gbm]
		x11-libs/libdrm
		x11-libs/libxkbcommon
	)
	elogind? ( sys-auth/elogind )
	fontconfig? ( media-libs/fontconfig )
	fribidi? ( dev-libs/fribidi )
	gif? ( media-libs/giflib:= )
	gles2? ( media-libs/mesa[egl,gles2] )
	glib? ( dev-libs/glib:2 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	harfbuzz? ( media-libs/harfbuzz )
	hyphen? ( dev-libs/hyphen )
	ibus? ( app-i18n/ibus )
	jpeg2k? ( media-libs/openjpeg:= )
	libuv? ( dev-libs/libuv )
	luajit? ( dev-lang/luajit:= )
	!luajit? ( dev-lang/lua:* )
	pdf? ( app-text/poppler:=[cxx] )
	physics? ( sci-physics/bullet:= )
	postscript? ( app-text/libspectre )
	pulseaudio? ( media-sound/pulseaudio )
	raw? ( media-libs/libraw:= )
	scim? ( app-i18n/scim )
	sdl? (
		media-libs/libsdl2
		virtual/opengl
	)
	sound? ( media-libs/libsndfile )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:= )
		)
	)
	svg? (
		gnome-base/librsvg
		x11-libs/cairo
	)
	system-lz4? ( app-arch/lz4 )
	systemd? ( sys-apps/systemd:= )
	tiff? ( media-libs/tiff:0= )
	tslib? ( x11-libs/tslib:= )
	unwind? ( sys-libs/libunwind )
	valgrind? ( dev-util/valgrind )
	vlc? ( media-video/vlc )
	vnc? ( net-libs/libvncserver )
	wayland? (
		dev-libs/wayland
		media-libs/mesa[gles2,wayland]
		x11-libs/libxkbcommon
	)
	webp? ( media-libs/libwebp:= )
	X? (
		media-libs/freetype
		x11-libs/libXcursor
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libXScrnSaver
		gles2? (
			x11-libs/libX11
			x11-libs/libXrender
			virtual/opengl
		)
		opengl? (
			x11-libs/libX11
			x11-libs/libXrender
			virtual/opengl
		)
		wayland? ( x11-libs/libxkbcommon[X] )
	)
	xine? ( media-libs/xine-lib )
	xpm? ( x11-libs/libXpm )
	xpresent? ( x11-libs/libXpresent )
	zeroconf? ( net-dns/avahi )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	default

	# Upstream still doesnt offer a configure flag. #611108
	if ! use unwind ; then
		sed -i -e 's:libunwind libunwind-generic:xxxxxxxxxxxxxxxx:' \
		configure || die "Sedding configure file with unwind fix failed."
	fi
}

src_configure() {
	local myconf=(
		--enable-cxx-bindings
		--enable-image-loader-generic
		--enable-image-loader-jpeg
		--enable-image-loader-png
		--enable-libeeze
		--enable-libmount
		--enable-quick-launch
		--enable-threads
		--enable-xinput22

		--disable-cancel-ok
		--disable-cocoa
		--disable-csharp-beta
		--disable-csharp-bindings
		--disable-doc
		--disable-ecore-buffer
		--disable-ecore-drm
		--disable-ecore-wayland
		--disable-eglfs
		--disable-g-main-loop
		--disable-gesture
		--disable-gstreamer
		--disable-pixman
		--disable-tizen
		--disable-wayland-ivi-shell

		$(use_enable bmp image-loader-bmp)
		$(use_enable bmp image-loader-wbmp)
		$(use_enable dds image-loader-dds)
		$(use_enable drm)
		$(use_enable drm elput)
		$(use_enable eet image-loader-eet)
		$(use_enable elogind)
		$(use_enable examples always-build-examples)
		$(use_enable fbcon fb)
		$(use_enable fontconfig)
		$(use_enable fribidi)
		$(use_enable gif image-loader-gif)
		$(use_enable gles2 egl)
		$(use_enable gstreamer gstreamer1)
		$(use_enable harfbuzz)
		$(use_enable hyphen)
		$(use_enable ico image-loader-ico)
		$(use_enable ibus)
		$(use_enable jpeg2k image-loader-jp2k)
		$(use_enable libuv)
		$(use_enable !luajit lua-old)
		$(use_enable neon)
		$(use_enable nls)
		$(use_enable pdf poppler)
		$(use_enable physics)
		$(use_enable postscript spectre)
		$(use_enable ppm image-loader-pmaps)
		$(use_enable psd image-loader-psd)
		$(use_enable pulseaudio)
		$(use_enable raw libraw)
		$(use_enable scim)
		$(use_enable sdl)
		$(use_enable sound audio)
		$(use_enable static-libs static)
		$(use_enable svg librsvg)
		$(use_enable system-lz4 liblz4)
		$(use_enable systemd)
		$(use_enable tga image-loader-tga)
		$(use_enable tiff image-loader-tiff)
		$(use_enable tslib)
		$(use_enable v4l v4l2)
		$(use_enable valgrind)
		$(use_enable vlc libvlc)
		$(use_enable vnc vnc-server)
		$(use_enable wayland)
		$(use_enable webp image-loader-webp)
		$(use_enable xcf)
		$(use_enable xim)
		$(use_enable xine)
		$(use_enable xpm image-loader-xpm)
		$(use_enable xpresent)
		$(use_enable zeroconf avahi)

		--with-crypto=$(usex gnutls gnutls $(usex ssl openssl none))
		--with-glib=$(usex glib)
		--with-js=none
		--with-net-control=$(usex connman connman none)
		--with-profile=$(usex debug debug release)
		--with-x11=$(usex X xlib none)

		$(use_with X x)
	)

	use drm && use wayland && myconf+=( --enable-gl-drm )

	if use opengl ; then
		myconf+=( --with-opengl=full )
	elif use gles2 ; then
		myconf+=( --with-opengl=es )
	elif use drm && use wayland ; then
		myconf+=( --with-opengl=es )
	else
		myconf+=( --with-opengl=none )
	fi

	econf "${myconf[@]}"
}

src_compile() {
	if host-is-pax && use luajit ; then
		# We need to build the lua code first so we can pax-mark it. #547076
		local target='_e_built_sources_target_gogogo_'
		printf '%s: $(BUILT_SOURCES)\n' "${target}" >> src/Makefile || die
		emake -C src "${target}"
		emake -C src bin/elua/elua
		pax-mark m src/bin/elua/.libs/elua
	fi

	V=1 emake
}

src_install() {
	V=1 emake install DESTDIR="${D}"
	einstalldocs

	if ! use static-libs ; then
		find "${D}" -name '*.la' -delete || die
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

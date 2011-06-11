# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit flag-o-matic qt4

MY_P=${PN/-/_}_v${PV}

DESCRIPTION="A QT4 IM client using CHINA MOBILE's Fetion Protocol"
HOMEPAGE="http://www.libfetion.cn/"
SRC_URI="http://libfetion-gui.googlecode.com/files/${MY_P}.tar.gz"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/openssl
	|| ( >=net-misc/curl-7.19.7[openssl] net-misc/curl[ssl] )
	x11-libs/qt-xmlpatterns
	x11-libs/qt-gui
	x11-libs/qt-core"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	if use amd64 ; then
		sed -i \
			-e "/libfetion_32.a/c    ./libfetion/lib/libfetion_64.a" \
			-e "/libfetion.a/c    ./libfetion/lib/libfetion_64.a" \
			${PN}.pro || die "sed failed"
	fi
	sed -i \
		-e 's/;Network/&;/' misc/LibFetion.desktop || die "failed to fix desktop entry"
}

src_compile() {
	filter-ldflags -Wl,--as-needed
	eqmake4
	default
}

src_install() {
	insinto /usr/share/libfetion
	doins -r skins resource || die

	insinto /usr/share/pixmaps
	doins misc/fetion.png || die
	insinto /usr/share/applications
	doins misc/LibFetion.desktop || die

	dobin ${PN} || die "dobin failed"
}

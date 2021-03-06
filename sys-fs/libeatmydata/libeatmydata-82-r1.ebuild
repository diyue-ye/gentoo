# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools-multilib eutils

DESCRIPTION="LD_PRELOAD hack to convert sync()/msync() and the like to NO-OP"
HOMEPAGE="https://launchpad.net/libeatmydata/"
SRC_URI="https://launchpad.net/${PN}/trunk/${P}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# sandbox fools LD_PRELOAD and libeatmydata does not get control
# bug/feature in sandbox?
#DEPEND="test? ( dev-util/strace )"
RESTRICT=test

DEPEND="sys-apps/sed"
RDEPEND=""

multilib_src_install_all() {
	dodoc AUTHORS README
}

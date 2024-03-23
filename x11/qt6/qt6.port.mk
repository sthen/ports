# This fragment defines MODQT_* variables to make it easier to substitute
# qt4/qt5 in a port.
MODQT_OVERRIDE_UIC ?=	Yes
MODQT6_OVERRIDE_UIC ?=	${MODQT_OVERRIDE_UIC}

MODQT6_LIBDIR =	${LOCALBASE}/lib/qt6
MODQT_LIBDIR ?= ${MODQT6_LIBDIR}
MODQT6_INCDIR =	${LOCALBASE}/include/X11/qt6
MODQT_INCDIR ?=	${MODQT6_INCDIR}

_MODQT6_SETUP =	MOC=${MODQT6_MOC} \
		MODQT_INCDIR=${MODQT6_INCDIR} \
		MODQT_LIBDIR=${MODQT6_LIBDIR}
.if ${MODQT6_OVERRIDE_UIC:L} == "yes"
_MODQT6_SETUP +=UIC=${MODQT6_UIC}
.endif

# may be needed to find plugins
MODQT6_MOC =		${LOCALBASE}/bin/moc-qt6
MODQT_MOC ?=		${MODQT6_MOC}
MODQT6_UIC =		${LOCALBASE}/bin/uic-qt6
MODQT_UIC ?=		${MODQT6_UIC}
MODQT6_QMAKE =		${LOCALBASE}/bin/qmake-qt6
MODQT_QMAKE ?=		${MODQT6_QMAKE}
MODQT6_QTDIR =		${LOCALBASE}/lib/qt6
MODQT_QTDIR ?=		${MODQT6_QTDIR}
MODQT6_LRELEASE =	${LOCALBASE}/bin/lrelease-qt6
MODQT_LRELEASE ?=	${MODQT6_LRELEASE}
MODQT6_LUPDATE =	${LOCALBASE}/bin/lupdate-qt6
MODQT_LUPDATE ?=	${MODQT6_LUPDATE}

_MODQT6_SETUP +=	Qt6_DIR=${MODQT6_LIBDIR}/cmake

MODQT6_LIB_DEPENDS =	x11/qt6/qtbase
MODQT_LIB_DEPENDS ?=	${MODQT6_LIB_DEPENDS}

# qdoc, etc.
MODQT6_BUILD_DEPENDS =	x11/qt6/qttools

MODQT_DEPS ?=		Yes
MODQT6_DEPS ?=		${MODQT_DEPS}

.if ${MODQT6_DEPS:L} == "yes"
BUILD_DEPENDS +=	${MODQT6_BUILD_DEPENDS}
LIB_DEPENDS +=		${MODQT6_LIB_DEPENDS}
.endif

MODQT_ENV_SETUP ?=	Yes
MODQT6_ENV_SETUP ?=	${MODQT_ENV_SETUP}
.if ${MODQT6_ENV_SETUP:L} == yes
CONFIGURE_ENV +=	${_MODQT6_SETUP}
MAKE_ENV +=		${_MODQT6_SETUP}
MAKE_FLAGS +=		${_MODQT6_SETUP}
.endif

MODQT6_USE_CXX17 ?=	Yes

.if ${MODQT6_USE_CXX17:L} == "yes"
COMPILER ?= base-clang ports-gcc
ONLY_FOR_ARCHS ?= ${CXX11_ARCHS}
.endif

.include "Makefile.version"

MODQT6_VERSION =	${QT6_VERSION}
MODQT_VERSION ?=	${MODQT6_VERSION}

show_deps: patch
	@cpkgs=$$(echo ${_MODQT6_CMAKE_PKGS:NQt6} | sed 's/ /|/g'); \
	find ${WRKSRC} \( -name '*.pr[iof]' -o -iname '*cmake*' \) -exec \
		egrep -hA 2 "\\<(qtHaveModule|QT_CONFIG|$$cpkgs)\\>|Qt6::" {} +

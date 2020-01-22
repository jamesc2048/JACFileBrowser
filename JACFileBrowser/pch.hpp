#ifndef PCH_HPP
#define PCH_HPP

#include <QtCore>
#include <QtGui>
#include <QtNetwork>
#include <QtQml>

#include "qmlutils.hpp"
#include "viewmodelbase.hpp"

#include <string>
#include <cstdlib>

#define REGISTER_METATYPE(t) qRegisterMetaType<t>(#t)

#endif // PCH_HPP

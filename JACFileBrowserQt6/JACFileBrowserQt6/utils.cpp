#include "utils.hpp"

#include <QNetworkAccessManager>
#include <QNetworkReply>

Utils::Utils(QObject *parent) : QObject(parent)
{

}

void Utils::httpGet(QString url, QJSValue callback)
{
    QNetworkAccessManager *nam = new QNetworkAccessManager();

    nam->get(QNetworkRequest(QUrl(url)));

    connect(nam, &QNetworkAccessManager::finished, [=](QNetworkReply *reply) {
        qDebug() << (void *)reply << QSslSocket::supportsSsl() << QSslSocket::sslLibraryBuildVersionString() << QSslSocket::sslLibraryVersionString();

        if (reply->error() == QNetworkReply::NoError)
        {
            QByteArray bytes = reply->readAll();

            if (callback.isCallable())
            {
                callback.call(QJSValueList { QJSValue(QString::fromLatin1(bytes)) });
            }

            return;
        }
        else
        {
            qDebug("Error: %s", qPrintable(reply->errorString()));
        }

        reply->deleteLater();
        nam->deleteLater();
    });
}

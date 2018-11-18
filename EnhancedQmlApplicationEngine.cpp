#include "EnhancedQmlApplicationEngine.h"
#include <QTimer>

#include <QDir>
#include <QFile>
#include <QtDebug>

EnhancedQmlApplicationEngine::EnhancedQmlApplicationEngine(QObject* parent)
  : QQmlApplicationEngine(parent)
{
  refreshWatcher();
  connect(&mFileWatcher,
          &QFileSystemWatcher::fileChanged,
          this,
          &EnhancedQmlApplicationEngine::clearCache);
}

void
EnhancedQmlApplicationEngine::clearCache(const QString& path)
{
  qDebug() << "Clear cache";
  QObject* rootObject = this->rootObjects().first();
  QObject* qmlObject = rootObject->findChild<QObject*>("loader");

  QVariant source = qmlObject->property("source");
  qmlObject->setProperty("source", "");
  clearComponentCache();
  qmlObject->setProperty("source", source.toString());

  mFileWatcher.removePath(path);
  mFileWatcher.addPath(path);
}

void
EnhancedQmlApplicationEngine::refreshWatcher()
{
  auto fileList = QDir::current().entryList(QStringList() << "*.qml");
  mFileWatcher.addPaths(fileList);
}

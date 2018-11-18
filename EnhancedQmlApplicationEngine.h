#pragma once

#include <QFileSystemWatcher>
#include <QQmlApplicationEngine>

class EnhancedQmlApplicationEngine : public QQmlApplicationEngine
{
  Q_OBJECT
public:
  explicit EnhancedQmlApplicationEngine(QObject* parent = nullptr);

public slots:
  Q_INVOKABLE void clearCache(const QString& path);
  void refreshWatcher();

private:
  QFileSystemWatcher mFileWatcher;
};

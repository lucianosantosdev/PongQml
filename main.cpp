#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>

#include <EnhancedQmlApplicationEngine.h>
#include <QQmlContext>

int
main(int argc, char* argv[])
{
  if (qEnvironmentVariableIsEmpty("QTGLESSTREAM_DISPLAY")) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  }

  QGuiApplication app(argc, argv);

  EnhancedQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("$QmlEngine", &engine);

  engine.load(QUrl("qrc:/main.qml"));
  if (engine.rootObjects().isEmpty())
    return -1;

  return app.exec();
}

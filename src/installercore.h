#ifndef INSTALLERCORE_H
#define INSTALLERCORE_H

#include <QObject>
#include <QDebug>
#include <QThread>

class F_systemThread : public QThread{  // Function systenm() thread
    Q_OBJECT
public:
    explicit F_systemThread(QObject *parent = 0);
    void setExecCommand(char *Cmd);
    void run(){
        if(ExecCommand)
            system(ExecCommand);
        else
            return;
    };
protected:
    char *ExecCommand;
};

class InstallerCore : public QObject{
    Q_OBJECT
public:
    explicit InstallerCore(QObject *parent = 0);
    Q_INVOKABLE void    setDesktopEnvironment(QString);
    Q_INVOKABLE void    setPackageManager(QString);
    Q_INVOKABLE void    launchGparted(void);
signals:

public slots:
    void setNumber(int i  ){
        qDebug()<< "Number is " << i << endl;
    }
protected:
     F_systemThread *systemThread;

};

#endif // INSTALLERCORE_H

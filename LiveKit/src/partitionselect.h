#ifndef PARTITIONSELECT_H
#define PARTITIONSELECT_H

#include <QScrollArea>
#include <QtGui>
#include <QListWidget>
#include <QPushButton>
#include <QTextEdit>
#include <QMenu>
#include <parted/parted.h>
#include <QHBoxLayout>
#include <QLabel>
#include <QComboBox>
#include <QCheckBox>
#include <QSpinBox>
#include <QMessageBox>

#define _FRIEND_LABEL_HEIGTH    35
#define     INSTALLER_MOUNT_POINT_NONE  0
#define     INSTALLER_MOUNT_POINT_ROOT  1
#define     INSTALLER_MOUNT_POINT_HOME  2
#define     INSTALLER_MOUNT_POINT_USR   3
#define     INSTALLER_MOUNT_POINT_BOOT  4

#define     INSTALLER_FILESYSTEM_NONE   -2
#define     INSTALLER_FILESYSTEM_FREESPACE -1
#define     INSTALLER_FILESYSTEM_EXT2   0
#define     INSTALLER_FILESYSTEM_EXT3   1
#define     INSTALLER_FILESYSTEM_EXT4   2
#define     INSTALLER_FILESYSTEM_NTFS   3
#define     INSTALLER_FILESYSTEM_FAT32  4

#define     INSTALLER_WORKTYPE_ADD      1
#define     INSTALLER_WORKTYPE_CHANGE   2

class InstallerPage : public QWidget{
    Q_OBJECT
public:
    explicit InstallerPage(QWidget *parent = 0);
    ~InstallerPage();

    virtual void PervShow();                    //  在跳转到这个页面时要做的操作【例如将按钮disable之类的】
                                                //  每跳转到这个页面就会执行一次
    void    SetContantTitle(const QString &);
    void    resizeEvent(QResizeEvent* );
    QFont   cContantFont;
    virtual int  SLOT_NextButtonClicked(void);  //  下一步按钮被按下时所执行的操作


signals:
    void    SIGN_SetNextButtonDisabled(bool);
    void    SIGN_SetPervButtonDisabled(bool);
    void    SIGN_TurnToSpecialPage(QWidget *);

public slots:
    virtual void SLOT_PageChanged(QWidget *);
private:
    QLabel *cTitle;
};

typedef QMap<int,InstallerPage*> InstallerPagesMap_t;


class MyTabWidget : public QTabWidget{
    Q_OBJECT
public:
    explicit MyTabWidget(QWidget *parent = 0);
};


class WorkingThread : public QThread{
    Q_OBJECT
public:
    explicit WorkingThread(QThread *parent = 0);
    ~WorkingThread();
    void    SetWork(QString);
    void    run();
signals:
    void    WorkDone(QString,int);
private:
    QString Work;
};

class WorkingDialog : public QWidget{
    Q_OBJECT
public:
    explicit WorkingDialog(QWidget *parent = 0);
    ~WorkingDialog();
    void    SetWork(QString);
    void    SetWorkingtText(QString);
signals:
    void    Started(void);
    void    Stoped(int);
public slots:
    void    Start(void);
    void    Stop(void);
    void    pWorkStarted(void);
    void    pWorkStoped(QString, int);
private:
    WorkingThread   *Thread;
    QLabel          *WorkingDescription;
    QPushButton     *CancelButton;
    QPushButton     *DoneButton;
};

class PartitionItem : public QWidget{
    Q_OBJECT
public:
    explicit        PartitionItem(QWidget *parent = 0);
    void            SetPartiton(PedPartition *_Partiton, PedDevice *_Device, PedDisk *_Disk, int MountPoint);
    PedPartition    GetPartition(void);
    PedDisk         GetDisk(void);
    PedDevice       GetDevice(void);
    int             GetMountPoint(void);
    void            SetUnselected(bool);
    void            SetMountPoint(int);
signals:
    void clicked(PartitionItem*);
protected:
    QHBoxLayout     *layout;
    PedPartition     Partition;
    PedDevice        Device;
    PedDisk          Disk;
    int              MountPoint;
    QLabel          *PartitionLabel;
    QLabel          *FileSystemLabel;
    QLabel          *SizeLabel;
    QLabel          *MountPointLabel;
    virtual void mousePressEvent(QMouseEvent *event);
};



class PartitionList : public QWidget{
    Q_OBJECT
public:
    explicit        PartitionList(QWidget *parent = 0);
    void            ClearPartitionList(void);
    void            AddPartition(PedPartition *_Partition, PedDevice *Device, PedDisk *Disk);
    void            resizeEvent(QResizeEvent *);
    void            SetPartitionCount(int n);
    int             GetPartitionCount(void);

    PedPartition    GetPartitionDataByUID(uint32_t UID);
    PedPartition    GetCurrentSelectedPartition(void);
    PedDisk         GetCurrentSelectedDisk(void);
    PedDevice       GetCurrentSelectedDevice(void);
    int             GetCurrentMountPoint(void);

    void            SetCurrentMountPoint(int);

    void            RefreshList(void);
    QString         GetMountPoint(int);
public slots:
    void            ItemClicked(PartitionItem*);
signals:
    void            SetAddButtonDisabled(bool);
    void            SetDelButtonDisabled(bool);
    void            SetChangeButtonDisabled(bool);
protected:
    int             PartitionCount;
    typedef         QMap<int,PartitionItem *>   _Map;
    typedef         QMap<int,QString>               _MountPointMap;
    QScrollArea         *List;
    PartitionItem       *CurrentSelelcted;
    int                  NowMountPoint;
    QWidget             *PartitionWidget;
    QWidget             *FriendLabelList;
    QVBoxLayout         *PartitionLayout;
    _Map                PartitionMap;
    _Map::iterator      Result;
    _MountPointMap      MountPointMap;
    _MountPointMap::iterator    MountPointIterator;
};

class ChangeDialogBox : public QWidget{
    Q_OBJECT
public:
    explicit ChangeDialogBox(QWidget *parent = 0);
    ~ChangeDialogBox();
    void    SetCurrentPartition(PedPartition Partition, PedDisk Disk, PedDevice Device, int, int WorkType);
signals:
    void    MountPointChangeApplied(int);     // MountPoint;
    void    WorkDone(void);

public slots:
    void    ApplyButtonClicked(void);
    void    CancelButtonClicked(void);
    void    FileSystemSelectChanged(int);
    void    FormatDone(int);
private:
    PedPartition     CurrentPartition;
    PedDisk          CurrentDisk;
    PedDevice        CurrentDevice;
    int              OriginMountPoint;
    int              OriginFileSystem;
    int              WorkType;
    QPushButton     *ApplyButton;
    QPushButton     *CancelButton;
    QLabel          *PartitionPath;
    QLabel          *FileSystemLabel;
    QLabel          *MountPointLabel;
    QLabel          *DoFormatLabel;
    QComboBox       *FileSystemSelect;
    QComboBox       *MountPointSelect;
    QCheckBox       *DoFormatCheckBox;
    QSpinBox        *PartitionSize;
    QLabel          *PartitionSizeLabel;

    QString         CurrentFileSystem;
    QString         CurrentMountPoint;
    WorkingDialog   *DoWork;
};

class AddDialogBox : public QWidget{
    Q_OBJECT
public:
    explicit AddDialogBox(QWidget *parent = 0);
    ~AddDialogBox();
    void    SetCurrentPartition(PedPartition CurrentPartition);
private:
    int              OriginMountPoint;
    int              OriginFileSystem;
    QPushButton     *ApplyButton;
    QPushButton     *CancelButton;
    QLabel          *PartitionPath;
    QComboBox       *FileSystemSelect;
    QComboBox       *MountPointSelect;
};

class PartedPage : public InstallerPage{
    Q_OBJECT
public:
    explicit PartedPage(InstallerPage *parent = 0);
    ~PartedPage();
    void PervShow();
    void            DelPartition(PedPartition TargetPartition,PedDisk TargetDisk);
    PartitionList   *List;
    int             SLOT_NextButtonClicked();
public slots:
    void            ShowChangeDialog(void);
    void            ShowAddDialog(void);
    void            AskForDeletePartition(void);
    void            MountPointChangeApplied(int);
    void            WorkDone(void);
    void            SetGrubDest(void);
    void            SetEFIDest(void);
    void            UnselectGrubClicked(void);
    void            UnselectEFIClicked(void);
    void            EnableEFISupport(bool);
    void            NextButtonClicked();
signals:
    void            PartedDone(bool InstallGrub, bool InstallEFI, QString GrubDest, QString EFIDest);
private:
    MyTabWidget     *DeviceSelect;
    QPushButton     *ChangeButton;
    QPushButton     *AddButton;
    QPushButton     *DelButton;
    QPushButton     *MyEFIPartition;
    QPushButton     *MyBootDevice;
    QPushButton     *UnselectGrub;
    QPushButton     *UnselectEFI;
    QPushButton     *NextButton;
    QLabel          *MyBootDevicePath;
    QLabel          *MyEFIPartitionPath;
    AddDialogBox    *AddDialog;
    ChangeDialogBox *ChangeDialog;
};

#endif // PARTITIONSELECT_CPP

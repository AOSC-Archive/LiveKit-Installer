#include "partitionselect.h"
#include <stdio.h>
#include <stdlib.h>
#include <QToolBox>
#include <QListWidget>
#include <QLabel>
#include <QtGui>
#include <QListView>
#include <QFrame>
#include <QScrollArea>
#include <QMap>
#include <QDebug>
#include <QObject>

int InstallGrub = false;
int InstallEFI  = false;
QString GrubDest;
QString EFIDest;

InstallerPage::InstallerPage(QWidget *parent):
    QWidget(parent){
    QFont cTitleFont;
    cTitleFont.setBold(true);
    cTitleFont.setPointSize(27);
    cTitle = new QLabel(this);
    cTitle->setFont(cTitleFont);
    cTitle->setGeometry(0,0,600,50);
    cContantFont.setBold(false);
    cContantFont.setPointSize(14);
}

InstallerPage::~InstallerPage(){

}

void InstallerPage::PervShow(){

}

int InstallerPage::SLOT_NextButtonClicked(void){
    return 0;
}

void InstallerPage::SLOT_PageChanged(QWidget *){

}

void InstallerPage::resizeEvent(QResizeEvent *){

}

void InstallerPage::SetContantTitle(const QString &str){
    cTitle->setText(str);
}

PartitionItem::PartitionItem(QWidget *parent)
    :QWidget(parent){
    this->show();
//    this->setStyleSheet("border:1px solid black");
    PartitionLabel  = new QLabel(this);
    FileSystemLabel = new QLabel(this);
    SizeLabel       = new QLabel(this);
    MountPointLabel = new QLabel(this);
    layout          = new QHBoxLayout(this);
    this->setLayout(layout);
    layout->addWidget(PartitionLabel);
    layout->addWidget(FileSystemLabel);
    layout->addWidget(SizeLabel);
    layout->addWidget(MountPointLabel);
}
void PartitionItem::SetPartiton(PedPartition *_Partition, PedDevice *_Device, PedDisk *_Disk, int MountPoint = INSTALLER_MOUNT_POINT_NONE){
    if(_Partition->type == PED_PARTITION_FREESPACE){  //Free Space
        PartitionLabel->setText(tr("Free Space").toUtf8().data());
        char size[36];
        sprintf(size,"%lld GB",(_Partition->geom.length * _Device->sector_size)/(1024*1024*1024));
        SizeLabel->setText(size);
        FileSystemLabel->setText(tr("Unknown"));
    }
    else if(_Partition->type == PED_PARTITION_NORMAL){  //  Normal Partition
        PartitionLabel->setText(ped_partition_get_path(_Partition));
        char size[36];
        sprintf(size,"%lld GB",(_Partition->geom.length * _Device->sector_size)/(1024*1024*1024));
        SizeLabel->setText(size);
        if(_Partition->fs_type)
            FileSystemLabel->setText(_Partition->fs_type->name);
        else
            FileSystemLabel->setText(tr("Unknown"));
    }
    else{
        PartitionLabel->setText(tr("Disabled").toUtf8().data());
        char size[36];
        sprintf(size,"%lld GB",(_Partition->geom.length * _Device->sector_size)/(1024*1024*1024));
        SizeLabel->setText(size);
        FileSystemLabel->setText(tr("Unknown"));
    }
    if(MountPoint == INSTALLER_MOUNT_POINT_NONE)
        MountPointLabel->setText(tr("NULL"));
    else if(MountPoint == INSTALLER_MOUNT_POINT_ROOT)
        MountPointLabel->setText(tr("/"));
    else if(MountPoint == INSTALLER_MOUNT_POINT_HOME)
        MountPointLabel->setText(tr("/home"));
    memcpy((void*)&Partition,(void*)_Partition,sizeof(PedPartition));
    memcpy((void*)&Device,(void*)_Device,sizeof(PedDevice));
    memcpy((void*)&Disk,(void*)_Disk,sizeof(PedDisk));
    PartitionLabel->setGeometry(0,0,50,20);
    PartitionLabel->show();
}

PedPartition PartitionItem::GetPartition(){
    return Partition;
}

PedDisk PartitionItem::GetDisk(){
    return Disk;
}

PedDevice PartitionItem::GetDevice(){
    return Device;
}

int PartitionItem::GetMountPoint(){
    return MountPoint;
}

void PartitionItem::SetMountPoint(int _MountPoint){
    MountPoint = _MountPoint;
    if(MountPoint == INSTALLER_MOUNT_POINT_NONE)
        MountPointLabel->setText(tr("NULL"));
    else if(MountPoint == INSTALLER_MOUNT_POINT_ROOT)
        MountPointLabel->setText(tr("/"));
    else if(MountPoint == INSTALLER_MOUNT_POINT_HOME)
        MountPointLabel->setText(tr("/home"));
}

void PartitionItem::SetUnselected(bool Status){
    if(Status == true)
        this->setStyleSheet("border:none");
    else
        this->setStyleSheet("border:1px solid black");
}

void PartitionItem::mousePressEvent(QMouseEvent *event){
    if (event->button() == Qt::LeftButton){
        emit clicked(this);
        this->setStyleSheet("border:1px solid black");
    }else
        QWidget::mousePressEvent(event);
}

//#############################################################

PartitionList::PartitionList(QWidget *parent)
    :QWidget(parent){
    PartitionLayout = new QVBoxLayout;
    FriendLabelList = new QWidget(this);
    FriendLabelList->setLayout(PartitionLayout);
    PartitionLayout->setMargin(0);
    PartitionLayout->setSpacing(0);
    PartitionLayout->setContentsMargins(0,0,0,0);
    FriendLabelList->resize(1,1);
    List = new QScrollArea(this);
    List->setWidget(FriendLabelList);
    FriendLabelList->show();
    List->show();
    this->show();
    PartitionCount = 0;
    NowMountPoint = INSTALLER_MOUNT_POINT_NONE;
}

void PartitionList::AddPartition(PedPartition *_Partition, PedDevice *Device, PedDisk *Disk){
    if ((_Partition->type & PED_PARTITION_METADATA) ||
                    (_Partition->type & PED_PARTITION_EXTENDED))
        return;
     PartitionItem *f = new PartitionItem(this);
     PartitionCount++;
     f->SetPartiton(_Partition,Device,Disk);
     f->resize(List->width()-20,_FRIEND_LABEL_HEIGTH);
     FriendLabelList->resize(List->width()-20,_FRIEND_LABEL_HEIGTH*PartitionCount);
     PartitionLayout->addWidget(f);
     this->connect(f,SIGNAL(clicked(PartitionItem*)),this,SLOT(ItemClicked(PartitionItem*)));
     PartitionMap[PartitionCount] = f;
     char Path[36];
     bzero(Path,36);
     memcpy(Path,ped_partition_get_path(_Partition),strlen(ped_partition_get_path(_Partition)));
     if(MountPointMap.contains(INSTALLER_MOUNT_POINT_ROOT)){
        MountPointIterator = MountPointMap.find(INSTALLER_MOUNT_POINT_ROOT);
        if(MountPointIterator.value() == Path){
            f->SetMountPoint(INSTALLER_MOUNT_POINT_ROOT);
                return;
        }
    }
    if(MountPointMap.contains(INSTALLER_MOUNT_POINT_HOME)){
        MountPointIterator = MountPointMap.find(INSTALLER_MOUNT_POINT_HOME);
        if(MountPointIterator.value() == Path){
            f->SetMountPoint(INSTALLER_MOUNT_POINT_HOME);
                return;
        }
    }
}

void PartitionList::ClearPartitionList(){
    if(PartitionMap.isEmpty() == false){
        for(Result = PartitionMap.begin();Result != PartitionMap.end();Result++)
            delete Result.value();
        PartitionMap.clear();
    }
    PartitionCount = 0;
}

void PartitionList::resizeEvent(QResizeEvent *){
    List->resize(this->width(),this->height());
    FriendLabelList->resize(List->width()-20,_FRIEND_LABEL_HEIGTH*PartitionCount);
}

void PartitionList::SetPartitionCount(int n){
    PartitionCount=n;
}

int PartitionList::GetPartitionCount(){
    return PartitionCount;
}

void PartitionList::ItemClicked(PartitionItem *Item){
    if(PartitionMap.isEmpty() == false){
        for(Result = PartitionMap.begin();Result != PartitionMap.end();Result++){
            Result.value()->SetUnselected(true);
        }
    }
    if(Item->GetPartition().type == PED_PARTITION_NORMAL){
        emit SetChangeButtonDisabled(false);
        emit SetAddButtonDisabled(true);
        emit SetDelButtonDisabled(false);
    }else if(Item->GetPartition().type == PED_PARTITION_FREESPACE){
        emit SetChangeButtonDisabled(true);
        emit SetAddButtonDisabled(false);
        emit SetDelButtonDisabled(true);
    }else{
        emit SetChangeButtonDisabled(true);
        emit SetAddButtonDisabled(true);
        emit SetDelButtonDisabled(true);
    }
    CurrentSelelcted = Item;
}

PedPartition PartitionList::GetPartitionDataByUID(uint32_t UID){
    Result = PartitionMap.find(UID);
    return Result.value()->GetPartition();
}

void PartitionList::SetCurrentMountPoint(int MountPoint){
    if(MountPoint == INSTALLER_MOUNT_POINT_NONE){
        return;
    }
    CurrentSelelcted->SetMountPoint(MountPoint);
    PedPartition t = CurrentSelelcted->GetPartition();
    MountPointMap[MountPoint]=ped_partition_get_path(&t);
}

int PartitionList::GetCurrentMountPoint(){
    return CurrentSelelcted->GetMountPoint();
}

PedPartition PartitionList::GetCurrentSelectedPartition(){
    return CurrentSelelcted->GetPartition();
}

PedDisk PartitionList::GetCurrentSelectedDisk(){
    return CurrentSelelcted->GetDisk();
}

PedDevice PartitionList::GetCurrentSelectedDevice(){
    return CurrentSelelcted->GetDevice();
}

void PartitionList::RefreshList(){
    ClearPartitionList();
    PedPartition Part;
    PedDevice *dev = 0;
    while((dev = ped_device_get_next(dev))){
      /*printf("\n ==============================================\n");
        printf("device model: %s\n", dev->model);
        printf("path: %s\n",dev->path);
        long long size = (dev->sector_size * dev->length)/(1024*1024*1024);
        printf("size: %lld G\n", size);*/
        PedDisk* disk = ped_disk_new(dev);
        PedPartition* part = 0;
        while((part = ped_disk_next_partition(disk, part))){
            //略过不是分区的空间
      /*    if ((part->type & PED_PARTITION_METADATA) ||
                (part->type & PED_PARTITION_FREESPACE) ||
                (part->type & PED_PARTITION_EXTENDED))
                    continue;*/
          /*printf("++++++++++++++++++++++++++++++++++++\n");
            printf("partition: %s\n", ped_partition_get_path(part));
            if(part->fs_type)
                printf("fs_type: %s\n", part->fs_type->name);
            else
                printf("fs_type: (null)\n");
            //printf("partition start:%lld/n", part->geom.start);
            //printf("partition end: %lld/n", part->geom.end);
            printf("partition length:%lld M\n", (part->geom.length * dev->sector_size)/(1024*1024));*/
            memcpy((void*)&Part,(void*)part,sizeof(Part));
            AddPartition(part,dev,disk);
        }
    }
}

QString PartitionList::GetMountPoint(int MountPoint){
    if(MountPointMap.contains(MountPoint)){
        MountPointIterator = MountPointMap.find(MountPoint);
        return MountPointIterator.value();
    }else{
        QString k;
        k.clear();
        return k;       //  返回一个空的QString
    }
}


PartedPage::PartedPage(InstallerPage *parent)
    :InstallerPage(parent){
    MyEFIPartitionPath = new QLabel(this);
    MyBootDevicePath   = new QLabel(this);
    UnselectEFI  = new QPushButton(this);
    UnselectGrub = new QPushButton(this);
    DeviceSelect = new MyTabWidget(this);
    ChangeButton = new QPushButton(this);
    AddButton    = new QPushButton(this);
    DelButton    = new QPushButton(this);
    MyBootDevice = new QPushButton(this);
    MyEFIPartition=new QPushButton(this);
    List         = new PartitionList();
    AddDialog    = new AddDialogBox;
    ChangeDialog = new ChangeDialogBox;
    AddDialog->hide();
    ChangeDialog->hide();
    DeviceSelect->setGeometry(0,50,475,this->height()-180);
    DeviceSelect->insertTab(0,List,"Main");
    DeviceSelect->setDocumentMode(true);
    ChangeButton->setText("Change");
    AddButton->setText("+");
    DelButton->setText("-");
    MyBootDevice->setText(tr("Install Grub here"));
    MyEFIPartition->setText(tr("Support Grub EFI"));
    MyBootDevicePath->setText(tr("Do not install"));
    MyEFIPartitionPath->setText(tr("Do not install"));
    UnselectGrub->setText(tr("Unselect"));
    UnselectEFI->setText(tr("Unselect"));
    AddButton->setGeometry(0,this->height()-120,20,20);
    ChangeButton->setGeometry(20,this->height()-120,55,20);
    DelButton->setGeometry(75,this->height()-120,20,20);
    MyBootDevice->setGeometry(0,this->height()-100,120,20);
    MyBootDevicePath->setGeometry(130,this->height()-100,120,20);
    UnselectGrub->setGeometry(300,this->height()-100,70,20);
    MyEFIPartition->setGeometry(0,this->height()-80,120,20);
    MyEFIPartitionPath->setGeometry(130,this->height()-80,120,20);
    UnselectEFI->setGeometry(300,this->height()-80,70,20);
    SetContantTitle(tr("Parted!"));
    ped_device_probe_all();
    ChangeButton->setDisabled(true);
    AddButton->setDisabled(true);
    DelButton->setDisabled(true);
    MyBootDevice->setDisabled(true);
    MyEFIPartition->setDisabled(true);
    MyEFIPartitionPath->show();
    UnselectGrub->show();
    UnselectGrub->setDisabled(true);
    UnselectEFI->show();
    UnselectEFI->setDisabled(true);
    this->connect(List,SIGNAL(SetAddButtonDisabled(bool)),this->AddButton,SLOT(setDisabled(bool)));
    this->connect(List,SIGNAL(SetChangeButtonDisabled(bool)),this->ChangeButton,SLOT(setDisabled(bool)));
    this->connect(List,SIGNAL(SetChangeButtonDisabled(bool)),this->MyBootDevice,SLOT(setDisabled(bool)));
    this->connect(List,SIGNAL(SetChangeButtonDisabled(bool)),this,SLOT(EnableEFISupport(bool)));
    this->connect(List,SIGNAL(SetDelButtonDisabled(bool)),this->DelButton,SLOT(setDisabled(bool)));
    this->connect(AddButton,SIGNAL(clicked()),this,SLOT(ShowAddDialog()));
    this->connect(ChangeButton,SIGNAL(clicked()),this,SLOT(ShowChangeDialog()));
    this->connect(DelButton,SIGNAL(clicked()),this,SLOT(AskForDeletePartition()));
    this->connect(ChangeDialog,SIGNAL(MountPointChangeApplied(int)),this,SLOT(MountPointChangeApplied(int)));
    this->connect(ChangeDialog,SIGNAL(WorkDone()),this,SLOT(WorkDone()));
    this->connect(MyBootDevice,SIGNAL(clicked()),this,SLOT(SetGrubDest()));
    this->connect(UnselectGrub,SIGNAL(clicked()),this,SLOT(UnselectGrubClicked()));
    this->connect(MyEFIPartition,SIGNAL(clicked()),this,SLOT(SetEFIDest()));
    this->connect(UnselectEFI,SIGNAL(clicked()),this,SLOT(UnselectEFIClicked()));
}

void PartedPage::ShowAddDialog(){
    ChangeDialog->SetCurrentPartition(List->GetCurrentSelectedPartition(),List->GetCurrentSelectedDisk(),List->GetCurrentSelectedDevice(),INSTALLER_MOUNT_POINT_NONE,INSTALLER_WORKTYPE_ADD);
    ChangeDialog->show();
}

void PartedPage::ShowChangeDialog(){
    ChangeDialog->SetCurrentPartition(List->GetCurrentSelectedPartition(),List->GetCurrentSelectedDisk(),List->GetCurrentSelectedDevice(),List->GetCurrentMountPoint(),INSTALLER_WORKTYPE_CHANGE);
    ChangeDialog->show();
}

void PartedPage::EnableEFISupport(bool s){
    if(s == false){
        if(InstallGrub == false)
            return;
        else
            MyEFIPartition->setEnabled(true);
    }else{
        MyEFIPartition->setDisabled(true);
    }
}

void PartedPage::SetGrubDest(){
    GrubDest = List->GetCurrentSelectedDisk().dev->path;
    InstallGrub = true;
    MyBootDevicePath->setText(GrubDest);
    UnselectGrub->setEnabled(true);
    MyEFIPartition->setEnabled(true);
}

void PartedPage::SetEFIDest(){
    PedPartition P;
    P = List->GetCurrentSelectedPartition();
    EFIDest = ped_partition_get_path(&P);
    MyEFIPartitionPath->setText(EFIDest);
    UnselectEFI->setEnabled(true);
}

void PartedPage::UnselectGrubClicked(){
    MyBootDevicePath->setText(tr("Do not install"));
    UnselectGrub->setDisabled(true);
    InstallGrub=false;
    this->UnselectEFIClicked();
}

void PartedPage::UnselectEFIClicked(){
    MyEFIPartitionPath->setText(tr("Do not Install"));
    UnselectEFI->setDisabled(true);
    InstallEFI = false;
    if(InstallGrub == false)
        MyEFIPartition->setDisabled(true);
}

void PartedPage::AskForDeletePartition(){
    if (QMessageBox::question(this,tr("Question"),tr("Do you want to delete this partition?"),QMessageBox::Yes|QMessageBox::No) == QMessageBox::Yes){
        DelPartition(List->GetCurrentSelectedPartition(),List->GetCurrentSelectedDisk());
        List->RefreshList();
    }
}

void PartedPage::DelPartition(PedPartition TargetPartition, PedDisk TargetDisk){
    PedDevice *dev = 0;
    while((dev = ped_device_get_next(dev))){
        PedDisk* disk = ped_disk_new(dev);
        PedPartition* part = 0;
        while((part = ped_disk_next_partition(disk, part))){
            //略过不是分区的空间
            if ((part->type & PED_PARTITION_METADATA) ||
                (part->type & PED_PARTITION_FREESPACE) ||
                (part->type & PED_PARTITION_EXTENDED))
                    continue;
            if(strcmp(ped_partition_get_path(part),ped_partition_get_path(&TargetPartition)) == 0){
                char Exec[64];
                bzero(Exec,64);
                sprintf(Exec,"parted %s rm %d",TargetDisk.dev->path,TargetPartition.num);
                system(Exec);
                ped_disk_commit(disk);
            }
        }
    }
}

PartedPage::~PartedPage(){

}

void PartedPage::PervShow(){
    //emit SIGN_SetNextButtonDisabled(true);
    system("umount -f /target");    //  umount all partitions
    List->RefreshList();
}

void PartedPage::MountPointChangeApplied(int MountPoint){
    List->SetCurrentMountPoint(MountPoint);
}

void PartedPage::WorkDone(){
    List->RefreshList();
    AddButton->setDisabled(true);
    DelButton->setDisabled(true);
    ChangeButton->setDisabled(true);
}

int PartedPage::SLOT_NextButtonClicked(){
    system("sudo umount -Rf /target");
    QString Path;
    char Exec[64];
    bzero(Exec,64);
    Path = List->GetMountPoint(INSTALLER_MOUNT_POINT_ROOT);
    if(Path.length() < 5){
        QMessageBox::warning(this,tr("警告"),tr("您没有选择root分区或选取分区无效，请选择挂载分区后重试"),QMessageBox::Yes);
        return -1;
    }
    sprintf(Exec,"mount %s /target",Path.toUtf8().data());
    if(system("Exec")!=0){
        if(QMessageBox::warning(this,tr("错误"),tr("root分区挂载失败，是否返回分区界面"),QMessageBox::Yes|QMessageBox::No) == QMessageBox::Yes){
            return -1;
        }
    }
    Path = List->GetMountPoint(INSTALLER_MOUNT_POINT_HOME);
    if(Path.length()>5){
        if(system("mkdir /target/home") != 0){
            QMessageBox::warning(this,tr("提示"),tr("无法创建%SYSTEMROOT%/home 目录，确认目标分区是否已经存在此同名文件"),QMessageBox::Yes);
        }
        bzero(Exec,64);
        sprintf(Exec,"mount %s /target/home",Path.toUtf8().data());
        if(system("Exec") != 0){
            QMessageBox::warning(this,tr("失败"),tr("挂载/home分区失败"),QMessageBox::Yes);
            return -1;
        }
    }
    Path = List->GetMountPoint(INSTALLER_MOUNT_POINT_BOOT);
    if(Path.length()>5){
        if(system("mkdir /target/boot") != 0){
            QMessageBox::warning(this,tr("提示"),tr("无法创建%SYSTEMROOT%/boot 目录，确认目标分区是否已经存在此同名文件"),QMessageBox::Yes);
            return 0;
        }
        bzero(Exec,64);
        sprintf(Exec,"mount %s /target/home",Path.toUtf8().data());
        if(system("Exec") != 0){
            QMessageBox::warning(this,tr("失败"),tr("挂载/home分区失败"),QMessageBox::Yes);
            return -1;
        }
    }
    return 0;
}


WorkingThread::WorkingThread(QThread *parent):
    QThread(parent){

}

WorkingThread::~WorkingThread(){

}

void WorkingThread::run(){
    int Status = system(Work.toUtf8().data());
    emit WorkDone(Work,Status);
}

void WorkingThread::SetWork(QString Joy){
    Work = Joy;
}




WorkingDialog::WorkingDialog(QWidget *parent):
    QWidget(parent){
    Thread              = new WorkingThread;
    WorkingDescription  = new QLabel(this);
    CancelButton        = new QPushButton(this);
    DoneButton          = new QPushButton(this);
    CancelButton->setText("Cancel");
    DoneButton->setText("Done");
    CancelButton->hide();
    DoneButton->hide();

    this->setMaximumSize(150,100);
    this->setMinimumSize(150,100);
    WorkingDescription->setGeometry(35,30,100,20);
    CancelButton->setGeometry(90,65,55,25);
    DoneButton->setGeometry(90,65,55,25);
    this->connect(Thread,SIGNAL(started()),this,SLOT(pWorkStarted()));
    this->connect(Thread,SIGNAL(WorkDone(QString,int)),this,SLOT(pWorkStoped(QString,int)));
    this->connect(CancelButton,SIGNAL(clicked()),this,SLOT(Stop()));
    this->connect(DoneButton,SIGNAL(clicked()),this,SLOT(close()));
    this->setWindowTitle(tr("Working..."));
}

WorkingDialog::~WorkingDialog(){

}

void WorkingDialog::SetWork(QString Work){
    Thread->SetWork(Work);
}

void WorkingDialog::SetWorkingtText(QString Text){
    WorkingDescription->setText(Text);
    WorkingDescription->show();
}

void WorkingDialog::Start(){
    Thread->start();
    this->show();
    CancelButton->show();
}

void WorkingDialog::Stop(){
    Thread->terminate();
    this->close();
    emit Stoped(-1);
}


void WorkingDialog::pWorkStarted(){
    this->show();
}

void WorkingDialog::pWorkStoped(QString,int Status){
    if(Status != 0){
        WorkingDescription->setText(tr("Failure!"));
    }else{
        WorkingDescription->setText(tr("Success"));
    }
    this->hide();
    emit Stoped(Status);
}

MyTabWidget::MyTabWidget(QWidget *parent):
    QTabWidget(parent){
    this->tabBar()->hide();
}


ChangeDialogBox::ChangeDialogBox(QWidget *parent):
    QWidget(parent){
    this->setMinimumSize(300,200);
    this->setMaximumSize(300,200);
    this->setWindowTitle(tr("Change partition"));
    ApplyButton     = new QPushButton(this);
    CancelButton    = new QPushButton(this);
    ApplyButton->setText(tr("Apply"));
    CancelButton->setText(tr("Cancel"));
    ApplyButton->setGeometry(160,160,60,30);
    CancelButton->setGeometry(230,160,60,30);

    DoWork           = new WorkingDialog;

    FileSystemSelect = new QComboBox(this);
    MountPointSelect = new QComboBox(this);
    MountPointLabel  = new QLabel(this);
    PartitionPath    = new QLabel(this);
    FileSystemLabel  = new QLabel(this);
    DoFormatLabel    = new QLabel(this);
    PartitionSizeLabel=new QLabel(this);
    DoFormatCheckBox = new QCheckBox(this);
    PartitionSize    = new QSpinBox(this);

    PartitionPath->setGeometry(35,10,200,20);
    FileSystemLabel->setGeometry(35,40,95,20);
    FileSystemSelect->setGeometry(130,40,75,20);
    MountPointLabel->setGeometry(35,60,95,20);
    MountPointSelect->setGeometry(130,60,75,20);
    DoFormatLabel->setGeometry(35,80,75,20);
    DoFormatCheckBox->setGeometry(130,80,110,20);
    PartitionSizeLabel->setGeometry(35,100,75,20);
    PartitionSize->setGeometry(130,100,75,20);


    PartitionPath->setText(tr("Partition path: /dev/sda1"));
    FileSystemLabel->setText(tr("Filesystem"));
    MountPointLabel->setText(tr("Mount point"));
    DoFormatLabel->setText(tr("Format"));

    FileSystemSelect->addItem(tr("ext2"));
    FileSystemSelect->addItem(tr("ext3"));
    FileSystemSelect->addItem(tr("ext4"));
    FileSystemSelect->addItem(tr("ntfs"));
    FileSystemSelect->addItem(tr("fat32"));

    MountPointSelect->addItem(tr("---"));
    MountPointSelect->addItem(tr("/"));
    MountPointSelect->addItem(tr("/home"));

    PartitionSizeLabel->setText(tr("Size(MB)"));



    this->connect(ApplyButton,SIGNAL(clicked()),this,SLOT(ApplyButtonClicked()));
    this->connect(CancelButton,SIGNAL(clicked()),this,SLOT(CancelButtonClicked()));
    this->connect(FileSystemSelect,SIGNAL(currentIndexChanged(int)),this,SLOT(FileSystemSelectChanged(int)));
    this->connect(DoWork,SIGNAL(Stoped(int)),this,SLOT(FormatDone(int)));

}

ChangeDialogBox::~ChangeDialogBox(){

}

void ChangeDialogBox::SetCurrentPartition(PedPartition Partition, PedDisk Disk, PedDevice Device,int MountPoint, int _WorkType){
    memcpy((void*)&CurrentPartition,(void*)&Partition,sizeof(PedPartition));
    memcpy((void*)&CurrentDisk,(void*)&Disk,sizeof(PedDisk));
    memcpy((void*)&CurrentDevice,(void*)&Device,sizeof(PedDevice));
    WorkType = _WorkType;
    OriginMountPoint =MountPoint;
    char Name[64];
    sprintf(Name,"%s :%s",tr("Partition path").toUtf8().data(),ped_partition_get_path(&Partition));
    PartitionPath->setText(Name);
    if(MountPoint > 0){
        if(MountPoint == INSTALLER_MOUNT_POINT_ROOT){
            MountPointSelect->insertItem(MountPoint,tr("/"));
        }else if(MountPoint == INSTALLER_MOUNT_POINT_HOME){
            MountPointSelect->insertItem(MountPoint,tr("/home"));
        }
    }
    MountPointSelect->setCurrentIndex(MountPoint);
    PartitionSize->setRange(0,(CurrentPartition.geom.length * CurrentDevice.sector_size)/(1024*1024));
    PartitionSize->setValue((CurrentPartition.geom.length * CurrentDevice.sector_size)/(1024*1024));
    if(WorkType == INSTALLER_WORKTYPE_ADD){
        OriginFileSystem = INSTALLER_FILESYSTEM_FREESPACE;
        FileSystemSelect->setCurrentIndex(INSTALLER_FILESYSTEM_EXT4);
        return;
    }else if(Partition.fs_type != NULL){
        if(strcmp(Partition.fs_type->name,"ext2") == 0)          OriginFileSystem = INSTALLER_FILESYSTEM_EXT2;
        else if(strcmp(Partition.fs_type->name,"ext3") == 0)     OriginFileSystem = INSTALLER_FILESYSTEM_EXT3;
        else if(strcmp(Partition.fs_type->name,"ext4") == 0)     OriginFileSystem = INSTALLER_FILESYSTEM_EXT4;
        else if(strcmp(Partition.fs_type->name,"ntfs") == 0)     OriginFileSystem = INSTALLER_FILESYSTEM_NTFS;
        else if(strcmp(Partition.fs_type->name,"fat32")== 0)     OriginFileSystem = INSTALLER_FILESYSTEM_FAT32;
        FileSystemSelect->setCurrentIndex(OriginFileSystem);
    }else{
        OriginFileSystem = INSTALLER_FILESYSTEM_NONE;
        FileSystemSelect->setCurrentIndex(INSTALLER_FILESYSTEM_EXT4);
    }
}

void ChangeDialogBox::FormatDone(int Status){
    if(Status != 0){
        QMessageBox::warning(this,tr("Warning"),tr("Format failure!"),QMessageBox::Yes);
    }else{
        QMessageBox::information(this,tr("Information"),tr("Format success!"),QMessageBox::Yes);
    }
    this->close();
    emit WorkDone();
}

void ChangeDialogBox::ApplyButtonClicked(){
    emit MountPointChangeApplied(MountPointSelect->currentIndex());
    if(MountPointSelect->currentIndex()>0){
        MountPointSelect->removeItem(MountPointSelect->currentIndex());
    }
    if(DoFormatCheckBox->isChecked() == false){
        this->close();
    }else{
        if(WorkType == INSTALLER_WORKTYPE_ADD){
            PedPartition *NewPartition;
            PedFileSystemType *fstype = ped_file_system_type_get("msdos");
            int ToEnd = (((CurrentPartition.geom.length * CurrentDevice.sector_size)/(1024*1024) - PartitionSize->value()))
                                                                *(1024*1024)/CurrentDevice.sector_size;
            NewPartition = ped_partition_new(&CurrentDisk,PED_PARTITION_NORMAL,fstype,CurrentPartition.geom.start,CurrentPartition.geom.end - ToEnd);
            if(NewPartition){
                ped_disk_add_partition(&CurrentDisk,NewPartition,ped_constraint_exact(&NewPartition->geom));
                ped_disk_commit_to_dev(&CurrentDisk);
                ped_disk_commit_to_os(&CurrentDisk);
            }
            char Name[64];
            bzero(Name,64);
            sprintf(Name,"%s :%s",tr("Partition path").toUtf8().data(),ped_partition_get_path(NewPartition));
            PartitionPath->setText(Name);
            char Work[64];
            bzero(Work,64);
            sprintf(Work,"mkfs.%s %s -F",FileSystemSelect->currentText().toUtf8().data(),ped_partition_get_path(NewPartition));
            DoWork->SetWork(tr(Work));
            DoWork->SetWorkingtText(tr("Formating......"));
            DoWork->Start();
            return;
        }
        char Work[64];
        bzero(Work,64);
        sprintf(Work,"mkfs.%s %s -F",FileSystemSelect->currentText().toUtf8().data(),ped_partition_get_path(&CurrentPartition));
        DoWork->SetWork(tr(Work));
        DoWork->SetWorkingtText(tr("Formating......"));
        DoWork->Start();
    }
}

void ChangeDialogBox::CancelButtonClicked(){
    if(OriginMountPoint > 0){
        MountPointSelect->removeItem(OriginMountPoint);
    }
    this->close();
}

void ChangeDialogBox::FileSystemSelectChanged(int Now){
    if(Now != OriginFileSystem){
        DoFormatCheckBox->setDisabled(true);
        DoFormatCheckBox->setChecked(true);
    }else{
        DoFormatCheckBox->setDisabled(false);
    }
}


AddDialogBox::AddDialogBox(QWidget *parent):
    QWidget(parent){
    this->setMinimumSize(300,200);
    this->setMaximumSize(300,200);
    this->setWindowTitle(tr("New partition"));
    ApplyButton     = new QPushButton(this);
    CancelButton    = new QPushButton(this);
}

AddDialogBox::~AddDialogBox(){

}

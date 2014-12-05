// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.stars.widgets 1.0
import "../utility"

MyPage{

    HeaderView{

        invertedTheme: command.invertedTheme
        height: screen.currentOrientation===Screen.Portrait?72:56
    }

    tools: ToolBarLayout{
        ToolIcon{
            iconId: "toolbar-volume"

            onClicked: {
                fileDialog.inverseTheme = false
                fileDialog.chooseType = FilesDialog.AllType
                fileDialog.exec("./", "", FilesDialog.AllEntries, FilesDialog.Name|FilesDialog.DirsFirst)

                var files_list = fileDialog.allSelection()
                //获取所有选中的文件，还可以用firstSelection()获取第一个选中的文件
                for(var i in files_list){//遍历输出所有选中的文件
                    console.debug(files_list[i].type+","+files_list[i].filePath)
                    //type为选中的类型（文件夹、文件、驱动器），name是它名字
                    //其中还有path属性是它的绝对路径，filePath是它的filePath（文件的话包含文件名）
                }
            }
        }
    }
}

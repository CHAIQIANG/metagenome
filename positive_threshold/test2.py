'''
当前代码实现一个文件夹内所有文本内容写入同一个 excel
每个文本都有各自独立的 sheet 页
文本单行用制表符分隔，代表多列数据
'''
# 导入模块
import os
import xlwt

def getline(filepath, xlspath):
    # 读取所有文本
    file_names = os.listdir(filepath)
    # 对os.listdir进行排序 指定参数加上 (key=lambda x:int(x[0]))
    file_names.sort()
    file_ob_list = []
    try:
        # 获取完整目录名并保存到数组
        for file_name in file_names:
            file_ob = filepath + "/" + file_name
            file_ob_list.append(file_ob)
        print(file_ob_list)

        # 新建工作表格
        xls = xlwt.Workbook()
        # 循环读取文件，并写入到表格中
        for file_ob in file_ob_list:
            # 仅获取文件名，如果末尾为 '/' '\' ,返回空
            sheet_name = os.path.basename(file_ob)
            # 每一个文本都会新建一个相同文件名的 sheet
            sheet = xls.add_sheet(sheet_name, cell_overwrite_ok=True)
            # txt 写入 xls
            f = open(file_ob)
            x = 0
            # 按行读取文本
            while True:
                line = f.readline()
                if not line:
                    break
                for i in range(len(line.split('\t'))):
                    data = line.split('\t')[i]
                    data = str(data)    #将数据转化为字符串，再对其中的换行符进行处理
                    data = data.replace('\n', ' ')  #使用python中字符串函数替换换行符为空格
                    sheet.write(x,i,data)   # x,i,data 代表横、纵坐标和内容
                x += 1
            # 然后读取下一个文本
            f.close()
        xls.save(xlspath)
    except:
        raise

if __name__ == "__main__" :
    filepath = "/f/mulinlab/chaiqiang/project/metagenome_2019/python_scripts/positive_threshold/positive+negative/10_therold/"  # 文件目录
    xlspath = "/f/mulinlab/chaiqiang/project/metagenome_2019/python_scripts/positive_threshold/positive+negative/CSF-Real-Ratio-INFO_10therold.xls"	# xls 文件绝对路径
    # 传入参数执行
    getline(filepath, xlspath)

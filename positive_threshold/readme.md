#### 阳性阈值的计算方法

- first_caculate是通过第二种阳性阈值的计算方法，即：

**Ratio=【NR/样本总reads】/【NNR/阴性脑脊液总reads】**

① 若是在阳性样本中有但是在阴性样本中没有的微生物，其Ratio计算方法为：**阳性样本raw reads/样本总reads数  **

- positive-therold_caculate_2th是通过第三种阳性阈值的计算方法，即：

① **Ratio=【RR/样本总reads】/【NRR/阴性脑脊液总reads】**

② **Ratio=【RR/样本总reads】/【1/阴性脑脊液总reads】**

若在阳性和阴性样本中都有，则采用**公式①**；

若阳性中有但阴性样本中没有，则采用**公式②**。

- F16_control是用F16作为阴性对照进行的阳性阈值的计算

- test.py是将多个txt文件合并为excel，每个txt代表一个sheet
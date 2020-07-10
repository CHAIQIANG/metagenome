#导入 ggplot2 包
library(ggplot2)

#读取文件
depth_base <- read.table('luoNEB9_strep_depth.txt',header = T)
depth_base$depth=log10(depth_base$depth)
#ggplot2 散点图
depth_local <- ggplot(depth_base, aes(Local, depth))+
  geom_point(color = 'gray', alpha = 0.6, pch = 19, size = 0.5) +
  theme(panel.grid.major = element_line(color = 'gray', linetype = 2, size = 0.25), panel.background = element_rect(color = 'black', fill = 'transparent')) +
  labs(x = 'local', y = 'Depth')
#depth_local=depth_local+scale_y_log10()
ggsave('./log-coverage_plot/luoNEB9_strep.png', depth_local, width = 10, height = 5.5)

##大肠杆菌
depth_base1 <- read.table('luoNEB9_Ecoli_depth.txt',header = T)
depth_base1$depth=log10(depth_base1$depth)
#ggplot2 散点图
depth_local1 <- ggplot(depth_base1, aes(Local, depth)) +
  geom_point(color = 'gray', alpha = 0.6, pch = 19, size = 0.5) +
  theme(panel.grid.major = element_line(color = 'gray', linetype = 2, size = 0.25), panel.background = element_rect(color = 'black', fill = 'transparent')) +
  labs(x = 'local', y = 'Depth')

ggsave('./log-coverage_plot/luoNEB9_Ecoli.png', depth_local1, width = 10, height = 5.5)

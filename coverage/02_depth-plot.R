#e/<e% ggplot2 e
library(ggplot2)
 
#h/;efd;6
depth_base <- read.table('B15_SP_depth.txt',header = T,col.names = c("Name","Local","depth"))
 
#ggplot2 f#g9e>
depth_local <- ggplot(depth_base, aes(Local, depth)) +
    geom_point(color = 'gray', alpha = 0.6, pch = 19, size = 0.5) +
    theme(panel.grid.major = element_line(color = 'gray', linetype = 2, size = 0.25), panel.background = element_rect(color = 'black', fill = 'transparent')) +
    labs(x = 'local', y = 'Depth')
 
ggsave('B15_SP.png', depth_local, width = 10, height = 5.5)


##e$'h fh
depth_base1 <- read.table('test-luoill4_Ecoli_depth.txt',header = T)

#ggplot2 f#g9e>
depth_local1 <- ggplot(depth_base1, aes(Local, depth)) +
  geom_point(color = 'gray', alpha = 0.6, pch = 19, size = 0.5) +
  theme(panel.grid.major = element_line(color = 'gray', linetype = 2, size = 0.25), panel.background = element_rect(color = 'black', fill = 'transparent')) +
  labs(x = 'local', y = 'Depth')

ggsave('test-luoill4_Ecoli.png', depth_local1, width = 10, height = 5.5)


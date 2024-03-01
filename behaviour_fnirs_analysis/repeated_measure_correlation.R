library(rmcorr)

library(openxlsx)

# 设置工作目录
setwd("/xxxxxxxx")

# 读取 txt 文件数据
data <- read.table("xxxx.txt", header=TRUE)

# 选择问卷分数和行为指标的列
questionnaire <- data[:, :]
behavior <- data[:, :]

# 创建一个空的数据框，用于存储每个问卷分数和行为指标的重复测量相关性
rmcorr_result <- data.frame(questionnaire = character(), behavior = character(), rmcorr = numeric(),rmcorrr = numeric(), rmcorrd = numeric(),stringsAsFactors = FALSE)

# 循环计算每个问卷分数和行为指标的重复测量相关性
for (i in 1:ncol(questionnaire)) {
  for (j in 1:ncol(behavior)) {
    # 从原始数据中选择对应的列
    measure1 <- questionnaire[, i]
    measure2 <- behavior[, j]
    participant <- data$Sub[:]
    # 将数据合并为数据框
    dataset <- data.frame(Participant = participant, Measure1 = measure1, Measure2 = measure2)
    # 计算重复测量相关性
    rmc.out <- rmcorr(participant, measure1, measure2, dataset, CIs = c("analytic"), nreps = 100, bstrap.out = FALSE)
    #print(rmc.out)
    # 将结果添加到数据框中
    rmcorr_result <- rbind(rmcorr_result, data.frame(questionnaire = names(questionnaire)[i], behavior = names(behavior)[j], rmcorr = rmc.out$p,rmcorrr = rmc.out$r,rmcorrd = rmc.out$d))
  }
}
# 查看结果
rmcorr_result
rmc.out
# write.xlsx(rmcorr_result, "/xxxx.xlsx", sheetName = "MySheet")

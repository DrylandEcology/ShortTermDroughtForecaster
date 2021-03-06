# This script contains figures pertaining to whether the NWS anomalies are being successfully integrated 
# and reflected into the SW runs
library(ggplot2)
library(plyr)

# Diagnostic plot ---- scatters of dailys ...
names(FutureData)
FutureData$runx <- sapply(strsplit(FutureData$run, '_'), '[', 1)
FutureData$Year <- NULL
FutureData$Year <- sapply(strsplit(FutureData$run, '_'), '[', 2)

# Historical 
HistDataNormMean <- HistDataAll[HistDataAll$Year %in% 1981:2010, ]
HistDataNormMean$Date <- as.Date(strptime(paste(HistDataNormMean$Year, HistDataNormMean$Day), format="%Y %j"), format="%m-%d-%Y")
HistDataNormMean$Month <- month(HistDataNormMean$Date)
names(HistDataNormMean)[3:4] <- c('Hist.Temp', 'Hist.ppt')

### Differences between Future and Historical --------------------------------------------------------------
DiffDaily <- plyr::join(FutureData[,c('Year','Day', 'avg_C', 'ppt', 'runx' )], HistDataNormMean[,c(1:4, 14)])
DiffDaily$SW_TempAnom <- DiffDaily$avg_C - DiffDaily$Hist.Temp
DiffDaily$SW_PPTAnom <- DiffDaily$ppt / DiffDaily$Hist.ppt
summary(DiffDaily)

# join with the anomaly data ------------------------------------------------------------------------------
MonthlyAnoms$runx <- rep(1:10, each = 12)

DiffDaily <- plyr::join(DiffDaily, MonthlyAnoms)
dim(DiffDaily)

Sample <- DiffDaily[sample(nrow(DiffDaily), 30000), ]
Sample <- Sample[!is.na(Sample$Month),]

# # plot temp ----------------------------------------------------------------------------------------------
ggplot() + geom_point(data = Sample, aes(tempAnom, SW_TempAnom)) + 
  geom_abline(intercept = 0, slope = 1, color = 'red') + 
  facet_wrap(Month~., nrow = 2) +
  theme_bw() + theme(legend.position = 'bottom')
ggsave('images/DailyScatter_AnomvsSWOuts_Temp.png', width =5, height =5)

ggplot() + geom_point(data = Sample, aes(pptAnom_CF, SW_PPTAnom)) + 
  geom_abline(intercept = 0, slope = 1, color = 'red') + 
  facet_wrap(Month~., nrow = 2) +
  theme_bw() + theme(legend.position = 'bottom')
ggsave('images/DailyScatter_AnomvsSWOuts_PPT.png', width =5, height =5)

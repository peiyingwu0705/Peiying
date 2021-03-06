source('pttTestFunction.R')
id = c(1:10)
URL = paste0("https://www.ptt.cc/bbs/Zastrology/index",id,".html")
filename = paste0(id, ".txt")
pttTestFunction(URL[1], filename[1])
mapply(pttTestFunction, 
       URL = URL, filename = filename)
rm(list=ls(all.names = TRUE))
library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)
filenames <- list.files(getwd(), pattern="*.txt")
files <- lapply(filenames, readLines)
docs <- Corpus(VectorSource(files))
#移除可能有問題的符號
toSpace <- content_transformer(function(x, pattern) {
  return (gsub(pattern, " ", x))
}
)
docs <- tm_map(docs, toSpace, "※")
docs <- tm_map(docs, toSpace, "◆")
docs <- tm_map(docs, toSpace, "‧")
docs <- tm_map(docs, toSpace, "的")
docs <- tm_map(docs, toSpace, "我")
docs <- tm_map(docs, toSpace, "是")
docs <- tm_map(docs, toSpace, "看板")
docs <- tm_map(docs, toSpace, "作者")
docs <- tm_map(docs, toSpace, "發信站")
docs <- tm_map(docs, toSpace, "批踢踢實業坊")
docs <- tm_map(docs, toSpace, "[a-zA-Z]")
docs <- tm_map(docs, toSpace, "如果")
docs <- tm_map(docs, toSpace, "非常")
docs <- tm_map(docs, toSpace, "沒有")
docs <- tm_map(docs, toSpace, "要")
docs <- tm_map(docs, toSpace, "了")
docs <- tm_map(docs, toSpace, "都")
docs <- tm_map(docs, toSpace, "而")
docs <- tm_map(docs, toSpace, "而且")
docs <- tm_map(docs, toSpace, "就")
docs <- tm_map(docs, toSpace, "在")
docs <- tm_map(docs, toSpace, "有")
docs <- tm_map(docs, toSpace, "不")
docs <- tm_map(docs, toSpace, "很")
docs <- tm_map(docs, toSpace, "又")

#移除標點符號 (punctuation)
#移除數字 (digits)、空白 (white space)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)
docs

mixseg = worker()
jieba_tokenizer=function(d){
  unlist(segment(d[[1]],mixseg))
}
seg = lapply(docs, jieba_tokenizer)
freqFrame = as.data.frame(table(unlist(seg)))
freqFrame = freqFrame[order(freqFrame$Freq,decreasing=TRUE), ]
library(knitr)
kable(head(freqFrame), format = "markdown")
wordcloud(freqFrame$Var1,freqFrame$Freq,
          scale=c(5,0.1),min.freq=30,max.words=150,
          random.order=TRUE, random.color=FALSE, 
          rot.per=.1, colors=brewer.pal(8, "Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)

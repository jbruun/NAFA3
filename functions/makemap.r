##MAP CREATION
Wij<-function(j,mem,g){
  M<-length(unique(mem))
  m<-which(mem==j)
  dfm<-data.frame()
  
  for(i in 1:length(m)){
    x<-incident(g,m[i],mode="in")
    a<-ends(g, x,names=F)
    
    b<-get.edge.attribute(g,name="weight",x)
    c<-mem[a[,1]] #HMMM:..
    dfm<-rbind(dfm,data.frame(a,weight=b,module=c))
    
  }
  
  
  V<-vector()
  for(l in 1:M){ 
    V[l]<-sum(dfm$weight[dfm$module==l])
  }
  
  return(V)
  
}
makemap<-function(mem,g){
  M<-length(unique(mem))
  W<-matrix(NA,ncol=M,nrow=M)
  for(j in 1:length(unique(mem))){
    W[,j]<-Wij(j,mem,g) #was W[j,i] - trying out this on June 21st 2020
  }
  ##naming modules based on 10 largest pageranks
  pr<-page.rank(g)
  modulenames<-vector()
  for(k in 1:length(unique(mem))){
    modulenames[k]<-paste(c(k,names(sort(pr$vector[mem==k],decreasing = T)[1:3])),collapse = ";")
  }
  
  internalLinks<-diag(W)
  n_words<-as.vector(table(mem))
  h<-graph.adjacency(W,mode=c("directed"),weighted = T,diag = F)
  V(h)$name<-modulenames #names of the 10 higest pagerank words in them module
  V(h)$id<-modulenames
  V(h)$n_words<-n_words #how many words in module
  V(h)$internallinks<-internalLinks #how many internal links are in each module
  
  return(h)
}
library(tidyverse)

## 前提
# 1. カイ二乗検定の前提は二項分布のポアソン分布近似とポアソン分布の正規分布近似
# 2. 二項分布のポアソン分布への近似は 以下の条件
# - np = λ（一定）
# - n 大きく、　p小さい
# 3. カイ二乗分布を利用できる条件はλ（期待値E）が大きい、pが小さすぎないというのがあると思う（この条件を逸脱する場合は、フィッシャーの正確性検定やG検定を利用する）

## 検討したいこと
# 1. 二項分布とポアソン分布は条件によりどの程度乖離するか
# 2. カイ二乗分布が使える条件は結局なにか、条件から逸脱するとどの程度問題がおこるのか
# 3. フィッシャーの正確性検定も含めまとめる
#------------------------------------------------------------

## 二項分布
# X = {0, 1},  P(x=1) = p, 各施行は独立とするとき
# この施行をn回繰り返したときの X = 1 の発生回数の分布
# E = np を中心とする二項分布
#   mean = E(x=1)=np,
#   var = E((x-E(x))^2)=np(1-p)）


n.sample=1000

get.samples <- function(n, p, n.sample=10000) {
  dt.ret <-
    tibble(binom=rbinom(n=n.sample, size=n, p=p),
           poiss=rpois(n=n.sample, lambda=n * p)
    ) %>%
    tidyr::gather(key='dist') %>%
    dplyr::mutate(p=p, n=n)
  return(dt.ret)
}

get.samples.df <- function(x) get.samples(x['n'], x['p'], n.sample)


p.vec <- seq(from=0.0, to=1.0, by=0.2)
n.vec <- 10 ^ (1:4)

p.n.cross <- expand.grid(p.vec, n.vec)
colnames(p.n.cross) <- c('p', 'n')
#labels <- as.list(with(p.n.cross, paste(n, p, sep='_')))



dt <- do.call("rbind", apply(p.n.cross, 1, get.samples.df)) %>%
    dplyr::group_by(dist, n, p) %>%
    dplyr::mutate(value_scaled=scale(value))


g <- ggplot(data=dt,
      aes(x=value, y=..density.., fill=dist)) +
      geom_histogram(alpha=.5, position="identity") + 
      facet_wrap(~ n + p, ncol=length(p.vec), nrow=length(n.vec), scales="free")


print(g)


#--------------------------------------------------------
# 結局 p = 0.0 - 0.3 くらいまでじゃないか

# - ポアソン分布を仮定する場合は、pは小さい必要がある0.2以下とか
# - 二項分布を仮定する場合、pは小さい必要はないが
# - いずれにせよnp(λ)は大きい10以上ある必要がある


# 1. 標準正規分布するか
# - p = 0.5, n = 10000で正規分布するか
# - p = 0.2, n = 10000で正規分布するか
#------------------------------------------------------------

# histogram
g_norm <- ggplot(data=dt,
            aes(x=value_scaled, y=..density.., fill=dist)) +
            geom_histogram(alpha=.5, position="identity") + 
            facet_wrap(~ n + p, ncol=length(p.vec), nrow=length(n.vec), scales="free")

print(g_norm)


# Q-Q plot
g_qq <- ggplot(data=dt,
               aes(sample=value_scaled, colour=dist)) + stat_qq() + 
  facet_wrap(~ n + p, ncol=length(p.vec), nrow=length(n.vec), scales="free")

print(g_qq)


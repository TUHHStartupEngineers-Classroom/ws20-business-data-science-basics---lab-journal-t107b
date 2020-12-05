library(tidyverse) 
library(rvest)     
library(xopen)     
library(jsonlite)  
library(glue)      
library(stringi)   
library(rvest)




url <- "https://www.radon-bikes.de/"


url_home <- read_html(url)
url_home

bike_family_tbl<- url_home %>%
  html_nodes(css = ".js-dropdown > a")%>%
  html_text()%>%
  discard(.p = ~stringr::str_detect(.x,"DE|SERVICE|WEAR|LIFE")) %>%
  unique()%>%
  enframe(name = "position", value = "family_name")

bike_family_tbl




bike_category_tbl <- url_home %>%
  html_nodes(css = ".megamenu__item> a") %>%
  html_attr('href')%>% 
  enframe(name = "position", value = "subdirectory")%>%
  mutate(
    url = glue("https://www.radon-bikes.de{subdirectory}bikegrid")
  )

bike_category_tbl


bike_category_url <- bike_category_tbl$url[2]


html_bike_category  <- read_html(bike_category_url)
bike_url_tbl        <- html_bike_category %>%
  
  html_nodes(css = ".m-bikegrid__item > a") %>%
  html_attr("href") %>%
  enframe(name = "position", value = "category_url")%>%
  mutate(
  url = glue("https://www.radon-bikes.de{category_url}")
      )
bike_url_tbl 




bike_price_tbl <- html_bike_category %>%
  html_nodes('.m-bikegrid__price.currency_eur .m-bikegrid__price--active')%>%
  html_text()%>%
  enframe(name = "position", value = "price")

bike_price_tbl

bike_title_tbl <- html_bike_category %>%
  html_nodes('.m-bikegrid__info .a-heading--small')%>%
  html_text()%>%
  enframe(name = "position", value = "title")

bike_title_tbl



bike_tbl1 <- merge(x = bike_title_tbl, y = bike_price_tbl, by = "position")
bike_tbl2 <- merge(x = bike_tbl1, y = bike_url_tbl, by = "position")




bike_tbl2 %>% 
  select(-position)


bike_tbl2

# match wish with dictionary
extract_keywords <- function(entry) {
  clauses <- entry[[1]]
  sapply(clauses, function(x){strsplit(x,split = " ")})
}

get_num_matches <- function(token, tokenized_wish_set) {
  sum(tokenized_wish_set %in% sets::as.set(token))
}

# dictionary
dictionary <- list(
  list( c("rotate x-axis labels 90 degree","rotated x-axis label 90 degrees","rotation x-axis label", "vertical x-axis labels"),
        "theme(axis.text.x = element_text(angle = 90))"),
  list ( c("x-axis bold","x-axis boldface") , "theme(axis.text.x = element_text(face = \"bold\"))"),
  list ( c("switch axes","switch x-axis y-axis","flip axes","flip x-axis y-axis","flip coordinates"), "coord_flip()"),
  #  list ( c("remove hide legend *title")," theme(legend. title = element_blank()) "),
  list ( c("remove hide legend"),"theme(legend.position = \"none\")"),
  list(c("x-axis log logarithmic scale"),"scale_x_log10()"),
  list(c("y-axis log logarithmic scale"),"scale_y_log10()"),
  list(c("increase larger double twice font size x-axis"),"theme(axis.title.x=element_text(size=rel(2)))"),
  list(c("reduce half smaller font size x-axis"),"theme(axis.title.x=element_text(size=rel(.5)))")

)

# test case
#    wish <- "I want my x-axis to be rotated"
#wish <- "make my x-axis show in boldface"

#' @export
gghelp <- function(wish="", print=TRUE) {


  # make the wish lower-case
  wish <- tolower(wish)

  # some replacements before tokenizing
  wish<-gsub("x.axis","x-axis", wish)
  wish<-gsub("y.axis","y-axis", wish)
  wish<-gsub("°"," degrees", wish)
  wish<-gsub("!|\\.|\\?|;", "", wish)

  # tokenize wish
  tokenized_wish <- strsplit(wish, " ")[[1]]
  tokenized_wish_set <- sets::as.set(tokenized_wish)

  # tokenize keywords (list of list of vector of character)
  # depth 1 (list) corresponds to the topic
  # depth 2 (list) corresponds to the question that matches the topic
  # depth 3 (vector) corresponds to the keywords of the question
  tokenized_keywords <- lapply(dictionary, extract_keywords)

  # matches
  vector_of_matches <- sapply(tokenized_keywords, function(topic) {
    x <- lapply(topic, get_num_matches, tokenized_wish_set=tokenized_wish_set)
    max(simplify2array(x))
  })

  total_matches <- sum(vector_of_matches)
  if ((total_matches) == 0) {
    warning("There were no matches!")
    return(NULL)
  }

  best_match_index <- which.max(vector_of_matches)

  if (vector_of_matches[best_match_index]==1) {
    warning("No clear match found!")
    return(NULL)
  }

  result <- dictionary[[best_match_index]][[2]]

  if (print)
    cat(result)

  invisible(result)

}

#' @export
gg_ <- function(wish=NULL, ...) {
  x <- eval(parse(text=gghelp(wish=wish, print=FALSE)))
  return(x)
}


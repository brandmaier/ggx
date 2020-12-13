# match wish with dictionary
#
# @param entry Character. String to split.
# @return vector of keywords
#
extract_keywords <- function(entry) {
  clauses <- entry[[1]]
  sapply(clauses, function(x){strsplit(x,split = " ")})
}

get_num_matches <- function(token, tokenized_wish_set) {
  sum(tokenized_wish_set %in% sets::as.set(token))
}

# dictionary
dictionary <- list(
  list( c("rotation x-axis label", "vertical x-axis labels"),
        "theme(axis.text.x = element_text(angle = 90))"),
  list( c("rotate x-axis labels #number# degree","rotated x-axis label #number# degrees"),
        "theme(axis.text.x = element_text(angle = #number#))"),

  list( c("rotation y-axis label", "vertical y-axis labels"),
        "theme(axis.text.y = element_text(angle = 90))"),
  list( c("rotate y-axis labels #number# degree","rotated y-axis label #number# degrees"),
        "theme(axis.text.y = element_text(angle = #number#))"),

  list ( c("x-axis bold","x-axis boldface") , "theme(axis.text.x = element_text(face = \"bold\"))"),
  list ( c("y-axis bold","y-axis boldface") , "theme(axis.text.y = element_text(face = \"bold\"))"),
  list ( c("switch axes","switch x-axis y-axis","flip axes","flip x-axis y-axis","flip coordinates"), "coord_flip()"),
  #  list ( c("remove hide legend *title")," theme(legend. title = element_blank()) "),
  list ( c("remove hide rid lose legend"),"theme(legend.position = \"none\")"),
  list(c("x-axis log logarithmic scale"),"scale_x_log10()"),
  list(c("y-axis log logarithmic scale"),"scale_y_log10()"),
  list(c("center title"),"theme(plot.title = element_text(hjust = 0.5))"),
  list(c("move change set legend bottom","theme(legend.position=\"bottom\")")),
  list(c("move change set legend position right","theme(legend.position=\"right\")")),
  list(c("move change set legend position left","theme(legend.position=\"left\")")),
  list(c("move change set legend position top","theme(legend.position=\"top\")")),
  list(c("increase larger double twice font size x-axis"),"theme(axis.title.x=element_text(size=rel(2)))"),
  list(c("reduce half smaller font size x-axis"),"theme(axis.title.x=element_text(size=rel(.5)))"),
  list(c("increase larger double twice font size y-axis"),"theme(axis.title.y=element_text(size=rel(2)))"),
  list(c("reduce half smaller font size y-axis"),"theme(axis.title.y=element_text(size=rel(.5)))"),
  list(c("remove shape legend", "scale_shape(guide=FALSE)")),
  list(c("remove size legend", "scale_shape(guide=FALSE)")),
  list(c("set legend font size #number#"),"theme(legend.text=element_text(size=#number#))"),
  list(c("set title font size #number#"),"theme(title=element_text(size=#number#))"),
  list(c("set legend title font size #number#"),"theme(legend.title=element_text(size=#number#))"),
  list(c("set paint font color title #color#"), "theme(plot.title=element_text(color='#color#'))"),
  list(c("set paint font color label x-axis #color#"), "theme(axis.title.x=element_text(color='#color#'))"),
  list(c("set paint font color label y-axis #color#"), "theme(axis.title.y=element_text(color='#color#'))"),

  list(c("remove plot margin"),"theme(plot.margin = unit(c(0,0, 0, 0), \"npc\"))"),

  list(c("set title #quote#"),"ggtitle(#quote#)"),
  list(c("set x-axis label #quote#"),"xlab(#quote#)"),
  list(c("set y-axis label #quote#"),"ylab(#quote#)"),

  list(c("meaning of the universe life","geom_label(label=\"42\")"))

)

#' Helps you find a ggplot command for formatting the plot.
#'
#' @param wish Character. A natural language command to ggplot2.
#' @param print Boolean. Print out the command or just return it.
#
#' @export
gghelp <- function(wish="", print=TRUE) {

  # parse numbers
  number_matches <- as.numeric(unlist(
    regmatches(wish, gregexpr("[[:digit:]]+", wish))
  ))

  # replace numbers by generic token
  wish <- gsub("[[:digit:]]+", "#number#", wish)

  # parse color
  color_regexp <- paste0("(",paste0(colors(),"",collapse="|"),")")
  color_matches <- unlist(
    regmatches(wish, gregexpr(color_regexp, wish))
  )

  # replace color by generic token
  wish <- gsub(color_regexp, "#color#", wish )

  # parse quote
  quote_matches <- unlist(
    regmatches(wish, gregexpr("[\"|'](.*?)[\"|']", wish))
  )

  wish <- gsub("[\"|'](.*?)[\"|']", "#quote#", wish )

  # match target (not yet used)
  targets <- c()
  if (length(grep("x.axis", wish, ignore.case = TRUE)) > 0) targets <- c(targets, "x-axis")
  if (length(grep("y.axis", wish, ignore.case = TRUE)) > 0) targets <- c(targets, "y-axis")
  if (length(grep("legend", wish, ignore.case = TRUE)) > 0) targets <- c(targets, "legend")

  # make the wish lower-case (must come after token extraction to
  # preserve quotes)
  wish <- tolower(wish)

  # some replacements before tokenizing
  wish<-gsub("x.axis","x-axis", wish)
  wish<-gsub("y.axis","y-axis", wish)
  wish<-gsub("°"," degrees", wish)
  wish<-gsub("!|\\.|\\?|;|,", "", wish)

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

  # replace generic token by actual numbers
  if (length(number_matches)>0) {
    result <- gsub("#number#", number_matches[1], result)
  }

  # replace generic token by actual color
  if (length(color_matches)>0) {
    result <- gsub("#color#", color_matches[1], result)
  }

  # replace generic token by actual quote
  if (length(quote_matches)>0) {
    result <- gsub("#quote#", quote_matches[1], result)
  }

  # add some default for unknown tokens. TODO: think of something smarter
  if (result=="theme(axis.text.x = element_text(angle = #number#))") {
    result <- "theme(axis.text.x = element_text(angle = 90)"
  }

  if (print)
    cat(result)

  invisible(result)

}

#' Generic command to transform a query in natural language
#' into a ggplot2 command.
#'
#' @param wish Character.
#'
#' @export
gg_ <- function(wish=NULL, ...) {
  x <- eval(parse(text=gghelp(wish=wish, print=FALSE)))
  return(x)
}


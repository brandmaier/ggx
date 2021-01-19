# match query with dictionary
#
# @param entry Character. String to split.
# @return vector of keywords
#
extract_keywords <- function(entry) {
  clauses <- entry[[1]]
  sapply(clauses, function(x){strsplit(x,split = " ")})
}

#
# returns the number of matches of tokens in the set
#
get_num_matches <- function(token, tokenized_query_set) {
  sum(tokenized_query_set %in% sets::as.set(token))
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

#' Converts a natural language query into a 'ggplot2' command.
#'
#' @description Converts a natural language query into a 'ggplot2' command string. Queries should be related to the styling of the plot, such as, axis label font size, axis label title, legend, and similar.
#'
#' @param query Character. A natural language command related to the styling of a ggplot.
#' @param print Boolean. Print out the command or just return it.
#'
#' @return Returns a string if there is a matching ggplot command in the database. Otherwise returns NULL.
#'
#' @examples
#'
#' gghelp("rotate x-axis labels by 90 degrees")
#'
#' gghelp("increase font size on x-axis label")
#'
#' gghelp("set x-axis label to 'Length of Sepal'")
#'
#'
#' @details 'gghelp' maintains a database of keywords that match typical queries related to styling
#' 'ggplot2' graphs. Based on the users natural language query, the function tries to find the best match
#' and then returns the ggplot2 command as string.
#'
#' @seealso \code{\link{gg_}}
#'
#' @export
gghelp <- function(query="", print=TRUE) {

  if (!is.character(query)) { stop("Only character input is valid") }

  # parse numbers
  number_matches <- as.numeric(unlist(
    regmatches(query, gregexpr("[[:digit:]]+", query))
  ))

  # replace numbers by generic token
  query <- gsub("[[:digit:]]+", "#number#", query)

  # parse color
  color_regexp <- paste0("(",paste0(grDevices::colors(),"",collapse="|"),")")
  color_matches <- unlist(
    regmatches(query, gregexpr(color_regexp, query))
  )

  # replace color by generic token
  query <- gsub(color_regexp, "#color#", query )

  # parse quote
  quote_matches <- unlist(
    regmatches(query, gregexpr("[\"|'](.*?)[\"|']", query))
  )

  query <- gsub("[\"|'](.*?)[\"|']", "#quote#", query )

  # match target (not yet used)
  targets <- c()
  if (length(grep("x.axis", query, ignore.case = TRUE)) > 0) targets <- c(targets, "x-axis")
  if (length(grep("y.axis", query, ignore.case = TRUE)) > 0) targets <- c(targets, "y-axis")
  if (length(grep("legend", query, ignore.case = TRUE)) > 0) targets <- c(targets, "legend")

  # make the query lower-case (must come after token extraction to
  # preserve quotes)
  query <- tolower(query)

  # some replacements before tokenizing
  query<-gsub("x.axis","x-axis", query)
  query<-gsub("y.axis","y-axis", query)
  query<-gsub("\u0176"," degrees", query)
  query<-gsub("!|\\.|\\?|;|,", "", query)

  # tokenize query
  tokenized_query <- strsplit(query, " ")[[1]]
  tokenized_query_set <- sets::as.set(tokenized_query)

  # tokenize keywords (list of list of vector of character)
  # depth 1 (list) corresponds to the topic
  # depth 2 (list) corresponds to the question that matches the topic
  # depth 3 (vector) corresponds to the keywords of the question
  tokenized_keywords <- lapply(dictionary, extract_keywords)

  # matches
  vector_of_matches <- sapply(tokenized_keywords, function(topic) {
    x <- lapply(topic, get_num_matches, tokenized_query_set=tokenized_query_set)
    max(simplify2array(x))
  })

  total_matches <- sum(vector_of_matches)
  if ((total_matches) == 0) {
    warning("There were no matches!")
    return(    invisible(NULL) )
  }

  best_match_index <- which.max(vector_of_matches)

  if (vector_of_matches[best_match_index]==1) {
    warning("No clear match found!")
    return(    invisible(NULL))
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

  # if there are still tokens left
  if ( gregexpr("#number#", result)[[1]][1] > -1 ) {
    warning("There seems to be a number missing in your request.")
    return(    invisible(NULL))
  }
  # if there are still tokens left
  if ( gregexpr("#color#", result)[[1]][1] > -1 ) {
    warning("There seems to be a color missing in your request!")
    return(    invisible(NULL))
  }
  # if there are still tokens left
  if ( gregexpr("#quote#", result)[[1]][1] > -1 ) {
    warning("There seems to be a quoted string missing in your request!")
    return(    invisible(NULL))
  }

  if (print) {
    cat(result, "\n")
  }

  return( invisible(result) )

}

#' @title Transforms a  natural language query into a gg object
#'
#' @description Converts a natural language query into a 'gg' object, which can be directly chained to a 'ggplot'-call. Queries should be related to the styling of the plot, such as, axis label font size, axis label title, legend, and similar.
#'
#'
#' @param query Character. A natural language command related to the styling of a ggplot.
#'
#' @return An object of class 'gg' from the internal class system of 'ggplot2'
#'
#' @examples
#'
#' \dontrun{
#' library(ggplot2)
#' ggplot(data=iris,
#' mapping=aes(x=Sepal.Length,
#'            y=Petal.Length, color=Species))+
#'  geom_point()+
#'  gg_("rotate x-axis labels by 90°")+
#'  gg_("set x-axis label to 'Length of Sepal'")
#'  }
#'
#' @seealso \code{\link{gghelp}}
#'
#' @details 'gg_' calls the function 'gghelp', which maintains a database of keywords that match typical queries related to styling
#' 'ggplot2' graphs. Based on the users natural language query, the function tries to find the best match
#' and then returns the ggplot2 command, such that the result of a call to 'gg_' can be chained directly to a 'ggplot()' call.
#'
#' @export
gg_ <- function(query=NULL) {
  ggresult <- gghelp(query=query, print=FALSE)

  if (is.null(ggresult)) {
    return(NULL)
  } else {
    x <- eval(parse(text=ggresult))
    return(x)
  }

}


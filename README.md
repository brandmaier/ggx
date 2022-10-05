
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggx <img src="man/figures/ggx-hexsticker.png" align="right" width="120" />

[![cran
version](http://www.r-pkg.org/badges/version/ggx)](https://cran.r-project.org/package=ggx)
[![rstudio mirror
downloads](http://cranlogs.r-pkg.org/badges/ggx)](https://github.com/metacran/cranlogs.app)
[![Total downloads
badge](https://cranlogs.r-pkg.org/badges/grand-total/ggx?color=blue)](https://CRAN.R-project.org/ggx)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![contributions](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)
![noAI](https://img.shields.io/badge/no-AI-blue)

## Overview

This package is an add-on to `ggplot2`, the R package for creating
awesome graphics, which is based on [The Grammar of
Graphics](https://amzn.to/2ef1eWp). `ggplot2` has changed my life as a
scientist and developer. However, I have terrible memory and I forget
the same commands again and again. Like, how do you rotate axis labels
again? Or how do you hide the legend…? So I often end up searching the
net for help and then I copy and paste the solution I find into my R
script. And I know at least one more person who does this, too.
Eventually, I wondered whether we couldn’t save this extra step and just
*talk* to ggplot in natural language (similar to a Google search query).
So, I wrote this package that lets us issue natural language commands,
which then are translated into ggplot commands. This is very likely
totally bonkers, and this is how it looks (watch the `gg_` commands
below):

``` r
ggplot(data=cars,aes(x=speed, y=dist))+geom_point()+
  gg_("rotate x-axis labels by 90 degrees")+
  gg_("increase font size on x-axis label")
```

<img src="man/figures/README-overview_usage-1.png" width="50%" />

## Disclaimer

I am pretty sure that this package violates fundamental principles of
ggplot2. First and foremost, it would be much wiser to just study and
learn the respective commands instead of relying on fuzzy and not
well-defined natural language commands. Second, this package doesn’t
rely on fancy deep learning or other AI technology. It’s a simple
keyword matching algorithm. If someone fancies to replace this with a
better approach, please do so. Contributions to this package are more
then welcome!

## Installation

Either install the latest stable version from CRAN:

``` r
install.packages("ggx")
```

Or, install the development version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("brandmaier/ggx")
```

## Usage Examples

You can find more examples and use cases on the package website:
[here](https://brandmaier.github.io/ggx/) This package has two basic
modes of operations. Either you use the `gg_(...)` command to generate
ggplot2 elements from natural language and chain them directly to your
plotting commands (for lazy people), or you use the package as a
reminder of the command and let the package print out the command, which
you then copy and paste to your code (safer option). In the following, I
will give you a few examples of how the package could be used. Assume,
we start off with basic 2D plot of Fisher’s classic iris data:

``` r
ggplot(data=iris, 
       mapping=aes(x=Sepal.Length, 
                  y=Petal.Length, color=Species))+
  geom_point()
```

<img src="man/figures/README-example_basic-1.png" width="50%" />

Now, if we want to hide the legend and don’t remember the ggplot command
to do so, we can use the `gg_()` short-hand to express our request in
natural language:

``` r
ggplot(data=iris, 
       mapping=aes(x=Sepal.Length, 
                  y=Petal.Length, color=Species))+
  geom_point()+
  gg_("hide legend")
```

<img src="man/figures/README-example_hide_legend-1.png" width="50%" />

Or, say we want to rotate the labels of the x axis and rename the axis
label:

``` r
ggplot(data=iris, 
       mapping=aes(x=Sepal.Length, 
                  y=Petal.Length, color=Species))+
  geom_point()+
  gg_("rotate x-axis labels by 90°")+
  gg_("set x-axis label to 'Length of Sepal'")
```

<img src="man/figures/README-example_rotate_labels-1.png" width="50%" />

Or,

``` r
ggplot(data=iris, 
       mapping=aes(x=Sepal.Length, 
                  y=Petal.Length, color=Species))+
  geom_point()+
  gg_("double the font size on the x-axis label")
```

<img src="man/figures/README-example_increase_fontsize-1.png" width="50%" />

Or,

``` r
ggplot(data=iris, 
       mapping=aes(x=Sepal.Length, 
                  y=Petal.Length, color=Species))+
  geom_point()+
  gg_("add 'Hello World' as plot title")+
  gg_("paint the plot title in a beautiful orange")+
  gg_("set the color of the x-axis label to blue")
```

<img src="man/figures/README-example_fontcolor-1.png" width="50%" />

If you want to go the safer route, just use the `ggx` package as
personal assistant that helps you find solutions to common graph
formatting problems, like in the following:

``` r
gghelp("How can I hide the graph legend?")
#> theme(legend.position = "none")
```

Or,

``` r
gghelp("I want to flip my x-axis and y-axis.")
#> coord_flip()
```

Or,

``` r
gghelp("How can I increase the font size on the x axis?")
#> theme(axis.title.x=element_text(size=rel(2)))
```

Since `ggx` is matching keywords, it allows for some variation in how
the question is put:

``` r
gghelp("I want to remove my plot legend")
#> theme(legend.position = "none")
gghelp("Please hide the legend")
#> theme(legend.position = "none")
gghelp("Get rid of that stupid legend")
#> theme(legend.position = "none")
```

Colors and numbers are parsed and inserted into the final commands:

``` r
gghelp("Rotate the x-axis labels by 56 degrees")
#> theme(axis.text.x = element_text(angle = 56))

gghelp("Paint the label of the y-axis in green")
#> theme(axis.title.y=element_text(color='green'))
```

## Other Solutions

There is a nice little package called
[ggeasy](https://jonocarroll.github.io/ggeasy/) that addresses the same
problem. However, it defines yet another set of commands, like this:

``` r
# rotate x axis labels
ggplot(mtcars, aes(hp, mpg)) + 
    geom_point() + 
    easy_rotate_x_labels()
```

But I keep forgetting those, too ;)

## Disclaimer (continued)

This package is just a quick and dirty implementation of a keyword
matching algorithm. Do not expect any deeper language processing.
Neither is this program a therapist (see Eliza or others). Also, the
program doesn’t aim for completeness. It just knows a couple of commands
that I tend to forget. Don’t be mad if you hate the package. Just ignore
it and write beautiful ggplot code without it. If you like the package,
think about contributing to it. Add more questions, keywords, etc. I
welcome any contribution, preferably via pull requests on github.

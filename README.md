<!-- README.md is generated from README.Rmd. Please edit that file -->

    ## Warning: replacing previous import 'vctrs::data_frame' by 'tibble::data_frame'
    ## when loading 'dplyr'

ggx <img src="man/figures/logo.png" align="right" width="120" />
================================================================

Overview
--------

`ggplot2` is an R packag for creating awesome graphics, based on [The
Grammar of Graphics](https://amzn.to/2ef1eWp). It has changed my life as
a scientist and developer but I have a terrible memory. With the
complexity of `ggplot2`, I forget the same commands again and again. So
I ended up googling what I wanted to do and then I copy and paste the
solution to my programme. So, I wondered whether we couldn’t save this
extra step and just *talk* to ggplot in natural language (similar to a
Google search query). So, I wrote this package that let’s you issue
natural language commands that are translated into ggplot commands. This
is how it looks:

Disclaimer
----------

I am pretty sure that this package violates fundamental principles of
ggplot2. First and foremost, it would be much wiser to just study and
learn the respective commands instead of relying on fuzzy and not
well-defined natural language commands. Second, this package doesn’t
rely on fancy deep learning or other AI technology. It’s a simple
keyword matching algorithm. If someone fancies to replace this with a
better approach, please do so. Contributions to this package are more
then welcome!

Installation
------------

    # Install the development version from GitHub:
    # install.packages("devtools")
    devtools::install_github("brandmaier/ggx")

Usage Examples
--------------

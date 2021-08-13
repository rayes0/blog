---
title: "Media Tracking with Recommendations in Org-mode"
date: 2021-06-24T19:02:37-06:00
tags:
- emacs/elisp
- machine learning
- data science
- anime
- manga
- literature
categories:
- Statistics
status:
- inprogress
draft: true
---

This is an attempt at a hybrid recommendation system from powered by Elisp in Org mode. It uses a combination of popularity, nearest neighbour, and matrix factorization to make a couple initial predictions. It will then use a trained machine learning model tailored from the users past ratings to predict possible media series that the user is most likely to enjoy.

# The Tracker

A quick rundown of the system I've been using to track my reading, manga, and anime list. For the most part because I don't want to sign up for a proprietary tracker service (like Goodreads, MAL or Anilist). Also, with Org-mode I have the flexibility of custom todo keywords for fine tune tracking, as well as access to [an](https://orgmode.org/worg/dev/org-element-api.html) [amazing](https://orgmode.org/manual/Using-the-Property-API.html) [set](https://orgmode.org/manual/Using-the-Mapping-API.html#Using-the-Mapping-API) of Elisp API's to parse and make meaning of the data.

I use a single org file with todo keywords for tracking progress. Org-babel is utilized to execute lisp code for grabbing stats. The file looks something like this:

{{< figure src="/img/media-recs/overview.png" >}}

The following custom todo keywords are defined at the top of the file: `#+TODO: MAYBE PLANNED IMPROGRESS STALLED | FINISHED DROPPED`. These are pretty self-explanatory for the most part:
  - The task keywords:
    - `MAYBE`: I am considering starting the series
    - `PLANNED`: I've committed to starting the series
    - `INPROGRESS`: I am currently reading/watching the series
    - `STALLED`: I have started the series but aren't currently actively reading it. This could be for various reasons such as waiting for the next season to come out, or losing interest and considering dropping it.
  - The done keywords:
    - `FINISHED`: Series that I have finished
    - `DROPPED`: Series that I have dropped

I keep this file out of my `org-agenda-files` so that the series don't show up in my todo list.

I organize the series by header. Here is the structure, with each category containing some sample series with an org todo keyword for demonstration:

```org
#+TITLE: Media
#+startup: fold content customtime
#+options: todo:f h:3 p:f
#+todo: MAYBE PLANNED INPROGRESS STALLED | FINISHED DROPPED

* In Progress
  ** Books
        ***** INPROGRESS The Testaments, Margaret Atwood
      *** Light Novels
        ***** INPROGRESS Toradora [5/9]
            - [X] Vol 1
            - [X] Vol 2
            - [X] Vol 3
            - [X] Vol 4
            - [X] Vol 5
            - [ ] Vol 6
            - [ ] Vol 7
            - [ ] Vol 8
            - [ ] Vol 9
  ** Manga
      ***** INPROGRESS Tonikaku Kawaii [13/20] ⬎
  ** Anime
* Finished
  ** Books
      *** Fiction
          **** FINISHED The Handmaid's Tale, Margaret Atwood
      *** Non-Fiction
          **** FINISHED The Wisdom of Crowds, James Surowiecki
  ** Manga
      *** FINISHED Horimiya
  ** Anime
      *** FINISHED Hyouka
```

Things to note:

- The export options: `todo:f h:3`. This makes org not export the todo keywords, and also sets the maximum heading level to 3 (before headings become lists). This means that all the headings for titles under [In Progress become lists](/media/in-progress).
- `#+startup: customtime`. This makes Org use a custom time stamp format stored in `org-time-stamp-custom-formats`. I use this because I don't want the precise time to also be exported, just the date.
- The [statistics cookies](https://orgmode.org/manual/Breaking-Down-Tasks.html) ([13/30], [5/9]). They keep track of the number of checkboxes and tasks under a header. This is useful for seeing the progress on series with multiple volumes. They are exported to HTML surrounded by `<code>` tags (check [the page](/media/in-progress)).
- For each finished series, I write a [short summary and some thoughts](/media/finished) under the header. I also log the date I finish the series by marking a timestamp (C-c .), and find one interesting quote from the series and surround it with `#+begin_quote` and `#+end_quote`.

## Stats

For some very basic stats such as the number of series in each category, I have the following org source code block, which contains an elisp macro that is run for each of the keywords:

```org
#+name: Table
#+begin_src elisp :colnames '("Status" "Number")
(require 'org)
(defmacro media/count (keyword)
  (length
   (org-map-entries nil (concat "/+" keyword) 'file)))
(let* ((planned (media/count "PLANNED"))
       (maybe (media/count "MAYBE"))
       (inprog (media/count "INPROGRESS"))
       (stalled (media/count "STALLED"))
       (dropped (media/count "DROPPED"))
       (finished (media/count "FINISHED"))
       (unfinished (media/count "PLANNED|INPROGRESS|STALLED"))
       (all (media/count "PLANNED|INPROGRESS|STALLED|MAYBE|DROPPED|FINISHED")))
  (list (list "Considering" maybe)
        (list "Planned" planned)
        (list "Reading" inprog)
        (list "Stalled" stalled)
        (list "Dropped" dropped)
        (list "Unfinished" unfinished)
        (list "Finished" finished)
        (list "All Tracked" all))))
#+end_src
```

What this does is parse the org tree and get the number of items with each keyword. It also gets the total number of items with all the keywords, which is needed instead of just getting the total number of headings as some headings are purely for organization purposes and don't contain series (like the 'Manga', 'Light Novel', and 'Anime' headings).

Now if we run `M-x org-babel-execute-src-block` with our cursor inside the code block (shortcut `C-c C-c`), emacs will run this code and output the following org table:

```org
#+RESULTS: Table
| Status      | Number |
|-------------+--------|
| Considering |     26 |
| Planned     |     16 |
| Reading     |     10 |
| Stalled     |     18 |
| Dropped     |      3 |
| Unfinished  |     44 |
| Finished    |     42 |
| All Tracked |    115 |
```

This is pretty nice, we have the number of series in each category. If we want, org can do some basic bar-like graphing with ASCII. Just put your cursor in the "Number" column of the table and run `M-x orgtbl-ascii-draw`, which will create a new column with some ASCII characters.

We can go one step further and use [org-babel-gnuplot](https://orgmode.org/worg/org-contrib/babel/languages/ob-doc-gnuplot.html) to graph the results into a meaningful format, such as a bar graph. We do this by adding the following line above the results section:

```org
#+PLOT: title:"Series" ind:1 type:2d with:"boxes ls 1" set:"boxwidth 0.5 transparent" set:"style fill solid" set:"style line 1 lc rgbcolor 'gray'" set:"xtics font ',8'" set:"ytics font ',8'" set:"terminal png size 600,400" file:"/tmp/mediaout.png"
```

Now with our cursor somewhere in the results section, if we run `M-x org-plot/gnuplot`, or use the shortcut `C-c " g` This will create a 600px by 400px image at `/tmp/mediaout.png`. Of course, you can edit this line and change the path or to get the look of the graph you wish for. We can add the image to the org file like any other image:

```org
[[/tmp/mediaout.png]]
```

And then we can run `M-x org-display-inline-images` to show the graph image inline (assuming your build of emacs has png support). The graph will look something like this:

{{< figure src="/img/media-recs/graph.png" >}}

# Creating the Recommendation Engine

We will firstly implement some basic AI-free methods for getting *general* recommendations. These will not be very personalized and won't be too accurate either. Later, we will create and train a machine learning model that will give us personalized, content-based recommendations based on our past reviews and data scraped from review sites.

## Popularity-based Recommendations

We will first use the easiest and most basic form of content recommendation, one based purely on the popularity of the series. We will use API's from a couple large review and database websites to determine the series that are currently popular, simply meaning the ones that have the most positive reviews within our selected period of time.


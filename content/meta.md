---
title: "Meta"
author: ["Jialu Fu"]
date: 2021-07-29
publishDate: 2021-07-30
draft: false
toc: false
special_letter: false
auto_summary_style: false
---

Meta page of various links to other content on this site.


# Media {#media}

A collection of books and shows I have finished reading/watching since the file creation date (August 2021). They are generated from my [personal media Org mode file](https://raw.githubusercontent.com/rayes0/blog/master/content-org/media-list.org).

-   [Media](/media)
    -   [Books](/media#books)
    -   [Manga](/media#manga)
    -   [Anime](/media#anime)


# Notes {#notes}

-   [Basics of Machine Learning](/notes/machine-learning) (unfinished)


# Other {#other}

-   [Tea journal](/tea)
-   [anemoia webnovel](/anemoia) (not currently updating, see [here](/about#writing))


# Feeds {#feeds}

A list of RSS and Atom feeds I am subscribed to. Just because a site is on here doesn't necessarily mean I endorse or agree with the content on it, it just means I want to keep up to date with it. I use newsticker (feed reader built into Emacs) to manage my feeds:

```elisp
(setq newsticker-url-list
    '(("arXiv q-bio" "https://arxiv.org/rss/q-bio")
      ("bioRxiv" "https://connect.biorxiv.org/biorxiv_xml.php?subject=all")
      ("medRxiv" "https://connect.medrxiv.org/medrxiv_xml.php?subject=all")
      ("arXiv math" "https://arxiv.org/rss/math")
      ("Terence Tao" "https://terrytao.wordpress.com/feed/")
      ("LessWrong" "https://www.lesswrong.com/feed.xml?view=community-rss&karmaThreshold=45")
      ("Astral Codex Ten" "https://astralcodexten.substack.com/feed")
      ("Scott Aaronson" "https://scottaaronson.blog/?feed=rss2")
      ("Zvi" "https://thezvi.wordpress.com/feed")
      ("Fantastic Anachronism" "https://fantasticanachronism.com/atom.xml")
      ("Hands and Cities" "https://handsandcities.com/feed/")
      ("Strange Loop Canon" "https://www.strangeloopcanon.com/feed")
      ("Protesilaos Blog" "https://protesilaos.com/master.xml")
      ("Gwern.net Newsletter" "https://gwern.substack.com/feed" nil 86400)
      ("Suspended Reason" "https://suspendedreason.com/feed" nil 86400)
      ("Melting Asphalt" "https://meltingasphalt.com/feed")
      ("nearcyan" "https://nearcyan.com/feed")
      ("For me, in full bloom" "https://formeinfullbloom.wordpress.com/feed/" nil 86400)
      ("Therefore it is" "https://thereforeitis.wordpress.com/feed" nil 86400)
      ("Wrong Every Time" "https://wrongeverytime.com/feed" nil 86400)
      ("Sakuga Blog" "https://blog.sakugabooru.com/feed/")
      ("ANN" "https://www.animenewsnetwork.com/all/rss.xml?ann-edition=us")
      ("R Weekly" "https://rweekly.org/atom.xml" nil 86400)
      ("GNOME Blogs" "https://blogs.gnome.org/feed/")
      ("Drew Devault" "https://drewdevault.com/blog/index.xml" nil 86400)
      ("Freedom To Tinker" "https://freedom-to-tinker.com/feed/rss/" nil 86400)
      ("Lennart Poettering" "https://0pointer.net/blog/index.rss20")
      ("LWN" "https://lwn.net/headlines/rss")
      ("XKCD" "https://xkcd.com/rss.xml")
      ("wingolog" "https://wingolog.org/feed/atom")))
```
---
title: "A Search for the Best Spaced Learning Algorithm"
date: 2021-05-23T12:16:00-06:00
tags:
- memory
- productivity
- machine learning
- data science
categories:
- Psychology
status:
- inprogress
katex: true
draft: true
---

Spaced repetition is an [evidence-based learning](https://en.wikipedia.org/wiki/Evidence-based_learning) technique which utilizes the [spacing effect](https://en.wikipedia.org/wiki/Spacing_effect). In contrast to more traditional repetition-based learning strategies such as cramming in which the main focus is on the total number of repetitions, spaced repetition is timing-based and focuses on maximizing efficiency by doing repetitions at scheduled times (typically decided by the difficulty of the material). Numerous studies have been conducted on spaced repetition (and on memory in general), and there is strong evidence suggesting that spaced repetition decreases the number of needed repetitions, and improves retention significantly over the long term. This article attempts to divulge into the specifics of spaced repetition implementations and the existing algorithms implemented in popular software like Anki, SuperMemo, Duolingo, and Quizlet. I will also share some general ideas and observations from the point of view of a daily user of spaced repetition.

# Memory and the Spacing Effect

Psychologists define two broad types of memory: [declarative]( https://en.wikipedia.org/wiki/Explicit_memory) (conscious) and [non-declarative](https://en.wikipedia.org/wiki/Implicit_memory) (unconscious). Compared to declarative memory, non-declarative memory is slow. However, as we will talk about later, the distinction our minds make between these two are fairly hazy, and we need to be wary of relying purely on our non-declarative memory, meaning that in addition to the timing, the way [the information is presented is also vitally important](https://super-memory.com/articles/20rules.htm). The ideal goal of studying information is to get it into your long term memory for later retrieval. Your short term memory can only recall around 7±2 items for only about a minute after you see them[^1], which isn't very useful other than for real time processing. 

[^1]: [A well-known paper](https://psychclassics.yorku.ca/Miller/) by psychologist George A. Miller argued that the approximate compacity of our working memory is only about 7 items. This is why memory techniques involving extending short term memory compacity aim to reduce the number of items (eg: [chunking](https://en.wikipedia.org/wiki/Chunking_(psychology))) which is required to be held.

# A Quantitative Representation of Memory

Ebbinghaus (from self experiments) proposed an equation for the [forgetting curve](https://en.wikipedia.org/wiki/Forgetting_curve):

{{<tex display="b = \frac{100k}{(\log(t))^c + k}" >}}

Where {{<tex "b" >}} is the percentage of time saved on relearning (same thing as recall probability), {{<tex "t" >}} is the time in minutes, and {{<tex "c" >}} and {{<tex "k" >}} are constants. There are [various reasons](https://supermemo.guru/wiki/Error_of_Ebbinghaus_forgetting_curve) to discredit this specific equation, which I will not go into detail on. A quick summary: Ebbinghaus used nonsense syllables to test himself, which had little real world associations and coherence with past memories, and also measured with a comparatively short time interval of around 2 weeks, while spaced repetition is typically implemented well beyond that time period.

Thus, Ebbinghaus's equation is usually dismissed in favour of one of exponential decay:

{{<tex display="R(t) = e^{\frac{-t}{S}}" >}}

Where {{<tex "R(t)" >}} is the recall probability as a function of {{<tex "t" >}} (time), and {{<tex "S" >}} is the memory stability. The memory stability corresponds to how strong the memory is, specifically how much time it takes for the recall probability to decay to {{<tex "e^{-1}" >}}. This is because when {{<tex "t = S" >}}, then {{<tex "R = e^{-1}" >}}. In oth

This equation seems to make logical sense. Consider the following cases:

1. When {{<tex "t=0" >}}:&ensp;{{<tex "R = e^0 = 1" >}}. This makes sense because {{<tex "t=0" >}} represents the initial retention rate when the item has just been reviewed, which should be 100%.
2. When {{<tex "t >> S" >}} (meaning we have reviewed the item a very long time ago):&ensp;{{<tex "R \approx e^{-\infty} \approx 0" >}} (we have a retention rate of close to 0%).
3. Another idea to consider is that {{<tex "S" >}} is not constant between repetitions of the same item. Each time the item is reviewed, {{<tex "S" >}} should grow because the item becomes more familiar with each repetition. In other words, as we do more and more repetitions, {{<tex "S \to \infty" >}}. When {{<tex "S >> t" >}}, then {{<tex "R \approx e^{0} \approx 1" >}}, which hypothetically means that after infinite repetitions, our recall probability will be 100%.

When dealing with spaced repetition, it makes sense to target a certain recall probability, say 80%.

# Current Implementations

Most of the major implementations of algorithms in popular scheduling software.

- Absolute spacing vs uniform spacing

## Logistic Regression

Used by: [Quizlet](https://medium.com/tech-quizlet/spaced-repetition-for-all-cognitive-science-meets-big-data-in-a-procrastinating-world-59e4d2c8ede1)[^quizlet], [Duolingo](https://aclanthology.org/P16-1174.pdf)

[^quizlet]: Quizlet doesn't implement true spaced repetition because it's designed for cramming, and thus focuses on reviewing higher priority items first. Quizlet does have a 'Long-Term Learning' mode, which appears to follow a fixed formula of `new interval = (old interval * 2) + 1` with new items starting at a 1 day interval. Items answered incorrectly are reset to the same status as new items. Of course, this is less than optimal as the fixed rate multiplier assumes that all material is the same difficulty.

The first thought I had when pondering on algorithms for spaced repetition is using a simple logistic regression classifier (trained on the user's previous data) to output a probability that the user will get the review item right given an input of the time interval. We can use this recall probability in numerous ways, Quizlet uses it to order the items for review (items with lower recall probability are reviewed first).

My thoughts were that the user could choose a desired recall probability (we'll call this the 'recall threshold' for now), which corresponds to the decision threshold of the classifier. A recall threshold of around 80% makes sense (of course, this will vary with different individuals). The algorithm will show the item once the recall threshold for it falls below 80%. In order to accurately predict the recall probability, this classifier would be trained on features based on past couple repetitions (Quizlet uses the past 3). It would check to see if the prior attempts were correct, how quickly they were answered, and how many consecutive attempts were correct, which will all help predict the classifier predict the probability of answering the current attempt correctly. Of course, the difficulty of the material is a large factor (that Quizlet apparently doesn't use), but difficulty is different for different individuals, which is why other algorithms like the SuperMemo family ask the user to rate how easy the item was to answer and uses that rating when considering further intervals. This does require more cognitive load from the user, which can be ameliorated at the cost of accuracy by having the algorithm automatically assign the rating based on factors like the time taken to answer, or at least provide a suggested score based on such factors.

Duolingo models its 'half-life regression' approach very similar to the forgetting curve equation described above.:

{{<tex display="p = 2^{-\Delta / h}" >}}

{{<tex "p" >}} is the probability of recall and has the domain {{<tex "0 < p \le 1" >}}. {{<tex "\Delta" >}} is the time since the item was last reviewed, and {{<tex "h" >}} is the *half life* corresponding to the learner's memory strength. The value of this is hoped to correspond with the amount of time it takes the learner to forget half of the material (or a recall probability of 50%). This is because when {{<tex "\Delta = h" >}}, the equation evaluates to {{<tex "p = 2^{-1} = 0.5" >}}.

## SM2

Used by: [Anki](https://faqs.ankiweb.net/what-spaced-repetition-algorithm.html), [Mnemosyne](https://mnemosyne-proj.org/help/memory-research), Wanikani

Reference: [SM2](https://www.supermemo.com/en/archives1990-2015/english/ol/sm2) (P.A.Wozniak, May 10, 1998)

Probably the most popular implementation of spaced repetition. In the algorithm, each review item is associated with an ease factor, which we hope to correspond to the difficulty of the review item. The original implementation consists of two initial hard coded learning phase steps: 1 day, and 6 days.

A fairly simple formula is used to calculate subsequent intervals:

```
New interval = Previous interval * Ease factor
```

The ease factor is simply a floating point number between 1.3 and 2.5. It's role, as seen in the formula, is to act as an interval multiplier leading to a larger and larger interval each time. The restrictions of 1.3 through 2.5 attempt to keep the number of repetitions reasonable. An ease below 1.3 will lead to the material being studied too often (usually indicative not because the knowledge itself is too difficult, but because it is poorly formatted or presented), and anything greater than 2.5 will space the intervals too much, especially as they get larger.

```
sdf
```

# Ebisu

## Neural Networks

# Further Reading

Studies, articles, and links I read (or at least skimmed) when researching the topic.

- [*Memory: A Contribution to Experimental Psychology*](https://psychclassics.yorku.ca/Ebbinghaus/index.htm) (H. Ebbinghaus. 1885)
- *The Precise Time Course of Retention* (D. Rubin, S. Hinton, and A. Wenzel, 1999) *cough, [scihub link](https://sci-hub.se/10.1037/0278-7393.25.5.1161)
- [*Improving Students’ Learning With Effective Learning Techniques: Promising Directions From Cognitive and  Educational Psychology*](https://pcl.sitehost.iu.edu/rgoldsto/courses/dunloskyimprovinglearning.pdf) (J. Dunlosky et al, 2013)

**Implementations**

- [Anki's algorithm](https://faqs.ankiweb.net/what-spaced-repetition-algorithm.html)
- Duolingo's algorithm: [*A Trainable Spaced Repetition Model for Language Learning*](https://aclanthology.org/P16-1174.pdf) (B. Settles and B. Mender. 2016)
- [Ebisu](https://github.com/fasiha/ebisu)
- [Memrise's algorithm](https://memrise.zendesk.com/hc/en-us/articles/360015889057-How-does-the-spaced-repetition-system-work-)
- [Quizlet's algorithm](https://medium.com/tech-quizlet/spaced-repetition-for-all-cognitive-science-meets-big-data-in-a-procrastinating-world-59e4d2c8ede1)
- SuperMemo-based (only major versions):
  - SM-0
  - SM-2 (1987)
  - [SM-5](https://supermemo.guru/wiki/First_fast-converging_spaced_repetition_algorithm:_Algorithm_SM-5) (1989)
  - [SM-8](https://supermemo.guru/wiki/First_data-driven_spaced_repetition_algorithm:_Algorithm_SM-8) (1995)
  - [SM-15](https://supermemo.guru/wiki/Algorithm_SM-15) (2013)
  - [SM-17](https://supermemo.guru/wiki/Algorithm_SM-17) (2016)
  - [SM-18](https://supermemo.guru/wiki/Algorithm_SM-18) (2020)
  - Other SuperMemo resources:
    - [Incremental Reading](https://supermemo.guru/wiki/History_of_incremental_reading) (2000)
    - [Comprehensive history of SuperMemo](https://www.supermemo.com/en/articles/history)
    - [SuperMemo's history of spaced repetition](https://supermemo.guru/wiki/History_of_spaced_repetition)
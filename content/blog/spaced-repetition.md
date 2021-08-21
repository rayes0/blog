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

# The Spacing Effect

Broadly speaking, there are two types of memory: [declarative]( https://en.wikipedia.org/wiki/Explicit_memory) (conscious) and [non-declarative](https://en.wikipedia.org/wiki/Implicit_memory) (unconscious). Compared to declarative memory, non-declarative memory is slow. However, the distinction our minds make between these two are fairly hazy, and we need to be wary of relying purely on our non-declarative memory, meaning that in addition to the timing, the way [the information is presented is also vitally important](https://super-memory.com/articles/20rules.htm). The ideal goal of studying knowledge for an exam, language learning, or similar venture is to get it into your long term memory for later retrieval. Your short term memory can only recall around 7±2 items for only about a minute after you see them[^1], which isn't very useful for anything other than real time processing, or recalling something temporary. 

[^1]: [A well-known paper](https://psychclassics.yorku.ca/Miller/) by psychologist George A. Miller argued that the approximate compacity of our working memory is only about 7 items. This is why memory techniques involving extending short term memory compacity aim to reduce the number of items (eg: [chunking](https://en.wikipedia.org/wiki/Chunking_(psychology))) which is required to be held.



# A Quantitative Representation of Memory

Ebbinghaus (from self experiments) proposed an equation for the [forgetting curve](https://en.wikipedia.org/wiki/Forgetting_curve):

{{<tex display="b = \frac{100k}{(\log(t))^c + k}" >}}

Where {{<tex "b" >}} is the percentage of time saved on relearning (same thing as recall probability), {{<tex "t" >}} is the time in minutes, and {{<tex "c" >}} and {{<tex "k" >}} are constants. There are [various reasons](https://supermemo.guru/wiki/Error_of_Ebbinghaus_forgetting_curve) to discredit this specific equation, which I will not go into detail on. A quick summary: Ebbinghaus used nonsense syllables to test himself, which had little real world associations and coherence with past memories, and also measured with a comparatively short time interval of around 2 weeks, while spaced repetition is typically implemented well beyond that time period.

Thus, Ebbinghaus's equation is usually dismissed in favour of one of exponential decay:

{{<tex display="R(t) = e^{\frac{-t}{S}}" >}}

Where {{<tex "R(t)" >}} is the recall probability as a function of {{<tex "t" >}} (time), and {{<tex "S" >}} is the memory stability. The memory stability corresponds to how strong the memory is, specifically how much time it takes for the recall probability to decay to {{<tex "e^{-1}" >}}. This is because when {{<tex "t = S" >}}, then {{<tex "R(t) = e^{-1}" >}}.

This equation seems to make logical sense. Consider the following cases:

1. When {{<tex "t=0" >}}:&ensp;{{<tex "R(0) = e^0 = 1" >}}. This makes sense because {{<tex "t=0" >}} represents the initial retention rate when the item has just been reviewed, which should be 100%.
2. When {{<tex "t >> S" >}} (meaning we have reviewed the item a very long time ago):&ensp;{{<tex "R(t) \approx e^{-\infty} \approx 0" >}} (we have a retention rate of close to 0%).
3. Another idea to consider is that {{<tex "S" >}} is not constant between repetitions of the same item. Each time the item is reviewed, {{<tex "S" >}} should grow because the item becomes more familiar with each repetition. Moreover, {{<tex "S" >}} appears to increase at an exponential rate. In other words, as we do more and more repetitions, {{<tex "S \to \infty" >}}, and when {{<tex "S >> t" >}}, then {{<tex "R(t) \approx e^{0} \approx 1" >}}. This hypothetically means that after infinite repetitions, our recall probability will be 100%.

Looking at the equation, this means that in order to accurately predict the recall probability, the main hurdle is finding an accurate value for {{<tex "S" >}}. The time {{<tex "t" >}}, is easy to measure. As for the base number, we have chosen {{<tex "e" >}} in this case, although the precise number doesn't matter too much. As long as it is positive and greater than 1, we can just vary the {{<tex "S" >}} variable to get the curve we want.

The value of {{<tex "S" >}} (memory strength) is hard to predict and is influenced by a multitude of factors. Here are some I can think of from the top of my head, ranked from easiest to hardest to measure (from the algorithm's perspective):

- Past reviews and performance on the same item, if the item was seen previously
- Difficulty of the material (subjective to individual differences)
- Format. How the material is presented.
- Previous experience and associations. More experience with similar material in the past will make future review easier. Also the degree of initial learning ([Loftus, 1985](https://faculty.washington.edu/gloftus/Downloads/LoftusForgettingCurves.pdf))
- The current psychological and physical state of the user. Things like emotional disposition ([Gumora & Arsenio, 2002](https://www.sciencedirect.com/science/article/pii/S0022440502001085)[^arsenio]) or consumption of caffiene ([Cole, 2014](https://link.springer.com/article/10.1007/s11325-014-0976-y)[^cole]). Sleep ([Mirghani et al, 2015](https://bmcresnotes.biomedcentral.com/articles/10.1186/s13104-015-1712-9)) especially seems to have large effects on memory strength. Motivation is obviously also a large factor.

[^arsenio]: \**cough*, [scihub link](https://sci-hub.se/10.1016/S0022-4405(02)00108-5) (G. Gumora & W. F. Arsenio, 2002, *Emotionality, Emotion Regulation, and School Performance in Middle School Children*)

[^cole]: \**cough*, [scihub link](https://sci-hub.se/10.1007/s11325-014-0976-y) (J. S. Cole, 2014, *A survey of college-bound high school graduates regarding circadian preference, caffeine use, and academic performance*)

# Current Implementations

Most of the major implementations of scheduling algorithms.

## Absolute Spacing

Used by: Leitner system, Pimsleur system

Pimsleur's schedule

## Regression based on Recall Probability

Used by: [Quizlet](https://medium.com/tech-quizlet/spaced-repetition-for-all-cognitive-science-meets-big-data-in-a-procrastinating-world-59e4d2c8ede1)[^quizlet], [Duolingo](https://aclanthology.org/P16-1174.pdf)

[^quizlet]: Quizlet doesn't implement true spaced repetition because it's designed for cramming. It doesn't have a strict scheduler and focuses primarily on the order of review, with higher priority items (ones with lower recall probability) being shown first. Quizlet does have a 'Long-Term Learning' mode with a scheduler that appears to follow a fixed formula of `new interval = (old interval * 2) + 1` with new items starting at a 1 day interval. Items answered incorrectly are reset to the same status as new items. Of course, this is less than optimal as the fixed rate multiplier assumes that all material is the same difficulty.

The first thought I had when pondering on algorithms for spaced repetition is using a simple logistic regression classifier (trained on the user's previous data) to output a probability that the user will get the review item right given an input of the time interval. We can use this recall probability in numerous ways, Quizlet uses it to order the items for review (items with lower recall probability are reviewed first).

My thoughts were that the user could choose a desired recall probability (we'll call this the 'recall threshold' for now), which corresponds to the decision threshold of the classifier. A recall threshold of around 80% makes sense (of course, this will vary with different individuals). The algorithm will show the item once the recall threshold for it falls below 80%. In order to accurately predict the recall probability, this classifier would be trained on features based on past couple repetitions of the same item (Quizlet uses the past 3). It would check to see if the prior attempts were correct, how quickly they were answered, and how many consecutive attempts were correct, which will all help predict the classifier predict the probability of answering the current attempt correctly. Of course, the difficulty of the material is a large factor (that Quizlet apparently doesn't use), but difficulty is different for different individuals, which is why other algorithms like the SuperMemo family ask the user to rate how easy the item was to answer and uses that rating when considering further intervals. This does require more cognitive load from the user, which can be ameliorated at the cost of accuracy by having the algorithm automatically assign the rating based on factors like the time taken to answer, or at least provide a suggested score based on such factors.

Duolingo models its 'half-life regression' approach very similar to the forgetting curve equation described above, except with a base of 2 rather than {{<tex "e" >}} (which doesn't affect anything much because we are really looking at {{<tex "h" >}} to determine the shape of our forgetting curve):

{{<tex display="p = 2^{-\Delta / h}" >}}

{{<tex "p" >}} is the probability of recall. {{<tex "\Delta" >}} is the time since the item was last reviewed, and {{<tex "h" >}} is the *half life* corresponding to the learner's memory strength. The value of this is hoped to correspond with the amount of time it takes the recall probability to decay to 0.5, or 50%. This is because when {{<tex "\Delta = h" >}}, the equation evaluates to {{<tex "p = 2^{-1} = 0.5" >}}. {{<tex "h" >}} should increase exponentially with every repetition (this is analogous to the {{<tex "S" >}} memory strength value), and thus can be modeled by in the form {{<tex "b^n" >}}. Duolingo assumes 2 as the base:
{{<tex display="h_{\theta} = 2^{\theta \cdot x}" >}}

{{<tex "\theta">}} is a vector of parameters and {{<tex "x" >}} is a vector of features. This is now a typical regression problem. All we need is a dataset from previous review performance consisting of the recall rate {{<tex "p" >}}, the time since last review {{<tex "\Delta" >}}, and the values for each of the feature vector {{<tex "x" >}}. Duolingo used the following features: the total number of times the user has seen the item before, the number of times the item was answered correctly and incorrectly, and a large set of lexeme tags indicating the difficulty of each item. The predicted recall rate can be calculated by using {{<tex "p = 2^{-\Delta / h_{\theta}}" >}}, and loss function can be constructed by comparing the predicted value with the actual measured recall rate from our dataset. We can then find values of {{<tex "\theta" >}} that minimize this loss function. I won't go into detail about all of this, check the Duolingo paper linked above for the full equations, apparently they also decided to use factor an approximation of {{<tex "h" >}} in the cost function. It seemed to provide decent results, the following image shows an attempt for the algorithm to fit curves for the predicted recall rate based on the forgetting curve from data points (the black 'x' marks):

{{<figure title="(Settles & Mender, 2016)" src="/img/spaced-repetition/duolingo-graph.png" >}}

## SM2

Used by: [Anki](https://faqs.ankiweb.net/what-spaced-repetition-algorithm.html), [Mnemosyne](https://mnemosyne-proj.org/help/memory-research), Wanikani

Reference: [SM2](https://www.supermemo.com/en/archives1990-2015/english/ol/sm2) (P. A.Wozniak, 1998)

Probably the most popular implementation of spaced repetition. In the algorithm, each review item is associated with an ease factor, which we hope to correspond to the difficulty of the review item. The original implementation consists of two initial hard coded learning phase steps: 1 day, and 6 days.

A fairly simple formula is used to calculate subsequent intervals:

```
New interval = Previous interval * Ease factor
```

The ease factor is simply a floating point number between 1.3 and 2.5. It's role, as seen in the formula, is to act as an interval multiplier leading to a larger and larger interval each time. The restrictions of 1.3 through 2.5 attempt to keep the number of repetitions reasonable. An ease below 1.3 will lead to the material being studied too often (usually indicative not because the knowledge itself is too difficult, but because it is poorly formatted or presented), and anything greater than 2.5 will space the intervals too much, especially as they get larger.

## Bayesian-based

Used by: Ebisu

## Neural Networks

# Further Reading

Interesting studies, articles, and links I read (or at least skimmed) when researching the topic.

- [*Improving Students’ Learning With Effective Learning Techniques: Promising Directions From Cognitive and  Educational Psychology*](https://pcl.sitehost.iu.edu/rgoldsto/courses/dunloskyimprovinglearning.pdf) (J. Dunlosky et al, 2013)
- [*Memory: A Contribution to Experimental Psychology*](https://psychclassics.yorku.ca/Ebbinghaus/index.htm) (H. Ebbinghaus. 1885) Translated from German
- Studies on the forgetting curve, effects of various elements, attempts at quantifying:
  - *The form of the forgetting curve and the fate of memories* (L. Averell and A. Heathcote, 2011) [\**cough*, [scihub link](https://sci-hub.se/10.1016/j.jmp.2010.08.009)]
  - *The Precise Time Course of Retention* (D. Rubin, S. Hinton, and A. Wenzel, 1999) [\**cough*, [scihub link](https://sci-hub.se/10.1037/0278-7393.25.5.1161)]
  - *Forgetting curves in long-term memory: Evidence for a multistage model of retention* (M. Fioravanti and F. Cesare, 1992) [\**cough*, [scihub link](https://sci-hub.se/10.1016/0278-2626(92)90073-U)]
  - [*Evaluating Forgetting Curves*](https://faculty.washington.edu/gloftus/Downloads/LoftusForgettingCurves.pdf) (G. R. Loftus, 1985)
  -  Jost's Law, cited in [another paper on retrograde amnesia](http://wixtedlab.ucsd.edu/publications/wixted/Jost_Law.pdf) (J. T. Wixted, 2004)

**Implementations**

- [Anki's algorithm](https://faqs.ankiweb.net/what-spaced-repetition-algorithm.html)
- Duolingo's algorithm: [*A Trainable Spaced Repetition Model for Language Learning*](https://aclanthology.org/P16-1174.pdf) (B. Settles & B. Mender, 2016) [[Github](https://github.com/duolingo/halflife-regression)]
- [Ebisu](https://github.com/fasiha/ebisu): [Github](https://github.com/fasiha/ebisu)
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
- [Wanikani's algorithm](https://knowledge.wanikani.com/wanikani/srs-stages/)
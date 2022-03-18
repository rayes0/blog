---
title: "Machine Learning"
author: ["rayes"]
date: 2021-08-08T12:03:00-04:00
lastmod: 2021-08-08
draft: false
auto_summary_style: false
status: "inprogress"
---

Some mathematical concepts and derivations that form the basis behind some simple machine learning algorithms. It can be viewed as a high level summary of Andrew Ng's famous [Coursera course](https://www.coursera.org/learn/machine-learning), or any introductory machine learning textbook.

**Helpful Prior Knowledge**

-   Basic linear algebra, fundamental operations (<img src="/ltximg/notes_845dbf0a889c396a179ec95e895c1699b3e0f021.svg" alt="$+, -, \times, /$" class="org-svg" />) with vectors and matrices, transpose and inverse
-   Basic conceptual calculus, taking derivatives


# Basic Concepts {#basic-concepts}

-   Features: The numerical inputs for the algorithm from which it makes predictions.
-   Parameters: The weights which we multiply to the features to produce the final output (corresponds to the prediction we make). These are the values we are trying to learn.
-   Hypothesis function: Function which uses the parameters to map the input features to the final prediction. It is represented as <img src="/ltximg/notes_2286804e1bd14abde5d4ce3b299d6b73b8472b20.svg" alt="$h_{\theta}(x)$" class="org-svg" />, taking the features <img src="/ltximg/notes_8200502396f43963cc03bd777b949929fa9ab630.svg" alt="$x$" class="org-svg" /> (could be a single value or a vector) as input.
-   Some ways to learn <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> values:
    -   Gradient Descent:
        -   Cost function: Function that returns the error of the hypothesis function and the actual correct values in the training set. It is represented as <img src="/ltximg/notes_c77510be9c70fef7898b00cc320981af2f80febe.svg" alt="$J(\theta)$" class="org-svg" />, taking our parameters used to make the prediction (<img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" />) as input.
        -   We try to find values of <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> which minimize the cost function, because the lower the cost function, the lower our error is. We do this by finding the global minimum.
    -   Normal Equation: An equation to calculate the minimum without the need for gradient descent. We will talk about this later.


# Notation {#notation}

Common idiomatic notation used in machine learning and linear algebra, used throughout these notes.

-   <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> - Vector of parameters
-   <img src="/ltximg/notes_8200502396f43963cc03bd777b949929fa9ab630.svg" alt="$x$" class="org-svg" /> - Matrix of features
-   <img src="/ltximg/notes_a2632ec8b80f3ecfeeee0304cd9bef673c246db0.svg" alt="$n$" class="org-svg" /> - Number of features
-   <img src="/ltximg/notes_146579d327178aee99aec103655dc12e35ad8ef6.svg" alt="$m$" class="org-svg" /> - Number of training examples
-   <img src="/ltximg/notes_48f83311bc2b7d912ca163aaaa205b2db56c0f24.svg" alt="$y$" class="org-svg" /> - The correct values for each set of features in the training set
-   <img src="/ltximg/notes_2286804e1bd14abde5d4ce3b299d6b73b8472b20.svg" alt="$h_{\theta}(x)$" class="org-svg" /> - Hypothesis function
-   <img src="/ltximg/notes_c77510be9c70fef7898b00cc320981af2f80febe.svg" alt="$J(\theta)$" class="org-svg" /> - Cost function

Given a matrix <img src="/ltximg/notes_3a366b44453f976c3eb420fb4afe08aaf3025233.svg" alt="$A$" class="org-svg" />:

-   <img src="/ltximg/notes_b326979f5110b369dfdd7fb221f5106dd2a787f2.svg" alt="$A_{ij}$" class="org-svg" /> - the entry in the <img src="/ltximg/notes_9208c498d83744d772365107a277a56df39402ac.svg" alt="$i^{th}$" class="org-svg" /> row, <img src="/ltximg/notes_e29aeff6cb13bfa3c029c6f8fe49fcdee1236e8e.svg" alt="$j^{th}$" class="org-svg" /> column
-   <img src="/ltximg/notes_dda1df432b5b26f786f82be46d734bc41490bc89.svg" alt="$A^T$" class="org-svg" /> - the transpose of <img src="/ltximg/notes_3a366b44453f976c3eb420fb4afe08aaf3025233.svg" alt="$A$" class="org-svg" />
-   <img src="/ltximg/notes_b590f77183f89167ae173fd5a676a2e4ffd1c422.svg" alt="$A^{\prime}$" class="org-svg" /> - the inverse of <img src="/ltximg/notes_3a366b44453f976c3eb420fb4afe08aaf3025233.svg" alt="$A$" class="org-svg" />

For our matrix of features <img src="/ltximg/notes_8200502396f43963cc03bd777b949929fa9ab630.svg" alt="$x$" class="org-svg" />:

-   <img src="/ltximg/notes_9880487a31f4590f5be1eaadc23b1da70717ac15.svg" alt="$x^{(i)}$" class="org-svg" /> - vector of the features in the <img src="/ltximg/notes_9208c498d83744d772365107a277a56df39402ac.svg" alt="$i^{th}$" class="org-svg" /> training example
-   <img src="/ltximg/notes_b09ef0162aebbf7d0c67472427b027bcef5d4759.svg" alt="$x^{(i)}_{j}$" class="org-svg" /> - value of feature <img src="/ltximg/notes_77a714938fae19e6d50afeed8bd776076921f1b1.svg" alt="$j$" class="org-svg" /> in the <img src="/ltximg/notes_9208c498d83744d772365107a277a56df39402ac.svg" alt="$i^{th}$" class="org-svg" /> training example


# Linear Regression {#linear-regression}

Linear regression fits a model to a straight line dataset, therefore our hypothesis function for univariate (one feature) linear regression is:

<img src="/ltximg/notes_31a4692e1bd683b22ad05013c14f26040247cdfd.svg" alt="$$h_{\theta}(x) = \theta_0 + \theta_1x$$" class="org-svg" />

This is a basic 2D straight line, where <img src="/ltximg/notes_8200502396f43963cc03bd777b949929fa9ab630.svg" alt="$x$" class="org-svg" /> is our feature and we are trying to learn the bias parameter <img src="/ltximg/notes_e6caa54cd01106637ca6d9cacea79ece9b24945a.svg" alt="$\theta_0$" class="org-svg" /> and the weight parameter <img src="/ltximg/notes_adb4f15a2e90a07fc681a8341dd09e74eb6703e6.svg" alt="$\theta_1$" class="org-svg" />. We only have a single feature parameter because we only have one feature.

If we do the same for multiple features, we will get a linear multi-dimensional equation:

<img src="/ltximg/notes_932d8254bcbc3ed37dfa85fb5a55b648e8f3a6c2.svg" alt="$$h_{\theta}(x) = \theta_0 + \theta_1x_1 + \theta_2x_2 + \cdots + \theta_nx_n$$" class="org-svg" />

Where <img src="/ltximg/notes_a2632ec8b80f3ecfeeee0304cd9bef673c246db0.svg" alt="$n$" class="org-svg" /> is the number of features. Each feature (the <img src="/ltximg/notes_8200502396f43963cc03bd777b949929fa9ab630.svg" alt="$x$" class="org-svg" /> terms) has a weight parameter (<img src="/ltximg/notes_adb4f15a2e90a07fc681a8341dd09e74eb6703e6.svg" alt="$\theta_1$" class="org-svg" /> through <img src="/ltximg/notes_426cc75e8d431da9720a0af4b4e649b435c36800.svg" alt="$\theta_n$" class="org-svg" />), and each of the individual bias terms are collected into one term <img src="/ltximg/notes_e6caa54cd01106637ca6d9cacea79ece9b24945a.svg" alt="$\theta_0$" class="org-svg" />. Notice how the input <img src="/ltximg/notes_8200502396f43963cc03bd777b949929fa9ab630.svg" alt="$x$" class="org-svg" /> is no longer a single value, and is instead a collection of values <img src="/ltximg/notes_645bb88dae81fcbce808962383b3ec121eb3edc9.svg" alt="$x_1, x_2, x_3 \cdots x_n$" class="org-svg" />, which we can represent as a column vector. We can do the same thing with our <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> values:

<img src="/ltximg/notes_d9f8762d049826ffbe126833b4f59a3411aab03d.svg" alt="$$x = \begin{bmatrix} x_0 = 1 \\ x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} \ \ \ \ \ \ \theta = \begin{bmatrix} \theta_0 \\ \theta_1 \\ \theta_2 \\ \vdots \\ \theta_n \end{bmatrix}$$" class="org-svg" />

Notice how we have added an extra <img src="/ltximg/notes_e5a5eafa53500abfebe157e28e0d88339e9afe37.svg" alt="$x_0$" class="org-svg" /> term into the start of the <img src="/ltximg/notes_8200502396f43963cc03bd777b949929fa9ab630.svg" alt="$x$" class="org-svg" /> vector, and we set it equal to 1. This corresponds to the bias term <img src="/ltximg/notes_e6caa54cd01106637ca6d9cacea79ece9b24945a.svg" alt="$\theta_0$" class="org-svg" />, which we used in the hypothesis equations. We do this because <img src="/ltximg/notes_66cb0615df4f70275c5e8d303ad8186b0c6051d6.svg" alt="$\theta_0 + \theta_1 x_1 + \cdots + \theta_n x_n= \theta_0 x_0 + \theta_1 x_1 + \cdots + \theta_n x_n$" class="org-svg" /> if <img src="/ltximg/notes_de1098bd3b88d979ba12415a9334aebe2defd220.svg" alt="$x_0 = 1$" class="org-svg" />. This also matches the dimensions of both vectors, enabling us to do operations such as multiplication with them.

With our two matrices, we can write out a vectorized version of the hypothesis function as <img src="/ltximg/notes_d15a0f2fe85ca4ceaebda8efcbf2d98011ac6fd7.svg" alt="$\theta^T x$" class="org-svg" />, which we can see is equivalent to our original equation:

<img src="/ltximg/notes_c28e51dedea62b6094ea19af71d9636666b1a4fd.svg" alt="$$h_{\theta}(x) = \theta^T x = \begin{bmatrix} \theta_0 &amp;amp; \theta_1 &amp;amp; \theta_2 &amp;amp; \cdots &amp;amp; \theta_n \end{bmatrix} \times \begin{bmatrix} 1 \\ x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = \theta_0 + \theta_1 x_1 + \theta_2 x_2 + \cdots + \theta_n x_n$$" class="org-svg" />


## Gradient Descent {#gradient-descent}

One way to learn the values of <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> is gradient descent. In order to implement this, we need a cost function which calculates the error of our hypothesis function above. There are a variety of cost functions that could be used, but the typical one for simple regression is a variation on the average of the [squared error](https://en.wikipedia.org/wiki/Variance):

<img src="/ltximg/notes_312db0f6af83148767a0fd6c97a16f8f87fc14d7.svg" alt="$$J(\theta) = \dfrac{1}{2m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})^2$$" class="org-svg" />

Recall that <img src="/ltximg/notes_146579d327178aee99aec103655dc12e35ad8ef6.svg" alt="$m$" class="org-svg" /> represents the number of training examples we have, and <img src="/ltximg/notes_48f83311bc2b7d912ca163aaaa205b2db56c0f24.svg" alt="$y$" class="org-svg" /> represents the actual correct predictions for each set of <img src="/ltximg/notes_8200502396f43963cc03bd777b949929fa9ab630.svg" alt="$x$" class="org-svg" /> features in our training set. What this function does is for each of our training sets, take the value of the hypothesis for that set (<img src="/ltximg/notes_c568204e19969ac483d8665dd8262ff81643a3fe.svg" alt="$h_{\theta}(x^{(i)})$" class="org-svg" />), and calculate the difference between it and the corresponding actual value, then square that difference. This guarantees a positive value. We then sum up each one of these squared positive values, then divides by <img src="/ltximg/notes_092d49d784a6c87e5fad2b861d3ec7501d024562.svg" alt="$2m$" class="org-svg" />, a slight variation on calculating the squared mean error (which would just be dividing by <img src="/ltximg/notes_146579d327178aee99aec103655dc12e35ad8ef6.svg" alt="$m$" class="org-svg" /> only). The reason we also divide by 2 is because it makes the derivative nicer, as the term inside the summation is squared. When we derive this, will end up with a coefficient of 2 in front, which will nicely cancel with the 2 in the denominator.

The actual gradient descent step comes from finding values of <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> that minimize this function the most, in other words, the global minimum. At the minimum point, the derivative (in this case the partial derivative) of the cost function in terms of <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> will be 0. We can calculate the derivative as follows:
<br />
<br />


<div class="equation-container">
<span class="equation">
<img src="/ltximg/notes_c998412850cfc96b6b6fdf378fd77e8cd514df9b.svg" alt="\begin{align*}
\dfrac{\delta}{\delta\theta} J(\theta) &amp;amp;= \dfrac{1}{2m} \cdot \dfrac{\delta}{\delta\theta} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})^2  &amp;amp;\text{(Note: } m \text{ is a constant)} \\
&amp;amp;= \dfrac{1}{2m} \cdot \sum_{i=1}^n \dfrac{\delta}{\delta \theta} (\theta^T x^{(i)} - y^{(i)})^2  &amp;amp;(h_{\theta}(x^{(i)}) \text{ is substituted for } \theta^T x^{(i)}) \\
&amp;amp;= \dfrac{1}{2m} \cdot \sum_{i=1}^m \:2(\theta^Tx^{(i)} - y ^{(i)}) \cdot x^{(i)} &amp;amp;\text{(Note: } y^{(i)} \text{ is a constant)} \\
&amp;amp;= \dfrac{1}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}  &amp;amp;\text{(Simplify and substitute back } h_{\theta}(x^{(i)}))
\end{align*}
" class="org-svg" />
</span>
</div>

One way to get to the minimum is to repeatedly subtract the value of the derivative from the old <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> value. By doing this, when the derivative is positive (indicating we are to the right of the minimum), <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> will be lowered (move to the left), when the derivative is negative (indicating we are to the left of the minimum), <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> will be raised (move to the right). Thus, with many iterations of this, we will eventually approach the minimum. Here is the mathematical representation (the <img src="/ltximg/notes_49f7cc88b417daaea73f795fd36aed316efb0672.svg" alt="$:=$" class="org-svg" /> is used to show that we are updating the value, rather than as an equality operator):


<div class="equation-container">
<span class="equation">
<img src="/ltximg/notes_d65906564b38c887f59f804e433d7517d66ed6cf.svg" alt="\begin{align*} &amp;amp; \text{For } j = 0, \cdots, n \\ &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_j := \theta_j - \alpha \dfrac{\delta}{\delta \theta_j} J(\theta) \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

Substituting the derivative we took above. <img src="/ltximg/notes_9880487a31f4590f5be1eaadc23b1da70717ac15.svg" alt="$x^{(i)}$" class="org-svg" /> is replaced with <img src="/ltximg/notes_da84ca9f0fcdc81a4f6dfe72c8bfd57178b348a2.svg" alt="$x^{(i)}_j$" class="org-svg" /> because when dealing with multiple features, we mean to say the feature set for the specific training example:


<div class="equation-container">
<span class="equation">
<img src="/ltximg/notes_a75d573d4062e30c78f512caed205c0a6d4a0462.svg" alt="\begin{align*} &amp;amp; \text{For } j = 0, \cdots, n \\ &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_j := \theta_j - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_j \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

We have added a new variable: <img src="/ltximg/notes_84c63207c74798a51629a7e35dc80e4d04673edb.svg" alt="$\alpha$" class="org-svg" />. This is called the learning rate, and as you can probably guess from the equation, it corresponds to the size of step we take with each iteration. A large <img src="/ltximg/notes_84c63207c74798a51629a7e35dc80e4d04673edb.svg" alt="$\alpha$" class="org-svg" /> value will lead to subtracting or adding larger values to <img src="/ltximg/notes_1fb5deb39f91dbb17c36d04651ebc1ef0b8b96cb.svg" alt="$\theta_j$" class="org-svg" /> each time. Too small of a learning rate will lead to gradient descent taking too long to converge, because we are taking very small steps each time. Too large of a learning rate can cause our algorithm to never converge because it will overshoot the minimum each time.

One important point is that we are repeating this step for multiple variables. If we were to write it out fully, assuming we have 50 features (meaning that <img src="/ltximg/notes_7ebb9e86fd4452680772e8b00d3a127453fd2661.svg" alt="$x \in \mathbb{R}^{51}$" class="org-svg" /> and <img src="/ltximg/notes_8ed4f2e78e137ba62977129b913ef33e5e0765b3.svg" alt="$\theta \in \mathbb{R}^{51}$" class="org-svg" />):


<div class="equation-container">
<span class="equation">
<img src="/ltximg/notes_ef38aaedf2da2d45043a6e4699fb563a7b132275.svg" alt="\begin{align*} &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_0 := \theta_0 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_0 \\ &amp;amp; \qquad \theta_1 := \theta_1 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta} (x^{(i)}) - y^{(i)})x^{(i)}_1 \\ &amp;amp; \qquad \theta_2 := \theta_2 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_2 \\ &amp;amp; \qquad \qquad \vdots \\ &amp;amp; \qquad \theta_{51} := \theta_{51} - \frac{\alpha}{m} \sum_{i=1}^m (h_{\theta} (x^{(i)}) - y^{(i)})x^{(i)}_{51} \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

Because our <img src="/ltximg/notes_c568204e19969ac483d8665dd8262ff81643a3fe.svg" alt="$h_{\theta}(x^{(i)})$" class="org-svg" /> is dependent on the values of the parameter vector <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" />, we need to make sure we are updating our values simultaneously after we are done with the computations. Consider the following incorrect psuedocode for a single gradient descent step on a three parameters:

```nil
# assume:
#   theta_0 is the bias term
#   theta_1 is the 1st parameter, theta_2 is the second parameter, ... etc.
#   alpha is the learning rate
#   dcost_1, dcost_2, ... etc. is the partial derivative of the cost function for each respective theta

theta_0 = theta_0 - ((alpha / m) * dcost_0)
theta_1 = theta_1 - ((alpha / m) * dcost_1)
theta_2 = theta_2 - ((alpha / m) * dcost_2)
```

This is wrong because we are updating the values before we are finished using all of them yet! Here is a correct implementation, where we update the <img src="/ltximg/notes_4f57cf560218f8f261532577846a228f6e559b38.svg" alt="$\theta$" class="org-svg" /> values simultaneously after the computation:

```nil
temp0 = theta_0 - ((alpha / m) * dcost_0)
temp1 = theta_1 - ((alpha / m) * dcost_1)
temp2 = theta_2 - ((alpha / m) * dcost_2)

theta_0 = temp0
theta_1 = temp1
theta_2 = temp2
```
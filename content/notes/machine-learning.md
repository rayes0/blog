---
title: "Machine Learning (unfinished)"
author: ["Jialu Fu"]
date: 2021-08-08T12:03:00-04:00
draft: false
katex: true
auto_summary_style: false
---

Some mathematical concepts and derivations that form the basis behind some simple machine learning algorithms. It can be viewed as a high level summary of Andrew Ng's famous [Coursera course](https://www.coursera.org/learn/machine-learning), or any introductory machine learning textbook.

**Helpful Prior Knowledge**

-   Basic linear algebra, fundamental operations (<img src="/ltximg/notes_815adc2172d57ad71944688d7382e4e0e13ec4d5.svg" alt="$+, -, \times, /$" class="org-svg" />) with vectors and matrices, transpose and inverse
-   Basic conceptual calculus, taking derivatives


# Basic Concepts {#basic-concepts}

-   Features: The numerical inputs for the algorithm from which it makes predictions.
-   Parameters: The weights which we multiply to the features to produce the final output (corresponds to the prediction we make). These are the values we are trying to learn.
-   Hypothesis function: Function which uses the parameters to map the input features to the final prediction. It is represented as <img src="/ltximg/notes_4889109bb0d73943f53f614e99b37748a8238cd6.svg" alt="$h_{\theta}(x)$" class="org-svg" />, taking the features <img src="/ltximg/notes_5b6a6c083bfd284f55b9f20ce8d5b73672ca4a4e.svg" alt="$x$" class="org-svg" /> (could be a single value or a vector) as input.
-   Some ways to learn <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> values:
    -   Gradient Descent:
        -   Cost function: Function that returns the error of the hypothesis function and the actual correct values in the training set. It is represented as <img src="/ltximg/notes_32d17b0f1b8ae358ae05311112839f9aaaea9c61.svg" alt="$J(\theta)$" class="org-svg" />, taking our parameters used to make the prediction (<img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" />) as input.
        -   We try to find values of <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> which minimize the cost function, because the lower the cost function, the lower our error is. We do this by finding the global minimum.
    -   Normal Equation: An equation to calculate the minimum without the need for gradient descent. We will talk about this later.


# Notation {#notation}

Common idiomatic notation used in machine learning and linear algebra, used throughout these notes.

-   <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> - Vector of parameters
-   <img src="/ltximg/notes_5b6a6c083bfd284f55b9f20ce8d5b73672ca4a4e.svg" alt="$x$" class="org-svg" /> - Matrix of features
-   <img src="/ltximg/notes_3740b32e1ec251d5331efcbf9151f1d77cec15d9.svg" alt="$n$" class="org-svg" /> - Number of features
-   <img src="/ltximg/notes_ba640a68887cba29ed92c6e7775db2868c212a71.svg" alt="$m$" class="org-svg" /> - Number of training examples
-   <img src="/ltximg/notes_d0938a29be697d249f949ccd8356bb3d3671af4b.svg" alt="$y$" class="org-svg" /> - The correct values for each set of features in the training set
-   <img src="/ltximg/notes_4889109bb0d73943f53f614e99b37748a8238cd6.svg" alt="$h_{\theta}(x)$" class="org-svg" /> - Hypothesis function
-   <img src="/ltximg/notes_32d17b0f1b8ae358ae05311112839f9aaaea9c61.svg" alt="$J(\theta)$" class="org-svg" /> - Cost function

Given a matrix <img src="/ltximg/notes_9d166169a9f0d0f1143e050d1084446dfb7a25d1.svg" alt="$A$" class="org-svg" />:

-   <img src="/ltximg/notes_27b6bf601883cc5e796b0aed97fed369d2188199.svg" alt="$A_{ij}$" class="org-svg" /> - the entry in the <img src="/ltximg/notes_f52a19075f6c556d3e118760933e66135c09744b.svg" alt="$i^{th}$" class="org-svg" /> row, <img src="/ltximg/notes_15d0b0f726f973799656eec576c7faf6292086f2.svg" alt="$j^{th}$" class="org-svg" /> column
-   <img src="/ltximg/notes_115cae748b09649f3c18ecb03f07d487915c1629.svg" alt="$A^T$" class="org-svg" /> - the transpose of <img src="/ltximg/notes_9d166169a9f0d0f1143e050d1084446dfb7a25d1.svg" alt="$A$" class="org-svg" />
-   <img src="/ltximg/notes_4ccd3ec4762b3593ff8135f6cc8b2dcdbb24dfb5.svg" alt="$A^{\prime}$" class="org-svg" /> - the inverse of <img src="/ltximg/notes_9d166169a9f0d0f1143e050d1084446dfb7a25d1.svg" alt="$A$" class="org-svg" />

For our matrix of features <img src="/ltximg/notes_5b6a6c083bfd284f55b9f20ce8d5b73672ca4a4e.svg" alt="$x$" class="org-svg" />:

-   <img src="/ltximg/notes_701a145712319d22b04a9c6b055c6934ee05a956.svg" alt="$x^{(i)}$" class="org-svg" /> - vector of the features in the <img src="/ltximg/notes_f52a19075f6c556d3e118760933e66135c09744b.svg" alt="$i^{th}$" class="org-svg" /> training example
-   <img src="/ltximg/notes_6ba01ddaeb47bcb6909368774f0d261173d47548.svg" alt="$x^{(i)}_{j}$" class="org-svg" /> - value of feature <img src="/ltximg/notes_0a967833a8675b93abb14b252b852951f7c51a1f.svg" alt="$j$" class="org-svg" /> in the <img src="/ltximg/notes_f52a19075f6c556d3e118760933e66135c09744b.svg" alt="$i^{th}$" class="org-svg" /> training example


# Linear Regression {#linear-regression}

Linear regression fits a model to a straight line dataset, therefore our hypothesis function for univariate (one feature) linear regression is:

<img src="/ltximg/notes_acb0fe7300c4583be0aca7300a0f2accc405faf6.svg" alt="$$h_{\theta}(x) = \theta_0 + \theta_1x$$" class="org-svg" />

This is a basic 2D straight line, where <img src="/ltximg/notes_5b6a6c083bfd284f55b9f20ce8d5b73672ca4a4e.svg" alt="$x$" class="org-svg" /> is our feature and we are trying to learn the bias parameter <img src="/ltximg/notes_b8d1d181e849eed4af7b698b8da66cc3ea0f0af3.svg" alt="$\theta_0$" class="org-svg" /> and the weight parameter <img src="/ltximg/notes_49c4e4f9ed137801f4683f744f0a393d74de80d9.svg" alt="$\theta_1$" class="org-svg" />. We only have a single feature parameter because we only have one feature.

If we do the same for multiple features, we will get a linear multi-dimensional equation:

<img src="/ltximg/notes_d7648cddba900ac61806fe2c3016d88e32ff6cee.svg" alt="$$h_{\theta}(x) = \theta_0 + \theta_1x_1 + \theta_2x_2 + \cdots + \theta_nx_n$$" class="org-svg" />

Where <img src="/ltximg/notes_3740b32e1ec251d5331efcbf9151f1d77cec15d9.svg" alt="$n$" class="org-svg" /> is the number of features. Each feature (the <img src="/ltximg/notes_5b6a6c083bfd284f55b9f20ce8d5b73672ca4a4e.svg" alt="$x$" class="org-svg" /> terms) has a weight parameter (<img src="/ltximg/notes_49c4e4f9ed137801f4683f744f0a393d74de80d9.svg" alt="$\theta_1$" class="org-svg" /> through <img src="/ltximg/notes_f30e6b339a1a7d8ac2db73b20fb536d98c300c57.svg" alt="$\theta_n$" class="org-svg" />), and each of the individual bias terms are collected into one term <img src="/ltximg/notes_b8d1d181e849eed4af7b698b8da66cc3ea0f0af3.svg" alt="$\theta_0$" class="org-svg" />. Notice how the input <img src="/ltximg/notes_5b6a6c083bfd284f55b9f20ce8d5b73672ca4a4e.svg" alt="$x$" class="org-svg" /> is no longer a single value, and is instead a collection of values <img src="/ltximg/notes_96be6a9db6fc2ed209ddc55b8cf7db0d88f93106.svg" alt="$x_1, x_2, x_3 \cdots x_n$" class="org-svg" />, which we can represent as a column vector. We can do the same thing with our <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> values:

<img src="/ltximg/notes_f0591f622a40cc41fa66daba2ead639a05cc7db9.svg" alt="$$x = \begin{bmatrix} x_0 = 1 \\ x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} \ \ \ \ \ \ \theta = \begin{bmatrix} \theta_0 \\ \theta_1 \\ \theta_2 \\ \vdots \\ \theta_n \end{bmatrix}$$" class="org-svg" />

Notice how we have added an extra <img src="/ltximg/notes_1f212ab717caf5d343945c02bf3644284381f1b7.svg" alt="$x_0$" class="org-svg" /> term into the start of the <img src="/ltximg/notes_5b6a6c083bfd284f55b9f20ce8d5b73672ca4a4e.svg" alt="$x$" class="org-svg" /> vector, and we set it equal to 1. This corresponds to the bias term <img src="/ltximg/notes_b8d1d181e849eed4af7b698b8da66cc3ea0f0af3.svg" alt="$\theta_0$" class="org-svg" />, which we used in the hypothesis equations. We do this because <img src="/ltximg/notes_fb10a94843568d7b352a0aee155d5a09a2a0d21b.svg" alt="$\theta_0 + \theta_1 x_1 + \cdots + \theta_n x_n= \theta_0 x_0 + \theta_1 x_1 + \cdots + \theta_n x_n$" class="org-svg" /> if <img src="/ltximg/notes_52b11fcbfe1ecc3ed130deb7196fae1b22f4aa6f.svg" alt="$x_0 = 1$" class="org-svg" />. This also matches the dimensions of both vectors, enabling us to do operations such as multiplication with them.

With our two matrices, we can write out a vectorized version of the hypothesis function as <img src="/ltximg/notes_2ce97bb983b00994f9fd3a5dc950e8354a2583da.svg" alt="$\theta^T x$" class="org-svg" />, which we can see is equivalent to our original equation:

<img src="/ltximg/notes_9b5894983743f892c8155d21ebd7b483ef5609c0.svg" alt="$$h_{\theta}(x) = \theta^T x = \begin{bmatrix} \theta_0 &amp;amp; \theta_1 &amp;amp; \theta_2 &amp;amp; \cdots &amp;amp; \theta_n \end{bmatrix} \times \begin{bmatrix} 1 \\ x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = \theta_0 + \theta_1 x_1 + \theta_2 x_2 + \cdots + \theta_n x_n$$" class="org-svg" />


## Gradient Descent {#gradient-descent}

One way to learn the values of <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> is gradient descent. In order to implement this, we need a cost function which calculates the error of our hypothesis function above. There are a variety of cost functions that could be used, but the typical one for simple regression is a variation on the average of the [squared error](https://en.wikipedia.org/wiki/Variance):

<img src="/ltximg/notes_0adbc5e24d08cb482b0994c1e15458e66bbc86ff.svg" alt="$$J(\theta) = \dfrac{1}{2m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})^2$$" class="org-svg" />

Recall that <img src="/ltximg/notes_ba640a68887cba29ed92c6e7775db2868c212a71.svg" alt="$m$" class="org-svg" /> represents the number of training examples we have, and <img src="/ltximg/notes_d0938a29be697d249f949ccd8356bb3d3671af4b.svg" alt="$y$" class="org-svg" /> represents the actual correct predictions for each set of <img src="/ltximg/notes_5b6a6c083bfd284f55b9f20ce8d5b73672ca4a4e.svg" alt="$x$" class="org-svg" /> features in our training set. What this function does is for each of our training sets, take the value of the hypothesis for that set (<img src="/ltximg/notes_77f0ec8a1b04f1ce3ed0602f36d5c0da425dd2e7.svg" alt="$h_{\theta}(x^{(i)})$" class="org-svg" />), and calculate the difference between it and the corresponding actual value, then square that difference. This guarantees a positive value. We then sum up each one of these squared positive values, then divides by <img src="/ltximg/notes_ad7d45ec4f51d2f276845fb1fb2bc9a889e7cdb0.svg" alt="$2m$" class="org-svg" />, a slight variation on calculating the squared mean error (which would just be dividing by <img src="/ltximg/notes_ba640a68887cba29ed92c6e7775db2868c212a71.svg" alt="$m$" class="org-svg" /> only). The reason we also divide by 2 is because it makes the derivative nicer, as the term inside the summation is squared. When we derive this, will end up with a coefficient of 2 in front, which will nicely cancel with the 2 in the denominator.

The actual gradient descent step comes from finding values of <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> that minimize this function the most, in other words, the global minimum. At the minimum point, the derivative (in this case the partial derivative) of the cost function in terms of <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> will be 0. We can calculate the derivative as follows:
<br />
<br />

<img src="/ltximg/notes_91bf69691e7a3bb2ea924b761dca6500bc35be1f.svg" alt="\begin{align*}
\dfrac{\delta}{\delta\theta} J(\theta) &amp;amp;= \dfrac{1}{2m} \cdot \dfrac{\delta}{\delta\theta} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})^2  &amp;amp;\text{(Note: } m \text{ is a constant)} \\
&amp;amp;= \dfrac{1}{2m} \cdot \sum_{i=1}^n \dfrac{\delta}{\delta \theta} (\theta^T x^{(i)} - y^{(i)})^2  &amp;amp;(h_{\theta}(x^{(i)}) \text{ is substituted for } \theta^T x^{(i)}) \\
&amp;amp;= \dfrac{1}{2m} \cdot \sum_{i=1}^m \:2(\theta^Tx^{(i)} - y ^{(i)}) \cdot x^{(i)} &amp;amp;\text{(Note: } y^{(i)} \text{ is a constant)} \\
&amp;amp;= \dfrac{1}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}  &amp;amp;\text{(Simplify and substitute back } h_{\theta}(x^{(i)}))
\end{align*}
" class="org-svg" />
</span>
</div>

One way to get to the minimum is to repeatedly subtract the value of the derivative from the old <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> value. By doing this, when the derivative is positive (indicating we are to the right of the minimum), <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> will be lowered (move to the left), when the derivative is negative (indicating we are to the left of the minimum), <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> will be raised (move to the right). Thus, with many iterations of this, we will eventually approach the minimum. Here is the mathematical representation (the <img src="/ltximg/notes_58bc33b0eefbb73c3eb9f8d0e36bd5d024a0eec0.svg" alt="$:=$" class="org-svg" /> is used to show that we are updating the value, rather than as an equality operator):

<img src="/ltximg/notes_2d0ea7d1f14a74a9d6962d2631a6f6a97867258f.svg" alt="\begin{align*} &amp;amp; \text{For } j = 0, \cdots, n \\ &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_j := \theta_j - \alpha \dfrac{\delta}{\delta \theta_j} J(\theta) \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

Substituting the derivative we took above. <img src="/ltximg/notes_701a145712319d22b04a9c6b055c6934ee05a956.svg" alt="$x^{(i)}$" class="org-svg" /> is replaced with <img src="/ltximg/notes_9bf08d7663d728b9ae40cbf31ed02ccbe64e49d8.svg" alt="$x^{(i)}_j$" class="org-svg" /> because when dealing with multiple features, we mean to say the feature set for the specific training example:

<img src="/ltximg/notes_922c62b81811c683bded170171cea03cb0abff91.svg" alt="\begin{align*} &amp;amp; \text{For } j = 0, \cdots, n \\ &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_j := \theta_j - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_j \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

We have added a new variable: <img src="/ltximg/notes_7d5b478a97cb67cf9ea5cfb0b4731926fade9efe.svg" alt="$\alpha$" class="org-svg" />. This is called the learning rate, and as you can probably guess from the equation, it corresponds to the size of step we take with each iteration. A large <img src="/ltximg/notes_7d5b478a97cb67cf9ea5cfb0b4731926fade9efe.svg" alt="$\alpha$" class="org-svg" /> value will lead to subtracting or adding larger values to <img src="/ltximg/notes_1957cbf625ff47196b9ff44f411baf30e32620f8.svg" alt="$\theta_j$" class="org-svg" /> each time. Too small of a learning rate will lead to gradient descent taking too long to converge, because we are taking very small steps each time. Too large of a learning rate can cause our algorithm to never converge because it will overshoot the minimum each time.

One important point is that we are repeating this step for multiple variables. If we were to write it out fully, assuming we have 50 features (meaning that <img src="/ltximg/notes_0afe11d818efd00b42357d5f4df0aafeb2f11ba4.svg" alt="$x \in \mathbb{R}^{51}$" class="org-svg" /> and <img src="/ltximg/notes_ad214cabe114978de8055bfe9efa1af045aab86f.svg" alt="$\theta \in \mathbb{R}^{51}$" class="org-svg" />):

<img src="/ltximg/notes_387966f84c5b99d390077d399d2434095f08e14d.svg" alt="\begin{align*} &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_0 := \theta_0 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_0 \\ &amp;amp; \qquad \theta_1 := \theta_1 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta} (x^{(i)}) - y^{(i)})x^{(i)}_1 \\ &amp;amp; \qquad \theta_2 := \theta_2 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_2 \\ &amp;amp; \qquad \qquad \vdots \\ &amp;amp; \qquad \theta_{51} := \theta_{51} - \frac{\alpha}{m} \sum_{i=1}^m (h_{\theta} (x^{(i)}) - y^{(i)})x^{(i)}_{51} \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

Because our <img src="/ltximg/notes_77f0ec8a1b04f1ce3ed0602f36d5c0da425dd2e7.svg" alt="$h_{\theta}(x^{(i)})$" class="org-svg" /> is dependent on the values of the parameter vector <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" />, we need to make sure we are updating our values simultaneously after we are done with the computations. Consider the following incorrect psuedocode for a single gradient descent step on a three parameters:

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

This is wrong because we are updating the values before we are finished using all of them yet! Here is a correct implementation, where we update the <img src="/ltximg/notes_c03e644679f65cb9621c592c0eece29c299bd915.svg" alt="$\theta$" class="org-svg" /> values simultaneously after the computation:

```nil
temp0 = theta_0 - ((alpha / m) * dcost_0)
temp1 = theta_1 - ((alpha / m) * dcost_1)
temp2 = theta_2 - ((alpha / m) * dcost_2)

theta_0 = temp0
theta_1 = temp1
theta_2 = temp2
```
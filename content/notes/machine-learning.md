---
title: "Machine Learning"
author: ["rayes"]
date: 2021-08-08T12:03:00-04:00
lastmod: 2021-08-08
draft: false
auto_summary_style: false
status: "inprogress"
---

Some mathematical concepts and derivations that form the basis behind some simple machine learning algorithms. It can be viewed as a high level summary of introductory machine learning.

**Helpful Prior Knowledge**

-   Basic linear algebra, fundamental operations with vectors and matrices, transpose and inverse
-   Basic conceptual calculus, taking derivatives


# Notation {#notation}

Common idiomatic notation used in machine learning and linear algebra, used throughout these notes.

-   <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> - Vector of parameters
-   <img src="/ltximg/notes_097625aaefdc9e57f0fe1fa54526065e3f456ec5.svg" alt="$x$" class="org-svg" /> - Matrix of features
-   <img src="/ltximg/notes_1adb5b2907d2ebb754c95a6d6fd4cbebdeebf3d1.svg" alt="$n$" class="org-svg" /> - Number of features
-   <img src="/ltximg/notes_aa07c7d034be54a788c28dd9ac68b55b2fe2dd0a.svg" alt="$m$" class="org-svg" /> - Number of training examples
-   <img src="/ltximg/notes_bce1d21d5072de51bb69a8db3178d2a3fc71ba73.svg" alt="$y$" class="org-svg" /> - The correct values for each set of features in the training set
-   <img src="/ltximg/notes_3585a6245ba7e10ead7fc1a8d6bcbea091238ba0.svg" alt="$h_{\theta}(x)$" class="org-svg" /> - Hypothesis function
-   <img src="/ltximg/notes_6aab55500fc51190e167484d1509801976ab0d2a.svg" alt="$J(\theta)$" class="org-svg" /> - Cost function

Given a matrix <img src="/ltximg/notes_79497c54a9bb8f80213afc2f459c9cf2868b24e8.svg" alt="$A$" class="org-svg" />:

-   <img src="/ltximg/notes_be2916e11396b91e53687f824039c661db6ef339.svg" alt="$A_{ij}$" class="org-svg" /> - the entry in the <img src="/ltximg/notes_e8ca01a1d26ee9297d4be21df431c4bc2741bbef.svg" alt="$i^{th}$" class="org-svg" /> row, <img src="/ltximg/notes_adc41893225811dee567efeec73ca1d7ee650697.svg" alt="$j^{th}$" class="org-svg" /> column
-   <img src="/ltximg/notes_819475424a9b08f311ea76d2a8a9f783f693bc1f.svg" alt="$A^T$" class="org-svg" /> - the transpose of <img src="/ltximg/notes_79497c54a9bb8f80213afc2f459c9cf2868b24e8.svg" alt="$A$" class="org-svg" />
-   <img src="/ltximg/notes_50836f21854418d7770d74d178e5b63f6df794b6.svg" alt="$A^{\prime}$" class="org-svg" /> - the inverse of <img src="/ltximg/notes_79497c54a9bb8f80213afc2f459c9cf2868b24e8.svg" alt="$A$" class="org-svg" />

For our matrix of features <img src="/ltximg/notes_097625aaefdc9e57f0fe1fa54526065e3f456ec5.svg" alt="$x$" class="org-svg" />:

-   <img src="/ltximg/notes_35a8c20c0d5265e49298fc18e809bee6ef05aa88.svg" alt="$x^{(i)}$" class="org-svg" /> - vector of the features in the <img src="/ltximg/notes_e8ca01a1d26ee9297d4be21df431c4bc2741bbef.svg" alt="$i^{th}$" class="org-svg" /> training example
-   <img src="/ltximg/notes_b3e62805b6a15aacdf013320c1468998281a3c98.svg" alt="$x^{(i)}_{j}$" class="org-svg" /> - value of feature <img src="/ltximg/notes_f7ecdff793a51c016e4f1321c74a54e1af20c8c5.svg" alt="$j$" class="org-svg" /> in the <img src="/ltximg/notes_e8ca01a1d26ee9297d4be21df431c4bc2741bbef.svg" alt="$i^{th}$" class="org-svg" /> training example


# Linear Regression {#linear-regression}


## Basic Concepts {#basic-concepts}

-   Features: The numerical inputs for the algorithm from which it makes predictions.
-   Parameters: The weights which we multiply to the features to produce the final output (corresponds to the prediction we make). These are the values we are trying to learn.
-   Hypothesis function: Function which uses the parameters to map the input features to the final prediction. It is represented as <img src="/ltximg/notes_3585a6245ba7e10ead7fc1a8d6bcbea091238ba0.svg" alt="$h_{\theta}(x)$" class="org-svg" />, taking the features <img src="/ltximg/notes_097625aaefdc9e57f0fe1fa54526065e3f456ec5.svg" alt="$x$" class="org-svg" /> (could be a single value or a vector) as input.
-   Some ways to learn <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> values:
    -   Gradient Descent:
        -   Cost function: Function that returns the error of the hypothesis function and the actual correct values in the training set. It is represented as <img src="/ltximg/notes_6aab55500fc51190e167484d1509801976ab0d2a.svg" alt="$J(\theta)$" class="org-svg" />, taking our parameters used to make the prediction (<img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" />) as input.
        -   We try to find values of <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> which minimize the cost function, because the lower the cost function, the lower our error is. We do this by finding the global minimum.
    -   Normal Equation: An equation to calculate the minimum without the need for gradient descent. We will talk about this later.


## How it works {#how-it-works}

Linear regression fits a model to a straight line dataset, therefore our hypothesis function for univariate (one feature) linear regression is:

<img src="/ltximg/notes_73c080f85bc86a36dc9781543fe8047e58f7543a.svg" alt="$$h_{\theta}(x) = \theta_0 + \theta_1x$$" class="org-svg" />

This is a basic 2D straight line, where <img src="/ltximg/notes_097625aaefdc9e57f0fe1fa54526065e3f456ec5.svg" alt="$x$" class="org-svg" /> is our feature and we are trying to learn the bias parameter <img src="/ltximg/notes_2c7e177ac1126d8755d82f2436f533611b05dca9.svg" alt="$\theta_0$" class="org-svg" /> and the weight parameter <img src="/ltximg/notes_82035cf768207cb7bc83989377f10e2324d4d246.svg" alt="$\theta_1$" class="org-svg" />. We only have a single feature parameter because we only have one feature.

If we do the same for multiple features, we will get a linear multi-dimensional equation:

<img src="/ltximg/notes_83270cd4eec132ec100b6013626f818ab112ea3f.svg" alt="$$h_{\theta}(x) = \theta_0 + \theta_1x_1 + \theta_2x_2 + \cdots + \theta_nx_n$$" class="org-svg" />

Where <img src="/ltximg/notes_1adb5b2907d2ebb754c95a6d6fd4cbebdeebf3d1.svg" alt="$n$" class="org-svg" /> is the number of features. Each feature (the <img src="/ltximg/notes_097625aaefdc9e57f0fe1fa54526065e3f456ec5.svg" alt="$x$" class="org-svg" /> terms) has a weight parameter (<img src="/ltximg/notes_82035cf768207cb7bc83989377f10e2324d4d246.svg" alt="$\theta_1$" class="org-svg" /> through <img src="/ltximg/notes_5a58caac37c2f37e2c2f8d9793aec4c55f4d839c.svg" alt="$\theta_n$" class="org-svg" />), and each of the individual bias terms are collected into one term <img src="/ltximg/notes_2c7e177ac1126d8755d82f2436f533611b05dca9.svg" alt="$\theta_0$" class="org-svg" />. Notice how the input <img src="/ltximg/notes_097625aaefdc9e57f0fe1fa54526065e3f456ec5.svg" alt="$x$" class="org-svg" /> is no longer a single value, and is instead a collection of values <img src="/ltximg/notes_7f3d0f99c7960863d365fd5a34e0a40d0f7d6d6f.svg" alt="$x_1, x_2, x_3 \cdots x_n$" class="org-svg" />, which we can represent as a column vector. We can do the same thing with our <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> values:

<img src="/ltximg/notes_dee37a7061eba08913228f2de0d9ad629ae198e5.svg" alt="$$x = \begin{bmatrix} x_0 = 1 \\ x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} \ \ \ \ \ \ \theta = \begin{bmatrix} \theta_0 \\ \theta_1 \\ \theta_2 \\ \vdots \\ \theta_n \end{bmatrix}$$" class="org-svg" />

Notice how we have added an extra <img src="/ltximg/notes_5aa94d5c5194c6f21251e530ea762560d03bd128.svg" alt="$x_0$" class="org-svg" /> term into the start of the <img src="/ltximg/notes_097625aaefdc9e57f0fe1fa54526065e3f456ec5.svg" alt="$x$" class="org-svg" /> vector, and we set it equal to 1. This corresponds to the bias term <img src="/ltximg/notes_2c7e177ac1126d8755d82f2436f533611b05dca9.svg" alt="$\theta_0$" class="org-svg" />, which we used in the hypothesis equations. We do this because <img src="/ltximg/notes_91434d89bda8ecfaba3b31f24b41cd634961625b.svg" alt="$\theta_0 + \theta_1 x_1 + \cdots + \theta_n x_n= \theta_0 x_0 + \theta_1 x_1 + \cdots + \theta_n x_n$" class="org-svg" /> if <img src="/ltximg/notes_531352d7651b83f481bddbc0a226cc92de20e577.svg" alt="$x_0 = 1$" class="org-svg" />. This also matches the dimensions of both vectors, enabling us to do operations such as multiplication with them.

With our two matrices, we can write out a vectorized version of the hypothesis function as <img src="/ltximg/notes_dccbd44da401cb85ba79ea054f6516b71b2a0325.svg" alt="$\theta^T x$" class="org-svg" />, which we can see is equivalent to our original equation:

<img src="/ltximg/notes_416ea6216898a823c99f7a95c786f2fe303a369d.svg" alt="$$h_{\theta}(x) = \theta^T x = \begin{bmatrix} \theta_0 &amp;amp; \theta_1 &amp;amp; \theta_2 &amp;amp; \cdots &amp;amp; \theta_n \end{bmatrix} \times \begin{bmatrix} 1 \\ x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = \theta_0 + \theta_1 x_1 + \theta_2 x_2 + \cdots + \theta_n x_n$$" class="org-svg" />


## Gradient Descent {#gradient-descent}

One way to learn the values of <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> is gradient descent. In order to implement this, we need a cost function which calculates the error of our hypothesis function above. There are a variety of cost functions that could be used, but the typical one for simple regression is a variation on the average of the [squared error](https://en.wikipedia.org/wiki/Variance):

<img src="/ltximg/notes_a2f5dccc309a42e0532929faae691bda418fe7af.svg" alt="$$J(\theta) = \dfrac{1}{2m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})^2$$" class="org-svg" />

Recall that <img src="/ltximg/notes_aa07c7d034be54a788c28dd9ac68b55b2fe2dd0a.svg" alt="$m$" class="org-svg" /> represents the number of training examples we have, and <img src="/ltximg/notes_bce1d21d5072de51bb69a8db3178d2a3fc71ba73.svg" alt="$y$" class="org-svg" /> represents the actual correct predictions for each set of <img src="/ltximg/notes_097625aaefdc9e57f0fe1fa54526065e3f456ec5.svg" alt="$x$" class="org-svg" /> features in our training set. What this function does is for each of our training sets, take the value of the hypothesis for that set (<img src="/ltximg/notes_c843aa7bcd4ccffe9fb51634bc0e5b219649317e.svg" alt="$h_{\theta}(x^{(i)})$" class="org-svg" />), and calculate the difference between it and the corresponding actual value, then square that difference. This guarantees a positive value. We then sum up each one of these squared positive values, then divides by <img src="/ltximg/notes_a12b0bda4057fe6f636d6b394fac81de65bfbca1.svg" alt="$2m$" class="org-svg" />, a slight variation on calculating the squared mean error (which would just be dividing by <img src="/ltximg/notes_aa07c7d034be54a788c28dd9ac68b55b2fe2dd0a.svg" alt="$m$" class="org-svg" /> only). The reason we also divide by 2 is because it makes the derivative nicer, as the term inside the summation is squared. When we derive this, will end up with a coefficient of 2 in front, which will nicely cancel with the 2 in the denominator.

The actual gradient descent step comes from finding values of <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> that minimize this function the most, in other words, the global minimum. At the minimum point, the derivative (in this case the partial derivative) of the cost function in terms of <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> will be 0. We can calculate the derivative as follows:
<br />
<br />


<div class="equation-container">
<span class="equation">
<img src="/ltximg/notes_af3f317704bd58192349e0a6a88e368c3f96ca4a.svg" alt="\begin{align*}
\dfrac{\delta}{\delta\theta} J(\theta) &amp;amp;= \dfrac{1}{2m} \cdot \dfrac{\delta}{\delta\theta} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})^2  &amp;amp;\text{(Note: } m \text{ is a constant)} \\
&amp;amp;= \dfrac{1}{2m} \cdot \sum_{i=1}^n \dfrac{\delta}{\delta \theta} (\theta^T x^{(i)} - y^{(i)})^2  &amp;amp;(h_{\theta}(x^{(i)}) \text{ is substituted for } \theta^T x^{(i)}) \\
&amp;amp;= \dfrac{1}{2m} \cdot \sum_{i=1}^m \:2(\theta^Tx^{(i)} - y ^{(i)}) \cdot x^{(i)} &amp;amp;\text{(Note: } y^{(i)} \text{ is a constant)} \\
&amp;amp;= \dfrac{1}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}  &amp;amp;\text{(Simplify and substitute back } h_{\theta}(x^{(i)}))
\end{align*}
" class="org-svg" />
</span>
</div>

One way to get to the minimum is to repeatedly subtract the value of the derivative from the old <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> value. By doing this, when the derivative is positive (indicating we are to the right of the minimum), <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> will be lowered (move to the left), when the derivative is negative (indicating we are to the left of the minimum), <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> will be raised (move to the right). Thus, with many iterations of this, we will eventually approach the minimum. Here is the mathematical representation (the <img src="/ltximg/notes_a8fb3e35e6fab620341907b48593896529e0436a.svg" alt="$:=$" class="org-svg" /> is used to show that we are updating the value, rather than as an equality operator):


<div class="equation-container">
<span class="equation">
<img src="/ltximg/notes_4b3d7d8df2fc1d604f4e18371c63dc98f2779e7f.svg" alt="\begin{align*} &amp;amp; \text{For } j = 0, \cdots, n \\ &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_j := \theta_j - \alpha \dfrac{\delta}{\delta \theta_j} J(\theta) \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

Substituting the derivative we took above. <img src="/ltximg/notes_35a8c20c0d5265e49298fc18e809bee6ef05aa88.svg" alt="$x^{(i)}$" class="org-svg" /> is replaced with <img src="/ltximg/notes_1a66956fd69156dde719eafe355bcd80b12be8bb.svg" alt="$x^{(i)}_j$" class="org-svg" /> because when dealing with multiple features, we mean to say the feature set for the specific training example:


<div class="equation-container">
<span class="equation">
<img src="/ltximg/notes_0933829f2ae400ea83945ac03ffd9dc8d07b0dd2.svg" alt="\begin{align*} &amp;amp; \text{For } j = 0, \cdots, n \\ &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_j := \theta_j - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_j \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

We have added a new variable: <img src="/ltximg/notes_2a242ae81b80fea8e8f05c855327d096d95a452f.svg" alt="$\alpha$" class="org-svg" />. This is called the learning rate, and as you can probably guess from the equation, it corresponds to the size of step we take with each iteration. A large <img src="/ltximg/notes_2a242ae81b80fea8e8f05c855327d096d95a452f.svg" alt="$\alpha$" class="org-svg" /> value will lead to subtracting or adding larger values to <img src="/ltximg/notes_83139ababcfac1ba6a5b6256e4cec200d838a6f4.svg" alt="$\theta_j$" class="org-svg" /> each time. Too small of a learning rate will lead to gradient descent taking too long to converge, because we are taking very small steps each time. Too large of a learning rate can cause our algorithm to never converge because it will overshoot the minimum each time.

One important point is that we are repeating this step for multiple variables. If we were to write it out fully, assuming we have 50 features (meaning that <img src="/ltximg/notes_fccdb0202a84d65799952c1e7e778768f8299ff5.svg" alt="$x \in \mathbb{R}^{51}$" class="org-svg" /> and <img src="/ltximg/notes_0f3a9b24386e342ed31284badcbea0a57ebf9bc4.svg" alt="$\theta \in \mathbb{R}^{51}$" class="org-svg" />):


<div class="equation-container">
<span class="equation">
<img src="/ltximg/notes_2685d87cd19bf16941bd2bb81e4de126c5d397c9.svg" alt="\begin{align*} &amp;amp; \text{repeat until convergence \{} \\ &amp;amp; \qquad \theta_0 := \theta_0 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_0 \\ &amp;amp; \qquad \theta_1 := \theta_1 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta} (x^{(i)}) - y^{(i)})x^{(i)}_1 \\ &amp;amp; \qquad \theta_2 := \theta_2 - \dfrac{\alpha}{m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)})x^{(i)}_2 \\ &amp;amp; \qquad \qquad \vdots \\ &amp;amp; \qquad \theta_{51} := \theta_{51} - \frac{\alpha}{m} \sum_{i=1}^m (h_{\theta} (x^{(i)}) - y^{(i)})x^{(i)}_{51} \\ &amp;amp;\}\end{align*}
" class="org-svg" />
</span>
</div>

Because our <img src="/ltximg/notes_c843aa7bcd4ccffe9fb51634bc0e5b219649317e.svg" alt="$h_{\theta}(x^{(i)})$" class="org-svg" /> is dependent on the values of the parameter vector <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" />, we need to make sure we are updating our values simultaneously after we are done with the computations. Consider the following incorrect psuedocode for a single gradient descent step on a three parameters:

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

This is wrong because we are updating the values before we are finished using all of them yet! Here is a correct implementation, where we update the <img src="/ltximg/notes_e41783b51f1f930b388def92688eaed47ab2aa44.svg" alt="$\theta$" class="org-svg" /> values simultaneously after the computation:

```nil
temp0 = theta_0 - ((alpha / m) * dcost_0)
temp1 = theta_1 - ((alpha / m) * dcost_1)
temp2 = theta_2 - ((alpha / m) * dcost_2)

theta_0 = temp0
theta_1 = temp1
theta_2 = temp2
```
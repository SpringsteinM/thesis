#import "@preview/glossarium:0.5.3": gls, glspl 
#import "@preview/subpar:0.1.0"
#import "../helper/outline_text.typ": outline-text
#import "@preview/equate:0.2.1": equate

= Foundations
<chp:fnd>

In this chapter, the concepts and methods necessary to understand this thesis are introduced. First, neural networks are described and how they are optimized (@sec:fnd_dl), followed by a detailed discussion of specific architectures, including #glspl("CNN") (@sec:fnd_cnn) and Transformers (@sec:fnd_tr). In particular, the variants used in the following chapters are explained. @sec:fnd_lr presents various self-supervised, semi-supervised, and unsupervised learning approaches that require little to no annotated training data for training neural networks. Finally in @sec:fnd_eval, several approaches for evaluating the performance of neural networks are introduced, which are relevant for the subsequent chapters.

== Artificial Neural Networks
<sec:fnd_dl>

=== Artificial Neuron and Fully Connected Layer

Artificial neural networks are mathematical models inspired by the structure and functioning of neural networks in the brains of living organisms. A neural network is composed of multiple individual neurons and their interconnections, known as synapses. The functionality of a neural network is determined by the distribution of weights between its individual neurons.

The model of a single artificial neuron consists of an input vector $bold(x) in bb(R)^n$, a weight vector $bold(w) in bb(R)^n$, a bias $b in  bb(R)$, and an activation function $f(dot)$. The input to the neuron is calculated as the weighted sum of the input vector and the weight vector. Subsequently, the bias value is subtracted from the input, and an activation function is applied to obtain the final output $hat(y)$ of the neuron. A representation of such a neuron can be found in @fig:fnd_neuron.

#figure([#image("../images/foundations/neural_network_wb_yhat.svg", width: 70%)],
  placement: auto,
  caption: outline-text([
    Schematic structure of an artificial neuron with a input vector $bold(x)$, a weight vector $bold(w)$, a bias term $b$, and an activation function $f(dot)$
  ],[Illustration of a simple artificial neuron])
)
<fig:fnd_neuron>

To solve more complex problems, more than one neuron is required. These neurons are organized into layers. When every input connection is linked to every single neuron in a layer, this is referred to as a fully connected or dense layer. The computation of the output of the $j$-th neuron in such a layer is shown in @eq:n_1 and @eq:n_2.

$
  o_j &= sum_i w_(i j)*x_i #<eq:n_1> \
  hat(y)_j &= f(o_j+b_j) #<eq:n_2>
$
For an entire layer with multiple neurons, matrix notation is often used, employing a weight matrix $bold(W) in bb(R)^(m times n)$ and a bias vector $bold(b) in bb(R)^m$, where $n$ represents the size of the input vector $bold(x)$, and $m$ denotes the number of neurons in the layer. The complete calculation is shown in @eq:n_matrix.

$
bold(hat(y)) &= f(bold(W)bold(x)+bold(b))
$ <eq:n_matrix>

=== Activation Functions in Neural Networks

Typically, multiple layers of neural networks are required to solve more complex problems. The activation function plays a crucial role in this process. Usually, non-linear functions are used, as a linear activation function would result in several layers being reduced to one. In general, a neural network with two layers and nonlinear activation functions serves as a universal approximator. This means it can approximate any continuous function on a compact domain to an arbitrary degree of accuracy, given sufficient neurons in the hidden layer @HornikSW89.


#subpar.grid(
    columns: 4,
    gutter: 6pt,
    align:top,
    figure(
      box([
        #set par(justify: false)
        *Sigmoid*
        #box(
          image("/images/foundations/activation_sigmoid.svg", height:15%)
        )
        #math.equation(block: true, numbering: none)[
          $
          f(x) &= 1/(1+e^-x) \
          f'(x) &= f(x)(1-f(x)) 
          $	
          ]
        ]
      ),
    ), 
    figure(
      box([
        #set par(justify: false)
        *Hyperbolic Tangent*
        #box(
          image("/images/foundations/activation_tanh.svg", height:15%)
        )
        #math.equation(block: true, numbering: none)[
          $
          f(x) &= (e^x-e^-x)/(e^x+e^-x) \
          f'(x) &= 1- f(x)^2 
          $	
          ]
        ]
      ),
    ), 
    figure(
      box([
        #set par(justify: false)
        *Rectified Linear Unit*
        #box(
          image("/images/foundations/activation_relu.svg", height:15%)
        )
        #math.equation(block: true, numbering: none)[
          $
          f(x) &= max(0,x) \
          f'(x) &= cases(0", if" x lt.eq 0, 1", if" x gt 0)
          $	
          ]
        ]
      ),
    ), 
    figure(
      box([
        #set par(justify: false)
        *Gaussian Error Linear Unit*
        #box(
          image("/images/foundations/activation_gelu.svg", height:15%)
        )
        #math.equation(block: true, numbering: none)[
          $
          f(x) &=  1/2x(1+op("erf")(x/sqrt(2))) = x Phi(x) \
          f'(x) &= Phi(x) + x/sqrt(2pi)*e^(-x^2/2)
          $	
          ]
        ]
      ),
    ), 
  placement: auto,
  caption: outline-text([Various nonlinear activation functions used in neural networks.],[Various nonlinear activation functions used in neural networks]),
  label: <fig:fnd_activation>,
) 

Other important properties of activation functions are their output range and whether they are continuously differentiable. The range of an activation function determines whether it provides a finite response, saturating its output at a specific value such as one or zero regardless of the input. Activation functions with a finite response are generally more robust during the learning process. However, they are also prone to the vanishing gradient problem. Examples of activation functions with a finite output range include classical functions such as the step function, sigmoid, or hyperbolic tangent. In contrast, functions like #gls("ReLU") @maas2013rectifier and #gls("GELU") @HendrycksG16 have an infinite output range. Examples of activation functions and their derivatives are shown in @fig:fnd_activation.

In general, it is desirable for an activation function to be differentiable across its entire range of values and for its derivative to not be zero everywhere. This is important because the most commonly used method for optimizing a neural network is the backpropagation algorithm (@sec:fnd_backpropagation). A well-known example of an activation function that lacks a derivative at a specific point is the #gls("ReLU") function, which is not differentiable at $x=0$. To address this limitation, several functions have been developed to improve upon this drawback of #gls("ReLU"), such as the #gls("GELU") function, which is commonly used in #glspl("LLM").

=== Optimization
<sec:fnd_optimization>

The weights of a neural network are typically initialized with random values, resulting in an initial output that is generally far from the desired output. To address this, the neural network must undergo optimization. Optimization of a neural networks $f(dot)$ typically refers to the training process, where the weights $theta$ are adjusted using training pairs $cal(D) = {(x, y) | x in cal(X), y in cal(Y)}$ to minimize the value of a loss or error function $E(hat(y),y)$. 

==== Loss Function
<sec:fnd_loss>

The loss function is designed for model optimization and indicates how close the prediction $hat(y)$ is to a target value $y$. Unlike performance metrics, the loss function does not need to be directly interpretable by humans. Its primary purpose is to be minimized during the optimization process, whereas metrics are generally used to evaluate the model's performance after training. Another difference is that the loss function must be differentiable when the backpropagation (@sec:fnd_backpropagation) algorithm is used for weight adjustment.

Generally, there is a wide range of loss functions, depending on factors such as whether a regression or classification problem is being solved. Examples of regression loss functions include #gls("MSE") (@eq:fnd_mse) and #gls("MAE") (@eq:fnd_mae). For classification tasks, #gls("CE") Loss (@eq:fnd_ce) is commonly used for multi-class problems, while #gls("BCE") (@eq:fnd_bce) is typical for single-class problems. In these examples, $n$ represents the number of training samples and $C$ denotes the number of classes to be distinguished. Additionally, multiple loss terms are often combined to achieve several optimization objectives, such as incorporating regularization to prevent overfitting (@sec:fnd_regularization). 

$
text("MSE") = 1/n sum_(i=1)^n (hat(y)_i - y_i)^2 #<eq:fnd_mse>\
text("MAE") = 1/n sum_(i=1)^n |hat(y)_i - y_i| #<eq:fnd_mae> \
text("Cross-Entropy") = - 1/n sum_(i=1)^n sum_(c=1)^C y_(i,c) log(hat(y)_(i,c)) #<eq:fnd_ce> \
text("BCE") = -1/n sum_(i=1)^n (y_i log(hat(y)_i) + (1- y_i) log(1-hat(y)_i)) #<eq:fnd_bce>
$

==== Backpropagation
<sec:fnd_backpropagation>

The training of neural networks proceeds in multiple steps. In the first step, an input $x$ is fed into the network and a forward pass is executed, resulting in a scalar loss value $E$. Subsequently, during the backward step, the gradient of the loss function with respect to each layer $l$ and its parameters $theta^((l))$ is calculated, utilizing the Backpropagation algorithm. The operations are performed using a computation graph, where the outputs of a layer $l$ are computed as a composition of the previous layers. Backpropagation uses the chain rule to efficiently compute the derivatives for previous layers. A model of such a computation graph is shown in @fig:fnd_layer.

#figure([#image("/images/foundations/layer_e.svg", width: 50%)],
  placement: auto,
  caption: outline-text([
    Layer-wise separate computation of a neural network, divided into a forward pass $z^((l))=f(z^((l-1)), theta^((l)))$ and a backward pass $delta^((l)) =(partial E)/(partial z^((l)))$ 
  ],[Layer wise calculation of a neural network])
)
<fig:fnd_layer>

$
z^((l+1)) &= f(z^((l))) #<eq:forward>\
delta_i^((l)) &= (partial E)/(partial z_i^((l))) = sum_j (partial E)/( partial z_j^((l+1)))( partial z_j^((l+1)))/(partial z_i^((l))) =  sum_j delta_j^((l+1))( partial z_j^((l+1)))/(partial z_i^((l))) #<eq:backward_derivatives>\
(partial E)/(partial theta_i^((l))) &= sum_j (partial E)/( partial z_j^((l+1)))( partial z_j^((l+1)))/(partial theta_i^((l))) =  sum_j delta_j^((l+1))( partial z_j^((l+1)))/(partial theta_i^((l)))#<eq:backward_parameters>
$

When implementing a new layer for a neural network, only three functions need to be defined for the computation using the chain rule: one for the forward pass @eq:forward, one for computing the derivatives based on the following layer @eq:backward_derivatives, and the derivative for each parameter within this layer @eq:backward_parameters. Normally, $z$, $delta$, and $theta$ are not scalars but rather matrices or vectors, with $i$ and $j$ serving as generic indices.

==== Parameter Update
<sec:fnd_parameter_update>

The next step in the optimization process is to adjust the weights of the individual layers so that the error of the loss function is minimized for all training examples in the dataset. Generally, there are various methods to adjust the weights, for example, Genetic Algorithms, but here only the procedures and methods most relevant to training large neural networks are listed.

#heading(level:5, numbering: none)[Gradient Descent]
Gradient descent is a classic optimization technique, where one proceeds iteratively and adjusts the weights in the direction of the negative gradient. In gradient descent, the entire dataset is used to calculate the loss, which in practice can lead to problems if the dataset is too large to fit into memory. The weight adjustment is performed with the following algorithm:

$
theta_(t+1,i) = theta_(t,i) - eta (partial E(theta_t))/(partial theta_(t,i))
$

In this equation, $eta$ is the learning rate, and $(partial E(theta_t))/(partial theta_(t,i))$ is the partial derivative determined using backpropagation.

#heading(level:5, numbering: none)[Stochastic Gradient Descent]
#gls("SGD") functions like gradient descent, but instead of making a weight adjustment only after all training examples, it does so after each individual example. This accelerates the training process, but it also makes it more unstable, so the learning rate often needs to be reduced. To make the training process with #gls("SGD") more stable, in practice, an update is usually performed after each mini-batch, which makes the training process more stable. The following equation specifies the parameter update for $m$ samples in the training dataset:

$
theta_(t+1,i) = theta_(t,i) - eta 1/m sum_(j=1)^m (partial E(theta_t; x^((j)), y^((j))))/(partial theta_(t,i)) #<eq:gradient>
$

#heading(level:5, numbering: none)[Optimizer with Momentum]

Another commonly used optimization technique for gradient descent is the use of the Momentum method @polyak1964some. In this method, the weight change is not directly applied through gradient descent but rather an exponentially decaying moving average of the past gradients is used. This helps to stabilize and accelerate the training process because, for example, in a canyon, the gradient would jump from one side to the other, but with Momentum, the final gradient would gradually move towards the canyon. An example of how the gradient behaves with momentum is shown in @fig:fnd_momentum.

#figure([#image("/images/foundations/momentum.svg", width: 50%)],
  placement: auto,
  caption: outline-text([Example of a gradient descent process with (green) and without (blue) a momentum term.],[Gradient descent process with and without momentum])
)
<fig:fnd_momentum>

There are several ways to implement the momentum term. An example of how it is calculated in PyTorch #footnote[https://pytorch.org/docs/stable/generated/torch.optim.SGD.html] is summarized in the following equations:

$
v_(t+1,i) &= alpha v_(t,i) - 1/m sum_(j=1)^m (partial E(theta_t; x^((j)), y^((j))))/(partial theta_(t,i)) \
 theta_(t+1,i) &= theta_(t,i) + eta v_(t+1,i)
$

Compared to @eq:gradient, there is an additional term $alpha$ here that specifies the strength of the momentum. The higher this value is, the stronger the weighting on the previous gradients and the less influence the current gradient has. This value is usually kept at 0.9 in most approaches.


#heading(level:5, numbering: none)[Adam Optimizer]
Adam is a widely used optimizer for neural networks proposed by Ba and Kingma @KingmaB14. Like the previous optimizers, Adam is a first-order gradient-based algorithm, based on adaptive estimates of lower-order moments. In this process, the exponential moving average of the first ($m_t$) and second ($v_t$) raw moments is calculated for each parameter to be optimized. The calculation of these moving averages is controlled by the two hyper-parameters, $beta_1$ and $beta_2$. Since the variables $m_t$​ and $v_t$​ are initialized to zero, there is a bias in the moving averages. To correct this, the moments are normalized by the term $1/(1−beta_1^t)$ and $1/(1−beta_2^t)$, respectively. The following equations summarize the Adam optimizer update procedure:

$
g_(t+1,i) &= 1/m sum_(j=1)^m (partial E(theta_t; x^((j)), y^((j))))/(partial theta_(t,i)) \
m_(t+1,i) &= beta_1 m_(t,i) + (1-beta_1) g_(t+1,i) \
v_(t+1,i) &= beta_2 v_(t,i) + (1-beta_2) g_(t+1,i)^2 \
hat(m)_(t+1,i) &= m_(t+1,i)/(1-beta_1^t) \
hat(v)_(t+1,i) &= v_(t+1,i)/(1-beta_2^t) \
theta_(t+1,i) &= theta_(t,i) - eta hat(m)_(t+1,i)/(sqrt(hat(v)_(t+1,i))+epsilon)
$

The parameters are typically set to $eta=0.001$  $beta_1 = 0.9$, $beta_2=0.999$ and $epsilon=10^(-8)$, where a fixed learning rate is often sufficient and a reduction of the learning rate $eta$ after some training epochs is not necessary.

==== Regularization
<sec:fnd_regularization>



== Convolutional Neural Networks for Computer Vision
<sec:fnd_cnn>
== Visual and Textual based Transformer Models
<sec:fnd_tr>
== Semi-supervised and Unsupervised based Deep Learning
<sec:fnd_lr>
== Evaluation Methods
<sec:fnd_eval>

=== Classification and Retrieval Metrics
<sec:fnd_map>

In order to evaluate retrieval or classification methods, various metrics have been developed to measure different aspects of these methods and thus allow a comparison or selection of the method. In retrieval tasks, several documents are usually considered, as these methods are used for searches and the question arises as to how many documents were found (#emph[Recall]) and how many of these documents are relevant (#emph[Precision]) to the concept being searched for. This also results in a variety of different metrics, because depending on the scenario it is important, for example, that all relevant results are found or that all objects found are correct. The following four parameters are particularly important for the various metrics and must all be determined for the $n$ documents to be evaluated for a search query:

- $T P$: True positive is the number of all correctly recognized positive examples
- $T N$: True negative is the number of all correctly recognized negative examples
- $F P$: False positive is the number of all falsely recognized positive examples
- $F N$: False negative is the number of all falsely recognized negative examples


#figure([#image("../images/foundations/metric_eng.svg", width: 70%)],
  caption: outline-text([
    Representation of the entire set of all documents in a retrieval result and how it is divided into portions for false negatives $F N$, true negatives $T N$, true positives $T P$, and false positives $F P$.
  ],[Categorization of retrieval results]) //TODO
)
<fig:precision_recall>

Figure @fig:precision_recall shows how these values relate to the number of documents retrieved and the total number of documents. Based on these values, we can calculate the following metrics.

==== Recall
<sec:fnd_recall>

Recall $R$ indicates how many of the found documents are relevant among the search results. The range of values for this metric is from zero to one, with one being the best possible outcome. However, recall alone is not sufficient for evaluating a retrieval system because if the system simply classifies all documents as positive, the metric would be one. Recall $R$ can be computed as follows:

$
R &= (T P) /(T P + F N)
$

==== Precision
<sec:fnd_precision>

Precision $P$ indicates how many of the found documents match the sought concepts. The value range of this metric goes from zero to one, where one would be the best possible result. Precision $P$ can be calculated as follows:

$
P &= (T P) /(T P + F P)
$

As the number of documents to be evaluated can become quite large in current datasets and deployment scenarios, making evaluation with recall and precision difficult to compute, there are several other metrics that consider only a subset of the results. For example, Precision at k examines only the top k documents, or R-Precision.

==== Average Precision 
<sec:fnd_ap>

Average Precision is a combination of recall and precision, allowing one to evaluate a system with just one value. However, it is essential that the system returns a sortable list of results because we can then calculate a precision-recall curve. After each returned document $n$, precision and recall $P(R)$ are calculated for this documents, and subsequently, the area under the resulting curve corresponds to the Average Precision. In this process, instead of using the integral function over $P(R)$, only a finite sum is used, which can be calculated as follows:

$
A P &= sum_(n = 1)^N (R_n-R_(n-1))P_n 
$

For some benchmarks such as #gls("VOC") @everingham2010pascal @everingham2015pascal, an interpolated version of Average Precision is also calculated. In this process, precision is only determined at discrete recall values and their sum is computed as shown in the following equation:

$
A P &= 1/11 sum_(r in {0,0.1,dots,1.0}) P(R)
$

==== Mean Average Precision 
<sec:fnd_map>

Mean Average Precision (mAP) is the mean of the Average Precision $A P$ for different concepts $C$ for a concept classifier or different search queries $C$ in a retrieval system. The metric can be calculated as follows:

$
m A P &= 1/(|C|)sum_(c in C) A P_c
$


=== Intersection over Union
<sec:fnd_iou>

=== Krippendorff's Alpha
<sec:fnd_agreement>

Krippendorff's Alpha is a statistical measure of agreement between coders. This measure can be used, for example, to determine how uniformly different annotators annotate the same data set. The metric can be used with any number of annotators and data types (nominal, ordinal and interval) and also handles the missing annotation in the data corpus. The metric covers a value range between -1 and 1, where 1 means that all annotators are in agreement and their annotations match, 0 means that the annotators are randomly guessing and negative values indicate that annotators systematically disagree. The metric can be calculated in the following way:

$
alpha = 1 - D_o/D_e
$

Where $D_o$ is the observed disagreement and $D_e$ is the expected disagreement, which can be calculated as follows:

$
D_o &= 1/n sum_(c in R) sum_(k in R) w(c,k) sum_(u in U) n_(c k u)/(m_u-1) \
D_e &= 1/(n (n-1)) sum_(c in R) sum_(k in R) w(c,k) n_c n_k 
$

Where $R$ is the set of all possible answers (all possible labels in a classification task) and $U$ is the set of all units (documents or images in a classification task). Furthermore, the following values are required: $n$ is the number of all annotations, $n_c$ and $n_k$ are the number of annotations of a certain class in $R$, $n_(c k u)$ is the number of annotation pairs $(c,k)$ for a certain document $u$, and $m_u$ are the number of annotations for a specific document $u$. Finally, a metric function $w(c,k)$ is needed that defines a weighting depending on two classes. This function depends on whether a relationship can be defined between the individual concepts of the annotation, if it is #emph[nominal] data as in this work, the following weighting function is used:

$
w(c,k) = cases(
  0 "if" c = k,
  1 "if" c != k
)
$
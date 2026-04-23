#import "@preview/glossarium:0.5.3": gls, glspl 
#import "@preview/subpar:0.2.2"
#import "../helper/outline_text.typ": outline-text
#import "@preview/equate:0.3.2": equate

= Foundations
<chp:fnd>

In this chapter, the concepts and methods necessary to understand this thesis are introduced. First, neural networks are described and how they are optimized (@sec:fnd_dl), followed by a detailed discussion of specific architectures, including #glspl("CNN") (@sec:fnd_cnn) and Transformers (@sec:fnd_tr). In particular, the variants used in the following chapters are explained. @sec:fnd_lr presents various self-supervised, semi-supervised, and unsupervised learning approaches that require little to no annotated training data for training neural networks. Finally in @sec:fnd_eval, several approaches for evaluating the performance of neural networks are introduced, which are relevant for the subsequent chapters.

== Artificial Neural Networks
<sec:fnd_dl>

=== Artificial Neuron and Fully Connected Layer
<sec:fnd_fully>

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

During the training of neural networks, a common challenge is overfitting, where the model memorizes the training data instead of generalizing to new, unseen data. This is often characterized by
continued improvement in performance on the training set while performance on validation or test datasets begins to decline. This effect is particularly pronounced in very large models or the amount of trainings samples is limited. Several regularization techniques are employed to mitigate overfitting in large neural networks.

#heading(level:5, numbering: none)[Early Stopping]

Early stopping is a straightforward regularization technique that involves monitoring the performance of a neural network during the iterative training process, such as gradient descent. In order to
prevent overfitting, the model's performance is periodically evaluated on data outside of the training dataset (e.g., the validation dataset). The training process is then halted when performance on this
validation set begins to degrade.

#heading(level:5, numbering: none)[Parameter Norm Penalties]

Another regularization technique involves limiting the magnitude of individual parameters, preventing the model from relying excessively on specific weights. This is achieved by adding a weighted norm penalty $Omega(theta)$ to the loss function $E$. Finally, the regularized loss function $tilde(E)$ is used during the optimization process.

$
tilde(E)(theta;cal(X), cal(Y)) &= E(theta;cal(X), cal(Y)) + lambda Omega(theta)\
Omega_(L 1)(theta) &= ||theta||_1 #<eq:l1_regularization> \
Omega_(L 2)(theta) &= 1/2||theta||_2^2 #<eq:l2_regularization> 
$

Utilizing the $L^2$ regularization (also known as weight decay) during the training process is a common technique in modern approaches (i.e. #gls("CLIP", long:false) @RadfordKHRGASAM21, #gls("BLIP", long:false)-2 @abs-2301-12597). This regularization method penalizes model parameters by incorporating the squared $L^2$ norm, denoted as $Omega_(L 2)(theta)$ in @eq:l2_regularization. Unlike $L^2$ normalization, $L^1$ normalization utilizes the absolute values of the weights as penalty, denoted as $Omega_(L 1)(theta)$ in @eq:l1_regularization. This leads to sparser models, as many parameters converge to a default value of zero. Current regularization practices frequently focus solely on penalizing neuron weights, often neglecting to regularize other parameters like biases.

#heading(level:5, numbering: none)[Dropout]

Dropout is a widely used regularization technique initially proposed by Hinton et al. @abs-1207-0580, designed to prevent co-adaptation between neurons. During training, a random subset of neurons are deactivated, effectively setting their output to zero. This results in only a fraction of the network being active during each iteration. Each Dropout layer requires a single hyper-parameter $p$, which represents the probability of a neuron being deactivated. To compensate for the missing outputs, the activations of the remaining neurons are normalized during training by a factor of $1/(1-p)$. During inference, dropout is not applied, so the entire network is always active. An illustrative example of Dropout implementation in a neural network with two hidden layers is shown in @fig:fnd_dropout.


#figure([#image("../images/foundations/dropout.svg", width: 100%)],
  placement: auto,
  caption: outline-text([Neural network with dropout between individual layers. Dashed nodes are set to zero, effectively removing all dashed connections, so that only the solid ones exist and are trained in this iteration.],[Neuronal Network with Dropout])
)
<fig:fnd_dropout>

== Convolutional Neural Networks for Computer Vision
<sec:fnd_cnn>

While traditional neural networks (@sec:fnd_dl) with fully connected layers (@sec:fnd_fully), can approximate any function, other architectures have proven more efficient in practice. Among these, #glspl("CNN") are particularly effective in visual domains. This is made possible by exploiting the spatial structure of images, because the interpretation of a given image region depends primarily on the surrounding observable regions. Convolutional layers, unlike fully connected layers that rely on matrix multiplication, employ a convolution operation in which a filter kernel is moved across the image and an output is computed at each spatial location. Consequently, #glspl("CNN") typically contain far fewer trainable parameters than fully connected layers, because the same set of weights is shared across all positions and only the weights inside the kernel are trainable. The idea behind these convolutional layers is that they operate analogously to the visual cortex in the brain, they extract simple patterns (e.g. edges and lines) and pass the resulting activations to subsequent layers. By stacking such layers, each successive layer covers a larger receptive field and extracts increasingly complex features.

#figure([#image("../images/foundations/dcnn_new.svg", width: 100%)],
  placement: auto,
  caption: outline-text([Example #gls("CNN") architecture (LeNet-5 @LeCunBBH98) with two convolutional layers, two pooling layers, and three fully connected layers for the automatic recognition of digits from 28 × 28‑pixel grayscale images.],[LeNet from Yann LeCun et al. 1998])
)
<fig:fnd_dcnn>

Since one of the first successful #glspl("CNN") introduced by Yann LeCun et al. in 1998 @LeCunBBH98 (@fig:fnd_dcnn), #glspl("CNN") have repeatedly demonstrated their ability to achieve state-of-the-art results @KrizhevskySH12 @szegedy2015going @he2015deep and even match or surpass human performance @he2015delving. Over the past years, various #gls("CNN") variants have been proposed to address diverse challenges in computer vision, including visual concept  classification @KrizhevskySH12, image segmentation @ChenPSA17 and object localization @RenHGS15.

=== Convolutional Layer
<sec:fnd_convolutional_layer>

Every convolutional neural network includes at least one convolutional layer, which performs the convolution operation. In each layer, a filter kernels is moved across the input and at each position, an output is computed for the subsequent layer. The convolutional operation for a single position is illustrated in @fig:fnd_cnn_kernel. The filter kernel illustrated in @fig:fnd_cnn_kernel is represented as a three-dimensional tensor, which, when slid over the three-dimensional input, produces a two-dimensional output. In practice, however, the kernel is four-dimensional, with an additional dimension accounting for the number of channels (i.e., the number of distinct filters) in the subsequent layer.

#figure([#image("../images/foundations/conv.svg", width: 80%)],
  placement: auto,
  caption: outline-text([A convolutional neural network with two convolutional layers. The kernels (blue and green) illustrate the computation at a single position in the input image, where the three-dimensional tensor determines exactly one output in the subsequent layer.],[A convolutional neural network with two convolutional layers.])
)
<fig:fnd_cnn_kernel>



$
sans(Y)_(i',j',f') &= b_(f') + sum_(i=1)^(H_F)sum_(j=1)^(W_F)sum_(f=1)^(F) sans(X)_(i'+i-1,j'+j-1,f) dot sans(W)_(i,j,f,f') \
(partial E)/(partial W_(i,j,f,f')) &= sum_(i',j',f') delta_(i',j',f')^((l+1)) (partial f_(i',j',f')(x,theta_(f')))/(partial theta_(i,j,f,f')) \
&=sum_(i',j',f') delta_(i',j',f')^((l+1)) x_(i'+i-1,j'+j-1,f) \
delta_(i,j,f) &= sum_(i',j',f') delta_(i',j',f')^((l+1)) theta_(i-i'+1,j-j'+1,f,f') 
$

The four-dimensional kernel $bold(sans(upright(W)))$ tensor parameters are: $H_F$ for the height of the kernel, $W_F$ for the width of the kernel, $F$ for the number of filters in the current layer, and $F'$ for the number of filters in the subsequent layer. 


=== Pooling Layer
<sec:fnd_pooling_layer>

The pooling operation constitutes a fundamental component of #glspl("CNN"). The primary objective of the pooling layer is to perform spatial down-sampling, thereby reducing the dimensionality of the input data. This process effectively minimizes the number of parameters and the overall computational complexity of the model. Furthermore, by constraining the parameter space, the pooling layer enhances the model’s robustness against overfitting and provides a degree of translational invariance, enabling the network to identify features regardless of their specific spatial coordinates within the frame. The most prominent variant is max pooling, which operates by applying a spatial kernel across the input to extract the maximum value from each local neighborhood $Omega$. The following equations define the computational operations for a 2D max-pooling layer:

#let argmax = $op("arg max", limits: #true)$

$
y_(i',j') &= max_((i,j) in Omega (i',j')) x_(i, j) \
delta_(i,j) &= sum_(i', j') delta^((l+1))_(i',j')(partial f_(i',j')(x))/(partial x_(i, j)) \
&= delta^((l+1))_(i',j') bb(1)((i,j)=argmax_((i'',j'') in Omega (i',j'))x_(i'',j'')) #<eq:delta_maxpooling> 
$

Specifically, @eq:delta_maxpooling stipulates that the error signal $delta_(i,j) $ from the higher-level layers is propagated exclusively to the specific input unit that was selected during the forward pass. Consequently, for all other non-selected units within the pooling region, the error signal is set to zero.

== Visual and Textual based Transformer Models
<sec:fnd_tr>

For years, #glspl("RNN") were the state-of-the-art method for processing sequential data, specifically their more advanced variants: #glspl("LSTM")@hochreiter1997long and #glspl("GRU")@cho2014learning. This kind of neural network contains a feedback loop, where the output of the #gls("RNN") layer is fed back into the input for the subsequent iteration. Despite their success and widespread adoption, #gls("RNN")-based models have several disadvantages:

- The recurrent feedback within an #gls("RNN") has a fixed dimensionality and must compress the entire history into this fixed-size vector, which can lead to information loss from earlier iterations.
- The computation of an #gls("RNN") layer cannot be efficiently parallelized on #glspl("GPU"), since the recurrent feedback requires the computations to be performed sequentially.
- During backpropagation in #glspl("GPU"), the so-called vanishing gradient problem can occur for long sequences. This arises because the error must be backpropagated through each individual time step, causing the gradient to become extremely small, which hinders the training of early time steps.

These problems were addressed with the introduction of the Transformer architecture @VaswaniSPUJGKP17, whose central idea is to replace recurrent feedback with a focus on attention mechanisms. The attention mechanism introduces a learnable weighting system that determines the relative importance of different parts of the input data within a neural network. The Transformer architecture utilizes multihead attention to parallelize the attention mechanism. This enables the model to jointly focus on different parts of the sequence from multiple perspectives, capturing a richer set of dependencies than a single attention head could. In practice, Transformers have proven to be exceptionally versatile and adaptable across a wide range of tasks. Their primary advantage lies in their superior scalability, which has enabled the development of #glspl("LLM") featuring hundreds of billions of parameters @abs-2303-08774 @radford2019language @abs-2302-13971.

=== Architecture 

As proposed by Vaswani et al. @VaswaniSPUJGKP17, the Transformer architecture consists of an encoder and a decoder. The encoder processes an input sequence of tokens $x = (x_1,dots,x_n)$ and maps it into a latent representation $z = (z_1,dots,z_n)$. Subsequently, the decoder iteratively generates an output sequence $y = (y_1,dots,y_m)$, where an attention mechanism provides access to the input embeddings during each iteration. Both the encoder and the decoder are composed of multiple stacked blocks, each containing a self-attention mechanism and a feed-forward layer. Each sub-block is encapsulated by a residual connection @HeZRS16 followed by a normalization layer. This encoder–decoder Transformer architecture is illustrated in @fig:fnd_arch_transformer and @fig:fnd_arch_encoder_decoder_transformer.

#figure([#image("../images/foundations/arch_transformer.svg", width: 60%)],
  placement: auto,
  caption: outline-text([Transformer architecture with $N$ encoder blocks and $M$ decoder blocks.],[Transformer model architecture])
)
<fig:fnd_arch_transformer>

In contrast to the originally proposed encoder-decoder structures, encoder-only or decoder-only Transformers have also gained prominence in practice for various scenarios:


==== Encoder-Decoder Transformer

This architectural flexibility is particularly advantageous in cross-lingual tasks, such as machine translation. Furthermore, the encoder-decoder framework excels in tasks where the input and output lengths vary significantly. While the encoder generates a high-dimensional representation of the entire input sequence, the decoder consumes this information via the cross-attention mechanism to generate the output auto-regressively. This separation allows the model to capture complex mappings between disparate data distributions that might be lost in a unified, single-vocabulary system. An example of translation using an encoder-decoder structure is shown in @fig:fnd_arch_encoder_decoder_transformer. This architecture is not only relevant to #gls("NLP")@LewisLGGMLSZ20 @ChungHLZTFL00BW24 @RaffelSRLNMZLL20 but also to computer vision tasks. For instance, the #gls("DETR") employs this encoder-decoder structure for bounding box prediction.

#figure([#image("../images/foundations/encoder_decoder_transformer.svg", width: 100%)],
  placement: auto,
  caption: outline-text([Transformer encoder-decoder for sentence translation.],[Transformer encoder-decoder for sentence translation])
)
<fig:fnd_arch_encoder_decoder_transformer>

==== Encoder-only Transformer

In encoder-only Transformer architectures, the self-attention mechanism allows each sequence element to attend to all other elements simultaneously. Unlike models that process text strictly from left to right, encoder-only models generate a bidirectional contextual representation. Consequently, this architecture is well-suited for tasks such as embedding sequences into a single vector, sequence classification, or the labeling of individual sequence elements. The example in @fig:fnd_arch_encoder_transformer illustrates a text classification task, where a special [cls] token is prepended to the input. A feed-forward classification head is then attached to the output of this token to perform the final prediction. While #gls("BERT") is the most prominent example of this architecture in the #gls("NLP") domain, these models have also become ubiquitous in computer vision through architectures such as the #gls("ViT") and the image-encoder components of multimodal frameworks like #gls("CLIP").

#figure([#image("../images/foundations/encoder_transformer.svg", width: 80%)],
  placement: auto,
  caption: outline-text([Transformer encoder for sentence classification.],[Transformer encoder for sentence classification])
)
<fig:fnd_arch_encoder_transformer>

==== Decoder-only Transformer

In decoder-only Transformer architectures, the self-attention mechanism is restricted to attending only to the current and preceding elements by masking connections to future positions. This design makes the architecture ideal for autoregressive modeling, where the objective is to predict subsequent tokens. Typically, during inference, the output from the previous step serves as the input for the current iteration. As a result, the vast majority of contemporary #glspl("LLM")@abs-2302-13971 @abs-2303-08774 @abs-2310-06825 and conversational agents @Ouyang0JAWMZASR22 utilize a decoder-only architecture, as it provides the most efficient framework for large-scale generative tasks. An example of such a decoder-only architecture for text generation is illustrated in @fig:fnd_arch_decoder_transformer. 

#figure([#image("../images/foundations/decoder_transformer.svg", width: 80%)],
  placement: auto,
  caption: outline-text([Transformer decoder for generative tasks.],[Transformer decoder for generative tasks])
)
<fig:fnd_arch_decoder_transformer>


=== Scaled Dot-Product Attention and Multi-Head Attention 

The Transformer architecture utilizes multiple so called #emph[Scaled Dot-Product Attention] layers. The primary objective of these layers is to reroute information within the network, enabling every element in a sequence to attend to every other element simultaneously. Attention as implemented in a Transformer is defined as the mapping of a query vector to a set of key–value pairs, where the output is a weighted sum of all value vectors $V$, based on the similarity between the query vector $Q$ and the corresponding key vectors $K$. To prevent the dot products from growing excessively large in magnitude, which could push the softmax function into regions with vanishing gradients, the scores are scaled by $sqrt(1/d_k)$​​, where dk​ represents the dimensionality of the key vectors. The attention is calculated as following:

#let attention = $op("Attention", limits: #true)$
#let softmax = $op("softmax", limits: #true)$

$
attention(Q,K,V) &= softmax((Q K^T)/sqrt(d_k))V
$

While a single Scaled Dot-Product Attention layer allows each sequence element to attend to only a single type of relationship at a time, constrained by a single set of learned weight matrices for the query and key, it is often insufficient for capturing complex dependencies. To enable the model to simultaneously attend to information from different representation subspaces at different positions, the Transformer introduces the Multi-Head Attention module. Here, the weight matrices $W^((Q))$, $W^((K))$, and $W^((V))$ are projected into $h$ different subspaces, allowing the network to focus on multiple perspectives without negatively affecting the number of parameters or the computational cost:

#let mha = $op("MultiHead", limits: #true)$
#let concat = $op("Concat", limits: #true)$
#let head = $op("head")$

$
mha(Q, K, V) &= concat(head_1, dots, head_h)W^((O)) \
head_i &= attention(Q W_i^((Q)),K  W_i^((K)),V  W_i^((V)))
$

In this context, the weight matrices are defined as follows: $W^((Q))_i in bb(R)^(d_("model") times d_k)$, $W^((K))_i in bb(R)^(d_("model") times d_k)$,  $W^((V))_i in bb(R)^(d_("model") times d_v)$ and $W^((O))_i in bb(R)^(h d_v times d_("model"))$.

=== Transformers for Visual Tasks

While originally proposed for #gls("NLP") tasks, recent studies demonstrate that this architecture is equally effective for image and video processing. The primary challenge in applying Transformers to images and videos is that visual data is significantly higher-dimensional than text. For instance, the standard AlexNet @KrizhevskySH12 input resolution of $224 times 224$ pixels results in a sequence length exceeding $50,000$ tokens. Due to the quadratic complexity of self-attention, processing such sequences would require a prohibitive amount of computational resources. Consequently, early attempts to employ Transformers in the visual domain were either restricted to low-resolution images @ParmarVUKSKT18 or utilized a #gls("CNN") as a feature extractor to reduce the input dimensionality to a manageable scale @CarionMSUKZ20.

This paradigm shifted with the introduction of the #gls("ViT") @dosovitskiy2021, which operates on image patches rather than individual pixels. These spatial regions are transformed via linear projection into a sequence significantly shorter than the raw pixel count. By utilizing patch sizes of $32 times 32$, $16 times 16$, or $14 times 14$, the #gls("ViT") reduces the sequence length and the computational overhead by several orders of magnitude. The proposed architecture for a classification task is illustrated in @fig:fnd_arch_vit.

#figure([#image("../images/foundations/vit_art.svg", width: 100%)],
  placement: auto,
  caption: outline-text([Architecture of the #gls("ViT",long:true). The image is partitioned into individual patches and transformed into a sequence of vectors. This sequence, along with a classification token [cls], is combined with one-dimensional position embeddings and fed into the Transformer encoder. Finally, a feed-forward classification head is attached to the output position of the [cls] token.],[Vision Transformer])
)
<fig:fnd_arch_vit>

Unlike convolutional layers, which use fixed filters to extract features from local regions, the Transformer architecture lacks these inherent inductive biases. Through the self-attention mechanism, the model can access all image regions simultaneously, even in the very first layers. Empirical studies on @ViT @dosovitskiy2021 have shown that while the model predominantly develops local attention patterns similar to #glspl("CNN") during training, it also attends to distant regions in the early stages. Because #glspl("CNN") have these inductive biases baked into their architecture while Transformers must learn these spatial relationships from scratch, the latter generally requires significantly more training data. However, the Transformer architecture scales more effectively with larger datasets and increased model parameters.

== Leveraging Unlabeled and Noisy Data in Deep Learning
<sec:fnd_lr>

The predominant method for training neural networks is supervised learning, which utilizes a dataset wherein each training instance is associated with a corresponding label. As the parameter count of neural networks continues to scale, the demand for increasingly large datasets has grown to enhance model generalization. However, the curation of such data is becoming prohibitively time-consuming and expensive. Consequently, research is increasingly exploring alternative strategies for the initial training phase, specifically those that do not demand manual annotations.

To overcome the limitations imposed by the scarcity of annotated datasets, researchers are increasingly incorporating unlabeled data into the training of neural networks. The primary strategies employed in this context are semi-supervised learning and unsupervised learning.

=== Semi-supervised Learning
<sec:fnd_semi>

Semi-supervised learning involves training a model with a dataset comprised of both labeled and unlabeled data, where the labeled portion is significantly smaller than the unlabeled portion. Numerous diverse approaches exist for leveraging unlabeled data to enhance model performance during training. Many recent methods rely on techniques such as consistency regularization or pseudo-labeling.

#strong[Consistency Regularization:] The fundamental principle behind these methods is that perturbations to the input or the internal state of the model should not significantly alter the model's prediction. For instance, the semantic identity of a cat remains unchanged despite rotations or pixel level noise. A prominent implementation of this principle is the Mean Teacher framework @TarvainenV17. In this architecture, a student model and a teacher model whose weights are an #gls("EMA") of the student weights process different augmented versions of the same unlabeled input. The training objective then minimizes a consistency cost such as mean squared error between the student prediction and the teacher targets.

#strong[Pseudo-Labeling:] This method utilizes a teacher model to generate labels for unlabeled data, which then serve as the optimization targets. The teacher can be a previous iteration of the student model or, more commonly, an #gls("EMA") of the weights from previous steps @SohnBCZZRCKL20. Depending on the implementation, the pseudo-labeling process can generate either soft labels (a probability distribution) or hard labels (a one-hot vector). To mitigate the effects of confirmation bias @ArazoOAOM20, these generated labels are only utilized if the model exhibits high confidence, i.e. the class probability exceeds a predefined threshold @SohnBCZZRCKL20.

=== Weakly Supervised Learning
<sec:fnd_weakly>

In contrast to semi-supervised learning, weakly supervised learning utilizes labels that are low-quality, coarse, or noisy. This training challenge arises when the specific annotations required for a given task are unavailable, necessitating the substitution of target annotations with auxiliary or lower-level labels. These labels are typically easier to collect in large quantities and do not require manual annotation.

Weakly supervised learning encompasses a broad range of data challenges and strategies. In the context of this work, weakly supervised learning is applied in the following scenarios:

#strong[Synthetic Label Generation:] This involves the creation of annotations using auxiliary models, such as Large Language Models (LLMs) or Vision-Language Models (VLMs). These labels can be derived from various inputs, including the image content itself or associated metadata such as tag lists. However, because these labels are machine-generated rather than human-verified, the final training signal may contain noise or hallucinations.

#strong[Synthetic Data Generation:] This strategy involves generating input data for model training rather than relying exclusively on real-world samples. Examples of this approach include the use of diffusion models to create class-specific training images @0001VTN23 or style transfer techniques to adapt existing datasets to a target domain @madhu2023. By synthesizing data, it is possible to bridge domain gaps and expand training sets where authentic data is scarce.

#strong[Web-Supervised Learning:]
This approach involves generating datasets by crawling images from the internet based on specific keywords, leveraging existing metadata as supervision targets. However, this introduces significant label noise, as the visual content is not always perfectly aligned with the search query or metadata. The utility of web-crawled data for weakly-supervised learning has been demonstrated in various works @SpringsteinE16, @SunSSG17. One notable example is #gls("CLIP") @RadfordKHRGASAM21, which utilizes 400 million (image, text) pairs for training.


=== Unsupervised and Self-supervised Learning
<sec:fnd_unsuper>

Unsupervised and self-supervised learning are closely related, as both share the common challenge of lacking target labels for data points. In unsupervised learning, algorithms like k-means clustering typically aim to identify underlying patterns within the data without a formal training stage. In contrast, self-supervised learning generates the necessary supervision feedback directly from the data itself. The standard strategy for self-supervised learning in computer vision is to define a pretext task that enables the model to acquire useful representations for subsequent downstream tasks. Examples of such tasks include solving jigsaw puzzles @NorooziF16, detecting image rotation @GidarisSK18, restoring masked image patches @HeCXLDG22, or training a unified embedding by maximizing the similarity between differently augmented views of the same image @ChenK0H20, @GrillSATRBDPGAP20.

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
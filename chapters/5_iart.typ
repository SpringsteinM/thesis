#import "@preview/glossarium:0.4.0": gls, glspl 
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule
#import "/helper/outline_text.typ": outline-text

= #outline-text([iART: A Search Engine for Art-Historical Images to Support Research in the Humanities],[iART: A Search Engine for Art-Historical Images]) <chp:iart>

== Introduction
<introduction>
Basic art-historical techniques of analysis are essentially built on
comparative processes. Heinrich Wölfflin, e.g., practised comparative
vision in determining the stylistic history of the Renaissance and the
Baroque, which he interpreted antagonistically @Wolfflin1915.
However, open Web platforms that promote such image-oriented research
processes by identifying objects that are similar to each other are
currently not available. Previous approaches lack either fine-tuning to
the art-historical domain @Rossetto2016, flexible search query
structures that adapt to users’ needs @Lang2018, or the ability
for users to upload their own datasets @Offert2021.

In this paper, we present
iART#footnote[#link("https://labs.tib.eu/iart"), accessed: 2021-06-15.]:
an e-research-tool that analyses structures (or similarities) of a group
of images by processing large, heterogeneous, and digitally available
databases of art-historical objects through machine learning. Ordering
criteria that were already common in early modern #emph[Wunderkammern],
such as colour, material, or function, can be applied as well as more
iconographically based classification principles that, e.g., examine
objects for biblical motifs or Christian themes. Decisive is that these
principles can be liquefied and reconfigured. The iART~platform has been
designed in such a way that it can be easily extended with the help of
plug-ins to meet the various requirements of art historians. The
retrieval of objects is not only performed with automatically generated
keywords but also by utilizing state-of-the-art multimodal embeddings
that enable search based on accurate, detailed scene descriptions given
by the user.

#figure(
  image("../images/iart/iart_architecture_color_4.svg", width:100%),
  caption: [
    Architecture with associated database structure and RedisAI inference server;
  ]
)
<fig:arch>


#figure(
  image("../images/iart/iart_pipeline_color_without_redisai_small.svg", width:100%),
  caption: [
    Indexing and post-processing steps with relevant plug-ins. The generated keywords and features are stored with the help of Elasticsearch and Faiss @JohnsonDJ17.
  ]
)
<fig:pipeline>

== System Architecture
<system-architecture>
The software was designed to be as modular as possible to facilitate
adaptation to different research interests: the individual indexing
steps are outsourced to plug-ins and user administration is separated
from the search infrastructure. All models are accelerated with a
RedisAI inference server to manage the resources needed for computation
optimally. This step makes it easier to run different deep learning
models on a single GPU and enables back end systems such as
PyTorch~@PaszkeGMLBCKLGA19 or
TensorFlow~@AbadiABBCCCDDDG16. The Web front
end integrates the Vue framework and communicates with the indexer via a
Django Web service. @fig:arch displays the
architecture of iART.

== Image Retrieval
<image-retrieval>
Due to the diffuseness of the concept of similarity, iART~supports
different types of search queries that can be precisely targeted by the
user. Hence, the underlying system was developed with the idea that each
processing step should be extensible through a plug-in structure. This
applies in particular to feature extraction, image classification,
ranking of results, and various post-processing steps that serve
visualization and clustering. The complete pipeline is shown in
@fig:pipeline.

Common feature extractors are integrated into iART, e.g., for ImageNet
embeddings through a pre-trained ResNet @HeZRS16.
These are complemented by models adjusted to the art-historical domain:
(1) the self-supervised model BYOL (Bootstrap Your Own Latent) is
trained on an adequate subset of Wikimedia
images~@GrillSATRBDPGAP20; (2) while the Painter
model utilizes the Painter by Numbers dataset~@painter to
extract features for style and genre; (3) and the transformer-based
neural network CLIP (Contrastive Language-Image Pre-Training) learns
visual concepts from natural language
supervision~@abs-2103-00020. Moreover,
different classification models are trained to automatically predict
art-historically relevant phenomena collected from
Iconclass~@iconclass, iMet~@imet, and Painter by
Numbers~@painter.

The extracted features primarily enable the user to retrieve similar
images based on a query image. As the system extracts different
embeddings for each image, the user can change the weighting of plug-ins
and thus adjust the order of results according to his or her needs.
Through its two decoder structures, CLIP creates a unified feature space
for image and text, allowing the user to also enter textual
descriptions. By weighting reference images and text queries, it is
possible to create more complex search requests. For example, a
reference image of Saint Sebastian can be combined with the text query
"crucifixion" (@fig:sebastian-ranked). Using a faceted
search, the list of results can be further narrowed down based on
classified attributes and the metadata given by the respective
collection. This helps users to filter their uploaded inventories and
about one million openly licensed images, including examples from
Amsterdam Rijksmuseum~@rijksmuseum, Wikidata~@wikidata,
Kenom~@kenom, and ARTigo~@Wieser2013@Becker2018.

== Result Visualization
<result-visualization>
To simplify the exploration of the results, different object views are
implemented. By default, an image grid sorted by relevance is displayed,
via which further details are provided on demand, such as metadata from
the respective object. Results can be clustered with k-means and
visualized, e.g., as image carousels vertically separated by groups. For
more advanced use cases, it is possible to arrange the images on a
two-dimensional canvas using the dimensionality reduction technique UMAP
(Uniform Manifold Approximation and
Projection)~@abs-1802-03426. Zoom and filter
operations, such as an interactive drag-select to juxtapose multiple
objects, are supported with the aid of VisJs
(@fig:sebastian-umap).

#figure([#figure([#image("../images/iart/iart_sebastian_ranked.jpg", width: 100%)],
    caption: [
    ]
  )
  <fig:sebastian-ranked>

  #figure([#image("../images/iart/iart_sebastian_umap.jpg", width: 100%)],
    caption: [
    ]
  )
  <fig:sebastian-umap>

  ],
  caption: [
    Search results for a reference image of Saint Sebastian, combined
    with the text query "crucifixion." (a) Default image grid; (b)
    two-dimensional canvas view.
  ]
)
<fig:sebastian>

== Conclusion
<conclusion>
With iART, we introduced an open Web platform for art-historical
research that facilitates the process of comparative vision. As the
system is extensible and supports various classification plug-ins and
feature extractors, users can adapt it to their needs. In the future,
the system will be enriched with additional openly licensed datasets.
Further plug-ins will also be integrated, e.g., feature extractors for
human body pose or image composition.

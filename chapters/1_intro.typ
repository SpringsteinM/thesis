#import "@preview/glossarium:0.5.3": gls, glspl 
#import "@preview/subpar:0.2.2"
#import "@preview/ctheorems:1.1.3": *
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule
#import "/helper/outline_text.typ": outline-text
#import "@preview/unify:0.7.1": num

= Introduction
<chp:intro>

// - Kunst suchmaschinen funktionieren nur über metadaten
// - Content basierte analysen werden erst durch große neuronale netzwerke ermöglicht, die auch auf kunst generalisieren
// - Problem bestehen, da Kunst weiter darüber hinaus gehen kann:
//   - was durch datensatze die aus fotografie bestehen abgedeckt wird
//   - Andere Fragestellung aufwirft, die durch die exitierenden Datensätze nur schlecht abgedeckt wird

// - CV Entwickelt sich von 
// - Content basierte analysen werden erst durch große neuronale netzwerke ermöglicht, die auch auf kunst generalisieren
// - Problem bestehen, da Kunst weiter darüber hinaus gehen kann:
//   - was durch datensatze die aus fotografie bestehen abgedeckt wird
//   - Andere Fragestellung aufwirft, die durch die exitierenden Datensätze nur schlecht abgedeckt wird

The discipline of art history seeks to systematically document and analyze works of art through established methodologies. This process encompasses various aspects, including content-based iconographic interpretation, formal design analysis, contextual classification in terms of place and time, and the perception of these works by their audience. While many of the methods employed have been refined over centuries, the documentation of art collections has traditionally relied on manual assessments conducted by experts. This reliance significantly limits the ability to analyze larger collections, as the process is highly time-intensive and constrained by the availability of qualified individuals. Existing image search platforms used in art historical research provide only limited support, often relying on a narrow set of metadata such as title, artist, or year of creation. These constraints underscore the need for advanced tools capable of addressing the scale and complexity of contemporary art historical research, paving the way for the integration of computer vision and machine learning technologies.

In recent years, automatic image content analysis through computer vision and machine learning has advanced rapidly. The adoption of #glspl("CNN") for image analysis marked a turning point, enabling automatic classification systems to surpass human annotators in performance for the first time. Achieving such performance, however, necessitates vast amounts of annotated training data. The demand for annotated data has grown exponentially, with current approaches such as #gls("CLIP") and #glspl("LLM") requiring billions of data examples. Given the impracticality of manual annotation at this scale, alternative learning approaches, including self-supervised and semi-supervised methods, are increasingly employed. Studies have demonstrated the emergence of scaling laws linking the size of neural networks, training datasets, and computational resources to performance gains. However, limitations are becoming apparent, as the training data requirements for #glspl("LLM") approach the total volume of all data available on the internet.

Within the context of visual analysis in art history, a critical challenge lies in the limited availability of training data. The largest datasets currently accessible for training contain fewer than one million examples, which pales in comparison to the vast and diverse visual content present in the field of art. This limitation hampers the ability of machine learning models to generalize effectively, particularly when analyzing rare styles, obscure works, or underrepresented iconography concepts.

The question therefore arises: How can we further scale automatic image analysis for the study of art without having new data available to us? Addressing this challenge requires innovative approaches, such as the generation of synthetic training to enlarge training corpora, semi- or self-supervised learning methods to minimize the reliance on labeled data, or transfer learning from pre-trained models on related domains. Such efforts could also address more complex challenges beyond basic concept recognition, such as iconographic concept detection or pose estimation in artistic figures.

// Human annotation study

An additional question arising from the continuous scaling of AI systems is how humans perform on these tasks in comparison and whether AI-based methods already achieve superior performance. Especially in a field like art, where some concepts are highly abstract and even experts often disagree on the correct classification, new questions arise about how performance improvements will manifest and be evaluated.

#subpar.super(
 [#figure(
      image("../images/intro/liberte.svg", height: 17.2%),
      caption:[]
    ) <fig:intro_examples_c>
  #grid(
    columns: 2,
    gutter: 6pt,
    [#figure(
      image("../images/intro/henry_8.svg", height: 15%),
      caption:[]
    ) <fig:intro_examples_a>],
    [#figure(
      image("../images/intro/persiflage.svg", height: 15%),
      caption:[]
    ) <fig:intro_examples_a>],
  )],
  placement: auto,
  caption: [Different types of search scenarios that should be possible in a search portal. (a) Identifying preliminary sketches for parts of an artwork or locating reused elements within an artwork. (b) Identifying adaptations of a young boy based on the image of Henry VIII. (c) Finding a caricature of a kissing scene as a persiflage of a biblical depiction.],
  label: <fig:intro_examples>,
)

Another challenge lies in making these state-of-the-art methods available to art historians in a way that allows them to be easily integrated into their workflow. An ideal solution would be a platform containing a large collection of art historical images, which expands traditional metadata search by incorporating a variety of computer vision-guided search methods. This would allow researchers to gradually expand their search behavior based on existing methods, enabling them to not only filter by metadata but also combine it with visual features. This would open up several new research possibilities for art historians that were previously only feasible manually. Some possible search scenarios are illustrated in @fig:intro_examples.

== Existing Challenges and Limitations
<sec:int_challenges>

#let researchquestion = thmbox(
  "rq", 
  "Research Question", 
  fill: rgb("#eeeeee"),
  bodyfmt: body => ["#emph[#body]"]
)

The rapid scaling of AI systems across various domains over the last decade increasingly raises the question of whether and for which tasks, they already surpass human performance. Over the years, several comparisons and studies have demonstrated that AI-powered automated systems can outperform human participants and even experts in their respective fields. Over the years, scientists have conducted various comparisons @bailer2005joanneum @jiang2011consumer @kumar2009attribute @lake2015human @nowak2011eval @parikh2010role @taigman2014deepface @turnbull2008semantic @weyand2016planet @xiao2010sun and some of these studies have demonstrated that certain AI-powered automated systems can outperform human participants and even experts in their respective fields @christiansen2025international @he2015delving. However, it's not only overall performance that matters, but also the agreement among a group of human annotators. If the annotators do not consistently agree, what can we expect from an automated system trained on this data?

#researchquestion(number: "1")[How does the performance of machines in multimedia annotation tasks compare to human performance and what methodologies can be used to determine if a recognition problem is solved at a human level?] <rq_1>


We utilize the insights gained from our user study, in which we measured the intercoder agreement, for the experiments in subsequent methods for art history.

Research projects aimed at the exploration of art using computer-assisted image processing are significantly more data-limited compared to projects focused on the analysis of photographs. Some of the largest datasets, such as WikiArt @SalehE15, Met @METDataset, or Art500k @art500k, contain only a few hundred thousand images, which is considerably smaller than other commonly used datasets @RussakovskyDSKS15 @LinMBHPRDZ14 @abs-2111-02114 @SchuhmannBVGWCC22. Another factor is that the performance of deep learning classifiers scales with the number and variation of samples per class @HuhAE16. However, most art datasets contain only a limited number of samples for each individual concept.

#researchquestion(number: "2")[How can generative methods be used to create training material for neural network training to enhance the performance of computer vision methods in the field of art?] <rq_2>


#researchquestion(number: "3")[How can we use alternative learning methods such as semi-supervised learning to further scale computer vision for art historical tasks without relying on more annotated training data?] <rq_3>


== Contributions
<sec:int_contributions>

The goal of this thesis is to answer the research questions which were formulated in previous chapters by developing various image analysis methods that enable art historians to systematically search through larger image collections. The challenge lies in the limited amount of training data available for specific tasks, making it difficult to optimize procedures specifically for art historical collections. For this purpose, improvements and approaches for various image analysis methods are proposed to specifically optimize them for the domain of art.

*The main contributions of this thesis can be summarized as follows:*

- Present a new dataset for saint classification in art-historical images
- #emph[PoPArt] data set consists of #num("2859") art images with #num("3514") annotated persons, comprising #num("51645") keypoints in #gls("COCO") format.
- Introduce a novel pose estimation model optimized through semi-supervised learning for application in art historical images
- #emph(gls("ICARUS")) data set consisting of #num("477569") images for iconographic concept recognition with #num("20596") different #gls("Iconclass") concepts
- `CAT` a novel iterative #gls("HMC", long: true) approach for predicting #gls("Iconclass") concepts from an art-historical image
- Search and analysis platform #emph("iArt") with various image indexes optimized for the needs of art historians

== Thesis Structure
<sec:int_thesis_structure>
The remainder of the thesis is structured as follows. @chp:fnd provides the necessary foundations required for understanding the subsequent chapters. These include the basics of training neural networks, specific architectures, and the metrics used to evaluate the methods. @chp:what analyzes current computer vision methods in comparison to human performance. Subsequently, the @chp:art explores various approaches to enhancing the performance of art classification systems, leveraging self-supervised and semi-supervised learning techniques as well as data generation strategies. In the end, the presented methods, along with additional approaches, are integrated into a unified search platform and made available to art historians, as described in @chp:iart. The thesis concludes with a summary and a discussion of potential future developments in @chp:conclusion. 

== List of Publications
<sec:int_publications>

The relevant publications that were published during the preparation of the dissertation and are used for this document are summarized here.

#heading(text([Human Performance in Image Classification:],weight: "bold"), numbering: none, level: 5, supplement: none, bookmarked: false, outlined:false)
#block(cite(<EwerthSPS17>, form: "full"))
#text([Abstract:], weight: "bold")
"Do machines perform better than humans in visual recognition tasks?" Not so long ago, this question would have been considered even somewhat provoking and the answer would have been clear: "No". In this paper, we present a comparison of human and machine performance with respect to annotation for multimedia retrieval tasks. Going beyond recent crowdsourcing studies in this respect, we also report results of two extensive user studies. In total, 23 participants were asked to annotate more than 1000 images of a benchmark dataset, which is the most comprehensive study in the field so far. Krippendorff's $alpha$ is used to measure inter-coder agreement among several coders and the results are compared with the best machine results. The study is preceded by a summary of studies which compared human and machine performance in different visual and auditory recognition tasks. We discuss the results and derive a methodology in order to compare machine performance in multimedia annotation tasks at human level. This allows us to formally answer the question whether a recognition problem can be considered as solved. Finally, we are going to answer the initial question. 

#heading(text([Art Historical Classification Systems:],weight: "bold"), numbering: none, level: 5, supplement: none, bookmarked: false, outlined:false)
#block(cite(<SpringsteinSRSK24>, form: "full"))
#text([Abstract:], weight: "bold")
Iconography refers to the methodical study and interpretation of thematic content in the visual arts, distinguishing it, e.g., from purely formal or aesthetic considerations. In iconographic studies, #gls("Iconclass") is a widely used taxonomy that encapsulates historical, biblical, and literary themes, among others. However, given the hierarchical nature and inherent complexity of such a taxonomy,  it is highly desirable to use  automated methods for (#gls("Iconclass")-based) image classification. Previous studies   either focused narrowly on certain subsets of narratives or failed to exploit #glspl("Iconclass") hierarchical structure. In this paper, we propose a novel approach for  #gls("HMC") of iconographic concepts in images. We present three strategies, including #glspl("LM"), for the generation of textual image descriptions using keywords extracted from #gls("Iconclass"). These descriptions are utilized to pre-train a #gls("VLM") based on a newly introduced data set of 477,569 images with more than 20,000 #gls("Iconclass") concepts, far more than considered in previous studies. Furthermore, we present five approaches to multi-label classification, including a novel transformer decoder that leverages hierarchical information from the #gls("Iconclass") taxonomy. Experimental results show the superiority of this approach over reasonable baselines. 

#block(cite(<SpringsteinSAE22>, form: "full"))
#text([Abstract:], weight: "bold")
Gesture as #quote[language] of non-verbal communication has been theoretically established since the 17th century. However, its relevance for the visual arts has been expressed only sporadically. This may be primarily due to the sheer overwhelming amount of data that traditionally had to be processed by hand. With the steady progress of digitization, though, a growing number of historical artifacts have been indexed and made available to the public, creating a need for automatic retrieval of art-historical motifs with similar body constellations or poses. Since the domain of art differs significantly from existing real-world data sets for human pose estimation due to its style variance, this presents new challenges. In this paper, we propose a novel approach to estimate human poses in art-historical images. In contrast to previous work that attempts to bridge the domain gap with pre-trained models or through style transfer, we suggest semi-supervised learning for both object and keypoint detection. Furthermore, we introduce a novel domain-specific art data set that includes both bounding box and keypoint annotations of human figures. Our approach achieves significantly better results than methods that use pre-trained models or style transfer.


#block(cite(<SchneiderSRHEK20>, form: "full"))
#text([Abstract:], weight: "bold")
Due to the increasingly unmanageable number of art-historical inventories made available in digital form, methods that computationally arrange larger amounts of objects are becoming more important. The category of similarity, which is fundamental in all areas of art-historical description, gains new relevance in this context. In this paper, we propose a novel approach to the subject-specific classification of art-historical objects that utilizes expert-based attributes, i.e., significant figurative motifs. We evaluate our procedure on a concrete use case, representations of saints in the visual arts. A representative data set of saints images is collected and a semi-supervised learning technique applied to enrich the data set with neural style transfer as well as to improve the joint training of saints and their attributes. We show that this technique outperforms other approaches.


#heading(text([Art Historical Search Engine:],weight: "bold"), numbering: none, level: 5, supplement: none, bookmarked: false, outlined:false)
#block(cite(<SchneiderSRKEH22>, form: "full"))
#[
  #set par(first-line-indent:0pt)
  #text([Abstract (english):], weight: "bold")
  With iART, an open web platform is introduced for searching art and cultural studies image inventories, inspired by methods established in the humanities, such as comparative viewing. The system integrates various machine learning techniques for keyword- and content-driven retrieval, as well as for category formation through clustering. Using a multimodal deep learning approach, it also enables text- and image-based searches for concepts that were not previously identified by trained classification models. Supported by an intuitive user interface that allows exploration of results through modifiable object views, users can explore approximately one million objects from art-historically significant image databases, such as those of the Dutch Rijksmuseum. Additionally, users can import their own collections.
  
  #text([Abstract (german):], weight: "bold")
  #[
    #set text(
      lang: "de"
    )
    Mit iART wird eine offene Web-Plattform zur Suche in kunst- und kulturwissenschaftlichen Bildinventaren präsentiert, die von in den Geistes­wissenschaften etablierten Methoden wie dem Vergleichenden Sehen inspiriert ist. Das System integriert verschiedene maschinelle Lerntechniken für das schlagwort- und inhaltsgesteuerte Retrieval sowie die Kategorienbildung über Clustering. Mithilfe eines multimodalen Deep-Learning-Ansatzes ist es zudem möglich, text- und bildbasiert nach Konzepten zu suchen, die von trainierten Klassifikationsmodellen zuvor nicht erkannt wurden. Unterstützt von einer intuitiven Benutzeroberfläche, die die Untersuchung der Ergebnisse durch modifizierbare Objektansichten erlaubt, können Nutzer:innen circa eine Millionen Objekte aus kunsthistorisch relevanten Bilddatenbanken, etwa des niederländischen Rijksmuseums, explorieren. Ebenso können eigene Bestände importiert werden.
  ]
]
#block(cite(<SpringsteinSRHK21>, form: "full"))
#text([Abstract:],weight: "bold")
In this paper, we introduce iART: an open Web platform for art-historical research that facilitates the process of comparative vision. The system integrates various machine learning techniques for keyword- and content-based image retrieval as well as category formation via clustering. An intuitive GUI supports users to define queries and explore results. By using a state-of-the-art cross-modal deep learning approach, it is possible to search for concepts that were not previously detected by trained classification models. Art-historical objects from large, openly licensed collections such as Amsterdam Rijksmuseum and Wikidata are made available to users.



#[
  #set par(first-line-indent:0pt)
#text([Further Publications:],weight: "bold")
]
#block(cite(<Ewerth2017>, form: "full"))
#block(cite(<Muehling2017>, form: "full"))
#block(cite(<Mueller-Budack_SCSMI2024>, form: "full"))
#block(cite(<MuellerBudack2021b>, form: "full"))
#block(cite(<MuellerBudack2021>, form: "full"))
#block(cite(<Mueller2017>, form: "full"))
#block(cite(<otto2019understanding>, form: "full"))
#block(cite(<otto2020characterization>, form: "full"))
#block(cite(<SpringsteinSPSM23>, form: "full"))
#block(cite(<Springstein2021a>, form: "full"))
#block(cite(<Springstein2021>, form: "full"))
#block(cite(<SpringsteinNHE18>, form: "full"))
#block(cite(<SpringsteinE16>, form: "full"))
#block(cite(<TahmasebzadehSE24>, form: "full"))
#block(cite(<Theiner_2023_CVPR>, form: "full"))




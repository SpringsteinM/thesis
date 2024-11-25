#import "@preview/glossarium:0.4.0": gls, glspl 
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule

= Introduction
<chp:intro>
== Motivation
<sec:int_motivation>
== Existing Challenges and Limitations
<sec:int_challenges>
== Contributions
<sec:int_contributions>
== List of Publications
<sec:int_publications>

The relevant publications that were published during the preparation of the dissertation and are used for this document are summarised here.

#heading(text([Human Performance in Image Classification:],weight: "bold"), numbering: none, level: 5, supplement: none, bookmarked: false, outlined:false)
#block(cite(<EwerthSPS17>, form: "full"))
#text([Abstract:],weight: "bold")
"Do machines perform better than humans in visual recognition tasks?" Not
so long ago, this question would have been considered even somewhat
provoking and the answer would have been clear: ``No''. In this paper, we
present a comparison of human and machine performance with respect to annotation for multimedia retrieval tasks.
Going beyond recent crowdsourcing studies in this respect,
we also report results of two extensive user studies. In total, 23
participants were asked to annotate more than 1000 images of a benchmark
dataset, which is the most comprehensive study in the field
so far. Krippendorff's $alpha$ is used to measure inter-coder agreement among
several coders and the results are compared with the best machine results.
The study is preceded by a summary of studies
which compared human and machine performance in different visual and auditory recognition
tasks. We discuss the results and derive a methodology in order to compare machine performance in multimedia annotation tasks at human level.
This allows us to formally answer the question whether a recognition problem
can be considered as solved. Finally, we are going to answer the initial question.

#heading(text([Art Historical Classification Systems:],weight: "bold"), numbering: none, level: 5, supplement: none, bookmarked: false, outlined:false)
#block(cite(<SpringsteinSRSK24>, form: "full"))
#text([Abstract:],weight: "bold")
Iconography refers to the methodical study and interpretation of thematic content in the visual arts, distinguishing it, e.g., from purely formal or aesthetic considerations.
In iconographic studies, #gls("Iconclass") is a widely used taxonomy that encapsulates historical, biblical, and literary themes, among others.
However, given the hierarchical nature and inherent complexity of such a taxonomy, 
it is highly desirable to use 
automated methods for (#gls("Iconclass")-based) image classification.
Previous studies  
either focused narrowly on certain subsets of narratives or failed to exploit #glspl("Iconclass") hierarchical structure.
In this paper, we propose a novel approach for 
#gls("HMC") of iconographic concepts in images.
We present three strategies, including #glspl("LM"), for the generation of textual image descriptions using keywords extracted from #gls("Iconclass").
These descriptions are utilized to pre-train a #gls("VLM") based on a newly introduced data set of 477,569 images with more than 20,000 #gls("Iconclass") concepts, far more than considered in previous studies. Furthermore, we present five approaches to multi-label classification, including a novel transformer decoder that leverages hierarchical information from the #gls("Iconclass") taxonomy.
Experimental results show the superiority of this approach over reasonable baselines.

#block(cite(<SpringsteinSAE22>, form: "full"))
#text([Abstract:],weight: "bold")
Gesture as #quote[language] of non-verbal communication has been theoretically established since the 17th century. 
However, its relevance for the visual arts has been expressed only sporadically. 
This may be primarily due to the sheer overwhelming amount of data that traditionally had to be processed by hand. 
With the steady progress of digitization, though, a growing number of historical artifacts have been indexed and made available to the public, creating a need for automatic retrieval of art-historical motifs with similar body constellations or poses. 
Since the domain of art differs significantly from existing real-world data sets for human pose estimation due to its style variance, this presents new challenges. In this paper, we propose a novel approach to estimate human poses in art-historical images. 
In contrast to previous work that attempts to bridge the domain gap with pre-trained models or through style transfer, we suggest semi-supervised learning for both object and keypoint detection. Furthermore, we introduce a novel domain-specific art data set that includes both bounding box and keypoint annotations of human figures. Our approach achieves significantly better results than methods that use pre-trained models or style transfer.


#block(cite(<SchneiderSRHEK20>, form: "full"))
#text([Abstract:],weight: "bold")
Due to the increasingly unmanageable number of art-historical inventories made available in digital form, methods that computationally arrange larger amounts of objects are becoming more important. The category of similarity, which is fundamental in all areas of art-historical description, gains new relevance in this context. In this paper, we propose a novel approach to the subject-specific classification of art-historical objects that utilizes expert-based attributes, i.e., significant figurative motifs. We evaluate our procedure on a concrete use case, representations of saints in the visual arts. A representative data set of saints images is collected and a semi-supervised learning technique applied to enrich the data set with neural style transfer as well as to improve the joint training of saints and their attributes. We show that this technique outperforms other approaches.


#heading(text([Art Historical Search Engine:],weight: "bold"), numbering: none, level: 5, supplement: none, bookmarked: false, outlined:false)
#block(cite(<SchneiderSRKEH22>, form: "full"))
#text([Abstract:],weight: "bold")
Mit iART wird eine offene Web-Plattform zur Suche in kunst- und kulturwissenschaftlichen Bildinventaren präsentiert, die von in den Geistes­wissenschaften etablierten Methoden wie dem Vergleichenden Sehen inspiriert ist. Das System integriert verschiedene maschinelle Lerntechniken für das schlagwort- und inhaltsgesteuerte Retrieval sowie die Kategorienbildung über Clustering. Mithilfe eines multimodalen Deep-Learning-Ansatzes ist es zudem möglich, text- und bildbasiert nach Konzepten zu suchen, die von trainierten Klassifikationsmodellen zuvor nicht erkannt wurden. Unterstützt von einer intuitiven Benutzeroberfläche, die die Untersuchung der Ergebnisse durch modifizierbare Objektansichten erlaubt, können Nutzer:innen circa eine Millionen Objekte aus kunsthistorisch relevanten Bilddatenbanken, etwa des niederländischen Rijksmuseums, explorieren. Ebenso können eigene Bestände importiert werden.

#block(cite(<SpringsteinSRHK21>, form: "full"))
#text([Abstract:],weight: "bold")
In this paper, we introduce iART: an open Web platform for art-historical research that facilitates the process of comparative vision. The system integrates various machine learning techniques for keyword- and content-based image retrieval as well as category formation via clustering. An intuitive GUI supports users to define queries and explore results. By using a state-of-the-art cross-modal deep learning approach, it is possible to search for concepts that were not previously detected by trained classification models. Art-historical objects from large, openly licensed collections such as Amsterdam Rijksmuseum and Wikidata are made available to users.



#text([Further Publications:],weight: "bold")

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






== Thesis Structure
<sec:int_structure>

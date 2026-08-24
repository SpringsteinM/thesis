= Computer Vision Methods for Art Recognition <chp:art>

The general objective of this thesis is to support art-historical analysis through the use of computer-aided methods. Art historians utilize diverse methodologies to analyze works of art, ranging from formal analysis of visual qualities @Wölfflin1915 to iconographic and iconological interpretations that uncover intended symbolic meanings and the work’s broader social, historical, and cultural significance @panofsky1939. The time-consuming nature of manual annotation by art historians hinders the analysis of larger datasets, particularly given the exponential growth of images within digital collections.

This chapter presents several computational methods designed to address distinct facets of art-historical inquiry. The focus is exclusively on formalist and iconographic approaches that utilize the visual properties of an artwork, deliberately excluding analytical methods that rely on extrinsic metadata, such as an artist’s biographical background. Specifically, we evaluate strategies to overcome the severe scarcity of annotated training data in the art domain. To this end, we investigate how synthetic data generation and alternative learning paradigms, such as semi-supervised and weakly-supervised training, can enhance the performance and scalability of computer vision models for art-historical tasks. Through these investigations, this chapter directly addresses the two central research questions #strong[RQ2] and #strong[RQ3]. 
// TODO the answer to this sup

The structure of this chapter is as follows: it first introduces a framework for the identification of hagiographic depictions based on visual attributes (@chp:saints). Subsequently, it delineates a system for automated pose estimation in artworks (@chp:pose). The chapter concludes with the proposal of a robust system for iconographic concept recognition (@chp:iconclass). Finally, these methods are integrated into an AI-supported platform, enabling art historians to search and evaluate vast selections of artworks efficiently (@chp:iart).

#include "4_1_saints.typ"

#pagebreak(to:"odd")
#include "4_2_pose.typ"

#pagebreak(to:"odd")
#include "4_3_iconclass.typ"
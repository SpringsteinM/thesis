#import "@preview/modern-cv:0.10.0": *
#import "@preview/fontawesome:0.6.2": *
#import "@preview/hidden-bib:0.1.1": hidden-bibliography

#show: resume.with(
  author: (
    firstname: "Matthias",
    lastname: "Springstein",
    email: "matthias.springstein@tib.eu",
    // homepage: "https://example.com",
    phone: "0173 1819956",
    github: "SpringsteinM",
    orcid: "0000-0002-6509-8534",
    birth: "Mai 8, 1988",
    address: "Seydlitzstraße 29, 30161 Hannover",
    positions: (
      "Elektroingenieur", "Softwareingenieur", "Entwickler"
    ),
  ),
  date: datetime.today().display(),
  language: "de",
  colored-headers: true,
  show-footer: false,
  profile-picture: image("/images/resume/tib_square.jpg")
)

= Erfahrungen

#resume-entry(
  title: "Wissenschaftlicher Mitarbeiter",
  location: "Hannover",
  date: "2015 - Heute",
  description: "TIB – Leibniz-Informationszentrum Technik und Naturwissenschaften",
  title-link: "https://github.com/DeveloperPaul123",
)

#resume-item[
  - Entwicklung verschiedener Bildklassifikationsverfahren, unter anderem für Konzepterkennung, Posenschätzung und Bildsegmentierung
  - Administration des GPU-Forschungsclusters der TIB
  - Entwicklung und Betrieb von KI-gestützter Forschungsinfrastruktur wie iART und TIB-AV-A.
]


= Projekte

#resume-entry(
  title: "ReflectAI",
  date: "2023 - Present",
  description: "Forscher",
)

#resume-item[
  - Reflexionsbasierte künstliche Intelligenz in der Kunstgeschichte – erklärbare hybride Modelle für die Bildersuche und -analyse
]

#resume-entry(
  title: "TIB-AV-A",
  location: [#github-link("TIBHannover/tibava")],
  date: "2021 - Present",
  description: "Designer/Entwickler",
)

#resume-item[
  - Webplattform zum Analysieren von Videos mithilfe von KI-gestützten Video, Bild- und Audioanalysatoren
  - #strong("Verwendete Technologien:") Redis, Celery, Django, Vue, Ray
]

#resume-entry(
  title: "MonoTo3D",
  date: "2019 - 2023",
  description: "Forscher",
)

#resume-item[
  - Schwach überwachtes Lernen zur Tiefenschätzung in monokularen Bildern 
]

 

#resume-entry(
  title: "iART",
  location: github-link("TIBHannover/iart"),
  date: "2019 - 2021",
  description: "Designer/Entwickler",
)

#resume-item[
  - Entwicklung einer contentbasierten Bildsuchplattform für Kunsthistoriker
  - Plugin-basierter Bildindexer für verschiedene KI-gestützte Bildanalysatoren
  - #strong("Verwendete Technologien:") Redis, Celery, Django, Vue, ElasticSearch, Qdrant
]

= Kompetenzen

#resume-skill-item(
  "Programmierspr.",
  (strong("Python"), strong("C++"), "Rust", "Java", "JavaScript", "C"),
)
#resume-skill-item(
  "Frameworks",
  (strong("PyTorch"), "TensorFlow", "Numpy", "HuggingFace/Transformers"),
)
#resume-skill-item(
  "Datenbanken",
  (strong("SQL"), "MongoDB", "Redis", "ElasticSearch", "Qdrant"),
)
#resume-skill-item("Sprachen", (strong("Deutsch"), strong("English")))

= Ausbildung

#resume-entry(
  title: "Ernst-Abbe-Fachhochschule Jena",
  location: "Jena",
  date: "2014 - 2015",
  description: "Master of Engineering, Studiengang Systemdesign",
)

#resume-item[
  - #strong("Abschlussarbeit:") Entwicklung eines Web-basierten Verfahrens zum Lernen von visuellen Konzepten
]


#resume-entry(
  title: "Ernst-Abbe-Fachhochschule Jena",
  location: "Jena",
  date: "2010 - 2014",
  description: "Bachelor of Engineering, Studiengang Technische Informatik",
)


#resume-item[
  - #strong("Abschlussarbeit:") Entwicklung und Validierung eines Verfahrens zur algoritmischen Vorverarbeitung von Fahrzeugkennzeichen zur optischen Zeichenerkennung
]

#resume-entry(
  title: "Fachoberschule Unterwellenborn",
  location: "Unterwellenborn",
  date: "2008 - 2009",
  description: "Allgemeine Fachhochschulreife / Technik",
)



#resume-entry(
  title: "Elektro–Mann e.K.",
  location: "Königsee",
  date: "2004 - 2008",
  description: "Elektroniker Fachrichtung Energie und Gebäudetechnik",
)

// #pagebreak()

= Publikationen


#resume-item[
- E. Müller-Budack, *M. Springstein*, M. Plank, J. Sittel, R. Mauer, O. Bulgakowa, u. a., „TIB AV-Analytics: A Computational Tool for Film and Video Analysis“, in Conference of the Society for Cognitive Studies of the Moving Image, SCSMI 2024, Budapest, Hungary, June 5-8, 2024, 2024.
- *M. Springstein*, S. Schneider, J. Rahnama, J. Stalter, M. Kristen, E. Müller-Budack, u. a., „Visual Narratives: Large-scale Hierarchical Classification of Art-historical Images“, in IEEE/CVF Winter Conference on Applications of Computer Vision, WACV 2024, Waikoloa, HI, USA, January 3-8, 2024, 2024, S. 7195–7205. doi: 10.1109/ WACV57701.2024.00705.
- G. Tahmasebzadeh, *M. Springstein*, R. Ewerth, und E. Müller-Budack, „Few-Shot Event Classification in Images using Knowledge Graphs for Prompting“, in IEEE/CVF Winter Conference on Applications of Computer Vision, WACV 2024, Waikoloa, HI, USA, January 3-8, 2024, 2024, S. 7271–7280. doi: 10.1109/WACV57701.2024.00712.
- *M. Springstein*, M. Stamatakis, M. Plank, J. Sittel, R. Mauer, O. Bulgakowa, u. a., „TIB AV-Analytics: A Web-based Platform for Scholarly Video Analysis and Film Studies“, in ACM Conference on Research and Development in Information Retrieval, SIGIR 2023, Taipei, Taiwan, July 23-27, 2023, 2023, S. 3195–3199. doi: 10.1145/3539618.3591820.
- J. Theiner, N. Nommensen, J. Rhotert, *M. Springstein*, E. Müller-Budack, und R. Ewerth, „Analyzing Results of Depth Estimation Models With Monocular Criteria“, in Explainable AI for Computer Vision Workshop co-located with the IEEE/CFV Conference on Computer Vision and Pattern Recognition, XAI4CV\@CVPR 2023, Vancouver, Canada, June 19, Juni 2023, S. 3738–3742.
- *M. Springstein*, S. Schneider, C. Althaus, und R. Ewerth, „Semi-supervised Human Pose Estimation in Art-historical Images“, in ACM Conference on Multimedia, MM 2022, Lisboa, Portugal, October 10 - 14, 2022, 2022, S.1107–1116. doi: 10.1145/3503161.3548371.
- S. Schneider, *M. Springstein*, J. Rahnama, H. Kohle, R. Ewerth, und E. Hüllermeier, „iART - Eine Suchmaschine zur Unterstützung von bildorientierten Forschungsprozessen“, in Tagung des Verbands Digital Humanities im deutschsprachigen Raum, DHd 2022, Potsdam, Germany, March 7 - 11, 2022, 2022. doi: 10.5281/ZENODO.6310.528175.
- *M. Springstein*, S. Schneider, J. Rahnama, E. Hüllermeier, H. Kohle, und R. Ewerth, „iART: A Search Engine for Art-Historical Images to Support Research in the Humanities“, in ACM Conference on Multimedia, MM 2021, Virtual Event, China, October 20 - 24, 2021, 2021, S. 2801–2803. doi: 10.1145/3474085.3478564.
- *M. Springstein*, E. Müller-Budack, und R. Ewerth, „Unsupervised Training Data Generation of Handwritten Formulas using Generative Adversarial Networks with Self-Attention“, in Workshop on Multi-Modal Pre-Training for Multimedia Understanding co-located with the International Conference on Multimedia Retrieval, MMPT\@ICMR 2021, Virtual Event, August 21, 2021, 2021, S. 46–54. doi: 10.1145/3463945.3469059.
- *M. Springstein*, E. Müller-Budack, und R. Ewerth, „QuTI! Quantifying Text-Image Consistency in Multimodal Documents“, in ACM SIGIR Conference on Research and Development in Information Retrieval, SIGIR 2021, Virtual Event, July 11-15, 2021, 2021, S. 2575–2579. doi: 10.1145/3404835.3462796.
- E. Müller-Budack, *M. Springstein*, S. Hakimov, K. Mrutzek, und R. Ewerth, „Ontology-driven Event Type Classification in Images“, in IEEE Winter Conference on Applications of Computer Vision, WACV 2021, Virtual Event, January 3-8, 2021, 2021, S. 2927–2937. doi: 10.1109/WACV48630.2021.00297.
- E. Müller-Budack, K. Pustu-Iren, S. Diering, *M. Springstein*, und R. Ewerth, „Image Analytics in Web Archives“, in The Past Web: Exploring Web Archives, Springer International Publishing, 2021, S. 141–151. doi:10.1007/978-3-030-63291-5_11. 
- S. Schneider, *M. Springstein*, J. Rahnama, E. Hüllermeier, R. Ewerth, und H. Kohle, „The Dissimilar in the Similar. An Attribute-guided Approach to the Subject-specific Classification of Art-historical Objects“, in Jahrestagung der Gesellschaft für Informatik, INFORMATIK 2020, Karlsruhe, Germany, September 28 - October 2, 2020, 2020, S. 1355–1364. doi: 10.18420/INF2020\_127.
- C. Otto, *M. Springstein*, A. Anand, und R. Ewerth, „Characterization and Classification of Semantic Image-Text Relations“, International Journal of Multimedia Information Retrieval, Bd. 9, Nr. 1, S. 31–45, 2020, doi: 10.1007/s13735-019-00187-6.
- C. Otto, *M. Springstein*, A. Anand, und R. Ewerth, „Understanding, Categorizing and Predicting Semantic Image-Text Relations“, in International Conference on Multimedia Retrieval, ICMR 2019, Ottawa, ON, Canada, June 10-13, 2019, 2019, S. 168–176. doi: 10.1145/3323873.3325049.
- *M. Springstein*, H. H. Nguyen, A. Hoppe, und R. Ewerth, „TIB-arXiv: An Alternative Search Portal for the arXiv Pre-print Server“, in International Conference on Theory and Practice of Digital Libraries, TPDL 2018, Porto,Portugal, September 10-13, 2018, 2018, Bd. 11057, S. 295–298. doi: 10.1007/978-3-030-00066-0\_26.
- R. Ewerth, *M. Springstein*, E. Müller, A. Balz, J. Gehlhaar, T. Naziyok, u. a., „Estimating relative depth in single images via rankboost“, in IEEE International Conference on Multimedia and Expo, ICME 2017, Hong Kong, China, July 10-14, 2017, 2017, S. 919–924. doi: 10.1109/ICME.2017.8019434.
- R. Ewerth, *M. Springstein*, L. A. Phan-Vogtmann, und J. Schütze, „"Are Machines Better Than Humans in Image Tagging?" - A User Study Adds to the Puzzle“, in European Conference on Information Retrieval, ECIR 2017, Aberdeen, UK, April 8-13, 2017, 2017, Bd. 10193, S. 186–198. doi: 10.1007/978-3-319-56608-5\_15.
- E. Müller, *M. Springstein*, und R. Ewerth, „"When Was This Picture Taken?" - Image Date Estimation in the Wild“, in European Conference on Information Retrieval, ECIR 2017, Aberdeen, UK, April 8-13, 2017, 2017, S. 619–625. doi: 10.1007/978-3-319-56608-5\_57. 
- M. Mühling, N. Korfhage, E. Müller, C. Otto, *M. Springstein*, T. Langelage, u. a., „Deep learning for content-based video retrieval in film and television production“, Multimedia Tools and Applications, Bd. 76, Nr. 21, S. 22169–22194, 2017, doi: 10.1007/s11042-017-4962-9.
- *M. Springstein* und R. Ewerth, „On the Effects of Spam Filtering and Incremental Learning for Web-Supervised Visual Concept Classification“, in ACM International Conference on Multimedia Retrieval, ICMR 2016, New York, New York, USA, June 6-9, 2016, 2016, S. 377–380. doi: 10.1145/2911996.2912072.
]
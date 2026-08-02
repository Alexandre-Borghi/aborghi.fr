// ============================================================
// aborghi.fr — site bundle entry point.
//
// Build:
//   typst compile --features bundle,html --format bundle site.typ dist
//
// Emits the whole site into dist/: the landing page, each case
// study, and the shared assets (CSS, favicon, images).
// ============================================================

#import "/template.typ": *

// ---- Landing page -------------------------------------------
#document("index.html")[
  #page(
    title: "Alexandre Borghi — Ingénieur logiciel indépendant",
    description: "Ingénieur logiciel indépendant, backend et intégration de systèmes. Des logiciels simples, maintenables et faits pour durer.",
    canonical: "https://aborghi.fr/",
    og: (
      title: "Alexandre Borghi — Ingénieur logiciel indépendant",
      description: "Backend et intégration de systèmes. Des logiciels simples, maintenables et faits pour durer.",
      url: "https://aborghi.fr/",
      image: "https://aborghi.fr/assets/og.png",
      alt: "Alexandre Borghi — ingénieur logiciel indépendant",
    ),
  )[
    #e("main")[

      // -- Hero --
      #e("header", attrs: (class: "hero"))[
        #e("div", attrs: (class: "wrap"))[
          #e("img", attrs: (
            class: "avatar", src: "assets/avatar-sm.jpg", width: "100", height: "100",
            alt: "Portrait d'Alexandre Borghi", fetchpriority: "high", decoding: "async",
          ))
          #e("p", attrs: (class: "eyebrow"))[Ingénieur logiciel indépendant]
          #e("h1")[Alexandre~Borghi]
          #e("p", attrs: (class: "lede"))[Je conçois des systèmes backend _simples_, maintenables et faits pour durer.]
          #e("p", attrs: (class: "intro"))[
            Développement web orienté backend, pipelines de données et intégration
            de systèmes IT. Une attention particulière pour l'industrie et les
            outils métier, là où un logiciel bien construit change vraiment le
            quotidien des équipes.
          ]
          #contact-actions("Me contacter", "LinkedIn")
        ]
      ]

      #divider

      // -- Approche --
      #e("section", attrs: (id: "approche"))[
        #e("div", attrs: (class: "wrap"))[
          #section-head("01", [Ma façon de travailler])
          #e("p", attrs: (class: "lead"))[
            Un logiciel de qualité n'est pas seulement un logiciel qui marche :
            c'est un logiciel *qu'on comprend*, simple à faire évoluer et à
            maintenir longtemps après sa mise en production. C'est l'artisanat
            que je mets dans chaque projet.
          ]
          #e("div", attrs: (class: "cards"))[
            #card("01", [Comprendre avant de coder])[
              Je pars du problème et des contraintes réelles, pas d'une solution
              toute faite. Bien cadrer, c'est éviter de construire la mauvaise chose — vite.
            ]
            #card("02", [Livrer par incréments])[
              Le premier périmètre réellement utile part en production tôt, puis
              évolue au rythme des retours. La valeur arrive vite, le risque reste maîtrisé.
            ]
            #card("03", [Bâtir pour l'exploitation])[
              Tests, sauvegardes, environnements séparés, déploiements
              reproductibles. Un système sérieux se maintient sereinement, sans mauvaises surprises.
            ]
          ]
        ]
      ]

      #divider

      // -- Étude de cas --
      #e("section", attrs: (id: "etude-de-cas"))[
        #e("div", attrs: (class: "wrap"))[
          #section-head("02", [Étude de cas])
          #e("a", attrs: (class: "case", href: "case-studies/junior-utc-erp.html"))[
            #e("span", attrs: (class: "case-meta"))[Junior UTC · ERP interne · Node, PostgreSQL, Typst]
            #e("h3")[Générer des documents contractuels dans un cadre légal qui change]
            #e("p")[
              Les documents contractuels étaient rédigés à la main, au prix de cinq
              à dix allers-retours qualité par étude. J'ai conçu et développé un ERP
              interne qui les génère automatiquement — pensé dès le départ pour que
              les évolutions réglementaires ne redeviennent jamais un chantier.
            ]
            #e("ul", attrs: (class: "metrics"))[
              #metric([÷5], [relectures qualité par document])
              #metric([1 semaine], [pour absorber un changement légal majeur])
              #metric([18 mois], [en production, et toujours étendu])
            ]
            #e("span", attrs: (class: "case-link"))[
              Lire l'étude de cas #e("span", attrs: (class: "arrow"))[→]
            ]
          ]
        ]
      ]

      #divider

      // -- Contact --
      #e("section", attrs: (id: "contact", class: "contact"))[
        #e("div", attrs: (class: "wrap"))[
          #section-head("03", [Travaillons ensemble])
          #e("p")[
            Un projet backend, une intégration de systèmes ou un outil métier à
            construire~? Écrivez-moi — je lis et je réponds à chaque message.
          ]
          #contact-actions("contact@aborghi.fr", "alexandre-borghi")
        ]
      ]
    ]

    #site-footer
  ]
]

// ---- Case study: Junior UTC ERP -----------------------------
#document("case-studies/junior-utc-erp.html")[
  #page(
    title: "Générer des documents contractuels dans un cadre légal qui change — Alexandre Borghi",
    description: "Étude de cas : un ERP interne conçu pour que les changements réglementaires ne redeviennent jamais un chantier. Relectures qualité divisées par cinq.",
    base: "../",
    canonical: "https://aborghi.fr/case-studies/junior-utc-erp.html",
    og: (
      title: "Générer des documents contractuels dans un cadre légal qui change",
      description: "Étude de cas — un ERP interne toujours en production après 18 mois, relectures qualité divisées par cinq, changement réglementaire absorbé en une semaine.",
      url: "https://aborghi.fr/case-studies/junior-utc-erp.html",
      image: "https://aborghi.fr/assets/og.png",
      alt: "Alexandre Borghi — ingénieur logiciel indépendant",
    ),
  )[
    #e("main")[
      #e("article", attrs: (class: "article"))[
        #backlink("../index.html")
        #include "case-studies/junior-utc-erp.typ"
      ]
    ]
    #site-footer
  ]
]

// ---- Shared assets ------------------------------------------
#asset("assets/site.css", read("assets/site.css", encoding: none))
#asset("assets/favicon.svg", read("assets/favicon.svg", encoding: none))
#asset("assets/avatar-sm.jpg", read("assets/avatar-sm.jpg", encoding: none))
#asset("assets/og.png", read("assets/og.png", encoding: none))

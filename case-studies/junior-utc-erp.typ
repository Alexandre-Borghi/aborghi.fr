#import "/template.typ": *

#set text(lang: "fr", region: "FR")
#show " :": [~:]

// ---- Illustrations ---------------------------------------------

// Roadmap: the four delivery increments, with the first three
// (shipped ~4 months in) highlighted against the fourth, absorbed
// over the following year. Illustrates "livraisons incrémentales".
#let illus-roadmap = figure-frame(
  alt: "Feuille de route en quatre incréments : authentification, gestion des études et génération des documents d'étude livrés en production après quatre mois ; les documents de trésorerie intégrés sur l'année suivante.",
  box(width: 600pt, height: 195pt)[
  #let axis-y = 85pt
  #let nodes = (75pt, 225pt, 375pt, 525pt)

  // highlight band over production
  #place(dx: nodes.at(2), dy: 63pt, rect(width: nodes.at(-1) - nodes.at(2) + 100pt, height: 44pt, radius: (left: 8pt, right: 0pt), fill: c-accent-soft))
  #place(dx: nodes.at(2) - 75pt, dy: 47pt, centered(150pt, text(font: font-mono, size: 13pt, fill: c-muted)[4 mois]))
  #place(dx: nodes.at(2), dy: 47pt, centered(nodes.at(-1) - nodes.at(2) + 100pt, text(font: font-sans, size: 13pt, fill: c-accent-2)[Production]))

  // axis + nodes
  #place(dx: nodes.at(0), dy: axis-y, line(start: (0pt, 0pt), end: (nodes.at(3) - nodes.at(0), 0pt), stroke: (paint: c-line-2, thickness: 1.5pt)))
  #place(dx: nodes.at(-1), dy: axis-y, line(length: 100pt, stroke: (paint: c-line-2, thickness: 1.5pt, dash: "dashed")))
  #for x in nodes.slice(0, 2) {
    place(dx: x - 7pt, dy: axis-y - 7pt, circle(radius: 7pt, fill: c-accent))
  }
  #place(dx: nodes.at(2) - 25pt, dy: axis-y, line(stroke: (thickness: 14pt, paint: c-accent, cap: "round"), length: 50pt))
  #place(dx: nodes.at(3) - 7pt, dy: axis-y - 7pt, circle(radius: 7pt, stroke: c-faint, fill: c-bg))

  // step labels
  #place(dx: nodes.at(0) - 75pt, dy: 120pt, centered(150pt, text(font: font-sans, size: 15pt, fill: c-text)[Authentification]))
  #place(dx: nodes.at(1) - 75pt, dy: 120pt, centered(150pt, text(font: font-sans, size: 15pt, fill: c-text)[Gestion des études]))
  #place(dx: nodes.at(2) - 75pt, dy: 120pt, centered(150pt, text(font: font-sans, size: 15pt, fill: c-text)[Génération des documents]))
  #place(dx: nodes.at(3) - 75pt, dy: 120pt, centered(150pt, text(font: font-sans, size: 15pt, fill: c-text)[Documents de trésorerie]))
])

// The templates repo standing apart from the app, connected only
// by a dashed line: modifying one never touches the other. Pairs
// with the Word-vs-Typst decision and the April 2025 test of it.
#let illus-decoupled-repos = figure-frame(
  alt: "Le dépôt des modèles Typst et l'application ERP sont deux dépôts distincts, reliés seulement par une ligne pointillée : modifier l'un ne touche jamais l'autre.",
  caption: "Les modèles vivent dans un dépôt distinct de l'application",
  box(width: 500pt, height: 90pt)[
  #let card(x, title, subtitle) = {
    place(dx: x, dy: 10pt, rect(width: 150pt, height: 70pt, radius: 10pt, stroke: (paint: c-line-2, thickness: 1.5pt)))
    place(dx: x, dy: 28pt, centered(150pt, text(font: font-sans, size: 15pt, fill: c-text)[#title]))
    place(dx: x, dy: 54pt, centered(150pt, text(font: font-mono, size: 12.5pt, fill: c-muted)[#subtitle]))
  }
  #card(75pt, [Dépôt modèles], [Typst])
  #card(275pt, [Application], [Node, PostgreSQL])
  #place(dx: 225pt, dy: 43pt, line(start: (0pt, 0pt), end: (50pt, 0pt), stroke: (paint: c-faint, thickness: 1.5pt, dash: "dashed")))
])

#article-header(
  meta: "Junior UTC · ERP interne · Node, PostgreSQL, Typst",
  title: [Générer des documents contractuels dans un cadre légal qui change],
)

#standfirst[
  Au début de mon aventure en tant que Responsable DSI à Junior UTC,
  les chargés d'affaires rédigeaient à la main les documents contractuels de leurs études.
]

J'ai conçu et développé un ERP interne pour les générer automatiquement,
avec une contrainte en tête :
la réglementation évolue,
et la mise à jour des documents ne devait jamais redevenir un chantier.

La première version est partie en production quatre mois après le démarrage.
Un an et demi plus tard,
l'outil est toujours utilisé,
le nombre de relectures qualité a été divisé par cinq,
et les changements réglementaires majeurs sont absorbés en une semaine.

#divider

= Le contexte

Les Junior-Entreprises sont des associations étudiantes permettant aux étudiants
de leur école de réaliser des missions rétribuées pour des clients réels.

Junior UTC est la Junior-Entreprise de l'Université de Technologie de Compiègne.
44 ans d'existence, 90k€ de chiffre d'affaires pour 25 études en 2025.
J'y ai occupé le poste de Responsable DSI pendant un an et demi,
de septembre 2024 à février 2026.

= Le problème

Chaque étude est rythmée par la signature de documents contractuels.
Quand j'ai intégré la structure,
les chargés d'affaires les rédigeaient manuellement à partir de modèles Word.

Pour garantir la conformité,
chaque document doit être relu et validé par un chargé qualité.
Tant que le document n'est pas conforme,
la liste des problèmes est renvoyée au chargé d'affaires
et le cycle se répète jusqu'à validation.

Un document écrit à la main n'est jamais parfait du premier coup.
On comptait alors en moyenne *cinq à dix* allers-retours,
selon les indicateurs du pôle Qualité.
Pendant ce temps, le client attend.
Et les délais de signature deviennent difficiles à tenir
pour des étudiants bénévoles qui travaillent entre deux cours.

= Les contraintes

On m'a parlé de cette problématique dès mon entretien de recrutement
(c'est dire à quel point le problème était pesant).
En quittant la visio ce soir-là,
je me suis dit : "Il faut automatiser tout ça !"

Mais au lieu de foncer sur une solution,
je voulais être sûr de bien comprendre le contexte.
J'ai invité tout le monde à une réunion,
surtout ceux qui allaient bientôt finir leur mandat pour avoir leur retour d'expérience.

#quote(block: true, quotes: true)[On avait bien un ERP avant,
  il générait les documents à partir de templates Word.
  Mais, suite à de gros changements du cadre légal,
  on a dû refaire tous nos documents.
  Personne n'avait le temps ou les compétences de modifier les templates,
  donc on s'est rabattus sur la rédaction manuelle.]

Cette discussion a posé les contraintes fortes pour la réussite du projet :

- Éliminer le temps passé à mettre en page les documents et réduire les allers-retours qualité ;
- Adapter facilement et rapidement les documents en cas de changements du cadre légal ;
- Faciliter l'utilisation pour un chargé d'affaires qui reprend des études après une courte formation.

= La démarche

== Comprendre avant de développer

Pour obtenir un cahier des charges clair et complet,
j'ai commencé par une série d'entretiens avec les trois pôles concernés :

- Le pôle Commercial voulait accélérer les opérations ;
- Le pôle Qualité, garantir la conformité ;
- Le pôle Trésorerie, obtenir des chiffrages corrects et suivre les délais.

Une fois les process définis,
les règles métier validées
et les attentes comprises,
j'ai commencé l'implémentation.

== Des livraisons incrémentales pour des retours rapides

La feuille de route a été découpée en incréments livrables :

+ L'authentification ;
+ La gestion des études ;
+ La génération des documents d'étude ;
+ Puis celle des documents de trésorerie.

Plutôt que d'attendre un produit complet,
le premier périmètre réellement utile est parti en production à la mi-décembre,
environ quatre mois après le démarrage.
Le reste a été intégré au fil de l'année suivante,
en s'appuyant continuellement sur les retours des utilisateurs.

#illus-roadmap

== Poser les bases d'une exploitation stable

Un outil qui produit des documents contractuels et suit des flux de trésorerie
doit pouvoir être exploité sérieusement :

- *Authentification SAML* pour que chacun puisse se connecter avec son compte
  Google Workspace, dès qu'il rejoint la structure, sans étape supplémentaire.
- *Tests d'intégration* contre une véritable base PostgreSQL démarrée dans Docker,
  avec une base dédiée par test,
  donc parallélisables sans interférence.
- *Deux environnements sur des serveurs distincts* :
  l'un pour tester les nouvelles fonctionnalités
  et former les arrivants sans risque pour les données réelles,
  l'autre pour la production.
- *Sauvegardes* incrémentales, chiffrées, purgées selon un calendrier de rétention
  et répliquées dans le cloud,
  conformément à la règle "3-2-1".
  Leur déploiement est décrit avec Ansible, donc reproductible et auto-documenté.

== Le choix le plus difficile : Typst plutôt que Word

D'après l'historique,
les modèles `.docx` s'imposaient comme une évidence.
Puis j'ai fait mes recherches :
peu de librairies existent pour manipuler les fichiers Word.
Le rendu est rarement parfait,
écrire un modèle demande de connaître une syntaxe obscure
et les fonctionnalités avancées (images, tableaux...) requièrent souvent une licence coûteuse,
hors du budget d'une asso à but non lucratif.

En parallèle,
j'ai découvert Typst.
Cet été-là,
j'ai rédigé mon premier rapport d'alternance avec,
et j'ai été bluffé par sa puissance et la qualité du rendu.
Typst est un langage de composition de documents,
semblable au LaTeX dans l'esprit.
Un modèle est un fichier texte,
dans lequel on peut utiliser des conditions, des boucles et des calculs.
On peut le stocker dans un dépôt Git,
où chaque modification est datée, attribuée et expliquée.
Par contre, il génère des PDF, pas des `.docx`.

#quote(block: true, quotes: true)[Oui mais, Alexandre, le document Word on peut le modifier s'il y a un problème.

  -- Et si... le document était toujours parfait ?
     Et puis, sur des documents qui engagent juridiquement la structure,
     pouvoir modifier un contrat sans que personne ne le sache n'est pas vraiment un avantage.]

C'était un pari risqué :

+ L'outil doit être complet pour ne pas manquer un cas limite ;
+ La technologie doit être assez simple à apprendre pour perdurer.

Le premier point a été résolu de manière incrémentale,
et l'ERP est maintenant au centre de la question en cas de changement de process.
Pour le deuxième point :
mon successeur,
sans aucune connaissance préalable de Typst,
a déjà réalisé et mis en production des évolutions majeures des documents depuis mon départ.

Aujourd'hui,
plus un seul chargé d'affaires n'imagine avoir à éditer un document Word.
En un clic,
le document est prêt à être envoyé au client.
La transition est totale,
*c'est la plus belle réussite de ce projet*.

= L'épreuve du réel : avril 2025

En avril 2025,
le cadre légal des Junior-Entreprises a de nouveau évolué,
de manière importante.
C'était exactement le scénario contre lequel le système avait été conçu,
et l'occasion de vérifier si le pari tenait.

Les modèles vivant dans un dépôt distinct de l'application,
j'ai pu travailler dessus sans toucher au produit.
J'ai fait les modifications sur une branche Git
et je les ai testées sur ma machine à partir de cas réels.
La revue avec la Responsable Qualité n'a porté que sur les différences entre l'ancienne et la nouvelle version,
ce qui est autrement plus sûr que de relire un document entier à la recherche de ce qui a changé.

#illus-decoupled-repos

La mise en production des nouveaux modèles n'a eu aucun impact sur l'application.
Modifications, revue et publication : *une semaine* au total,
là où la refonte documentaire précédente avait purement et simplement fait perdre la génération automatique.

= Ce que je referais autrement

Au démarrage, j'ai misé sur la simplicité de l'architecture :
un serveur web, dont les routes parlent directement à la base de données.
Ce choix m'a permis d'avancer vite jusqu'aux premiers déploiements en production.
Mais au fur et à mesure,
le code est devenu un bloc monolithique difficile à faire évoluer.

Cela pose également des limites organisationnelles.
Sans frontières nettes, il est plus compliqué de se répartir les tâches.
Ce qui nous a fait gagner beaucoup de temps au début,
nous a fait perdre des opportunités de paralléliser l'avancement par la suite.

Je l'ai appris avec ce projet,
et maintenant l'architecture est ma priorité pour tout système
trop vaste pour un seul fichier de code.
J'ai engagé la migration vers une architecture modulaire avant la fin de mon mandat,
et elle se poursuit aujourd'hui.

= Les résultats

La rédaction manuelle a disparu du travail des dix chargés d'affaires :
il leur reste à saisir les données de l'étude dans l'outil,
qui produit ensuite les documents.

L'indicateur suivi par la Qualité est passé de cinq à dix allers-retours par document à un ou deux,
ce qui représente,
sur 20 à 30 études par an,
plusieurs centaines de cycles de relecture évités.

Les documents sont homogènes, conformes,
et partent plus vite chez le client.
Le changement réglementaire d'avril 2025 a été absorbé en une semaine,
revue comprise.

Enfin, l'ERP est toujours en production,
et il figure aujourd'hui parmi les outils stratégiques de la structure.
Il est d'autant plus sollicité que celle-ci grandit,
et les équipes qui se succèdent depuis mon départ continuent de l'étendre.

#e("ul", attrs: (class: "metrics"))[
  #metric([÷5], [relectures qualité par document])
  #metric([1 semaine], [pour absorber un changement légal majeur])
  #metric([18 mois], [en production, et toujours étendu])
]

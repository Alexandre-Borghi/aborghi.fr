// ============================================================
// aborghi.fr — shared Typst template for the HTML bundle.
// Page shell (full <head> control), inline icons, and the
// component helpers used by the landing page and case studies.
// ============================================================

#let e = html.elem

// ---- Site constants -----------------------------------------
#let email = "contact@aborghi.fr"
#let linkedin = "https://www.linkedin.com/in/alexandre-borghi/"

// ---- Icons --------------------------------------------------
// Referenced from a single shared sprite (assets/icons.svg) so
// the browser caches one file across every page. `currentColor`
// still flows in, so icons take the colour of their button.
#let icon(name, base) = e("svg", attrs: (class: "icon", "aria-hidden": "true"))[
  #e("use", attrs: ("href": base + "assets/icons.svg#" + name))
]

// ---- Page shell ---------------------------------------------
// `base` is the relative prefix to the site root ("" at root,
// "../" one level down) so shared assets resolve on every page.
// `og` is an optional dict: (title, description, url, image, alt).
#let page(
  title: none,
  description: "",
  base: "",
  canonical: none,
  og: (:),
  body,
) = e("html", attrs: (lang: "fr"))[
  #e("head")[
    #e("meta", attrs: (charset: "utf-8"))
    #e("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))
    #e("title")[#title]
    #e("meta", attrs: (name: "description", content: description))
    #e("meta", attrs: (name: "author", content: "Alexandre Borghi"))
    #if canonical != none { e("link", attrs: (rel: "canonical", href: canonical)) }

    #e("meta", attrs: (property: "og:type", content: "website"))
    #e("meta", attrs: (property: "og:locale", content: "fr_FR"))
    #e("meta", attrs: (property: "og:title", content: og.at("title", default: title)))
    #e("meta", attrs: (property: "og:description", content: og.at("description", default: description)))
    #if "url" in og { e("meta", attrs: (property: "og:url", content: og.url)) }
    #if "image" in og [
      #e("meta", attrs: (property: "og:image", content: og.image))
      #e("meta", attrs: (property: "og:image:width", content: "1200"))
      #e("meta", attrs: (property: "og:image:height", content: "630"))
      #e("meta", attrs: (property: "og:image:alt", content: og.at("alt", default: title)))
      #e("meta", attrs: (name: "twitter:card", content: "summary_large_image"))
      #e("meta", attrs: (name: "twitter:image", content: og.image))
    ]

    #e("link", attrs: (rel: "icon", href: base + "assets/favicon.svg"))
    #e("link", attrs: (rel: "stylesheet", href: base + "assets/site.css"))
  ]
  #e("body")[#body]
]

// ---- Shared components --------------------------------------
#let btn(label, href: "", variant: "primary", glyph: none, external: false) = {
  let attrs = (class: "btn btn-" + variant, href: href)
  if external { attrs += (target: "_blank", rel: "noopener") }
  e("a", attrs: attrs)[#glyph#label]
}

// The email + LinkedIn button pair, reused in hero, contact and CTA.
// `base` points icons at the shared sprite from any page depth.
#let contact-actions(email-label, linkedin-label, base: "") = e("div", attrs: (class: "actions"))[
  #btn(email-label, href: "mailto:" + email, variant: "primary", glyph: icon("mail", base))
  #btn(linkedin-label, href: linkedin, variant: "ghost", glyph: icon("linkedin", base), external: true)
]

#let section-head(index, title) = e("div", attrs: (class: "section-head"))[
  #e("span", attrs: (class: "section-index"))[#index]
  #e("h2")[#title]
]

#let card(k, title, body) = e("div", attrs: (class: "card"))[
  #e("span", attrs: (class: "k"))[#k]
  #e("h3")[#title]
  #e("p")[#body]
]

#let metric(value, label) = e("li")[
  #e("strong")[#value]
  #e("span")[#label]
]

#let site-footer = e("footer")[
  #e("div", attrs: (class: "wrap"))[
    #e("span")[© 2026 Alexandre Borghi]
    #e("span", attrs: (class: "sig"))[Fait avec soin.]
  ]
]

// ---- Case-study helpers -------------------------------------
#let divider = e("hr", attrs: (class: "divider"))

#let backlink(href) = e("a", attrs: (class: "backlink", href: href))[← Retour à l'accueil]

#let article-header(meta: "", title: none) = [
  #e("p", attrs: (class: "article-meta"))[#meta]
  #e("h1")[#title]
]

#let standfirst(body) = e("p", attrs: (class: "standfirst"))[#body]

// Closing call-to-action, appended to every case study.
#let case-cta(base: "") = e("aside", attrs: (class: "cta"))[
  #e("h2")[Un projet dans le même esprit ?]
  #e("p")[
    Backend, intégration de systèmes ou outil métier : si vous voulez un logiciel
    simple, solide et fait pour durer, parlons-en. Je réponds à chaque message.
  ]
  #contact-actions("Me contacter", "LinkedIn", base: base)
]

// Full case-study page: shared shell + reading column + backlink
// + the closing CTA + footer. Every case study goes through this,
// so the call-to-action is guaranteed and consistent.
#let case-study-page(
  title: none,
  description: "",
  canonical: none,
  og: (:),
  body,
) = page(
  title: title,
  description: description,
  base: "../",
  canonical: canonical,
  og: og,
)[
  #e("main")[
    #e("article", attrs: (class: "article"))[
      #backlink("../index.html")
      #body
      #case-cta(base: "../")
    ]
  ]
  #site-footer
]

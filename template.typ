// ============================================================
// aborghi.fr — shared Typst template for the HTML bundle.
// Page shell (full <head> control), inline icons, and the
// component helpers used by the landing page and case studies.
// ============================================================

#let e = html.elem

// ---- Site constants -----------------------------------------
#let email = "contact@aborghi.fr"
#let linkedin = "https://www.linkedin.com/in/alexandre-borghi/"

// ---- Inline icons (inherit currentColor) --------------------
#let icon-mail = e("svg", attrs: (
  viewBox: "0 0 24 24", fill: "none", stroke: "currentColor",
  "stroke-width": "1.8", "stroke-linecap": "round", "stroke-linejoin": "round",
))[
  #e("rect", attrs: (x: "3", y: "5", width: "18", height: "14", rx: "2"))
  #e("path", attrs: (d: "m3 7 9 6 9-6"))
]

#let icon-linkedin = e("svg", attrs: (viewBox: "0 0 24 24", fill: "currentColor"))[
  #e("path", attrs: (d: "M4.98 3.5C4.98 4.88 3.87 6 2.5 6S0 4.88 0 3.5 1.12 1 2.5 1s2.48 1.12 2.48 2.5zM.24 8h4.52v14H.24V8zm7.5 0h4.33v1.92h.06c.6-1.14 2.08-2.34 4.28-2.34 4.58 0 5.42 3.01 5.42 6.93V22h-4.52v-6.63c0-1.58-.03-3.62-2.2-3.62-2.2 0-2.54 1.72-2.54 3.5V22H7.74V8z"))
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
#let btn(label, href: "", variant: "primary", icon: none, external: false) = {
  let attrs = (class: "btn btn-" + variant, href: href)
  if external { attrs += (target: "_blank", rel: "noopener") }
  e("a", attrs: attrs)[#icon#label]
}

// The email + LinkedIn button pair, reused in hero and contact.
#let contact-actions(email-label, linkedin-label) = e("div", attrs: (class: "actions"))[
  #btn(email-label, href: "mailto:" + email, variant: "primary", icon: icon-mail)
  #btn(linkedin-label, href: linkedin, variant: "ghost", icon: icon-linkedin, external: true)
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

// A block quotation. `by` adds a monospace attribution line.
#let bquote(body, by: none) = e("blockquote")[
  #body
  #if by != none { e("span", attrs: (class: "attribution"))[#by] }
]

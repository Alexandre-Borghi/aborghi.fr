#let e = html.elem

#let template(body) = [
  #e("html")[
    #e("head")[
      #e("meta", attrs: (charset: "utf-8"))
      #e("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))
      #e("title", (context document.title) + " | Alexandre Borghi")
      #e("meta", attrs: (name: "author", content: "Alexandre Borghi"))
      #e("link", attrs: (rel: "stylesheet", href: "style.css"))
    ]
    #e("body")[#body]
  ]
]

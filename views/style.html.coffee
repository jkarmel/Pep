application
  head: ->
    title "Style Guide | Feel Well Labs"
  body: ->
    div ".page", ->
      h1 ".sep", "Style Guide"
      h1 "Heading 1"
      h1 -> a href: 'javascript:void(0);', "Heading 1 anchor"
      h2 "Heading 2"
      h3 "Heading 3"
      p "This is a paragraph (p) in a page"
      p "This is a p below another p"
      p ->
        i "italic text "
        b "bold text "
        a href: "javascript:void(0);", "anchor"
      ol ->
        li "li inside ol"
        li "li inside ol"
      ul ->
        li "li inside ul"
        li "li inside ul"
      div ".three.sections", ->
        div ".section", -> "1st .section in .three.sections"
        div ".section", "2nd .section"
        div ".section", ->
          h3 "3rd .section (heading 3)"

      div ".two.sections", ->
        div ".section", "1st .section in .two.sections"
        div ".section", ->
          p "2nd .section p"

      div ".three.narrow.sections", ->
        div ".section", -> "1st .section in .three.narrow.sections"
        div ".section", "2nd .section"
        div ".section", ->
          h3 "3rd .section (heading 3)"

      div ".two.narrow.sections", ->
        div ".section", "1st .section in .two.narrow.sections"
        div ".section", ->
          p "2nd .section p"

      p ".mission-statement", "p.mission-statement"

      p ".transition", "p.transition"

      p ".center", "p.center"

      p ".small", "*p.small"

      h1 ".sep", "Forms"
      p ->
        input type: 'submit', value: "input[type='submit'] | [type='button']"
      p ->
        input ".disabled", type: 'submit', value: "input.disabled"
      p ->
        input ".disabled.loading", type: 'submit', value: "input.disabled.loading"
      p ->
        input type: 'text', value: "input[type='text']"
      p ->
        textarea "textarea"
      h1 ".sep", "Chat"
    div ".page", ->
      div '.session', ->
        div '.sidebar', ->
          div '.profile.detail', ->
            h3 "Abhik Pramanik"
            p '.desc', ->
              img src: '/images/abhik.jpg'
              text """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent magna lacus, vulputate a pretium non, cursus in mauris. Nam non nisl luctus erat imperdiet tempus a in erat. Morbi sapien leo, fermentum sit amet lobortis non, pellentesque sed tellus. Vivamus faucibus cursus massa, eu consectetur tortor dictum eget. Suspendisse potenti. Nulla vulputate purus interdum massa accumsan pellentesque. Sed at dictum.
              """

          div '.detail', "a .detail"
        div '.chat', ->
          div '.log', style: 'height: 600px;', ->
            div '.message.other', ->
              p '.sender', 'Abhik'
              p '.body', 'Hey!'
            div '.message', ->
              p '.body', "Hey Mary! How's it going? Are you doing well? sdlkfjsdlkfjs sldkfjsldkfjsd lsdkjflskdjf sdlfkjsldkjf "
          div '.composer', ->
              textarea "poop"

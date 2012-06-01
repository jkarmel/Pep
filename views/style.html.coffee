application
  head: ->
    title "Style Guide | Feel Well Labs"
  body: ->
    div ".page", ->
      h1 ".sep.center", "Style Guide"
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

      p ".center", "*.center"

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
        input type: 'text', placeholder: "input[type='text'][placeholder=]"
      p ->
        textarea "textarea"

      p ->
        select name: "pretty", tabindex: "1", ->
          option "Choose a reaction"
          option value: "amazed", "Amazed"
          option value: "bored", "Bored"
          option value: "surprised", "Surprised"

      form ->
        p "form"
        fieldset ->
          div ".field", ->
            label "Label"
            div ".controls", ->
              input type: 'text', value: ".controls input[type='text']"
          div ".field", ->
            label "Label 2"
            div ".controls", ->
              textarea "textarea"
          div ".field", ->
            label "Label 3"
            div ".controls", ->
              input type: 'text', value: ".controls input[type='text']"

      form ".small", ->
        p "form.small"
        fieldset ->
          div ".field", ->
            label "Label"
            div ".controls", ->
              input type: 'text', value: ".controls input[type='text']"
          div ".field", ->
            label "Label 2"
            div ".controls", ->
              textarea "textarea"
          div ".field", ->
            label "Label 3"
            div ".controls", ->
              input type: 'text', value: ".controls input[type='text']"

    div ".page", ->
      h1 ".sep", "Chat"
      div '.session', ->
        div '.panes', ->
          div '.profile.pane', ->
            h3 'Feelings & Thoughts'
            h4 '.step', 'Feelings Before'
            ul ->
              li ->
                text "Angry - "
                b "8"
              li ->
                text "Frustrated - "
                b "9"
            h4 '.step', 'Thoughts'
            ul ->
              li "I will lose my home"
              li "I am a horrible money manager"

            h4 '.step.current', 'Feelings After'
            ul ->
              li ->
                text "Angry - "
                b "5"
              li ->
                text "Frustrated - "
                b "6"
          div '.profile.pane', ->
            h3 'Results'
            h4 '.step', 'Before'
            ul ->
              li ->
                text "Angry - "
                b "8"
              li ->
                text "Frustrated - "
                b "9"
            h4 '.step.current', 'After'
            ul ->
              li ->
                text "Angry - "
                b "5"
              li ->
                text "Frustrated - "
                b "6"
          div '.profile.pane', ->
            h3 'Payment'


        div '.chat', ->
          div '.messages', style: 'height: 600px;', ->
            div '.message.other', ->
              p '.sender', 'Abhik'
              p '.body', 'Hey!'
            div '.message', ->
              p '.body', "Hey Mary! How's it going? Are you doing well? sdlkfjsdlkfjs sldkfjsldkfjsd lsdkjflskdjf sdlfkjsldkjf "
          div '.composer', ->
              textarea "poop"

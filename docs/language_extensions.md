# Language Extensions in sprocketjs

In the `gulpjs` world, we deal with vinyl streams, which is the foundation of many of gulp plugins. So its easily to link them with sprocket, we just need to create a close loop of streams so that language with extensions can be compiled to their final state.

A typical loop would be:

* `.scss` -> `.css`
* `.less` -> `.css`
* `.ls` -> `.js`
* `.coffee` -> `.js`

We might add supports for gulp template in the future.


![sprocket-streams](https://cloud.githubusercontent.com/assets/922234/3299883/964c664e-f619-11e3-81d4-53dc9ccdb69d.png)

Once all the files are compiled and linted, we can end the stream and emits output.

## List of currently supported languages

* javascript
* LiveScript
* cascading stylesheets (CSS)
* Syntactically Awesome Style Sheets (Sass)

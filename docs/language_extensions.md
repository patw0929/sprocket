# Language Extensions in sprocketjs

In the `gulpjs` world, we deal with vinyl streams, which is the foundation of many of gulp plugins. So its easily to link them with sprocket, we just need to create a close loop of streams so that files can be compiled to their final state.

![sprocket-streams](https://cloud.githubusercontent.com/assets/922234/3280647/f066a0ba-f473-11e3-880d-58ddfa3aeb52.png)

Once all the files are compiled and linted, we can end the stream and emits output.


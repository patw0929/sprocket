# Seamless Integration in sprocketjs

Two images are worth a thousand words.

**Development**

![2014-06-27 11 56 47](https://cloud.githubusercontent.com/assets/922234/3414300/ffb905ea-fe13-11e3-885b-22f3876ffe0e.png)

**Production**

![2014-06-27 12 34 11](https://cloud.githubusercontent.com/assets/922234/3401425/3de9f6e0-fd50-11e3-8452-f6661c556eed.png)


## What does sprocketjs do in development?

First, it resolves dependencies of all files that are passed in to sprocketjs stream. Since we can build a dependency graph based on this, it's easy to generated a ordered list of files based on the triversal of the graph.

The ordered list then later outputted to the html, generating `script/style` tags. The resulting html looks just like you're writting `script/style` tags yourself. But by declaring your dependencies explicitly, you and your team would never have to bother on this anymore.

Just require it, and it works.


## What does sprocketjs do in production?

For production, sprocketjs will automatically do these for your assets:

1. minification (uglifyjs, csso)
2. concation
3. versioning and renaming

### Minification
Minification will apply best practices in [MinifyResources @ Google PageSpeed](https://developers.google.com/speed/docs/insights/MinifyResources). This will dramitically reduce the size of code but don't affect any functionality. And you never and should't write the code with ugly naming like `a, b, c` just to reduce size. Let sprocketjs handles that.


### Concation
Concation of assets files would remove many small HTTP calls, saving the precious time of your consumer.

### Versioning and renaming
Versioning and renaming is applying best practices in [LeverageBrowserCaching @ Google PageSpeed](https://developers.google.com/speed/docs/insights/LeverageBrowserCaching). We're using MD5 hash from the file content, and postfixed it to the end of the filename. By doing this, you can set a maximun expiration date of your assets and leverage the best of browser cache.


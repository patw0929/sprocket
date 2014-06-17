# Seamless Integration in sprocketjs

Two images worth thousands of words.

**Development**

![2014-06-17 11 14 11](https://cloud.githubusercontent.com/assets/922234/3295916/8ce5484c-f5cd-11e3-98d9-9c9535c1c0d6.png)

**Production**

![2014-06-17 11 16 44](https://cloud.githubusercontent.com/assets/922234/3295928/d6ae0eaa-f5cd-11e3-8f28-5e39dcdb90de.png)


## What does sprocketjs do in development?

First, it resolves dependencies of all files that are passed in to sprocketjs stream. Since we can build a dependency graph based on this, it's easy to generated a ordered list of files based on the triversal of the graph.

The ordered list then later outputted to the html, generating <script/style> tags. The resulting html looks just like you're writting <script/style> tags yourself. But by declaring your dependencies explicitly, you and your team would never have to bother on this anymore.

Just require it, and it works.


## What does sprocketjs do in production?

For production, sprocketjs will automatically do these for your assets:

1. minification (uglifyjs, csso)
2. concation
3. versioning and renaming

Minification will apply best practices in [MinifyResources @ Google PageSpeed](https://developers.google.com/speed/docs/insights/MinifyResources). This will dramitically reduce the size of code but don't affect any functionality. And you never and should't write the code with ugly naming like `a, b, c` just to reduce size. Let sprocketjs handles that.


Concation of assets files would remove many small HTTP calls, saving the precious time of your consumer.

Versioning and renaming is applying best practices in [LeverageBrowserCaching @ Google PageSpeed](https://developers.google.com/speed/docs/insights/LeverageBrowserCaching). We're using MD5 hash from the file content, and postfixed it to the end of the filename. By doing this, you can set a maximun expiration date of your assets and leverage the best of browser cache.


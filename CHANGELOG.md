## 0.4.0 (2014-07-23)


#### Bug Fixes

* **Environment:** only javascript is default stable ([58e4fc9a](https://github.com/tomchentw/sprocket/commit/58e4fc9aba1865abf7c153fa443b92501b91a950))


#### Features

* **errors:**
  * added error messages and fixed #11 ([04900840](https://github.com/tomchentw/sprocket/commit/04900840d1f2af37dfe9ad81c3c9ad8c3e0e86a9))
  * extracted from VinylNodeCollection#finalizeNode ([4346d8df](https://github.com/tomchentw/sprocket/commit/4346d8dfea24bfccc8cd5a2a2bbf3dae0abb5380))
  * extracted out from RequireState#addNodeIfNeeded ([8b13f04f](https://github.com/tomchentw/sprocket/commit/8b13f04fa0a7f678360e00a679f550575df54ead))


#### Breaking Changes

* change mime_type key in options to mimeType
The mime_type is legacy naming convention from ruby's sprockets.
In this project we use camelCased for public APIs.

Before:
Sprocket.registerEngine('.js', JsEngine, mime_type: 'application/javascript')

After:
Sprocket.registerEngine('.js', JsEngine, mimeType: 'application/javascript')

And there's no fallback on this change

 ([72127a23](https://github.com/tomchentw/sprocket/commit/72127a2376644e2980daa3bc6f7160c3ad082ecb))


### 0.3.3 (2014-07-11)


#### Bug Fixes

* **VinylNodeCollection:** added default unstable for a Node ([ce197637](https://github.com/tomchentw/sprocket/commit/ce197637eb5514a28d8324e0e123ab987acaf074), closes [#19](https://github.com/tomchentw/sprocket/issues/19))


### 0.3.2 (2014-07-10)


#### Features

* **VinylNodeCollection:**
  * only output files that just changed * same rule applied to manifest.json files * ([2b16fd2b](https://github.com/tomchentw/sprocket/commit/2b16fd2b39af6576f3cc16042ab33d7d04559d2d), closes [#16](https://github.com/tomchentw/sprocket/issues/16))
  * change default behavior of node ([2bb8ad7a](https://github.com/tomchentw/sprocket/commit/2bb8ad7a18b63da3a742deb4bd4c99e66add0419))


### 0.3.1 (2014-07-03)


#### Bug Fixes

* **HTML Engine:** Preserve empty attributes since angular attributes are often empty. ([9b4593a9](https://github.com/tomchentw/sprocket/commit/9b4593a90bc4171946ddd684bf5e3ac9ff8c4bad))


## 0.3.0 (2014-07-02)


#### Bug Fixes

* **VinylNodeCollection:** split src path with dest vinyl to resolve bug ([2ef393dd](https://github.com/tomchentw/sprocket/commit/2ef393dd6d97905937d22779e6d0a9c535a1fe2b))


#### Features

* **Engines:** lazy loaded engines depedencies ([6055aef4](https://github.com/tomchentw/sprocket/commit/6055aef4b979df8b0b7deb3d2d49345bae80a6e2))
* **Preprocessors:** lazy loaded preprocessors depedencies ([63cd29d9](https://github.com/tomchentw/sprocket/commit/63cd29d9e19147b76643ae073563d8d0ed92e644))
* **Sprockets:**
  * lazily link engines and templates ([c2f60bca](https://github.com/tomchentw/sprocket/commit/c2f60bca682deb2e31db7605699cef779b3abef9))
  * add templates support and ejs for html ([ce9260ba](https://github.com/tomchentw/sprocket/commit/ce9260ba6268e2f07ab53078a440770b495860c6))


### 0.2.4 (2014-07-02)


#### Bug Fixes

* **Node:** update version directly if it's stable ([556132d6](https://github.com/tomchentw/sprocket/commit/556132d6036dbe4788ca3d71838dfc2d36d0fd10))


#### Features

* **package.json:** update dependencies ([072d3446](https://github.com/tomchentw/sprocket/commit/072d34460a8b2e6f75922331226b17c454fc19d5))


### 0.2.3 (2014-06-28)


#### Bug Fixes

* **Engines:** correct multimatch pattern for gulp-filter ([f37cfa0d](https://github.com/tomchentw/sprocket/commit/f37cfa0da87edab18063d9555d72958332ebe6aa))


### 0.2.2 (2014-06-27)

#### Features

* **Sprockets:** add to base_path for directory vinyls ([0bb54dc5](https://github.com/tomchentw/sprocket/commit/0bb54dc57fda47286c7486f29fdc24a92d62ba27))
* **Node:** added full content cached support ([64ce2944](https://github.com/tomchentw/sprocket/commit/64ce2944bb13314749955925c955332e6eed619b))


### 0.2.1 (2014-06-22)


## 0.2.0 (2014-06-22)


#### Features

* **Sprocket:** rewrite module from ruby ([6c91e27f](https://github.com/tomchentw/sprocket/commit/6c91e27fb06ec4bda706b1fe5b8527e907ce1a6a))
* **Sprockets:**
  * add ejs template support ([ebd3a813](https://github.com/tomchentw/sprocket/commit/ebd3a813f2fe88e8182713a15c5a03d617676a7c))
  * added viewLocals for prototype chain ([315990a1](https://github.com/tomchentw/sprocket/commit/315990a1c35e58b7838f0ce9be2ae922ce333bb7))
  * added htmls stream support and postprocessors ([cacd1cd8](https://github.com/tomchentw/sprocket/commit/cacd1cd80dd97bce08fab5b33eea4f8ebb30a9d8))
  * remove old sprocket ([4d6a8b87](https://github.com/tomchentw/sprocket/commit/4d6a8b87f98b1b9a8da7b8f826fe3602e47d7404))
  * remove preprocessor and compressor ([a046396e](https://github.com/tomchentw/sprocket/commit/a046396e6aa66d6468190b03a161050fcdd1176e))
* **package.json:** update dependencies for html and ejs ([0eea92d2](https://github.com/tomchentw/sprocket/commit/0eea92d29e24132765e8f5323879ead22218a1c6))


### 0.1.2 (2014-06-20)


#### Features

* **package.json:** add less extension support ([92bc3d0c](https://github.com/tomchentw/sprocket/commit/92bc3d0c331a49893a0488753f19ac3750d0a4cb))


### 0.1.1 (2014-06-15)


#### Bug Fixes

* **package.json:** downgrade through2 to 0.5.1 ([f76333ff](https://github.com/tomchentw/sprocket/commit/f76333ff582886106355b82cabbe9c825cbf68d4))


## 0.1.0 (2014-06-15)


#### Features

* **SprocketEnvironment:** remove nconf dependency ([61318e3a](https://github.com/tomchentw/sprocket/commit/61318e3a576a0be0b8c6c03ab4ea5fac8eafc102))


#### Breaking Changes

* remove nconf support, please set process.env.NODE_ENV directly

 ([61318e3a](https://github.com/tomchentw/sprocket/commit/61318e3a576a0be0b8c6c03ab4ea5fac8eafc102))


### 0.0.2 (2014-06-14)


#### Bug Fixes

* **RequireState:** manifest filepath ([975eae15](https://github.com/tomchentw/sprocket/commit/975eae15e8012163601ac0e410e0c33c1fee8c44))
* **SprocketRequireState:** MANIFEST_BASENAME only in getManifestFilepath ([dca05971](https://github.com/tomchentw/sprocket/commit/dca0597109816dd870ad19518e8cd3e7d2f509c7))
* **VinylNode.SuperNode:** recursively build dependencies in forEach ([1acc430d](https://github.com/tomchentw/sprocket/commit/1acc430d47ca0f54c0952e4bc836f48eaec69dc5))
* **VinylNodeCollection:** bugs with prefilled .min files ([3f46854a](https://github.com/tomchentw/sprocket/commit/3f46854a54f60fe2f3b563db5fe2381ab6375c26))


#### Features

* **Edge.Circular:** add circular for require_self ([20573608](https://github.com/tomchentw/sprocket/commit/20573608203acfc17c70501fb9de6346b9e4c114))
* **RequireState:** extract manifest creation code and prettify it ([05fe4920](https://github.com/tomchentw/sprocket/commit/05fe49208d0ea2e6e10943b2b1f4b9b1f6b1e301))
* **Sprocket:**
  * better API for expose and watch ([13b1fb46](https://github.com/tomchentw/sprocket/commit/13b1fb46ce9e3e75bd10cb380e1402c0faccfa75))
  * add development environment support ([0903d0f3](https://github.com/tomchentw/sprocket/commit/0903d0f30c8c41973ba8aaf1966d257b936dd122))
  * add environment, gulp and view helpers ([dd1a8b8a](https://github.com/tomchentw/sprocket/commit/dd1a8b8a6c66ef59e04ebdbe452f9c38aa8cf6c9))
* **SprocketCollection:** store dependencies as object ([ca03e82b](https://github.com/tomchentw/sprocket/commit/ca03e82bb9d667d146fd0ab218ef8a3bef77f3f8))
* **SuperNode.Directory:** add require_directory support ([cddbe83a](https://github.com/tomchentw/sprocket/commit/cddbe83afc705f0fa8e1de6056fd61e06aa39041))
* **SupportedExtname:** extract as class and fix several bugs ([21cfa5ed](https://github.com/tomchentw/sprocket/commit/21cfa5ed41fb2ffade004ae2dea4479990e6a120))
* **VinylNode:**
  * fix dependencies changes while watcher active ([331d6b57](https://github.com/tomchentw/sprocket/commit/331d6b5726b60b12137891021b0aeeef1c0650c1))
  * export Collection and other classes ([cc573bf4](https://github.com/tomchentw/sprocket/commit/cc573bf4e2e0a90f59a9513a45238d1cad4a67e1))
* **VinylNode.Collection:** add require_self support and update directive regex ([4d1c6d6b](https://github.com/tomchentw/sprocket/commit/4d1c6d6bc8b1d40e88d9c8eda45098b9380df52c))
* **VinylNodeCollection:** add reversioning support ([38e1a804](https://github.com/tomchentw/sprocket/commit/38e1a804e57a754150603ccca174a3d17dcb3a0e))



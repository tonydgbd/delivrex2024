'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "15d129613737be07ee0e83eea4774e6a",
"assets/assets/fonts/Rubik-Bold.ttf": "071fcca9ce48f336894f072bae4c2440",
"assets/assets/fonts/Rubik-Medium.ttf": "11f22f212ab3e9b8e241cbd69d3c43e7",
"assets/assets/fonts/Rubik-Regular.ttf": "cd619a4f068dc66cc6e58fe0a91a8a34",
"assets/assets/icon/close_lock.png": "f0c62d0c763d92243543de6b56aa2edb",
"assets/assets/icon/done.png": "68a72e1189dcf0ed04dffa9f46a03bd3",
"assets/assets/icon/done_with_full_background.png": "56152f73fde9e8053d4d387a35984197",
"assets/assets/icon/edit.png": "40adf7172adba7389b26999fced464fe",
"assets/assets/icon/email_with_background.png": "60b9a4ba3c326e939783b7057cc1d8ca",
"assets/assets/icon/filter_icon.png": "e042dc677ca2c3ba17a306c59d3843a4",
"assets/assets/icon/home.png": "90a165cfdfa8d0df0e2363cf52959160",
"assets/assets/icon/location.png": "8735c4ecb37566648085bdf7c2274b84",
"assets/assets/icon/map.png": "c5102e6ec37e3e3b57d0eaff4d04363b",
"assets/assets/icon/marker.png": "a82fd1faefe24f97290d081353647e0f",
"assets/assets/icon/menu.png": "9f79745f3ca3d427a142f8496d9ee3ba",
"assets/assets/icon/my_location.png": "8d97ae00b06b8dc30cf07cb98553de18",
"assets/assets/icon/notification.png": "62e57e8af0317b29202eec2881f27655",
"assets/assets/icon/open_lock.png": "43a9fa242acd95a606733e55bf510a3b",
"assets/assets/icon/search.png": "11fab25f0bd7fda539bfe4d1873726ad",
"assets/assets/icon/workplace.png": "44572bd50d298201c7802b3f25662a1f",
"assets/assets/image/arabic.png": "a39296665f237666b6d436b6de291e66",
"assets/assets/image/binoculars.png": "4c473ad9095e6064bd05b26838640aad",
"assets/assets/image/cart_icon.png": "cedf8fcf381534257c6ec26501a5ff3b",
"assets/assets/image/china.png": "afc12b38a7a4b5ef8d69445b440a1d9f",
"assets/assets/image/clock.png": "4054687e90ca44f4ac96d1f9f98a9d8d",
"assets/assets/image/closed.png": "f7565cb70fc0febeff3766b31774827a",
"assets/assets/image/coupon.png": "a3d5daaf5e2a22c1887f2e30a13cff63",
"assets/assets/image/coupon_bg.png": "5db42dff9cc2ea5e3f5ba99e84e741ba",
"assets/assets/image/delivery_boy_marker.png": "45aa0d85d72678ba48be9cf97a7c20fd",
"assets/assets/image/destination_marker.png": "e074aaf37e79f4727e80f54609946d72",
"assets/assets/image/errorpage.png": "d7165a7c9a87a6c716cf470c85871118",
"assets/assets/image/fav_icon.png": "a5be5952868d50acd8f3f69ec7889c56",
"assets/assets/image/filter_icon.png": "e042dc677ca2c3ba17a306c59d3843a4",
"assets/assets/image/germany.png": "87d00b62bfac9dd56fab3d5255375f9c",
"assets/assets/image/guest_login.png": "599272316034a2134dc01137165e232d",
"assets/assets/image/home_icon.png": "bd53e728dacb97b977896bf2a3f92225",
"assets/assets/image/image.png": "389e383900c474b0f14d1a6c31147ce1",
"assets/assets/image/italy.png": "f04e64ce018c293d9e293cd4829ba8c4",
"assets/assets/image/japan.png": "8f15ebe0f28e1cdacedf478ea72f1a00",
"assets/assets/image/korean.png": "96ee9171e7ba7c6118196b39cc908589",
"assets/assets/image/language.png": "30e0d278ce8251309b54db48f9749859",
"assets/assets/image/line.png": "66ed0c57619cdb2adcc5a92e3e224eb3",
"assets/assets/image/loading_image.png": "4eda07e312abe26251b3b9ea061a1243",
"assets/assets/image/logo.png": "1e06438e01817b1800ba711038d231b7",
"assets/assets/image/log_out.png": "44e1b2e6cd6f95377efe12be428726f6",
"assets/assets/image/message.png": "bc81b172d0763339f4d6c4ba41664cc5",
"assets/assets/image/more_icon.png": "9b08b3a23e6b3cfa0457541e08c7b456",
"assets/assets/image/onboarding_one.png": "b3bb7e67644236fce0a473abf62dce68",
"assets/assets/image/onboarding_three.png": "32ff46cda75204cd688359643ece8c9d",
"assets/assets/image/onboarding_two.png": "f18dd2bd1c6b528aa5a180e4462f72ae",
"assets/assets/image/order.png": "4131fcff41c7c164549cf982e1b19d4f",
"assets/assets/image/payment.png": "86a2f4943fd4be798efb8659f885b550",
"assets/assets/image/percentage.png": "ccc510128cc0ebc175f2befa1cfa6c1f",
"assets/assets/image/placeholder_banner.png": "c06b90e57183bfc8df71ba94535c1ed3",
"assets/assets/image/placeholder_image.png": "910c99c200112971a4db84e4d914a39f",
"assets/assets/image/placeholder_rectangle.png": "739e015695133d5e2c0865e2703055e8",
"assets/assets/image/placeholder_user.png": "253958b8e84fdeb85cf4610e65805f38",
"assets/assets/image/profile.png": "4976c7c6989e4d3130b29c3e6803adb7",
"assets/assets/image/restaurant_marker.png": "b17891d47fd62dfa389d70dba1fa7279",
"assets/assets/image/send.png": "507bfa6b99f901ddd8029183c3108ac2",
"assets/assets/image/shopping_cart.png": "7a90b793d6811247176e225acf6e75ac",
"assets/assets/image/support.png": "7ea8654f8920f9fbfb248f815809b69d",
"assets/assets/image/united_kindom.png": "bbd8fd7399eb38fb175d75cd53b9f61b",
"assets/assets/image/unselected_restaurant_marker.png": "744d669976c02ce7166d879f1c0e787e",
"assets/assets/image/wallet.png": "744631e17632317ce0f3676e51008ef3",
"assets/assets/language/ar.json": "b0fbd05eef8a412ae0e580bffdf0f997",
"assets/assets/language/en.json": "1108cab02c8290a4afb60e0a43297812",
"assets/FontManifest.json": "f5fbd81cf18282fed9bb2c5c2ac5f06d",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/NOTICES": "dd677bffd4b7217cb301b8ca72fbf347",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"favicon.png": "1e06438e01817b1800ba711038d231b7",
"firebase-messaging-sw.js": "d30b94742c3d526de982b0c741af38f4",
"icons/efood_bike.png": "1e06438e01817b1800ba711038d231b7",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "322c2c1a01bb35324d873b3ae6f50bfd",
"/": "322c2c1a01bb35324d873b3ae6f50bfd",
"loader.gif": "5bc723f8545ce7c528cf370c5aa54f67",
"logo.png": "1e06438e01817b1800ba711038d231b7",
"main.dart.js": "ebbcce48ec9ef2fac93cdcdef40da570",
"manifest.json": "3f2a90551538504773b5298378b6ade0",
"style.css": "a2a6ce1458b3d38d10349af8e21c0447",
"version.json": "649246690d1db0b2494d4ca7a3bac4c2"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

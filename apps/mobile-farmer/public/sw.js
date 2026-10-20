// Offline PWA Caching & Background Sync Manager

import { precacheAndRoute } from "workbox-precaching";

import { registerRoute } from "workbox-routing";

import { NetworkFirst, StaleWhileRevalidate } from "workbox-strategies";

import { BackgroundSyncPlugin } from "workbox-background-sync";

precacheAndRoute(self.__WB_MANIFEST || []);

// Background Sync Queue for Voice Crop Listing Submissions

const bgSyncPlugin = new BackgroundSyncPlugin("offline-listing-queue", {
  maxRetentionTime: 24 * 60, // Retry sync for up to 24 hours
});

registerRoute(
  ({ url }) => url.pathname.startsWith("/api/v1/crops/create"),

  new NetworkFirst({
    plugins: [bgSyncPlugin],
  }),

  "POST",
);

registerRoute(
  ({ url }) => url.pathname.startsWith("/api/v1/crops"),

  new StaleWhileRevalidate(),
);

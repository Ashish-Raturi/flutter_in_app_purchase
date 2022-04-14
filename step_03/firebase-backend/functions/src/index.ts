import * as Functions from "firebase-functions";

import * as admin from "firebase-admin";
import {productDataMap} from "./products";
import {PurchaseHandler} from "./purchase-handler";
import {GooglePlayPurchaseHandler} from "./google-play.purchase-handler";
import {AppStorePurchaseHandler} from "./app-store.purchase-handler";
import {CLOUD_REGION} from "./constants";
import {IapRepository, IAPSource} from "./iap.repository";
// import {HttpsError} from "firebase-functions/lib/providers/https";

const functions = Functions.region(CLOUD_REGION);
admin.initializeApp();

//
// Dependencies
//

const iapRepository = new IapRepository(admin.firestore());
const purchaseHandlers: { [source in IAPSource]: PurchaseHandler } = {
  "google_play": new GooglePlayPurchaseHandler(iapRepository),
  "app_store": new AppStorePurchaseHandler(iapRepository),
};

//
// Callables
//

// Verify Purchase Function
interface VerifyPurchaseParams {
  source: IAPSource;
  verificationData: string;
  productId: string;
  uid: string;
}

// Handling of purchase verifications
export const verifyPurchase = functions.https.onCall(
    async (
        data: VerifyPurchaseParams
    ): Promise<boolean> => {
      // Get the product data from the map
      const productData = productDataMap[data.productId];
      // If it was for an unknown product, do not process it.
      if (!productData) {
        console.warn("verifyPurchase called for an unknown product ()");
        return false;
      }
      // If it was for an unknown source, do not process it.
      if (!purchaseHandlers[data.source]) {
        console.warn("verifyPurchase called for an unknown source ()");
        return false;
      }
      console.warn("calling veriifcation");
      // Process the purchase for the product
      return purchaseHandlers[data.source].verifyPurchase(
          data.uid,
          productData,
          data.verificationData,
      );
    });

// Handling of AppStore server-to-server events
export const handleAppStoreServerEvent =
    (purchaseHandlers.app_store as AppStorePurchaseHandler)
        .handleServerEvent;

// Handling of PlayStore server-to-server events
export const handlePlayStoreServerEvent =
    (purchaseHandlers.google_play as GooglePlayPurchaseHandler)
        .handleServerEvent;

// Scheduled job for expiring subscriptions in the case of missing store events
export const expireSubscriptions = functions.pubsub.schedule("every 1 mins")
    .onRun(() => iapRepository.expireSubscriptions());

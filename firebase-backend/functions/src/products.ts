export interface ProductData {
  productId: string;
  type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
}

export const productDataMap: { [productId: string]: ProductData } = {
  "your_android_premium_product_id": {
    productId: "your_android_premium_product_id",
    type: "NON_SUBSCRIPTION",
  },
  "your_android_gold_coin_id": {
    productId: "your_android_gold_coin_id",
    type: "NON_SUBSCRIPTION",
  },
  "your_ios_premium_product_id": {
    productId: "your_ios_premium_product_id",
    type: "NON_SUBSCRIPTION",
  },
  "your_ios_gold_coin_id": {
    productId: "your_ios_gold_coin_id",
    type: "NON_SUBSCRIPTION",
  },
};

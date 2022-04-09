export interface ProductData {
  productId: string;
  type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
}

export const productDataMap: { [productId: string]: ProductData } = {
  "premium_plan": {
    productId: "premium_plan",
    type: "NON_SUBSCRIPTION",
  },
  "game_coin": {
    productId: "game_coin",
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

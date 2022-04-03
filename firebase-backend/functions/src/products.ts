export interface ProductData {
  productId: string;
  type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
}

export const productDataMap: { [productId: string]: ProductData } = {
  "your_android_sub1_id": {
    productId: "your_android_sub1_id",
    type: "SUBSCRIPTION",
  },
  "your_android_sub2_id": {
    productId: "your_android_sub2_id",
    type: "SUBSCRIPTION",
  },
  "your_ios_sub1_id": {
    productId: "your_ios_sub1_id",
    type: "SUBSCRIPTION",
  },
  "your_ios_sub2_id": {
    productId: "your_ios_sub2_id",
    type: "SUBSCRIPTION",
  },
};

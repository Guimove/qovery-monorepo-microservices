export type OrderStatus = "pending" | "confirmed" | "shipped";

export interface Order {
  id: string;
  customerId: string;
  totalInCents: number;
  status: OrderStatus;
}

export type PaymentStatus = "authorized" | "captured" | "failed";

export interface Payment {
  id: string;
  orderId: string;
  amountInCents: number;
  status: PaymentStatus;
}

export interface ServiceInfo {
  name: string;
  version: string;
  status: "ok";
}

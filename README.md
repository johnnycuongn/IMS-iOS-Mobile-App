# IMS-iOS-Mobile-App

## Model

Item:

- name: string
- inventory: number
- lower_limit: number
- barcode: string

Stock_Take:

- created_date: Date
- updated_date: Date
- item: string
- status: string (pending, complete)
- inventory_from: number
- inventory_to: number

---

## Features

- Add item with Barcode enter
- Inventory Count
- UPC API Fetched

### Stock-in/Stock-out

- Create a stock take

---

## Extensions

- Notifications
- Share

---

## Views

- A list of card (item)
- A list of stock takes (sorted by date)
- A stock take CREATE view
- A stock stake Status View

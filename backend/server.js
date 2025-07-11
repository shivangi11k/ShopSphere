const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();
const { db } = require('./firebase');
const OpenAI = require("openai");

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(bodyParser.json());

// 📦 Add to cart
app.post('/api/cart/add', async (req, res) => {
  const { userId, product } = req.body;
  console.log("🛒 Add to cart - User:", userId, "Product:", product);
  if (!userId || !product) {
    return res.status(400).json({ error: "userId and product are required." });
  }

  try {
    await db.ref(`users/${userId}/cart`).push(product);
    console.log("✅ Product added to cart");
    res.status(200).json({ message: 'Product added to cart' });
  } catch (error) {
    console.error("❌ Cart Add Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// 🛒 Get user cart
app.get('/api/cart/:userId', async (req, res) => {
  const { userId } = req.params;
  console.log("📥 Get cart for user:", userId);
  try {
    const snapshot = await db.ref(`users/${userId}/cart`).once('value');
    const cartItems = snapshot.val() || {};
    res.status(200).json(cartItems);
  } catch (error) {
    console.error("❌ Fetch Cart Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// ❌ Remove product from cart
app.delete('/api/cart/:userId/:itemId', async (req, res) => {
  const { userId, itemId } = req.params;
  console.log("🗑️ Removing item", itemId, "from user:", userId);
  try {
    await db.ref(`users/${userId}/cart/${itemId}`).remove();
    res.status(200).json({ message: 'Item removed from cart' });
  } catch (error) {
    console.error("❌ Cart Remove Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// 🧠 Product recommendations
app.post('/api/recommend', async (req, res) => {
  const { userId, productId } = req.body;
  console.log("🔮 Recommend for user:", userId, "Product ID:", productId);
  try {
    const mockRecs = {
      "Coca Cola": ["Lays Chips", "Snickers", "Ice Cream"],
      "Milk": ["Cornflakes", "Cookies", "Honey"]
    };
    const recommendations = mockRecs[productId] || ["Milk", "Bread", "Eggs"];
    res.status(200).json({ recommendations });
  } catch (error) {
    console.error("❌ Recommendation Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// ✅ Save allergies to Firebase
app.post('/api/user/allergies', async (req, res) => {
  const { userId, allergies } = req.body;
  console.log("🩺 Save allergies - User:", userId, "Allergies:", allergies);

  if (!userId || !Array.isArray(allergies)) {
    return res.status(400).json({ error: "Invalid input. Requires userId and allergies[]" });
  }

  try {
    await db.ref(`users/${userId}/allergies`).set(allergies);
    console.log("✅ Allergies saved to Firebase");
    res.status(200).json({ message: 'Allergies updated successfully.' });
  } catch (error) {
    console.error("🔥 Allergy Save Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// ⚠️ Check product for allergens
app.post('/api/allergy-check', async (req, res) => {
  const { userId, product } = req.body;
  console.log("⚠️ Allergy check for user:", userId, "Product:", product);

  try {
    const allergySnapshot = await db.ref(`users/${userId}/allergies`).once('value');
    const userAllergies = allergySnapshot.val() || [];
    const hasAlert = product.ingredients?.some(i =>
      userAllergies.includes(i.toLowerCase())
    );
    res.status(200).json({ alert: hasAlert });
  } catch (error) {
    console.error("❌ Allergy Check Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// 📸 Product recognition mock
app.post('/api/recognize', async (req, res) => {
  const { imageBase64 } = req.body;
  console.log("📷 Product recognition called");
  try {
    const mockProduct = "Coca Cola";
    res.status(200).json({ productId: mockProduct });
  } catch (error) {
    console.error("❌ Recognition Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// 🧾 Inventory info
app.get('/api/inventory/:productId', async (req, res) => {
  const { productId } = req.params;
  console.log("📦 Inventory check for:", productId);
  try {
    const mockInventory = {
      "Coca Cola": { price: 45, available: true, offer: "10% off today!" },
      "Milk": { price: 30, available: true, offer: "Buy 1 Get 1 Free" },
      "Snickers": { price: 20, available: false, offer: null }
    };
    const productInfo = mockInventory[productId] || {
      price: null, available: false, offer: null
    };
    res.status(200).json(productInfo);
  } catch (error) {
    console.error("❌ Inventory Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// ✅ Checkout
app.post('/api/checkout', async (req, res) => {
  const { userId } = req.body;
  console.log("💳 Checkout initiated for user:", userId);

  try {
    const cartRef = db.ref(`users/${userId}/cart`);
    const snapshot = await cartRef.once('value');
    const cartItems = snapshot.val();

    if (!cartItems) {
      console.warn("⚠️ Cart is empty");
      return res.status(400).json({ error: "Cart is empty!" });
    }

    const orderRef = db.ref(`users/${userId}/orders`).push();
    await orderRef.set({ items: cartItems, placedAt: new Date().toISOString() });
    await cartRef.remove();

    console.log("✅ Order placed and cart cleared");
    res.status(200).json({ message: "Order placed successfully!" });
  } catch (error) {
    console.error("❌ Checkout Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// 📦 Order history
app.get('/api/orders/:userId', async (req, res) => {
  const { userId } = req.params;
  console.log("📜 Fetching order history for:", userId);
  try {
    const ordersSnapshot = await db.ref(`users/${userId}/orders`).once('value');
    const orders = ordersSnapshot.val();
    res.status(200).json({ orders: orders || {} });
  } catch (error) {
    console.error("❌ Order Fetch Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// 🤖 Voice assistant
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

app.post('/api/voice-assistant', async (req, res) => {
  const { message } = req.body;
  console.log("💬 Voice assistant message:", message);

  try {
    const response = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        { role: "system", content: "You are a helpful shopping assistant." },
        { role: "user", content: message }
      ]
    });
    res.status(200).json({ response: response.choices[0].message.content });
  } catch (error) {
    console.error("❌ OpenAI Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// 🌐 Home route
app.get('/', (req, res) => {
  res.send(`
    <html>
      <head><title>ShopSphere API</title></head>
      <body style="font-family:sans-serif;text-align:center;padding:40px;background:#f9f9f9">
        <h1>🚀 Welcome to ShopSphere Backend</h1>
        <p>Try routes like <code>POST /api/cart/add</code> or <code>GET /api/inventory/:productId</code></p>
      </body>
    </html>
  `);
});

// 🚀 Launch server
app.listen(PORT, () => {
  console.log(`🚀 ShopSphere backend is running on http://localhost:${PORT}`);
});

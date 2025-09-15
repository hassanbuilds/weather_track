<h1 align="center">🌤️ Weather App (Flutter)</h1>

<p align="center">
  A modern weather forecast app built with <b>Flutter</b>, using the <b>OpenWeatherMap API</b>.<br>
  This app displays <b>current weather, hourly forecast, and a 7-day forecast</b> with a clean UI, gradient design, and smooth user experience.
</p>

---

<h2>📱 Features</h2>

<ul>
  <li>🌍 <b>Current Weather</b> – Shows location, temperature, condition, and highs/lows.</li>
  <li>⏰ <b>Hourly Forecast</b> – <b>Dynamic (real-time API data)</b> for the next 18 hours (6 entries, 3-hour interval).</li>
  <li>📅 <b>7-Day Forecast</b> – <b>Static placeholder values</b> (currently hardcoded, can be extended with API).</li>
  <li>🔄 <b>Refresh Button</b> – Manual refresh with haptic feedback.</li>
  <li>🎨 <b>UI/UX</b> – Gradient backgrounds, modern typography, weather icons, and responsive layout.</li>
  <li>🛡️ <b>Error Handling</b> – App falls back to default sunny weather if API fails.</li>
</ul>

---

<h2>🛠️ Tech Stack</h2>

<ul>
  <li><b>Framework:</b> Flutter</li>
  <li><b>API:</b> <a href="https://openweathermap.org/">OpenWeatherMap</a></li>
  <li><b>Packages:</b>
    <ul>
      <li><code>http</code> – REST API calls</li>
      <li><code>weather_icons</code> – Weather condition icons</li>
      <li><code>google_fonts</code> – Modern typography</li>
    </ul>
  </li>
</ul>

---

<h2>📸 Screenshots</h2>

<p align="center">
  <img src="https://github.com/user-attachments/assets/your-screenshot.png" alt="Weather App Screenshot" width="300">
</p>

---

<h2>🚀 Getting Started</h2>

<ol>
  <li>
    Clone the repo:
    <pre><code>git clone https://github.com/your-username/weather_app.git
cd weather_app</code></pre>
  </li>
  <li>
    Add your API key:
    <ul>
      <li>Get one from <a href="https://openweathermap.org/api">OpenWeatherMap</a>.</li>
      <li>Create a file <code>secrets.dart</code> inside <code>lib/</code>:
        <pre><code>const openWeatherApiKey = "YOUR_API_KEY_HERE";</code></pre>
      </li>
    </ul>
  </li>
  <li>
    Run the app:
    <pre><code>flutter pub get
flutter run</code></pre>
  </li>
</ol>

---


<h2>📜 License</h2>

<p>This project is licensed under the MIT License.</p>

import { Elm } from "./frontend/Main.elm";

const apiBaseUrl = (process.env.API_BASE_URL || "http://localhost:8080").replace(/\/$/, "");

Elm.Main.init({
  node: document.getElementById("app"),
  flags: {
    apiBaseUrl
  }
});

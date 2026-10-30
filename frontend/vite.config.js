import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  // Vercel serves the app from the domain root. GitHub Pages uses its own base path.
  base: process.env.GITHUB_ACTIONS === "true" ? "/OnlinelearningPlatform_fsd/" : "/",
});

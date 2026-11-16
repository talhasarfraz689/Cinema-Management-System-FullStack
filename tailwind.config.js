/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        neon: {
          purple: '#6C63FF',
          royal: '#8A2BE2',
          gold: '#FFCE42',
          rose: '#FF6B81',
          aqua: '#5BE7C4',
        },
        dark: {
          bg: '#0E0E14',
          card: '#2D2B3C',
          mid: '#1E1E2E',
        },
      },
      fontFamily: {
        poppins: ['Poppins', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
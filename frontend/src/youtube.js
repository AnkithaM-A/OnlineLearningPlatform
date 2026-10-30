const YOUTUBE_HOSTS = new Set([
  "youtube.com",
  "www.youtube.com",
  "m.youtube.com",
  "music.youtube.com",
  "youtu.be",
  "www.youtu.be",
]);

export function getYouTubeVideoId(value) {
  if (!value) return null;

  try {
    const url = new URL(value);
    if (!["http:", "https:"].includes(url.protocol) || !YOUTUBE_HOSTS.has(url.hostname)) {
      return null;
    }

    let id = "";
    if (url.hostname.endsWith("youtu.be")) {
      id = url.pathname.split("/")[1] || "";
    } else if (url.pathname === "/watch") {
      id = url.searchParams.get("v") || "";
    } else {
      const pathMatch = url.pathname.match(/^\/(?:embed|shorts|live)\/([^/]+)/);
      id = pathMatch?.[1] || "";
    }

    return /^[A-Za-z0-9_-]{11}$/.test(id) ? id : null;
  } catch {
    return null;
  }
}

export function getYouTubeEmbedUrl(value) {
  const id = getYouTubeVideoId(value);
  return id ? `https://www.youtube.com/embed/${id}?rel=0&playsinline=1` : null;
}

let youtubeApiPromise;

export function loadYouTubeIframeApi() {
  if (window.YT?.Player) return Promise.resolve(window.YT);
  if (youtubeApiPromise) return youtubeApiPromise;

  youtubeApiPromise = new Promise((resolve, reject) => {
    const previousCallback = window.onYouTubeIframeAPIReady;
    window.onYouTubeIframeAPIReady = () => {
      if (typeof previousCallback === "function") previousCallback();
      resolve(window.YT);
    };

    let script = document.querySelector('script[src="https://www.youtube.com/iframe_api"]');
    if (!script) {
      script = document.createElement("script");
      script.src = "https://www.youtube.com/iframe_api";
      script.async = true;
      script.onerror = () => {
        youtubeApiPromise = null;
        reject(new Error("Could not load YouTube's video player. Check your internet connection."));
      };
      document.head.appendChild(script);
    }
  });

  return youtubeApiPromise;
}

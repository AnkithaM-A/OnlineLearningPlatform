import { useEffect, useRef, useState } from "react";
import { getYouTubeVideoId, loadYouTubeIframeApi } from "../youtube.js";

export default function CourseVideo({ course, onProgress, onComplete, completed = false }) {
  const mountRef = useRef(null);
  const playerRef = useRef(null);
  const timerRef = useRef(null);
  const onProgressRef = useRef(onProgress);
  const onCompleteRef = useRef(onComplete);
  const completedRef = useRef(completed);
  const watchedRangesRef = useRef([]);
  const lastSampleRef = useRef(null);
  const reportedPercentRef = useRef(0);
  const [playerError, setPlayerError] = useState("");
  const [playbackNotice, setPlaybackNotice] = useState("");
  const videoId = getYouTubeVideoId(course.videoUrl);

  useEffect(() => { onProgressRef.current = onProgress; }, [onProgress]);
  useEffect(() => { onCompleteRef.current = onComplete; }, [onComplete]);
  useEffect(() => { completedRef.current = completed; }, [completed]);

  useEffect(() => {
    if (!videoId || !mountRef.current) return undefined;
    let cancelled = false;
    setPlayerError("");

    const clearProgressTimer = () => {
      if (timerRef.current) window.clearInterval(timerRef.current);
      timerRef.current = null;
      lastSampleRef.current = null;
    };

    const watchedSeconds = () => watchedRangesRef.current.reduce(
      (total, range) => total + Math.max(0, range[1] - range[0]), 0,
    );

    const addWatchedRange = (start, end) => {
      if (end <= start) return;
      const ranges = [...watchedRangesRef.current, [Math.max(0, start), end]]
        .sort((a, b) => a[0] - b[0]);
      const merged = [];
      for (const range of ranges) {
        const previous = merged[merged.length - 1];
        if (previous && range[0] <= previous[1] + 0.25) {
          previous[1] = Math.max(previous[1], range[1]);
        } else {
          merged.push([...range]);
        }
      }
      watchedRangesRef.current = merged;
    };

    loadYouTubeIframeApi()
      .then((YT) => {
        if (cancelled || !mountRef.current) return;
        playerRef.current = new YT.Player(mountRef.current, {
          videoId,
          width: "100%",
          height: "100%",
          playerVars: {
            enablejsapi: 1,
            origin: window.location.origin,
            playsinline: 1,
            rel: 0,
          },
          events: {
            onError: () => setPlayerError("This video cannot be played here. The owner may have disabled embedding."),
            onStateChange: (event) => {
              if (event.data === YT.PlayerState.PLAYING) {
                clearProgressTimer();
                setPlaybackNotice("");
                const samplePlayback = () => {
                  const player = playerRef.current;
                  if (!player || completedRef.current) return;
                  const duration = player.getDuration();
                  const currentTime = player.getCurrentTime();
                  if (!(duration > 0) || !(currentTime >= 0)) return;

                  const previousTime = lastSampleRef.current;
                  if (previousTime !== null) {
                    const elapsedVideoSeconds = currentTime - previousTime;
                    // Ignore seeks and large jumps; only count normal forward playback.
                    if (elapsedVideoSeconds > 0 && elapsedVideoSeconds <= 3.25) {
                      addWatchedRange(previousTime, currentTime);
                    }
                  }
                  lastSampleRef.current = currentTime;
                  const percent = Math.min(99, Math.floor((watchedSeconds() / duration) * 100));
                  if (percent > reportedPercentRef.current) {
                    reportedPercentRef.current = percent;
                    if (percent > 0) onProgressRef.current?.(percent);
                  }
                };
                samplePlayback();
                timerRef.current = window.setInterval(samplePlayback, 2000);
              } else {
                // Capture the last playback interval before clearing the sampling timer.
                if (event.data === YT.PlayerState.ENDED && lastSampleRef.current !== null) {
                  const player = playerRef.current;
                  const currentTime = player?.getCurrentTime?.();
                  const delta = currentTime - lastSampleRef.current;
                  if (Number.isFinite(delta) && delta > 0 && delta <= 3.25) {
                    addWatchedRange(lastSampleRef.current, currentTime);
                  }
                }
                clearProgressTimer();
                if (event.data === YT.PlayerState.ENDED && !completedRef.current) {
                  const duration = playerRef.current?.getDuration?.() || 0;
                  const coverage = duration > 0 ? watchedSeconds() / duration : 0;
                  if (coverage < 0.95) {
                    setPlaybackNotice("It looks like part of the lesson was skipped. Please watch the skipped parts before the course can be completed.");
                    return;
                  }
                  completedRef.current = true;
                  Promise.resolve(onCompleteRef.current?.(Math.min(100, Math.floor(coverage * 100)))).then((saved) => {
                    if (saved === false) completedRef.current = false;
                  }).catch(() => {
                    completedRef.current = false;
                  });
                }
              }
            },
          },
        });
      })
      .catch((error) => {
        if (!cancelled) setPlayerError(error.message);
      });

    return () => {
      cancelled = true;
      clearProgressTimer();
      if (playerRef.current?.destroy) playerRef.current.destroy();
      playerRef.current = null;
    };
  }, [videoId]);

  if (!course.videoUrl) return null;
  if (!videoId) {
    return (
      <section className="course-video-section" aria-label={`${course.title} lesson video`}>
        <p className="eyebrow">WATCH THE LESSON</p>
        <p className="video-unavailable" role="status">This link is not a valid YouTube video URL.</p>
      </section>
    );
  }

  return (
    <section className="course-video-section" aria-label={`${course.title} lesson video`}>
      <p className="eyebrow">WATCH THE LESSON</p>
      <div className="course-video-frame">
        <div ref={mountRef} className="youtube-player-mount" />
      </div>
      {playerError && <p className="video-unavailable" role="alert">{playerError}</p>}
      {playbackNotice && <p className="video-unavailable" role="status">{playbackNotice}</p>}
      <p className="form-hint">
        {completed ? "Lesson completed." : onComplete ? "Your progress saves while you watch. The course completes when the video finishes." : "Play the lesson here, or open it directly on YouTube."}
      </p>
      <a
        className="text-button"
        href={course.videoUrl}
        target="_blank"
        rel="noopener noreferrer"
      >
        Open on YouTube ↗
      </a>
    </section>
  );
}

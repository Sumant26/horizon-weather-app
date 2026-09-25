// Horizon Browser Geolocation API Bridge
window.horizonLocation = {
  getCurrentCoords: function(successCb, errorCb) {
    if (!navigator.geolocation) {
      if (errorCb) errorCb("Geolocation unsupported");
      return;
    }
    navigator.geolocation.getCurrentPosition(
      function(pos) {
        if (successCb) {
          successCb(JSON.stringify({
            latitude: pos.coords.latitude,
            longitude: pos.coords.longitude
          }));
        }
      },
      function(err) {
        if (errorCb) errorCb(err.message || "Denied");
      },
      { enableHighAccuracy: true, timeout: 8000, maximumAge: 30000 }
    );
  }
};

// Horizon Procedural Atmospheric Audio Synthesizer (Web Audio API)
window.horizonAudio = {
  ctx: null,
  gainNode: null,
  activeNodes: [],
  interval: null,

  init() {
    if (!this.ctx) {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (AudioCtx) {
        this.ctx = new AudioCtx();
        this.gainNode = this.ctx.createGain();
        this.gainNode.gain.value = 0.35;
        this.gainNode.connect(this.ctx.destination);
      }
    }
    if (this.ctx && this.ctx.state === 'suspended') {
      this.ctx.resume();
    }
  },

  stop() {
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = null;
    }
    if (this.activeNodes && this.activeNodes.length > 0) {
      this.activeNodes.forEach(node => {
        try {
          if (node.stop) node.stop();
          if (node.disconnect) node.disconnect();
        } catch (e) {}
      });
      this.activeNodes = [];
    }
  },

  setVolume(vol) {
    this.init();
    if (this.gainNode && this.ctx) {
      const target = Math.max(0, Math.min(1, vol)) * 0.45;
      this.gainNode.gain.setTargetAtTime(target, this.ctx.currentTime, 0.05);
    }
  },

  duck(targetFraction = 0.2, duration = 0.3) {
    if (this.gainNode && this.ctx) {
      const current = this.gainNode.gain.value;
      const target = current * targetFraction;
      this.gainNode.gain.cancelScheduledValues(this.ctx.currentTime);
      this.gainNode.gain.setTargetAtTime(target, this.ctx.currentTime, duration);
    }
  },

  unduck(targetVol = 0.7, duration = 0.5) {
    if (this.gainNode && this.ctx) {
      const target = Math.max(0, Math.min(1, targetVol)) * 0.45;
      this.gainNode.gain.cancelScheduledValues(this.ctx.currentTime);
      this.gainNode.gain.setTargetAtTime(target, this.ctx.currentTime, duration);
    }
  },

  _createPinkNoiseBuffer() {
    const bufferSize = this.ctx.sampleRate * 2;
    const noiseBuffer = this.ctx.createBuffer(1, bufferSize, this.ctx.sampleRate);
    const output = noiseBuffer.getChannelData(0);
    let b0 = 0, b1 = 0, b2 = 0, b3 = 0, b4 = 0, b5 = 0, b6 = 0;
    for (let i = 0; i < bufferSize; i++) {
      const white = Math.random() * 2 - 1;
      b0 = 0.99886 * b0 + white * 0.0555179;
      b1 = 0.99332 * b1 + white * 0.0750759;
      b2 = 0.96900 * b2 + white * 0.1538520;
      b3 = 0.86650 * b3 + white * 0.3104856;
      b4 = 0.55000 * b4 + white * 0.5329522;
      b5 = -0.7616 * b5 - white * 0.0168980;
      output[i] = (b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362) * 0.11;
      b6 = white * 0.115926;
    }
    return noiseBuffer;
  },

  play(type) {
    this.init();
    this.stop();
    if (!this.ctx) return;

    const noiseBuffer = this._createPinkNoiseBuffer();
    const noiseSource = this.ctx.createBufferSource();
    noiseSource.buffer = noiseBuffer;
    noiseSource.loop = true;

    const soundType = (type || '').toLowerCase();

    if (soundType.includes('rain') || soundType.includes('drizzle')) {
      // 🌧️ Gentle Rain Drizzle: Bandpass filter + raindrop transients
      const filter = this.ctx.createBiquadFilter();
      filter.type = 'bandpass';
      filter.frequency.value = 1100;
      filter.Q.value = 0.9;

      noiseSource.connect(filter);
      filter.connect(this.gainNode);
      noiseSource.start();
      this.activeNodes.push(noiseSource, filter);

      // Random micro droplet taps
      this.interval = setInterval(() => {
        if (!this.ctx || this.ctx.state === 'suspended') return;
        try {
          const drop = this.ctx.createOscillator();
          const dropGain = this.ctx.createGain();
          const t = this.ctx.currentTime;
          drop.type = 'sine';
          drop.frequency.setValueAtTime(800 + Math.random() * 600, t);
          drop.frequency.exponentialRampToValueAtTime(300, t + 0.04);
          dropGain.gain.setValueAtTime(0.025, t);
          dropGain.gain.exponentialRampToValueAtTime(0.0001, t + 0.04);
          drop.connect(dropGain);
          dropGain.connect(this.gainNode);
          drop.start(t);
          drop.stop(t + 0.05);
        } catch(e) {}
      }, 140);

    } else if (soundType.includes('breeze') || soundType.includes('wind') || soundType.includes('alpine') || soundType.includes('canopy')) {
      // 🍃 Alpine Mountain Breeze / Canopy Rustle: Lowpass filter modulated with slow gust LFO
      const filter = this.ctx.createBiquadFilter();
      filter.type = 'lowpass';
      filter.frequency.value = 400;

      const lfo = this.ctx.createOscillator();
      lfo.frequency.value = 0.18; // Slow organic gust cycle
      const lfoGain = this.ctx.createGain();
      lfoGain.gain.value = 220; // Modulates cutoff between 180Hz and 620Hz
      lfo.connect(lfoGain);
      lfoGain.connect(filter.frequency);

      noiseSource.connect(filter);
      filter.connect(this.gainNode);
      noiseSource.start();
      lfo.start();
      this.activeNodes.push(noiseSource, filter, lfo, lfoGain);

    } else if (soundType.includes('night') || soundType.includes('campfire') || soundType.includes('hearth')) {
      // ✨ Starry Night & Hearth: Deep warm hum + fire crackles + cricket harmonic
      const filter = this.ctx.createBiquadFilter();
      filter.type = 'lowpass';
      filter.frequency.value = 240;

      noiseSource.connect(filter);
      filter.connect(this.gainNode);
      noiseSource.start();
      this.activeNodes.push(noiseSource, filter);

      // Crickets chirp
      const cricket = this.ctx.createOscillator();
      cricket.type = 'sine';
      cricket.frequency.value = 4800;
      const cricketGain = this.ctx.createGain();
      cricketGain.gain.value = 0.006;
      cricket.connect(cricketGain);
      cricketGain.connect(this.gainNode);
      cricket.start();
      this.activeNodes.push(cricket, cricketGain);

      // Hearth crackle bursts
      this.interval = setInterval(() => {
        if (!this.ctx || this.ctx.state === 'suspended' || Math.random() > 0.45) return;
        try {
          const crackle = this.ctx.createOscillator();
          const crackleGain = this.ctx.createGain();
          const t = this.ctx.currentTime;
          crackle.type = 'triangle';
          crackle.frequency.setValueAtTime(300 + Math.random() * 800, t);
          crackleGain.gain.setValueAtTime(0.04, t);
          crackleGain.gain.exponentialRampToValueAtTime(0.0001, t + 0.03);
          crackle.connect(crackleGain);
          crackleGain.connect(this.gainNode);
          crackle.start(t);
          crackle.stop(t + 0.035);
        } catch(e) {}
      }, 350);

    } else {
      // 🐦 Morning Forest Birds: Gentle leaf rustle + sporadic sweet melodic chirps
      const filter = this.ctx.createBiquadFilter();
      filter.type = 'bandpass';
      filter.frequency.value = 750;
      filter.Q.value = 0.7;

      noiseSource.connect(filter);
      filter.connect(this.gainNode);
      noiseSource.start();
      this.activeNodes.push(noiseSource, filter);

      // Sweet bird chirp generator
      this.interval = setInterval(() => {
        if (!this.ctx || this.ctx.state === 'suspended') return;
        try {
          const t = this.ctx.currentTime;
          const chirp = this.ctx.createOscillator();
          const chirpGain = this.ctx.createGain();
          const baseFreq = 2400 + Math.random() * 600;
          chirp.frequency.setValueAtTime(baseFreq, t);
          chirp.frequency.exponentialRampToValueAtTime(baseFreq + 700, t + 0.08);
          chirp.frequency.exponentialRampToValueAtTime(baseFreq - 300, t + 0.16);

          chirpGain.gain.setValueAtTime(0.02, t);
          chirpGain.gain.exponentialRampToValueAtTime(0.0001, t + 0.18);

          chirp.connect(chirpGain);
          chirpGain.connect(this.gainNode);
          chirp.start(t);
          chirp.stop(t + 0.19);
        } catch(e) {}
      }, 2400);
    }
  }
};

// Horizon Ambient Voice Synthesizer (Web Speech API + Audio Ducking)
window.horizonSpeech = {
  activeUtterance: null,
  isSpeaking: false,
  onEndCallback: null,

  speak(text, onStartCb, onEndCb, onErrorCb) {
    if (!('speechSynthesis' in window)) {
      if (onErrorCb) onErrorCb("Speech synthesis unsupported");
      return;
    }

    this.stop();

    const utterance = new SpeechSynthesisUtterance(text);
    this.activeUtterance = utterance;
    utterance.rate = 0.95; // Calm, editorial pacing
    utterance.pitch = 1.0;

    // Pick a natural sounding English voice if available
    const voices = window.speechSynthesis.getVoices();
    const preferredVoice = voices.find(v => 
      v.lang.startsWith('en') && (v.name.includes('Natural') || v.name.includes('Neural') || v.name.includes('Google') || v.name.includes('Samantha') || v.name.includes('Daniel') || v.name.includes('Premium'))
    ) || voices.find(v => v.lang.startsWith('en'));

    if (preferredVoice) {
      utterance.voice = preferredVoice;
    }

    utterance.onstart = () => {
      this.isSpeaking = true;
      if (window.horizonAudio) {
        window.horizonAudio.duck(0.18, 0.4);
      }
      if (onStartCb) onStartCb();
    };

    const cleanup = () => {
      this.isSpeaking = false;
      this.activeUtterance = null;
      if (window.horizonAudio) {
        window.horizonAudio.unduck(0.7, 0.6);
      }
    };

    utterance.onend = () => {
      cleanup();
      if (onEndCb) onEndCb();
    };

    utterance.onerror = (e) => {
      cleanup();
      if (onErrorCb) onErrorCb(e.error || "Speech error");
    };

    window.speechSynthesis.speak(utterance);
  },

  pause() {
    if (window.speechSynthesis && window.speechSynthesis.speaking) {
      window.speechSynthesis.pause();
    }
  },

  resume() {
    if (window.speechSynthesis && window.speechSynthesis.paused) {
      window.speechSynthesis.resume();
    }
  },

  stop() {
    if (window.speechSynthesis) {
      window.speechSynthesis.cancel();
    }
    this.isSpeaking = false;
    this.activeUtterance = null;
    if (window.horizonAudio) {
      window.horizonAudio.unduck(0.7, 0.4);
    }
  }
};

// Horizon Dynamic Tab & Canvas Favicon Generator
window.horizonTab = {
  updateTab(title, emoji, tempStr) {
    if (title) {
      document.title = title;
    }
    try {
      const canvas = document.createElement('canvas');
      canvas.width = 32;
      canvas.height = 32;
      const ctx = canvas.getContext('2d');
      if (!ctx) return;

      // Dark background rounded pill
      ctx.fillStyle = '#090A0F';
      ctx.beginPath();
      ctx.roundRect(0, 0, 32, 32, 8);
      ctx.fill();

      // Subtle cyan border
      ctx.strokeStyle = '#64D2FF';
      ctx.lineWidth = 1.5;
      ctx.stroke();

      // Draw Emoji
      ctx.font = '16px "Apple Color Emoji", "Segoe UI Emoji", sans-serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(emoji || '🌤️', 16, 17);

      const faviconUrl = canvas.toDataURL('image/png');
      let link = document.querySelector("link[rel*='icon']");
      if (!link) {
        link = document.createElement('link');
        link.type = 'image/png';
        link.rel = 'shortcut icon';
        document.getElementsByTagName('head')[0].appendChild(link);
      }
      link.href = faviconUrl;
    } catch (e) {}
  }
};

// Horizon Proactive Browser Notifications API Bridge
window.horizonNotifications = {
  requestPermission(callback) {
    if (!('Notification' in window)) {
      if (callback) callback('unsupported');
      return;
    }
    Notification.requestPermission().then(permission => {
      if (callback) callback(permission);
    });
  },

  showNotification(title, body, tag) {
    if (!('Notification' in window) || Notification.permission !== 'granted') {
      return false;
    }
    try {
      new Notification(title, {
        body: body,
        icon: 'icons/Icon-192.png',
        badge: 'icons/Icon-192.png',
        tag: tag || 'horizon-weather',
        renotify: true
      });
      return true;
    } catch (e) {
      return false;
    }
  }
};

// Horizon Off-Grid Hike & Trip Snapshot Exporter
window.horizonExporter = {
  printOrSaveReport(title, htmlBody) {
    const printWindow = window.open('', '_blank');
    if (!printWindow) {
      window.print();
      return;
    }
    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
      <head>
        <title>${title || 'Horizon Weather Dossier'}</title>
        <style>
          @page { size: portrait; margin: 15mm; }
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #fff;
            color: #111;
            margin: 0;
            padding: 20px;
            font-size: 12pt;
            line-height: 1.5;
          }
          h1 { font-size: 20pt; margin-bottom: 4px; letter-spacing: -0.5px; }
          h2 { font-size: 14pt; border-bottom: 2px solid #111; padding-bottom: 4px; margin-top: 24px; }
          .subtitle { color: #555; font-size: 10pt; margin-bottom: 20px; }
          table { width: 100%; border-collapse: collapse; margin: 16px 0; font-size: 10pt; }
          th, td { border: 1px solid #ddd; padding: 8px 10px; text-align: left; }
          th { background: #f4f4f4; font-weight: 600; }
          .badge { display: inline-block; padding: 2px 8px; border-radius: 4px; background: #eee; font-weight: bold; font-size: 9pt; }
          .section-box { border: 1px solid #111; padding: 12px; border-radius: 6px; margin: 12px 0; background: #fafafa; }
          .footer { margin-top: 30px; font-size: 9pt; color: #888; text-align: center; border-top: 1px dashed #ccc; padding-top: 10px; }
        </style>
      </head>
      <body>
        ${htmlBody}
        <script>
          window.onload = function() {
            setTimeout(function() {
              window.print();
            }, 300);
          };
        </script>
      </body>
      </html>
    `);
    printWindow.document.close();
  },

  downloadMarkdown(filename, content) {
    const blob = new Blob([content], { type: 'text/markdown;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename || 'horizon-weather-dossier.md';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }
};


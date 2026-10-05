<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Marin Hub</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }

  body {
    background: radial-gradient(circle at 50% 50%, #1a1a2e 0%, #0a0a0a 70%);
    height: 100vh;
    font-family: 'Segoe UI', 'Poppins', sans-serif;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  /* ===== BOTÃO PRINCIPAL ===== */
  .launcher {
    position: fixed;
    top: 30px;
    left: 30px;
    width: 90px;
    height: 90px;
    border-radius: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 1000;
    user-select: none;
    transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    background: linear-gradient(145deg, #1a1a1a, #0a0a0a);
    box-shadow:
      0 0 20px rgba(0, 255, 213, 0.4),
      0 0 40px rgba(122, 0, 255, 0.3),
      inset 0 1px 0 rgba(255, 255, 255, 0.1);
  }

  .launcher:hover {
    transform: scale(1.1) rotate(-3deg);
  }
  .launcher:active { transform: scale(0.95); }

  /* Borda RGB girando */
  .launcher::before {
    content: '';
    position: absolute;
    inset: -3px;
    border-radius: 26px;
    background: conic-gradient(
      from var(--angle),
      #ff0000, #ff7300, #fffb00, #48ff00,
      #00ffd5, #002bff, #7a00ff, #ff00c8, #ff0000
    );
    z-index: -1;
    animation: spin 4s linear infinite;
    filter: blur(0.5px);
  }

  /* Glow externo */
  .launcher::after {
    content: '';
    position: absolute;
    inset: -6px;
    border-radius: 30px;
    background: conic-gradient(
      from var(--angle),
      #ff0000, #ff7300, #fffb00, #48ff00,
      #00ffd5, #002bff, #7a00ff, #ff00c8, #ff0000
    );
    z-index: -2;
    animation: spin 4s linear infinite;
    filter: blur(22px);
    opacity: 0.85;
  }

  /* Conteúdo interno do botão */
  .launcher-inner {
    position: relative;
    width: 100%;
    height: 100%;
    border-radius: 22px;
    background:
      radial-gradient(circle at 30% 20%, rgba(255,255,255,0.08), transparent 50%),
      linear-gradient(145deg, #151515, #050505);
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
  }

  /* Brilho passando por dentro */
  .launcher-inner::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: linear-gradient(
      115deg,
      transparent 40%,
      rgba(255, 255, 255, 0.15) 50%,
      transparent 60%
    );
    animation: shine 3s linear infinite;
  }

  /* Letra M estilizada em SVG */
  .launcher-inner svg {
    width: 52px;
    height: 52px;
    filter: drop-shadow(0 0 6px rgba(0, 255, 213, 0.8));
    z-index: 2;
  }

  /* Animações */
  @property --angle {
    syntax: '<angle>';
    initial-value: 0deg;
    inherits: false;
  }

  @keyframes spin {
    to { --angle: 360deg; }
  }

  @keyframes shine {
    0%   { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
    100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
  }

  @keyframes rgb {
    0%   { background-position: 0% 50%; }
    100% { background-position: 400% 50%; }
  }

  /* ===== PAINEL ===== */
  .panel {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) scale(0.6);
    width: 420px;
    padding: 35px 30px;
    border-radius: 24px;
    background: linear-gradient(145deg, #131313, #0a0a0a);
    color: #fff;
    z-index: 999;
    opacity: 0;
    pointer-events: none;
    transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
    cursor: grab;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.8);
  }

  .panel.open {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
    pointer-events: auto;
  }

  .panel:active { cursor: grabbing; }

  .panel::before {
    content: '';
    position: absolute;
    inset: -3px;
    border-radius: 26px;
    background: conic-gradient(
      from var(--angle),
      #ff0000, #ff7300, #fffb00, #48ff00,
      #00ffd5, #002bff, #7a00ff, #ff00c8, #ff0000
    );
    z-index: -1;
    animation: spin 6s linear infinite;
  }

  .panel::after {
    content: '';
    position: absolute;
    inset: -6px;
    border-radius: 30px;
    background: conic-gradient(
      from var(--angle),
      #ff0000, #ff7300, #fffb00, #48ff00,
      #00ffd5, #002bff, #7a00ff, #ff00c8, #ff0000
    );
    z-index: -2;
    animation: spin 6s linear infinite;
    filter: blur(28px);
    opacity: 0.8;
  }

  /* Logo bonito dentro do painel */
  .logo-wrap {
    position: relative;
    width: 130px;
    height: 130px;
    margin: 0 auto 20px;
    border-radius: 30px;
    background: linear-gradient(145deg, #1a1a1a, #050505);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow:
      0 0 25px rgba(0, 255, 213, 0.35),
      0 0 50px rgba(122, 0, 255, 0.25),
      inset 0 1px 0 rgba(255, 255, 255, 0.1);
  }

  .logo-wrap::before {
    content: '';
    position: absolute;
    inset: -3px;
    border-radius: 33px;
    background: conic-gradient(
      from var(--angle),
      #ff0000, #ff7300, #fffb00, #48ff00,
      #00ffd5, #002bff, #7a00ff, #ff00c8, #ff0000
    );
    z-index: -1;
    animation: spin 5s linear infinite;
  }

  .logo-wrap::after {
    content: '';
    position: absolute;
    inset: -5px;
    border-radius: 35px;
    background: conic-gradient(
      from var(--angle),
      #ff0000, #ff7300, #fffb00, #48ff00,
      #00ffd5, #002bff, #7a00ff, #ff00c8, #ff0000
    );
    z-index: -2;
    animation: spin 5s linear infinite;
    filter: blur(20px);
    opacity: 0.9;
  }

  .logo-wrap svg {
    width: 75px;
    height: 75px;
    filter: drop-shadow(0 0 10px rgba(0, 255, 213, 0.9));
  }

  .panel h1 {
    font-size: 26px;
    font-weight: 900;
    text-align: center;
    letter-spacing: 3px;
    margin-bottom: 6px;
    background: linear-gradient(90deg, #ff0000, #ff7300, #fffb00, #48ff00, #00ffd5, #002bff, #7a00ff, #ff00c8, #ff0000);
    background-size: 400%;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    animation: rgb 6s linear infinite;
    filter: drop-shadow(0 0 15px rgba(0, 255, 213, 0.5));
  }

  .panel .subtitle {
    font-size: 12px;
    text-align: center;
    color: #888;
    letter-spacing: 4px;
    margin-bottom: 22px;
    text-transform: uppercase;
  }

  .panel p {
    font-size: 13px;
    color: #999;
    text-align: center;
    margin-bottom: 22px;
    line-height: 1.6;
  }

  .panel button {
    display: block;
    margin: 0 auto;
    padding: 12px 32px;
    border: none;
    border-radius: 12px;
    background: linear-gradient(90deg, #ff0000, #ff7300, #fffb00, #48ff00, #00ffd5, #002bff, #7a00ff, #ff00c8);
    background-size: 400%;
    color: #fff;
    font-weight: 700;
    font-size: 14px;
    letter-spacing: 1px;
    cursor: pointer;
    animation: rgb 8s linear infinite;
    transition: transform 0.2s, box-shadow 0.2s;
    box-shadow: 0 0 20px rgba(0, 255, 213, 0.4);
  }

  .panel button:hover {
    transform: scale(1.06);
    box-shadow: 0 0 30px rgba(0, 255, 213, 0.7);
  }

  .close-btn {
    position: absolute;
    top: 12px;
    right: 18px;
    font-size: 20px;
    color: #666;
    cursor: pointer;
    z-index: 10;
    transition: all 0.2s;
    width: 28px;
    height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
  }
  .close-btn:hover {
    color: #fff;
    background: rgba(255, 255, 255, 0.1);
  }
</style>
</head>
<body>

<!-- Botão flutuante -->
<div class="launcher" id="launcher">
  <div class="launcher-inner">
    <svg viewBox="0 0 100 100">
      <defs>
        <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#00ffd5"/>
          <stop offset="50%" stop-color="#7a00ff"/>
          <stop offset="100%" stop-color="#ff00c8"/>
        </linearGradient>
      </defs>
      <!-- M estilizado -->
      <path d="M20 80 L20 25 L35 25 L50 55 L65 25 L80 25 L80 80 L65 80 L65 48 L52 75 L48 75 L35 48 L35 80 Z"
            fill="url(#grad1)"/>
    </svg>
  </div>
</div>

<!-- Painel -->
<div class="panel" id="panel">
  <div class="close-btn" id="closeBtn">✕</div>
  <div class="logo-wrap">
    <svg viewBox="0 0 100 100">
      <defs>
        <linearGradient id="grad2" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#00ffd5"/>
          <stop offset="50%" stop-color="#7a00ff"/>
          <stop offset="100%" stop-color="#ff00c8"/>
        </linearGradient>
      </defs>
      <path d="M20 80 L20 25 L35 25 L50 55 L65 25 L80 25 L80 80 L65 80 L65 48 L52 75 L48 75 L35 48 L35 80 Z"
            fill="url(#grad2)"/>
    </svg>
  </div>
  <h1>MARIN HUB</h1>
  <div class="subtitle">Premium Panel</div>
  <p>Arraste-me para onde quiser</p>
  <button>Entrar</button>
</div>

<script>
  const launcher = document.getElementById('launcher');
  const panel = document.getElementById('panel');
  const closeBtn = document.getElementById('closeBtn');

  // Abrir
  launcher.addEventListener('click', () => {
    panel.classList.add('open');
    panel.style.left = '50%';
    panel.style.top = '50%';
    panel.style.transform = 'translate(-50%, -50%) scale(1)';
  });

  // Fechar
  closeBtn.addEventListener('click', () => {
    panel.classList.remove('open');
  });

  // Arrastar painel
  let isDragging = false, offsetX, offsetY;

  panel.addEventListener('mousedown', (e) => {
    if (e.target.tagName === 'BUTTON' ||
        e.target.classList.contains('close-btn')) return;
    isDragging = true;
    const rect = panel.getBoundingClientRect();
    offsetX = e.clientX - rect.left;
    offsetY = e.clientY - rect.top;
    panel.style.transition = 'none';
    panel.style.transform = 'none';
    panel.style.left = rect.left + 'px';
    panel.style.top = rect.top + 'px';
  });

  document.addEventListener('mousemove', (e) => {
    if (!isDragging) return;
    panel.style.left = (e.clientX - offsetX) + 'px';
    panel.style.top  = (e.clientY - offsetY) + 'px';
  });

  document.addEventListener('mouseup', () => {
    if (isDragging) {
      isDragging = false;
      panel.style.transition = 'all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)';
    }
  });

  // Arrastar botão
  let dragLauncher = false, lx, ly;

  launcher.addEventListener('mousedown', (e) => {
    dragLauncher = true;
    const rect = launcher.getBoundingClientRect();
    lx = e.clientX - rect.left;
    ly = e.clientY - rect.top;
  });

  document.addEventListener('mousemove', (e) => {
    if (!dragLauncher) return;
    launcher.style.left = (e.clientX - lx) + 'px';
    launcher.style.top  = (e.clientY - ly) + 'px';
  });

  document.addEventListener('mouseup', () => dragLauncher = false);
</script>

</body>
</html>

#!/usr/bin/env node
// Renders the App Store "Header & Search Results" artwork.
//
//   node tool/app_store_creative/render.mjs [locale]
//
// Writes opaque sRGB PNGs (no alpha, which Apple rejects) to
// ios/fastlane/app_store_creative/<locale>/. That folder sits outside
// ios/fastlane/screenshots/ so `deliver` won't try to upload them as screenshots.
//
// Safe boxes are the bounds of the "Art Safe Area" layer in Apple's PSD templates:
// https://developer.apple.com/app-store/asset-best-practices/
//
// Requires Google Chrome and ImageMagick.

import { execFileSync } from 'node:child_process';
import { mkdirSync, mkdtempSync, readFileSync, renameSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';

// Add a locale here to localize the art. Apple asks for text to be localized.
const COPY = {
  'en-US': {
    headline: ['Know they', 'got there.'],
    alert: 'Lily arrived at School', // app_en.arb: geofenceEntered
    app: 'FamHub',
    when: 'now',
  },
};

const LAYOUTS = {
  universal: {
    file: 'universal_5244x2950.png',
    W: 5244, H: 2950,
    safe: { x: 1921, y: 660, w: 1402, h: 962 },
    mapScale: 1,
    headline: { top: 688, size: 196, oneLine: false },
    phone: { top: 1100, w: 1040 },
    banner: { top: 1150, w: 1340 },
    zone: { r: 1000 },
    glow: { cy: 900, rx: 1250, ry: 720 },
    home: { dx: -1720, dy: 640, r: 430 },
    park: { dx: 1800, dy: -210, r: 390 },
    school: { dx: 860, dy: 470 },
  },
  header: {
    file: 'header_3840x1646.png',
    W: 3840, H: 1646,
    safe: { x: 1097, y: 493, w: 1646, h: 661 },
    mapScale: 0.82,
    headline: { top: 506, size: 150, oneLine: true },
    phone: { top: 700, w: 900 },
    banner: { top: 742, w: 1340 },
    zone: { r: 1130 },
    glow: { cy: 640, rx: 1300, ry: 480 },
    home: { dx: -1400, dy: 250, r: 310 },
    park: { dx: 1440, dy: -160, r: 280 },
    school: { dx: 970, dy: 360 },
  },
};

const C = {
  ink: '#2D2013', ink2: '#7A6652',
  orange: '#FF8C00', orangeDeep: '#E67700',
  cream: '#FFF8F0', land: '#F7EEDF', road: '#FFFDF9',
  block: ['#F2E6D3', '#F4E9D8', '#EFE2CC', '#F5EBDC'],
  building: '#E9DAC2',
  park: '#CFE6B4', parkDeep: '#BEDC9F',
  water: '#BFE3F4',
  green: '#66BB6A', blue: '#42A5F5',
};

const dataUri = (path, mime) =>
  `data:${mime};base64,${readFileSync(join(ROOT, path)).toString('base64')}`;

function rng(seed) {
  let s = seed >>> 0;
  return () => {
    s = (s + 0x6d2b79f5) >>> 0;
    let t = s;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// Illustrated city grid. Deliberately not real map tiles: no third-party data
// or attribution to carry, and it can be kept quiet behind the message.
function mapSvg(l) {
  const r = rng(20261106);
  const k = l.mapScale;
  const span = Math.hypot(l.W, l.H) * 1.05;
  const cuts = (min, max) => {
    const out = [-span / 2];
    while (out[out.length - 1] < span / 2) out.push(out[out.length - 1] + (min + r() * (max - min)) * k);
    return out;
  };
  const xs = cuts(250, 470);
  const ys = cuts(190, 360);
  const road = 30 * k;
  const artery = (i) => i % 5 === 2;
  let blocks = '';
  let buildings = '';
  for (let i = 0; i < xs.length - 1; i++) {
    for (let j = 0; j < ys.length - 1; j++) {
      const gx = (artery(i) ? 62 : road) * k * 0.5;
      const gy = (artery(j) ? 62 : road) * k * 0.5;
      const x = xs[i] + gx, y = ys[j] + gy;
      const w = xs[i + 1] - xs[i] - gx * 2, h = ys[j + 1] - ys[j] - gy * 2;
      const isPark = r() < 0.075;
      const fill = isPark ? C.park : C.block[Math.floor(r() * C.block.length)];
      blocks += `<rect x="${x.toFixed(1)}" y="${y.toFixed(1)}" width="${w.toFixed(1)}" height="${h.toFixed(1)}" rx="${(16 * k).toFixed(1)}" fill="${fill}"/>`;
      if (isPark) {
        const n = 3 + Math.floor(r() * 4);
        for (let t = 0; t < n; t++) {
          const rad = (20 + r() * 26) * k;
          blocks += `<circle cx="${(x + rad + r() * (w - 2 * rad)).toFixed(1)}" cy="${(y + rad + r() * (h - 2 * rad)).toFixed(1)}" r="${rad.toFixed(1)}" fill="${C.parkDeep}"/>`;
        }
        continue;
      }
      // Building footprints give the map fine grain at full canvas.
      const pad = 22 * k, cols = Math.max(1, Math.floor(w / (92 * k))), rows = Math.max(1, Math.floor(h / (84 * k)));
      const cw = (w - pad * 2) / cols, ch = (h - pad * 2) / rows;
      for (let a = 0; a < cols; a++) {
        for (let b = 0; b < rows; b++) {
          if (r() < 0.34) continue;
          const bw = cw * (0.55 + r() * 0.3), bh = ch * (0.55 + r() * 0.3);
          buildings += `<rect x="${(x + pad + a * cw).toFixed(1)}" y="${(y + pad + b * ch).toFixed(1)}" width="${bw.toFixed(1)}" height="${bh.toFixed(1)}" rx="${(6 * k).toFixed(1)}"/>`;
        }
      }
    }
  }
  const { W, H } = l;
  // River through the lower-right corner of the canvas.
  const water = `<path d="M${W * 0.76} ${H + 40} C ${W * 0.8} ${H * 0.82}, ${W * 0.94} ${H * 0.8}, ${W + 40} ${H * 0.58} L ${W + 40} ${H + 40} Z" fill="${C.water}"/>`;
  return `<svg class="layer" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}">
    <rect width="${W}" height="${H}" fill="${C.road}"/>
    <g transform="translate(${W / 2} ${H / 2}) rotate(-31)">${blocks}<g fill="${C.building}">${buildings}</g></g>
    ${water}
  </svg>`;
}

const ICONS = {
  home: `<path d="M-46 -2 L0 -44 L46 -2 M-32 -12 V38 H-10 V12 H10 V38 H32 V-12" fill="none" stroke="#fff" stroke-width="13" stroke-linecap="round" stroke-linejoin="round"/>`,
  school: `<path d="M-46 38 V-2 L0 -26 L46 -2 V38 Z" fill="#fff"/><path d="M0 -26 V-50 L22 -42 L0 -35" fill="#fff"/><rect x="-11" y="12" width="22" height="26" rx="4" fill="${C.orange}"/><rect x="-34" y="4" width="14" height="14" rx="3" fill="${C.orange}"/><rect x="20" y="4" width="14" height="14" rx="3" fill="${C.orange}"/>`,
  tree: `<circle cx="0" cy="-16" r="32" fill="#fff"/><circle cx="-24" cy="4" r="22" fill="#fff"/><circle cx="24" cy="4" r="22" fill="#fff"/><rect x="-7" y="6" width="14" height="38" rx="5" fill="#fff"/>`,
};

// A map pin whose tip lands on (x, y).
const pin = (x, y, icon, s = 1) =>
  `<g transform="translate(${x} ${y}) scale(${s})">
    <ellipse cx="0" cy="4" rx="46" ry="15" fill="${C.ink}" opacity=".16"/>
    <path d="M0 0 C-30 -46 -104 -92 -104 -168 A104 104 0 0 1 104 -168 C104 -92 30 -46 0 0 Z" fill="${C.orange}" stroke="#fff" stroke-width="13" stroke-linejoin="round"/>
    <g transform="translate(0 -168) scale(1.05)">${ICONS[icon]}</g>
  </g>`;

function sceneSvg(l) {
  const cx = l.safe.x + l.safe.w / 2;
  const cy = l.safe.y + l.safe.h / 2;
  const homeX = cx + l.home.dx, homeY = cy + l.home.dy;
  const parkX = cx + l.park.dx, parkY = cy + l.park.dy;
  const schoolX = cx + l.school.dx, schoolY = cy + l.school.dy;
  const zone = (x, y, r, w, fillO = 0.17) =>
    `<circle cx="${x}" cy="${y}" r="${r}" fill="${C.orange}" fill-opacity="${fillO}" stroke="${C.orange}" stroke-width="${w}"/>`;
  const scale = l.mapScale;
  // The walk from Home ends at School, passing behind the phone.
  const route = `M${homeX} ${homeY - 8} C ${homeX + 620 * scale} ${homeY - 40}, ${cx - 300} ${cy + l.home.dy * 1.5}, ${cx} ${cy + l.home.dy * 0.9} S ${schoolX - 300 * scale} ${schoolY + 150 * scale}, ${schoolX} ${schoolY}`;
  return `<svg class="layer" width="${l.W}" height="${l.H}" viewBox="0 0 ${l.W} ${l.H}">
    <defs>
      <radialGradient id="glow" gradientUnits="userSpaceOnUse" cx="0" cy="0" r="1"
        gradientTransform="translate(${cx} ${l.glow.cy}) scale(${l.glow.rx} ${l.glow.ry})">
        <stop offset="0" stop-color="${C.cream}" stop-opacity=".98"/>
        <stop offset=".45" stop-color="${C.cream}" stop-opacity=".94"/>
        <stop offset=".62" stop-color="${C.cream}" stop-opacity=".78"/>
        <stop offset=".76" stop-color="${C.cream}" stop-opacity=".46"/>
        <stop offset=".89" stop-color="${C.cream}" stop-opacity=".16"/>
        <stop offset="1" stop-color="${C.cream}" stop-opacity="0"/>
      </radialGradient>
      <radialGradient id="edge" gradientUnits="userSpaceOnUse" cx="${cx}" cy="${cy}" r="${Math.hypot(l.W, l.H) * 0.56}">
        <stop offset=".55" stop-color="${C.orange}" stop-opacity="0"/>
        <stop offset="1" stop-color="${C.orange}" stop-opacity=".2"/>
      </radialGradient>
    </defs>
    <rect width="${l.W}" height="${l.H}" fill="url(#edge)"/>
    <circle cx="${cx}" cy="${cy}" r="${l.zone.r * 1.62}" fill="none" stroke="${C.orange}" stroke-width="${8 * scale}" opacity=".16"/>
    <circle cx="${cx}" cy="${cy}" r="${l.zone.r * 1.3}" fill="none" stroke="${C.orange}" stroke-width="${10 * scale}" opacity=".3"/>
    ${zone(cx, cy, l.zone.r, 16 * scale)}
    ${zone(homeX, homeY - 80 * scale, l.home.r, 12 * scale, 0.13)}
    ${zone(parkX, parkY - 80 * scale, l.park.r, 12 * scale, 0.13)}
    <rect width="${l.W}" height="${l.H}" fill="url(#glow)"/>
    <path d="${route}" fill="none" stroke="${C.orangeDeep}" stroke-width="${22 * scale}" stroke-linecap="round" stroke-dasharray="${2} ${58 * scale}"/>
    ${pin(homeX, homeY, 'home', 1.2 * scale)}
    ${pin(parkX, parkY, 'tree', 1.2 * scale)}
    ${pin(schoolX, schoolY, 'school', 1.35 * scale)}
    <g transform="translate(${schoolX + 186 * scale} ${schoolY - 70 * scale})">
      <circle r="${84 * scale}" fill="${C.green}" stroke="#fff" stroke-width="${18 * scale}"/>
      <text y="${35 * scale}" text-anchor="middle" font-family="Nunito" font-weight="900" font-size="${100 * scale}" fill="#fff">L</text>
    </g>
  </svg>`;
}

function html(l, t) {
  const font = (w, f) =>
    `@font-face{font-family:Nunito;font-weight:${w};src:url(${dataUri(`assets/fonts/${f}.ttf`, 'font/ttf')}) format('truetype');}`;
  const bezel = Math.round(l.phone.w * 0.026);
  const radius = Math.round(l.phone.w * 0.145);
  const cx = l.safe.x + l.safe.w / 2;
  const title = l.headline.oneLine ? t.headline.join(' ') : t.headline.join('<br>');
  return `<!doctype html><html><head><meta charset="utf-8"><style>
  ${font(600, 'Nunito-SemiBold')}${font(800, 'Nunito-ExtraBold')}${font(900, 'Nunito-Black')}
  *{margin:0;padding:0;box-sizing:border-box}
  html,body{width:${l.W}px;height:${l.H}px;overflow:hidden;background:${C.land};font-family:Nunito,sans-serif}
  .layer{position:absolute;left:0;top:0}
  h1{position:absolute;left:${cx}px;top:${l.headline.top}px;transform:translateX(-50%);white-space:nowrap;text-align:center;
     font-weight:900;font-size:${l.headline.size}px;line-height:.98;letter-spacing:-.018em;color:${C.ink}}
  .phone{position:absolute;left:${cx - l.phone.w / 2}px;top:${l.phone.top}px;width:${l.phone.w}px;padding:${bezel}px;
     background:linear-gradient(145deg,#4A3A2A,#1E1610 40%,#2D2118);border-radius:${radius}px;
     box-shadow:0 0 0 5px #6B5843,0 90px 180px rgba(83,47,8,.34),0 24px 60px rgba(83,47,8,.24)}
  .phone img{display:block;width:100%;border-radius:${radius - bezel}px}
  .banner{position:absolute;left:${cx - l.banner.w / 2}px;top:${l.banner.top}px;width:${l.banner.w}px;
     display:flex;align-items:center;gap:44px;padding:44px 56px 44px 44px;background:#fff;border-radius:84px;
     box-shadow:0 70px 130px rgba(83,47,8,.34),0 14px 36px rgba(83,47,8,.2)}
  .banner img{width:172px;height:172px;flex:none;border-radius:39px}
  .text{flex:1;min-width:0}
  .row{display:flex;justify-content:space-between;font-weight:800;font-size:56px;line-height:1.1;color:${C.ink2}}
  .row .when{font-weight:600}
  .msg{margin-top:12px;font-weight:900;font-size:88px;line-height:1.08;letter-spacing:-.012em;color:${C.ink};white-space:nowrap}
  </style></head><body>
  ${mapSvg(l)}
  ${sceneSvg(l)}
  <h1>${title}</h1>
  <div class="phone"><img src="${dataUri('ios/fastlane/screenshots/en-US/iPhone69_01_parent-home.png', 'image/png')}"></div>
  <div class="banner">
    <img src="${dataUri('assets/icons/app/app_icon.png', 'image/png')}">
    <div class="text">
      <div class="row"><span>${t.app}</span><span class="when">${t.when}</span></div>
      <div class="msg">${t.alert}</div>
    </div>
  </div>
  </body></html>`;
}

const locale = process.argv[2] ?? 'en-US';
const copy = COPY[locale];
if (!copy) throw new Error(`No copy for locale "${locale}". Add it to COPY.`);

const outDir = join(ROOT, 'ios/fastlane/app_store_creative', locale);
mkdirSync(outDir, { recursive: true });
const work = mkdtempSync(join(tmpdir(), 'creative-'));

for (const l of Object.values(LAYOUTS)) {
  const page = join(work, `${l.W}.html`);
  const raw = join(work, `${l.W}.png`);
  writeFileSync(page, html(l, copy));
  execFileSync(CHROME, [
    '--headless=new', '--disable-gpu', '--hide-scrollbars', '--force-device-scale-factor=1',
    `--window-size=${l.W},${l.H}`, '--virtual-time-budget=8000',
    `--user-data-dir=${join(work, 'profile')}`, `--screenshot=${raw}`, `file://${page}`,
  ], { stdio: 'ignore' });
  const out = join(outDir, l.file);
  // Apple rejects alpha: flatten to 8-bit opaque sRGB.
  execFileSync('magick', [raw, '-alpha', 'off', '-colorspace', 'sRGB', '-depth', '8', '-strip', `PNG24:${out}.tmp`]);
  renameSync(`${out}.tmp`, out);
  console.log(out);
}
rmSync(work, { recursive: true, force: true });

// Mints the Supabase legacy anon / service_role API keys (HS256) from JWT_SECRET.
// Header/payload strings are fixed so every service derives byte-identical keys.
const crypto = require('crypto');
const s = process.env.JWT_SECRET;
if (!s) process.exit(0);
const b64 = (x) => Buffer.from(x).toString('base64url');
const H = b64('{"alg":"HS256","typ":"JWT"}');
const mint = (role) => {
  const p = b64(`{"role":"${role}","iss":"supabase","iat":1760000000,"exp":2075000000}`);
  return `${H}.${p}.` + crypto.createHmac('sha256', s).update(`${H}.${p}`).digest('base64url');
};
console.log(`export ANON_KEY='${mint('anon')}'; export SERVICE_ROLE_KEY='${mint('service_role')}'`);

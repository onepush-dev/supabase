// Example Edge Function. Call it with your anon key:
//   curl https://YOUR-DOMAIN/functions/v1/hello -H "Authorization: Bearer ANON_KEY" -d '{"name":"Railway"}'
// SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY and SUPABASE_DB_URL are available via Deno.env.
Deno.serve(async (req: Request) => {
  let name = 'world'
  try { name = (await req.json()).name ?? name } catch (_) { /* no body */ }
  return new Response(
    JSON.stringify({ message: `Hello ${name}!`, has_anon_key: Boolean(Deno.env.get('SUPABASE_ANON_KEY')) }),
    { headers: { 'Content-Type': 'application/json' } },
  )
})

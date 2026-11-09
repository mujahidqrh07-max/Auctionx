-- AuctionX multi-user cloud migration. Run once in Supabase Dashboard > SQL Editor.
-- Do not expose a service_role key in the browser.
create table if not exists public.auctionx_auctions (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  data jsonb not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists auctionx_auctions_owner_id_idx on public.auctionx_auctions(owner_id);
alter table public.auctionx_auctions enable row level security;
drop policy if exists "AuctionX public can view auctions" on public.auctionx_auctions;
create policy "AuctionX public can view auctions" on public.auctionx_auctions for select to anon, authenticated using (true);
drop policy if exists "AuctionX users create own auctions" on public.auctionx_auctions;
create policy "AuctionX users create own auctions" on public.auctionx_auctions for insert to authenticated
with check (owner_id = auth.uid() and coalesce(auth.jwt() ->> 'email', '') <> '');
drop policy if exists "AuctionX owner or super admin updates" on public.auctionx_auctions;
create policy "AuctionX owner or super admin updates" on public.auctionx_auctions for update to authenticated
using (owner_id = auth.uid() or lower(coalesce(auth.jwt() ->> 'email', '')) = 'mujahidqrh@gmail.com')
with check (owner_id = auth.uid() or lower(coalesce(auth.jwt() ->> 'email', '')) = 'mujahidqrh@gmail.com');
drop policy if exists "AuctionX owner or super admin deletes" on public.auctionx_auctions;
create policy "AuctionX owner or super admin deletes" on public.auctionx_auctions for delete to authenticated
using (owner_id = auth.uid() or lower(coalesce(auth.jwt() ->> 'email', '')) = 'mujahidqrh@gmail.com');
do $$ begin
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='auctionx_auctions') then
    alter publication supabase_realtime add table public.auctionx_auctions;
  end if;
end $$;
-- Legacy table is intentionally retained as a rollback backup. No automatic destructive migration.

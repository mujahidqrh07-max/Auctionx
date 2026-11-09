AuctionX Cloud Sync build

This package preserves the MVP auction-page layout and theme and includes Supabase Auth,
cloud persistence, and Realtime subscription code.

SETUP REQUIRED BEFORE MULTI-DEVICE USE
1. Open your Supabase project: https://supabase.com/dashboard/project/pflxjtrzkvvwpxjyafau
2. Open SQL Editor and run AuctionX-MultiUser-Migration.sql (included in this ZIP).
3. In Authentication > Providers, enable Email provider.
4. In Authentication > URL Configuration, add your deployed app URL to Site URL / Redirect URLs.
5. Deploy the contents of this folder to the existing hosting project.
6. Sign in with the Admin email configured in the app. Regular users must sign up / sign in to create auctions.
7. Test by creating an auction on one device and refreshing another device.

IMPORTANT
- The browser uses only the Supabase publishable key. Never put a service_role/secret key in HTML.
- The migration intentionally keeps the legacy cricauction_state table unchanged as a backup.
- If the cloud table is empty but this browser has local auctions, the app retains local data rather than silently replacing it.
- Database migration and live multi-device behavior cannot be confirmed until the SQL is run in the Supabase project and tested on two devices.

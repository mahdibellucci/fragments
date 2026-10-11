import './globals.css'
import { PostHogProvider, ThemeProvider } from './providers'
import { Toaster } from '@/components/ui/toaster'
import { Analytics } from '@vercel/analytics/next'
import { GoogleTagManager } from '@next/third-parties/google'
import type { Metadata } from 'next'
// Google Fonts is unreachable from this sandbox, so `next/font/google` (Inter)
// cannot fetch its CSS at build time. We self-host the exact same Inter family
// via the `@fontsource/inter` npm package instead.
import localFont from 'next/font/local'

const inter = localFont({
  src: [
    {
      path: '../node_modules/@fontsource/inter/files/inter-latin-300-normal.woff2',
      weight: '300',
      style: 'normal',
    },
    {
      path: '../node_modules/@fontsource/inter/files/inter-latin-400-normal.woff2',
      weight: '400',
      style: 'normal',
    },
    {
      path: '../node_modules/@fontsource/inter/files/inter-latin-500-normal.woff2',
      weight: '500',
      style: 'normal',
    },
    {
      path: '../node_modules/@fontsource/inter/files/inter-latin-600-normal.woff2',
      weight: '600',
      style: 'normal',
    },
    {
      path: '../node_modules/@fontsource/inter/files/inter-latin-700-normal.woff2',
      weight: '700',
      style: 'normal',
    },
  ],
})

export const metadata: Metadata = {
  title: 'Fragments by E2B',
  description: "Open-source version of Anthropic's Artifacts",
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      {process.env.NEXT_PUBLIC_GTM_ID && (
        <GoogleTagManager gtmId={process.env.NEXT_PUBLIC_GTM_ID} />
      )}
      <PostHogProvider>
        <body className={inter.className}>
          <ThemeProvider
            attribute="class"
            defaultTheme="dark"
            enableSystem
            disableTransitionOnChange
          >
            {children}
          </ThemeProvider>
          <Toaster />
          <Analytics />
        </body>
      </PostHogProvider>
    </html>
  )
}

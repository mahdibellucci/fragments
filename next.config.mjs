/** @type {import('next').NextConfig} */

// The upstream repo hard-codes `X-Frame-Options: DENY`, which blocks the app
// from rendering inside the LM Arena preview iframe. Embedding is allowed by
// default here; set ALLOW_IFRAME_EMBEDDING=false to restore the DENY header.
const allowIframeEmbedding = process.env.ALLOW_IFRAME_EMBEDDING !== 'false'

const nextConfig = {
  async headers() {
    if (allowIframeEmbedding) {
      return []
    }

    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
        ],
      },
    ]
  },
}

export default nextConfig

import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Vercel 原生部署，不需要 output: 'export'，API 路由可直接使用
  images: {
    unoptimized: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
};

export default nextConfig;

"use client";

import { motion } from "framer-motion";
import { ReactNode } from "react";

export default function PageTransition({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <motion.div
      initial={{ y: 20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ ease: "easeOut", duration: 0.8 }}
      className={className}
    >
      {children}
    </motion.div>
  );
}
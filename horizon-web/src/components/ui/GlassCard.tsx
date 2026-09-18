import React from 'react';

interface GlassCardProps extends React.HTMLAttributes<HTMLDivElement> {
  children: React.ReactNode;
  className?: string;
  glowColor?: string;
  hoverEffect?: boolean;
}

export const GlassCard: React.FC<GlassCardProps> = ({
  children,
  className = '',
  glowColor,
  hoverEffect = true,
  style,
  ...props
}) => {
  return (
    <div
      className={`glass-card ${hoverEffect ? 'hoverable' : ''} ${className}`}
      style={{
        ...style,
        ...(glowColor ? { borderColor: glowColor } : {}),
      }}
      {...props}
    >
      {children}
    </div>
  );
};

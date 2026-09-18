import React from 'react';

interface BadgeProps {
  children: React.ReactNode;
  variant?: 'gold' | 'cyan' | 'peach' | 'sage' | 'muted';
  className?: string;
}

export const Badge: React.FC<BadgeProps> = ({
  children,
  variant = 'gold',
  className = '',
}) => {
  return <span className={`badge badge-${variant} ${className}`}>{children}</span>;
};

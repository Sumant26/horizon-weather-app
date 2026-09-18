import React from 'react';
import { TECH_SPECS, TechSpecItem } from '../../domain/data/tech_specs';
import { GlassCard } from '../ui/GlassCard';
import { Badge } from '../ui/Badge';
import { Cpu, ShieldCheck, Layers } from 'lucide-react';

export const TechSpecsSection: React.FC = () => {
  return (
    <section id="specs" className="section-container">
      <div className="section-header">
        <Badge variant="sage">CLEAN ARCHITECTURE</Badge>
        <h2 className="section-title">Engineered with Architectural Discipline</h2>
        <p className="section-subtitle">
          Built without compromise: strict Clean Architecture, deterministic state transitions, zero analytics bloat, and sub-millisecond offline caching.
        </p>
      </div>

      <div className="tech-specs-grid">
        {TECH_SPECS.map((spec: TechSpecItem, index: number) => (
          <GlassCard key={index} className="spec-card">
            <div className="spec-card-header">
              {index === 0 && <Layers size={20} className="text-gold" />}
              {index === 1 && <ShieldCheck size={20} className="text-sage" />}
              {index === 2 && <Cpu size={20} className="text-cyan" />}
              <h3 className="spec-category">{spec.category}</h3>
            </div>

            <div className="spec-items-list">
              {spec.items.map((item, i) => (
                <div key={i} className="spec-row">
                  <span className="spec-label">{item.label}</span>
                  <span className="spec-value">{item.value}</span>
                </div>
              ))}
            </div>
          </GlassCard>
        ))}
      </div>
    </section>
  );
};

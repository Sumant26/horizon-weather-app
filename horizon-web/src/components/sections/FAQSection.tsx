import React, { useState } from 'react';
import { FAQS, FAQItem } from '../../domain/data/faqs';
import { GlassCard } from '../ui/GlassCard';
import { Badge } from '../ui/Badge';
import { ChevronDown } from 'lucide-react';

export const FAQSection: React.FC = () => {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  const toggle = (idx: number) => {
    setOpenIndex(openIndex === idx ? null : idx);
  };

  return (
    <section id="faq" className="section-container">
      <div className="section-header">
        <Badge variant="muted">FAQ</Badge>
        <h2 className="section-title">Frequently Asked Questions</h2>
        <p className="section-subtitle">
          Everything you need to know about distribution, privacy, installation, and data sources.
        </p>
      </div>

      <div className="faq-list max-w-3xl mx-auto">
        {FAQS.map((faq: FAQItem, index: number) => {
          const isOpen = openIndex === index;
          return (
            <GlassCard
              key={index}
              className={`faq-card ${isOpen ? 'open' : ''}`}
              onClick={() => toggle(index)}
            >
              <div className="faq-question-row">
                <h3 className="faq-question">{faq.question}</h3>
                <span className={`faq-arrow ${isOpen ? 'rotated' : ''}`}>
                  <ChevronDown size={18} />
                </span>
              </div>
              {isOpen && <p className="faq-answer">{faq.answer}</p>}
            </GlassCard>
          );
        })}
      </div>
    </section>
  );
};

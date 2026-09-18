import React from 'react';
import { PlatformType } from '../../core/utils/platform_detector';

interface TabItem {
  id: PlatformType;
  label: string;
  icon: React.ReactNode;
  badge?: string;
}

interface TabGroupProps {
  tabs: TabItem[];
  activeTab: PlatformType;
  onChange: (tabId: PlatformType) => void;
}

export const TabGroup: React.FC<TabGroupProps> = ({
  tabs,
  activeTab,
  onChange,
}) => {
  return (
    <div className="tab-group" role="tablist">
      {tabs.map((tab) => {
        const isActive = activeTab === tab.id;
        return (
          <button
            key={tab.id}
            role="tab"
            aria-selected={isActive}
            className={`tab-btn ${isActive ? 'active' : ''}`}
            onClick={() => onChange(tab.id)}
          >
            <span className="tab-icon">{tab.icon}</span>
            <span className="tab-label">{tab.label}</span>
            {tab.badge && <span className="tab-badge">{tab.badge}</span>}
          </button>
        );
      })}
    </div>
  );
};

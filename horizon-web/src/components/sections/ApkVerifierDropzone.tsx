import React, { useState, useRef } from 'react';
import { ShieldCheck, ShieldAlert, UploadCloud, Loader2, RefreshCw } from 'lucide-react';

interface ApkVerifierDropzoneProps {
  expectedChecksum: string;
}

export const ApkVerifierDropzone: React.FC<ApkVerifierDropzoneProps> = ({
  expectedChecksum,
}) => {
  const [isDragging, setIsDragging] = useState(false);
  const [isCalculating, setIsCalculating] = useState(false);
  const [calculatedHash, setCalculatedHash] = useState<string | null>(null);
  const [fileName, setFileName] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const calculateSha256 = async (file: File) => {
    setIsCalculating(true);
    setError(null);
    setCalculatedHash(null);
    setFileName(file.name);

    try {
      const buffer = await file.arrayBuffer();
      const hashBuffer = await crypto.subtle.digest('SHA-256', buffer);
      const hashArray = Array.from(new Uint8Array(hashBuffer));
      const hashHex = hashArray
        .map((b) => b.toString(16).padStart(2, '0'))
        .join('');
      setCalculatedHash(hashHex);
    } catch {
      setError('Unable to compute cryptographic checksum. Please try again.');
    } finally {
      setIsCalculating(false);
    }
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = () => {
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
      calculateSha256(e.dataTransfer.files[0]);
    }
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      calculateSha256(e.target.files[0]);
    }
  };

  const isMatch =
    calculatedHash &&
    calculatedHash.toLowerCase() === expectedChecksum.toLowerCase();

  const reset = () => {
    setCalculatedHash(null);
    setFileName(null);
    setError(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  return (
    <div className="verifier-container">
      <div className="verifier-header">
        <div className="flex items-center gap-2">
          <ShieldCheck size={16} className="text-sage" />
          <h4 className="verifier-title">In-Browser APK Integrity Verifier</h4>
        </div>
        <span className="verifier-privacy-tag">Client-side only • Zero upload</span>
      </div>

      {!calculatedHash && !isCalculating && (
        <div
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          onDrop={handleDrop}
          onClick={() => fileInputRef.current?.click()}
          className={`verifier-dropzone ${isDragging ? 'dragging' : ''}`}
        >
          <input
            ref={fileInputRef}
            type="file"
            accept=".apk,application/vnd.android.package-archive"
            onChange={handleFileChange}
            style={{ display: 'none' }}
          />
          <UploadCloud size={24} className="dropzone-icon" />
          <p className="dropzone-text">
            Drop downloaded <strong className="text-white">app-release.apk</strong> here to verify
          </p>
          <span className="dropzone-sub">or click to browse local file</span>
        </div>
      )}

      {isCalculating && (
        <div className="verifier-status-box">
          <Loader2 size={24} className="spinner text-cyan" />
          <p className="status-text">Computing SHA-256 cryptographic hash...</p>
          <span className="status-sub">{fileName}</span>
        </div>
      )}

      {calculatedHash && (
        <div className={`verifier-result-box ${isMatch ? 'result-success' : 'result-warning'}`}>
          <div className="result-header">
            {isMatch ? (
              <div className="flex items-center gap-2 text-sage">
                <ShieldCheck size={18} />
                <strong>Verified Authentic & Safe</strong>
              </div>
            ) : (
              <div className="flex items-center gap-2 text-amber">
                <ShieldAlert size={18} />
                <strong>Checksum Mismatch Warning</strong>
              </div>
            )}
            <button onClick={reset} className="verifier-reset-btn" title="Verify another file">
              <RefreshCw size={13} />
              <span>Verify another</span>
            </button>
          </div>

          <p className="result-desc">
            {isMatch
              ? `File "${fileName}" perfectly matches the official release hash. The APK is 100% untampered.`
              : `File "${fileName}" does not match the official build. It may be corrupted or an older release.`}
          </p>

          <div className="result-hashes">
            <div className="hash-row">
              <span className="hash-label">Calculated:</span>
              <code className="hash-value">{calculatedHash}</code>
            </div>
            <div className="hash-row">
              <span className="hash-label">Expected:</span>
              <code className="hash-value">{expectedChecksum}</code>
            </div>
          </div>
        </div>
      )}

      {error && <p className="verifier-error">{error}</p>}
    </div>
  );
};

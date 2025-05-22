import { useState } from 'react';
import Layout from '../components/Layout';

export default function DownloadPage({ signOut }) {
  // holds document data
  const [verifiedData] = useState(() => {
    const storedData = sessionStorage.getItem('verifiedData');
    return storedData ? JSON.parse(storedData)?.updated_document : null;
  });

  function displayPreviewTable() {
    if (!verifiedData || !verifiedData?.extracted_data) {
      return <p>No extracted data available</p>;
    }
    return (
      <table className="usa-table">
        <thead>
          <tr>
            <th scope="col">Field</th>
            <th scope="col">Value</th>
            <th scope="col">Confidence</th>
          </tr>
        </thead>
        <tbody>
          {Object.entries(verifiedData?.extracted_data)
            .sort(([keyA], [keyB]) =>
              keyA.localeCompare(keyB, undefined, { numeric: true })
            )
            .map(([key, field]) => {
              return (
                <tr key={key}>
                  <td>{key}</td>
                  <td> {field.value ? field.value : ''}</td>
                  <td>
                    {field.confidence
                      ? parseFloat(field.confidence).toFixed(2) + '%'
                      : ''}
                  </td>
                </tr>
              );
            })}
        </tbody>
      </table>
    );
  }

  function downloadCSV() {
    if (!verifiedData || !verifiedData.extracted_data) {
      console.error('No data available for CSV download');
      return;
    }
    let csvContent = 'data:text/csv;charset=utf-8,Field,Value\n';

    const sortedEntries = Object.entries(verifiedData.extracted_data).sort(
      ([keyA], [keyB]) => keyA.localeCompare(keyB, undefined, { numeric: true })
    );

    // Construct CSV content
    sortedEntries.forEach(([key, field]) => {
      let value = field.value !== undefined ? `"${field.value}"` : '""';
      csvContent += `"${key}",${value}\n`;
    });

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');

    link.setAttribute('href', encodedUri);
    link.setAttribute(
      'download',
      verifiedData.document_key.replace(/\.[^/.]+$/, '') + '.csv'
    );
    document.body.appendChild(link);
    link.click();
  }

  function downloadJSON() {
    if (!verifiedData || !verifiedData.extracted_data) {
      console.error('No data available for JSON download');
      return;
    }
    const jsonContent = JSON.stringify(verifiedData, null, 2);
    const blob = new Blob([jsonContent], { type: 'application/json' });
    const url = URL.createObjectURL(blob);

    const link = document.createElement('a');
    link.href = url;
    link.download =
      verifiedData.document_key.replace(/\.[^/.]+$/, '') + '.json';
    document.body.appendChild(link);
    link.click();
  }

  function handleDownloadSubmit(event) {
    event.preventDefault();
    if (!verifiedData) {
      console.error('No document available for download');
      return;
    }
    // get the selected file type (CSV or JSON) from the radio buttons
    const fileType = document.querySelector(
      "input[name='download-file-type']:checked"
    ).value;

    if (!fileType) {
      console.error('No file type selected');
      return;
    }
    // Extract the original filename, remove 'input/
    let originalFilename = verifiedData.document_key
      ? verifiedData.document_key.replace(/^input\//, '')
      : 'document_data';

    // download function based on selected file type
    if (fileType === 'csv') {
      downloadCSV(verifiedData, originalFilename);
    } else {
      downloadJSON(verifiedData, originalFilename);
    }
  }

  return (
    <Layout signOut={signOut}>
      <div className="grid-container margin-bottom-15">
        {/* Start step indicator section  */}
        <div
          className="usa-step-indicator usa-step-indicator--counters margin-top-2 margin-bottom-6"
          aria-label="Document processing steps"
        >
          <ol className="usa-step-indicator__segments">
            <li className="usa-step-indicator__segment usa-step-indicator__segment--complete">
              <span className="usa-step-indicator__segment-label">
                Upload documents{' '}
                <span className="usa-sr-only">— completed</span>
              </span>
            </li>
            <li className="usa-step-indicator__segment usa-step-indicator__segment--complete">
              <span className="usa-step-indicator__segment-label">
                Verify documents and data{' '}
                <span className="usa-sr-only">— completed</span>
              </span>
            </li>
            <li
              className="usa-step-indicator__segment usa-step-indicator__segment--current"
              aria-current="step"
            >
              <span className="usa-step-indicator__segment-label">
                Save and download CSV file{' '}
                <span className="usa-sr-only">— current step</span>
              </span>
            </li>
          </ol>
        </div>
        {/* End step indicator section  */}
        <form onSubmit={handleDownloadSubmit}>
          <h1>Download document</h1>
          {/* Start card section  */}
          <ul className="usa-card-group">
            <li className="usa-card tablet:grid-col-6 widescreen:grid-col-4">
              <div className="usa-card__container">
                <div className="usa-card__header">
                  <h2 className="usa-card__heading font-body-md">
                    File download
                  </h2>
                </div>
                <div className="usa-card__body">
                  {/* Start radio button section  */}
                  <fieldset className="usa-fieldset">
                    <legend className="usa-legend usa-legend">
                      File type is
                    </legend>
                    <div className="usa-radio">
                      <input
                        className="usa-radio__input"
                        id="download-file-type-csv"
                        type="radio"
                        name="download-file-type"
                        value="csv"
                        defaultChecked
                      />
                      <label
                        className="usa-radio__label"
                        htmlFor="download-file-type-csv"
                      >
                        CSV
                      </label>
                    </div>
                    <div className="usa-radio">
                      <input
                        className="usa-radio__input"
                        id="download-file-type-json"
                        type="radio"
                        name="download-file-type"
                        value="json"
                      />
                      <label
                        className="usa-radio__label"
                        htmlFor="download-file-type-json"
                      >
                        JSON
                      </label>
                    </div>
                  </fieldset>
                  {/* End radio button section  */}
                </div>
                <div className="usa-card__footer">
                  {/* Start button section  */}
                  <div>
                    {' '}
                    <button
                      id="download-button"
                      className="usa-button"
                      type="submit"
                    >
                      Download file
                    </button>
                  </div>
                  {/* End button section  */}
                </div>
              </div>
            </li>
          </ul>
          {/*  End card section  */}
        </form>
        <div id="preview-section">
          <h2 id="preview-section-title">File Preview</h2>
          <h3 id="preview-section-file-name">File name</h3>
          <div>{displayPreviewTable()}</div>
        </div>
      </div>
    </Layout>
  );
}

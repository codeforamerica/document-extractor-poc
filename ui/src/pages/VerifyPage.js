import { useState, useEffect, useRef } from 'react';
import Layout from '../components/Layout';
import { authorizedFetch } from '../utils/api';
import { useNavigate } from 'react-router';
import * as pdfjsLib from 'pdfjs-dist';
import 'pdfjs-dist/build/pdf.worker.mjs';
import '../pdf-viewer.css';

export default function VerifyPage({ signOut }) {
  const [documentId] = useState(() => sessionStorage.getItem('documentId'));
  const [responseData, setResponseData] = useState(null); // API response
  const [loading, setLoading] = useState(true); // tracks if page is loading
  const [error, setError] = useState(false); // tracks when there is an error
  const [activeBoundingBox, setActiveBoundingBox] = useState(null); // tracks the currently focused field's bounding box
  const previewContainerRef = useRef(null);
  const pdfCanvasRef = useRef(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [numPages, setNumPages] = useState(null);
  const [pdfDocument, setPdfDocument] = useState(null);

  const navigate = useNavigate();

  async function pollApiRequest(attempts = 30, delay = 2000) {
    for (let i = 0; i < attempts; i++) {
      try {
        const response = await authorizedFetch(`/api/document/${documentId}`, {
          method: 'GET',
          headers: {
            Accept: 'application/json',
          },
        });

        if (response.ok) {
          const result = await response.json(); // parse response

          setResponseData(result); // store API data in state
          setLoading(false); // stop loading when data is received
          setError(false); // clear any previous errors
          return;
        } else if (response.status === 401 || response.status === 403) {
          alert('You are no longer signed in!  Please sign in again.');
          signOut();
          return;
        } else {
          console.warn(`Attempt ${i + 1} failed: ${response.statusText}`);
        }
      } catch (error) {
        console.error(`Attempt ${i + 1} failed:`, error);
      }

      await new Promise((resolve) => setTimeout(resolve, delay));
    }
    console.error('Attempt failed after max attempts');
    setLoading(false);
    setError(true);
  }

  async function handleVerifySubmit(event) {
    event.preventDefault();

    if (!responseData || !responseData.extracted_data) {
      console.log('no extracted data available');
    }
    const formData = {
      extracted_data: responseData.extracted_data,
    };

    try {
      const apiUrl = `/api/document/${responseData.document_id}`;
      const response = await authorizedFetch(apiUrl, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        const result = await response.json();
        sessionStorage.setItem('verifiedData', JSON.stringify(result));
        navigate('/download-document');
        //TODO remove alert
        alert('Data saved successfully!');
      } else if (response.status === 401 || response.status === 403) {
        alert('You are no longer signed in!  Please sign in again.');
        signOut();
      } else {
        //TODO remove alert
        const result = await response.json();
        alert('Failed to save data: ' + result.error);
      }
    } catch (error) {
      console.error('Error submitting data:', error);
      //TODO remove alert
      alert('An error occurred while saving.');
    }
  }

  useEffect(() => {
    if (!documentId) {
      console.error('No documentId found in sessionStorage');
      setLoading(false);
      setError(true);
      return;
    }
    pollApiRequest();
  }, []); // runs only once when the component mounts

  function displayFileName() {
    const fileName = responseData?.document_key
      ? responseData?.document_key.replace('input/', '')
      : ' ';
    return fileName;
  }

  function handleInputChange(event, key, field) {
    setResponseData((prevData) => ({
      ...prevData, // keep previous data
      extracted_data: {
        ...prevData.extracted_data, // keep other fields the same
        [key]: { ...field, value: event.target.value },
      },
    }));
  }

  function handleInputFocus(field) {
    if (field.boundingBox) {
      setActiveBoundingBox(field.boundingBox);
      
      // If we have a PDF open, re-render with the bounding box
      if (responseData?.document_key?.split('.')?.pop()?.toLowerCase() === 'pdf' && 
          pdfDocument && pdfCanvasRef.current) {
        // The PDF will re-render automatically due to the useEffect dependency on activeBoundingBox
      }
    }
  }

  function handleInputBlur() {
    setActiveBoundingBox(null);
  }

  function shouldUseTextarea(value) {
    if (typeof value !== 'string') return false;
    return value.includes('\n');
  }

  function displayExtractedData() {
    if (!responseData?.extracted_data) {
      console.warn('No extracted data found.');
      return;
    }
    return Object.entries(responseData.extracted_data)
      .sort(([keyA], [keyB]) =>
        keyA.localeCompare(keyB, undefined, { numeric: true })
      )
      .map(([key, field]) => {
        return (
          <div key={key}>
            <label className="usa-label" htmlFor={`field-${key}`}>
              {key}{' '}
              <span className="text-accent-cool-darker display-inline-block width-full padding-top-2px">
                {field.confidence
                  ? `(Confidence ${field?.confidence.toFixed(2)})`
                  : 'Confidence'}
              </span>
            </label>
            {shouldUseTextarea(field.value) ? (
              <textarea
                className="usa-textarea"
                id={`field-${key}`}
                name={`field-${key}`}
                rows={2}
                value={field.value || ''}
                onChange={(event) => handleInputChange(event, key, field)}
                onFocus={() => handleInputFocus(field)}
                onBlur={handleInputBlur}
              />
            ) : (
              <input
                className="usa-input"
                id={`field-${key}`}
                name={`field-${key}`}
                value={field.value || ''}
                onChange={(event) => handleInputChange(event, key, field)}
                onFocus={() => handleInputFocus(field)}
                onBlur={handleInputBlur}
              />
            )}
          </div>
        );
      });
  }

  // Function to render a PDF page with bounding box overlay
  const renderPdf = async (pdfData, pageNum) => {
    if (!pdfCanvasRef.current) return;
    
    try {
      // Load the PDF data
      const loadingTask = pdfjsLib.getDocument({ data: atob(pdfData) });
      const pdf = await loadingTask.promise;
      setPdfDocument(pdf);
      setNumPages(pdf.numPages);
      
      // Get the page
      const page = await pdf.getPage(pageNum);
      
      // Get the canvas context
      const canvas = pdfCanvasRef.current;
      const context = canvas.getContext('2d');
      
      // Calculate the scale to fit the canvas
      const viewport = page.getViewport({ scale: 1 });
      const containerWidth = previewContainerRef.current.clientWidth;
      const scale = containerWidth / viewport.width;
      const scaledViewport = page.getViewport({ scale });
      
      // Set canvas dimensions
      canvas.height = scaledViewport.height;
      canvas.width = scaledViewport.width;
      
      // Render the PDF page
      const renderContext = {
        canvasContext: context,
        viewport: scaledViewport
      };
      
      await page.render(renderContext).promise;
      
      // If there's an active bounding box, draw it on the canvas
      if (activeBoundingBox) {
        drawBoundingBoxOnCanvas(context, activeBoundingBox, scaledViewport);
      }
    } catch (error) {
      console.error('Error rendering PDF:', error);
    }
  };
  
  // Function to draw a bounding box on the canvas
  const drawBoundingBoxOnCanvas = (context, boundingBox, viewport) => {
    if (!boundingBox) return;
    
    const { Left, Top, Width, Height } = boundingBox;
    
    // Calculate coordinates based on the viewport
    const x = Left * viewport.width;
    const y = Top * viewport.height;
    const width = Width * viewport.width;
    const height = Height * viewport.height;
    
    // Save current context state
    context.save();
    
    // Set bounding box styles
    context.strokeStyle = '#0050d8';
    context.lineWidth = 2;
    context.setLineDash([5, 3]); // Dotted line
    context.fillStyle = 'rgba(0, 80, 216, 0.1)';
    
    // Draw rectangle
    context.fillRect(x, y, width, height);
    context.strokeRect(x, y, width, height);
    
    // Restore context state
    context.restore();
  };
  
  // Function to handle page navigation
  const changePage = (newPage) => {
    if (newPage >= 1 && newPage <= numPages) {
      setCurrentPage(newPage);
    }
  };
  
  // Effect to re-render PDF when active bounding box changes
  useEffect(() => {
    if (responseData?.base64_encoded_file && 
        responseData.document_key.split('.').pop().toLowerCase() === 'pdf') {
      renderPdf(responseData.base64_encoded_file, currentPage);
    }
  }, [activeBoundingBox, currentPage, responseData]);

  function displayFilePreview() {
    if (!responseData || !responseData.base64_encoded_file) return null;

    // get file extension
    const fileExtension = responseData.document_key
      .split('.')
      .pop()
      .toLowerCase();
    const mimeType =
      fileExtension === 'pdf' ? 'application/pdf' : `image/${fileExtension}`;
    // Base64 URL to display image
    const base64Src = `data:${mimeType};base64,${responseData.base64_encoded_file}`;

    return (
      <div id="file-display-container" ref={previewContainerRef} className="position-relative">
        {fileExtension === 'pdf' ? (
          <div className="pdf-container">
            <canvas ref={pdfCanvasRef} className="pdf-canvas" />
            
            {numPages > 1 && (
              <div className="pdf-controls usa-pagination">
                <button 
                  onClick={() => changePage(currentPage - 1)} 
                  disabled={currentPage <= 1}
                  className="usa-button usa-button--outline"
                >
                  Previous
                </button>
                <span className="page-info">
                  Page {currentPage} of {numPages}
                </span>
                <button 
                  onClick={() => changePage(currentPage + 1)} 
                  disabled={currentPage >= numPages}
                  className="usa-button usa-button--outline"
                >
                  Next
                </button>
              </div>
            )}
          </div>
        ) : (
          <div className="position-relative">
            <img
              src={base64Src}
              alt="Uploaded Document"
              style={{ maxWidth: '100%', height: 'auto' }}
            />
            {activeBoundingBox && (
              <div
                className="bounding-box-highlight"
                style={{
                  position: 'absolute',
                  marginTop: "-4px",
                  left: `${activeBoundingBox.Left * 100}%`,
                  top: `${activeBoundingBox.Top * 100}%`,
                  width: `${activeBoundingBox.Width * 100}%`,
                  height: `${activeBoundingBox.Height * 100}%`,
                  border: '1px dotted #0050d8',
                  backgroundColor: 'rgba(0, 80, 216, 0.1)',
                  pointerEvents: 'none',
                  zIndex: 10,
                }}
              ></div>
            )}
          </div>
        )}
      </div>
    );
  }

  function displayStatusMessage() {
    if (loading) {
      return (
        <div className="loading-overlay">
          <div className="loading-content-el">
            <div className="loading-content">
              <p className="font-body-lg text-semi-bold">
                Processing your document
              </p>
              <p>We&apos;re extracting your data and it&apos;s on the way.</p>
              <div className="spinner" aria-label="loading"></div>
            </div>
          </div>
        </div>
      );
    }
    if (error) {
      return (
        <div className="loading-overlay">
          <div className="loading-content-el">
            <div className="loading-content">
              <p className="font-body-lg text-semi-bold">No data found</p>
              <p>
                We couldn&apos;t extract the data from this document. Please
                check the file format and then try again. If the issue persists,
                reach out to support.
              </p>
              <a href="/">Upload document</a>
            </div>
          </div>
        </div>
      );
    }
  }

  return (
    <Layout signOut={signOut}>
      {/* Start step indicator section  */}
      <div className="grid-container">
        <div
          className="usa-step-indicator usa-step-indicator--counters margin-y-2"
          aria-label="Document processing steps"
        >
          <ol className="usa-step-indicator__segments">
            <li className="usa-step-indicator__segment usa-step-indicator__segment--complete">
              <span className="usa-step-indicator__segment-label">
                Upload documents{' '}
                <span className="usa-sr-only">— completed</span>
              </span>
            </li>
            <li
              className="usa-step-indicator__segment usa-step-indicator__segment--current"
              aria-current="step"
            >
              <span className="usa-step-indicator__segment-label">
                Verify documents and data
                <span className="usa-sr-only">— current step</span>
              </span>
            </li>
            <li className="usa-step-indicator__segment">
              <span className="usa-step-indicator__segment-label">
                Save and download CSV file
                <span className="usa-sr-only">— not completed</span>
              </span>
            </li>
          </ol>
        </div>
      </div>
      {/* End step indicator section  */}
      <div className="border-top-2px border-base-lighter">
        <div className="grid-container position-relative">
          {displayStatusMessage()}
          <div className="grid-row">
            <div className="grid-col-12 tablet:grid-col-8">
              {/* Start card section  */}
              <ul className="usa-card-group">
                <li className="usa-card width-full">
                  <div className="usa-card__container file-preview-col">
                    <div className="usa-card__body">
                      <div>{displayFilePreview()}</div>
                      <p>{displayFileName()}</p>
                    </div>
                  </div>
                </li>
              </ul>
              {/* End card section  */}
            </div>
            <div className="grid-col-12 maxh-viewport border-bottom-2px border-base-lighter tablet:grid-col-4 tablet:border-left-2px tablet:border-base-lighter tablet:border-bottom-0">
              {/* Start verify form section  */}
              <form id="verify-form" onSubmit={handleVerifySubmit}>
                <ul className="usa-card-group">
                  <li className="usa-card width-full">
                    <div className="usa-card__container verify-col">
                      <div className="usa-card__body overflow-y-scroll minh-mobile-lg maxh-mobile-lg">
                        {displayExtractedData()}
                      </div>
                      <div className="usa-card__footer border-top-1px border-base-lighter">
                        <button
                          id="verify-button"
                          className="usa-button"
                          type="submit"
                        >
                          Data verified
                        </button>
                      </div>
                    </div>
                  </li>
                </ul>
              </form>
              {/* End verify form section  */}
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}

import logo from 'url:../assets/GSA-logo.svg';

export default function Footer() {
  return (
    <footer>
      <div className="usa-identifier">
        <section
          className="usa-identifier__section usa-identifier__section--masthead"
          aria-label="Agency identifier"
        >
          <div className="usa-identifier__container">
            <div className="usa-identifier__logos">
              <a href="javascript:void(0);" className="usa-identifier__logo">
                <img
                  className="usa-identifier__logo-img"
                  src={logo}
                  alt="&lt;Parent agency&gt; logo"
                  role="img"
                />
              </a>
            </div>
            <section
              className="usa-identifier__identity"
              aria-label="Agency description"
            >
              <p className="usa-identifier__identity-disclaimer">
                An official website of the
                <a href="https://www.gsa.gov">
                  U.S. General Services Administration
                </a>
              </p>
            </section>
          </div>
        </section>
        <nav
          className="usa-identifier__section usa-identifier__section--required-links"
          aria-label="Important links"
        >
          <div className="usa-identifier__container">
            <ul className="usa-identifier__required-links-list">
              <li className="usa-identifier__required-links-item">
                <a
                  href="https://www.gsa.gov/about-us"
                  className="usa-identifier__required-link"
                >
                  About GSA
                </a>
              </li>
              <li className="usa-identifier__required-links-item">
                <a
                  href="javascript:void(0);"
                  className="usa-identifier__required-link"
                >
                  Accessibility support
                </a>
              </li>
              <li className="usa-identifier__required-links-item">
                <a
                  href="javascript:void(0);"
                  className="usa-identifier__required-link usa-link"
                >
                  FOIA requests
                </a>
              </li>
              <li className="usa-identifier__required-links-item">
                <a
                  href="javascript:void(0);"
                  className="usa-identifier__required-link usa-link"
                >
                  No FEAR Act data
                </a>
              </li>
              <li className="usa-identifier__required-links-item">
                <a
                  href="javascript:void(0);"
                  className="usa-identifier__required-link usa-link"
                >
                  Office of the Inspector General
                </a>
              </li>
              <li className="usa-identifier__required-links-item">
                <a
                  href="javascript:void(0);"
                  className="usa-identifier__required-link usa-link"
                >
                  Performance reports
                </a>
              </li>
              <li className="usa-identifier__required-links-item">
                <a
                  href="javascript:void(0);"
                  className="usa-identifier__required-link usa-link"
                >
                  Privacy policy
                </a>
              </li>
            </ul>
          </div>
        </nav>
        <section
          className="usa-identifier__section usa-identifier__section--usagov"
          aria-label="U.S. government information and services,"
        >
          <div className="usa-identifier__container">
            <div className="usa-identifier__usagov-description">
              Looking for U.S. government information and services?
            </div>
            <a href="https://www.usa.gov/" className="usa-link">
              Visit USA.gov
            </a>
          </div>
        </section>
      </div>
    </footer>
  );
}

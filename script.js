const menuButton = document.querySelector(".menu-toggle");
const navigation = document.querySelector(".site-nav");
const navigationLinks = [...document.querySelectorAll('.site-nav a[href^="#"]')];
const mobileQuery = window.matchMedia("(max-width: 820px)");
const brandLink = document.querySelector('.brand[href="#top"]');
const siteHeader = document.querySelector(".site-header");
const reducedMotionQuery = window.matchMedia("(prefers-reduced-motion: reduce)");
let isReturningToTop = false;
let activeUpdateFrame = null;

function setMenuState(isOpen) {
  if (!menuButton || !navigation) return;

  menuButton.setAttribute("aria-expanded", String(isOpen));
  menuButton.setAttribute("aria-label", isOpen ? "Close navigation menu" : "Open navigation menu");
  navigation.classList.toggle("is-open", isOpen);
  document.body.classList.toggle("menu-open", isOpen);
}

function closeMenu() {
  setMenuState(false);
}

if (menuButton && navigation) {
  menuButton.addEventListener("click", () => {
    const isOpen = menuButton.getAttribute("aria-expanded") === "true";
    setMenuState(!isOpen);
  });

  navigationLinks.forEach((link) => link.addEventListener("click", closeMenu));

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && menuButton.getAttribute("aria-expanded") === "true") {
      closeMenu();
      menuButton.focus();
    }
  });

  mobileQuery.addEventListener("change", (event) => {
    if (!event.matches) closeMenu();
  });
}

if (brandLink) {
  brandLink.addEventListener("click", (event) => {
    event.preventDefault();
    isReturningToTop = true;
    updateActiveLink(null);
    window.scrollTo({
      top: 0,
      left: 0,
      behavior: reducedMotionQuery.matches ? "auto" : "smooth",
    });
    if (window.scrollY <= 1) isReturningToTop = false;
  });
}

const yearNode = document.querySelector("#current-year");
if (yearNode) {
  yearNode.textContent = String(new Date().getFullYear());
}

const sections = navigationLinks
  .map((link) => document.querySelector(link.getAttribute("href")))
  .filter(Boolean);
const heroSection = document.querySelector(".hero");
const trackedSections = heroSection ? [heroSection, ...sections] : sections;

function updateActiveLink(sectionId) {
  const activeSectionId = window.scrollY <= 1 ? null : sectionId;

  navigationLinks.forEach((link) => {
    const isActive = link.getAttribute("href") === `#${activeSectionId}`;
    if (isActive) {
      link.setAttribute("aria-current", "true");
    } else {
      link.removeAttribute("aria-current");
    }
  });
}

function updateActiveSection() {
  if (isReturningToTop) {
    updateActiveLink(null);
    return;
  }

  const headerBottom = siteHeader?.getBoundingClientRect().bottom ?? 0;
  const activationLine = Math.max(headerBottom + 24, window.innerHeight * 0.4);
  const activeSection = trackedSections.find((section) => {
    const bounds = section.getBoundingClientRect();
    return bounds.top <= activationLine && bounds.bottom > activationLine;
  });

  updateActiveLink(!activeSection || activeSection === heroSection ? null : activeSection.id);
}

function scheduleActiveSectionUpdate() {
  if (activeUpdateFrame !== null) return;

  activeUpdateFrame = window.requestAnimationFrame(() => {
    activeUpdateFrame = null;
    updateActiveSection();
  });
}

window.addEventListener(
  "scroll",
  () => {
    if (isReturningToTop && window.scrollY <= 1) {
      isReturningToTop = false;
      updateActiveLink(null);
    }

    scheduleActiveSectionUpdate();
  },
  { passive: true },
);

window.addEventListener("resize", scheduleActiveSectionUpdate);
scheduleActiveSectionUpdate();

// projectRESTCON.OS Generated Script
// Master JS for Crain Bros Inc website

// Auto-update footer year
const y = document.getElementById("year");
if (y) y.textContent = new Date().getFullYear();

// Mobile nav toggle
const toggle = document.querySelector(".nav-toggle");
const nav = document.querySelector(".nav");

if (toggle && nav) {
  toggle.addEventListener("click", () => {
    const isOpen = nav.classList.toggle("open");
    toggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
  });
}

// Meta Contact event for clickable telephone links
document.addEventListener("click", function (event) {
  const clickedElement = event.target;

  if (!(clickedElement instanceof Element)) {
    return;
  }

  const telephoneLink = clickedElement.closest('a[href^="tel:"]');

  if (!telephoneLink) {
    return;
  }

  if (typeof fbq === "function") {
    fbq('track', 'Contact');
  }
});

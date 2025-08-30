/* ==== BOOKORY THEME ================================================== */
:root{
  /* brand palette */
  --brand:#FF6600;     /* primary: CTAs, links, accents */
  --accent:#cda48b;    /* soft accent */
  --paper:#ffffff;     /* background */
  --ink:#343a40;       /* navbar/footer/dark text */

  /* bootstrap variable overrides */
  --bs-primary:var(--brand);
  --bs-secondary:var(--accent);
  --bs-body-bg:var(--paper);
  --bs-body-color:#212529;
  --bs-link-color:var(--brand);
  --bs-link-hover-color:#e05500;

  /* niceties */
  --radius:16px;
  --shadow:0 6px 24px rgba(0,0,0,.08);
}

body{ background:var(--paper); }

/* navbar + footer dark surfaces */
.navbar.bg-dark,
footer.bg-dark{ background-color:var(--ink) !important; }
.navbar .nav-link,
.navbar .navbar-brand span{ color:#fff !important; }

/* brand text fallback always uppercase */
.navbar-brand span{ text-transform:uppercase; letter-spacing:1px; }

/* footer text */
footer .text-muted{ color:rgba(255,255,255,.85) !important; }

/* hero band */
.hero{
  background:linear-gradient(90deg,#FF6600 0%, #cda48b 100%);
  color:#fff;
  border-radius:var(--radius);
  padding:2.25rem;
  box-shadow:var(--shadow);
}

/* cards */
.card, .product-card{
  border-radius:var(--radius);
  box-shadow:var(--shadow);
  border:1px solid rgba(0,0,0,.04);
}

/* buttons */
.btn-primary{ background-color:var(--brand); border-color:var(--brand); }
.btn-primary:hover, .btn-primary:focus{ background-color:#e05500; border-color:#e05500; }
.btn-outline-primary{ color:var(--brand); border-color:var(--brand); }
.btn-outline-primary:hover, .btn-outline-primary:focus{ background-color:var(--brand); border-color:var(--brand); color:#fff; }

/* badges */
.badge.bg-primary{ background-color:var(--brand) !important; }
.badge.bg-secondary{ background-color:var(--accent) !important; }

/* forms */
.form-control:focus, .form-select:focus{
  border-color:var(--brand);
  box-shadow:0 0 0 .2rem rgba(255,102,0,.15);
}

/* full-screen auth */
.auth-bg{
  min-height:100vh;
  background:url('/images/login-bg.png') center/cover no-repeat fixed, #343a40;
  display:grid; place-items:center;
}
.auth-card{
  width:min(460px, 92vw);
  border-radius:var(--radius);
  box-shadow:var(--shadow);
}

/* ===== Checkout / Payment polish ===== */
.checkout-steps{
  display:flex; gap:.75rem; align-items:center; margin-bottom:1rem;
}
.step{
  display:inline-flex; align-items:center; gap:.5rem;
  padding:.4rem .8rem; border-radius:999px; font-weight:600;
  background:#fff; border:1px solid rgba(0,0,0,.06);
}
.step.current{ background:var(--brand); color:#fff; border-color:var(--brand); }
.step .num{
  display:inline-grid; place-items:center; width:1.6rem; height:1.6rem;
  border-radius:999px; background:rgba(0,0,0,.08); font-weight:700;
}
.step.current .num{ background:rgba(255,255,255,.25); color:#fff; }

.summary-card .line{ display:flex; justify-content:space-between; margin:.25rem 0; }
.summary-card .total{ font-weight:700; font-size:1.1rem; }

.payment-method-card{
  border:1px solid rgba(0,0,0,.07);
  border-radius:var(--radius);
  padding:1rem; margin-bottom:.75rem;
}
.payment-method-card.active{ border-color:var(--brand); box-shadow:0 0 0 .2rem rgba(255,102,0,.1); }

.upi-hint{ font-size:.9rem; color:#6c757d; }

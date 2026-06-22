- **Paused Route-C chapters** (OCofP/OcOfD/RRFormula/RationalCurveIso/WeilDivisor) carry ~78 literal `REF` citation placeholders left in prose; they don't block the build but need human citations whenever Route C is unpaused.
- **11 `REF` placeholders in protected `Jacobian.tex`/`AbelJacobi.tex`** render as bare "Theorem~REF" (build still passes). They're your prose to fill; suggested `\cref` targets (all labels verified to exist) were listed in the iter-287 notes — confirm or correct.

## Union merge of GR-quot_closure (2026-06-22)
- Imported the subproject's full Grassmannian/Quot representability deliverable (5 new
  sorry-free files + `Grassmannian.represents` + the section graded ring/module lane).
  The configured `enrich` scope was a **no-op** (all 26 shared decls identical /
  target-stronger / already-proved); you opted into **union** to capture the real
  non-shared deliverable. Both sides' `QuotScheme.lean` work preserved (base-change lane
  kept; descent machinery appended).
- **Note on the subproject's `\leanok` marks:** several were LSP-earned, not kernel-earned
  (e.g. `Grassmannian.representable` is marked proved in the source blueprint but is a
  `sorry` stub in the source Lean — identical to this project's stub). The merge relies on
  `lake build` (lake_mode=`build`) as the real kernel check; the χ-blocked QuotScheme
  stubs (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian.representable`) remain `sorry`.

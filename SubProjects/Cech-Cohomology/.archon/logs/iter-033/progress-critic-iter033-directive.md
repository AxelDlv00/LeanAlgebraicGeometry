# Progress-critic directive — iter-033

Assess convergence of the two active routes from their last-K-iter signals. K=4 (iters 029–032).

## Route A — 02KG affine Serre vanishing (cover-system), file `AffineSerreVanishing.lean`
- Entered current phase: iter-029. STRATEGY current `Iters left`: ~2–3.
- Signals (sorry count is 0 every iter — this is a `mathlib-build` route, so track *decls added* and *blocker*, not sorries):
  - iter-029: +3 axiom-clean decls (`affine_faces_mem`, `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic` ⊤-case). PARTIAL — surfaced the ⊤-vs-D(f) design fork.
  - iter-030: route NOT worked (effort went to FreePresheafComplex re-param, a different file).
  - iter-031: route NOT worked (effort went to CechBridge family form, a different file).
  - iter-032: +1 axiom-clean decl (`standard_cover_cofinal`, Tag 009L). PARTIAL — blocked on `toSheaf_preservesEpimorphisms`.
- Recurring blocker phrase: "blocked on `toSheaf_preservesEpimorphisms`" — newly discovered (iter-032) to be NOT a small instance but `(SheafOfModules.toSheaf).PreservesFiniteColimits` (toSheaf right-exactness), a multi-lemma Mathlib gap. `affine_surj_of_vanishing` + `affineCoverSystem` are gated on it. Top theorem additionally gated on Route B (01I8).

## Route B — 01I8 `F≅~(ΓF)` global generation (Route P), file `QcohTildeSections.lean`
- Entered current phase: iter-029 (promoted to its own STRATEGY phase row iter-032). STRATEGY current `Iters left`: ~5–8.
- Signals (sorry 0 every iter; mathlib-build):
  - iter-029: +4 decls (conditional `qcoh_iso_tilde_sections` + presentation form + 2 accessors). PARTIAL.
  - iter-030: +3 decls (`isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`, `free_isQuasicoherent`). PARTIAL.
  - iter-031: +1 decl (P0 `exists_finite_basicOpen_subcover`, pure topology). PARTIAL.
  - iter-032: +7 decls (P1b `isLocalizedModule_of_span_cover` + 6 private helpers), the ENTIRE assigned objective. COMPLETE.
- Recurring blocker phrase (iters 029–031): "P1 `qcoh_localized_sections` blocked." iter-032 corrective = structural P1→P1a/P1b split + dispatch only the independent P1b. P1b is now done. Remaining: P1a `isQuasicoherent_restrict_basicOpen` (geometry, SheafOfModules-restriction-to-D(f) absent from Mathlib) + P3 `tildePreservesFiniteLimits` (stalkwise flatness, independent).

## Proposed iter-033 objective list (for dispatch-sanity)
- 1 new prover lane proposed: **`TildeExactness.lean`** (NEW file) — scaffold+build `tildePreservesFiniteLimits` (Route B / 01I8 P3), `mathlib-build`. Detailed blueprint exists.
- `toSheaf_preservesEpimorphisms` (Route A) and `isQuasicoherent_restrict_basicOpen` (Route B / P1a) are in PREP this iter (blueprint-writer fix of the wrong to_sheaf proof; effort-breaker on P1a) — NOT dispatched to a prover this iter.

Give a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, the corrective TYPE.

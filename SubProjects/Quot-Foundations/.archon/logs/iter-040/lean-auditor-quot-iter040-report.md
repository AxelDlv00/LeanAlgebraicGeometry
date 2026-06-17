# Lean Audit Report

## Slug
quot-iter040

## Iteration
040

## Scope
- files audited: 1 (directive narrowed scope to `AlgebraicJacobian/Picard/QuotScheme.lean`)
- files skipped (per directive): all other `.lean` files — directive focus

---

## Per-file checklist

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: 1 flagged (iter-N labels on scaffold stubs from original project)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 126/165/201/228 — 4 pre-existing scaffold stubs (`sorry`), known from iter-176 file skeleton. **Not new findings.** All 4 carry `iter-177+: the body...` labels in their docstrings; see stale-comment observation below.
  - Lines 1950–1957 (`compositeBasicOpenImmersion`, def): noncomputable def, body is a morphism composition `isoSpec.inv ≫ ι_W ≫ ι_{q.X i}`. Axioms clean: `{propext, Classical.choice, Quot.sound}`. No sorry. Signature matches the stated intent (morphism into `Spec R`). Honest.
  - Lines 1969–1987 (`pullback_composite_immersion_isIso_fromTildeΓ`, theorem): calls `@isIso_fromTildeΓ_of_iso _ _ _` with an explicitly-built iso (two `pullbackComp` coherence isos chained via `≪≫`) and the `[IsIso …]` instance supplied positionally as `isIso_fromTildeΓ_restrict_basicOpen M q s i hs`. The iso chain types-check: `(pullback α).mapIso (pullbackComp ι_W ι_i).app M` has target `(pullback α).obj ((pullback (ι_W ≫ ι_i)).obj M)`, which equals the source of `(pullbackComp α (ι_W ≫ ι_i)).app M`, so `≪≫` is valid. The `@`-positional form is a standard Lean 4 idiom for manually supplying a `[…]` instance; it is **not** a defeq abuse or fragile `rfl`. Axioms clean: `{propext, Classical.choice, Quot.sound}`. Honest.
  - Lines 1991–1996 (`compositeBasicOpenImmersion_isOpenImmersion`, instance): `unfold compositeBasicOpenImmersion; infer_instance`. After unfolding, the term is a composition `isoSpec.inv ≫ ι_W ≫ ι_{q.X i}` — an isomorphism followed by two open immersions. Standard Mathlib `IsOpenImmersion` composition instances resolve this. Axioms clean: `{propext, Classical.choice, Quot.sound}`. Honest.
  - Lines 2002–2011 (`compositeBasicOpenImmersion_opensRange`, theorem): rewrite chain using `Scheme.Hom.opensRange_comp_of_isIso`, `Scheme.Hom.opensRange_comp`, `Scheme.Opens.opensRange_ι` (×2), `Scheme.Hom.image_preimage_eq_opensRange_inf`, then `inf_eq_right.mpr hs`. All named lemmas confirmed to exist in `Mathlib/AlgebraicGeometry/OpenImmersion.lean` via local search. Axioms clean: `{propext, Classical.choice, Quot.sound}`. Honest.
  - No orphaned helpers introduced this iteration. All 4 new declarations have clear downstream purpose (the section-transport producer) stated in their docstrings, and each is used by at least one sibling declaration.
  - Minor code duplication: `(by rw [Scheme.Opens.opensRange_ι]; exact hs)` appears twice within the body of `pullback_composite_immersion_isIso_fromTildeΓ`. Not a correctness issue.

---

## Must-fix-this-iter

*(none)*

---

## Major

*(none)*

---

## Minor

- `QuotScheme.lean:119,156,197,219` (docstrings for scaffold stubs at lines 126/165/201/228) — The `iter-177+: …` labels in the scaffold-stub docstrings refer to iteration numbers from the original "Algebraic-Jacobian-Challenge" project (this file was extracted from there in the initial commit). In the current Quot-Foundations project (now at iter-040), these labels have no actionable meaning. The underlying prose description of what needs to be done is still accurate; only the `iter-177+` reference is stale. Known pre-existing stubs.

- `QuotScheme.lean:1976,1983` — `(by rw [Scheme.Opens.opensRange_ι]; exact hs)` duplicated twice in the iso-argument of `pullback_composite_immersion_isIso_fromTildeΓ`. Trivial copy; no correctness impact.

---

## Excuse-comments (always called out separately)

*(none)*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 2 (stale iter-N labels on pre-existing scaffold stubs; minor proof duplication)
- **excuse-comments**: 0

Overall verdict: The 4 new declarations are axiom-clean (`{propext, Classical.choice, Quot.sound}`), no sorry, no native_decide, no vacuous/placeholder bodies, no defeq abuse — the `@`-positional instance passing is a legitimate Lean 4 idiom confirmed correct by elaboration. No orphaned helpers. The only findings are two low-impact minor observations on pre-existing stub labels and a trivial code duplication.

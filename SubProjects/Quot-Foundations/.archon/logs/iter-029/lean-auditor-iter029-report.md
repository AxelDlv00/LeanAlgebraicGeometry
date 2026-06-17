# Lean Audit Report

## Slug
iter029

## Iteration
029

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 4 known sorry stubs (acknowledged in directive; see notes)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lines 1416–1445 (iter-029 DIAGNOSIS box, `base_change_mate_fstar_reindex_legs` sorry site).**
    The rewritten box comment is accurate about the code beneath it:
    — The `sorry` is present at line 1446 exactly as the comment says.
    — The claim "The dead `have hpfc := …` of prior iters is removed" is accurate; no such `have` appears anywhere in the current proof body (lines 1363–1446).
    — The listing of which defeq collapses are `rfl`-provable vs which are genuine isos is consistent with the prior diagnostic record and does not claim the proof is done.
    — The CONSEQUENCE paragraph prescribes a specific `exact`-based term-mode approach without claiming it has been executed — the sorry remains, making this an honest diagnostic, not a false-completion claim.
    — The phrase "definitive; supersedes the analogist's 'term-mode congrArg' hope" is a forward-looking editorial note, not a false claim that the proof is closed. Minor: "definitive" language could be overconfident if the diagnosis turns out to miss an angle, but it describes observed tactic failures, not a claimed proof.
  - **Lines 1838–1846 (docstring of `base_change_mate_section_identity`).**
    The docstring says "body has no inline `sorry`" and "transitively `sorry`-backed through `base_change_mate_gstar_transpose`". Both statements are accurate:
    — The proof (lines 1862–1864) is `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose ψ φ M` — no inline sorry.
    — `base_change_mate_gstar_transpose` has the sorry at line 1818, confirming the transitive dependency.
    This docstring is an honest disclosure, not a false-completion claim.
  - **Lines 1910–1916 (docstring of `pushforward_base_change_mate_cancelBaseChange`).**
    The docstring says "body has no inline `sorry`" and "transitively `sorry`-backed through `base_change_mate_gstar_transpose`". Both statements are accurate:
    — The proof (lines 1931–1942) chains `base_change_mate_generator_trace → base_change_mate_section_identity → base_change_mate_gstar_transpose` via `haveI … infer_instance` — no inline sorry.
    — The transitive sorry chain is correctly identified (see the chain: generator_trace → section_identity → gstar_transpose → sorry@1818).
    This docstring is an honest disclosure, not a false-completion claim.
  - **`gstar_transpose` sorry at ~1818:** The comment (lines 1795–1817) says "LANDED SCAFFOLD (iter-022, recipe step 1 COMPLETE — verified compiling)" and "REMAINING CRUX (recipe steps 2–3)". This is accurate — recipe step 1 refers to the counit-transport scaffold established at iter-022, which compiled; the remaining crux (steps 2–3) is precisely what remains at this sorry. Not misleading.
  - **`affineBaseChange_pushforward_iso` sorry at ~1999:** The comment (lines 1978–1998) gives an accurate account of the remaining obligation (restriction-compatibility of `pushforwardBaseChangeMap`, Mathlib-absent). No misleading claims.
  - **`flatBaseChange_pushforward_isIso` sorry at ~2021:** The comment provides an honest proof sketch labelled "deferred to a later iteration" with a precise Čech-cohomology strategy and an explicit admission that the required infrastructure is absent. This is close to the edge of an excuse-comment but is mathematically specific and makes no claim that the code is correct as-is.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 4 protected typed sorry stubs at ~126/165/201/228 (per directive: not re-reported)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lines 730–749 (`exists_finite_basicOpen_cover_le_quasicoherentData`).**
    The proof is genuine and complete: no sorry, no fake body. It:
    1. Defines `G := {r | ∃ i, D(r) ≤ q.X i}`.
    2. Proves `Ideal.span G = ⊤` by quasi-compactness of `Spec R` and the basic-open basis (via `PrimeSpectrum.iSup_basicOpen_eq_top_iff'`, `Sieve.mem_ofObjects_iff`, and `PrimeSpectrum.isBasis_basic_opens`).
    3. Extracts a finite subset `t ⊆ G` with `Ideal.span t = ⊤` using `Ideal.span_eq_top_iff_finite`.
    The proof is mathematically sound. The proof tactic choices are appropriate for the goal type.
  - **Docstring of `exists_finite_basicOpen_cover_le_quasicoherentData` (lines 712–729).** Accurately describes the theorem's content and proof method. The paragraph beginning "The remaining (heavy) step toward gap1" is an honest boundary note — it describes what this theorem does NOT prove, which is appropriate context for the reader and is not an excuse-comment.
  - **No corollary `exists_finite_basicOpen_cover_of_isQuasicoherent` present.** The directive noted this as "possible". The file ends at line 751 (after `end AlgebraicGeometry`) with no such corollary. This is a gap between the directive's expectation and the file, but not an audit issue — the theorem exists, the corollary was never added.
  - **`Module.annihilator_isLocalizedModule_eq_map` (lines 362–422).** The proof is genuine and complete: uses `Finset`-based argument on a spanning set, `IsLocalization.mk'_surjective`, `IsLocalizedModule.mk'_smul_mk'`, and the two inclusion directions. Mathematically appropriate for the claim.
  - **`isLocalizedModule_tilde_restrict` (lines 467–490).** Genuine proof: correctly chains `tilde.toOpen_res` with `IsLocalizedModule.of_linearEquiv_right`.
  - **`isLocalizedModule_restrict_of_isIso_fromTildeΓ` (lines 510–546).** Genuine proof: uses naturality of the sheaf map and transfers localization across component isomorphisms.
  - **`isIso_fromTildeΓ_of_isLocalizedModule_restrict` (lines 614–642).** Genuine proof: uses `bijective_comp_of_localizations` + `isIso_sheaf_of_isIso_app_basicOpen` + `SpecModulesToSheafFullyFaithful.isIso_of_isIso_map`. Appropriately structured.
  - **`map_units_restrict_basicOpen` (lines 705–710).** Genuine one-liner using `tilde.isUnit_algebraMap_end_basicOpen`.
  - **Protected stubs at ~126/165/201/228.** All four carry honest "iter-177+ body" labels; they are typed `sorry`s (return correct types), as expected for skeleton declarations. Not re-reported per directive.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `FlatBaseChange.lean:1416` — the iter-029 diagnosis box uses the word "definitive" to describe tactic failures. This is editorial language; the failures described are accurate but future iterations may discover a different blocking factor. Not a false claim — the sorry remains — but "definitive" may mislead future developers about the exhaustiveness of the analysis.

---

## Excuse-comments (always called out separately)

None flagged.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 1
- **excuse-comments**: 0

Overall verdict: Both audited files are clean — all comments are accurate about the code beneath them, the two "transitively sorry-backed" docstrings are honest disclosures (not false-completion claims), and the new `exists_finite_basicOpen_cover_le_quasicoherentData` proof is genuine with no laundering.

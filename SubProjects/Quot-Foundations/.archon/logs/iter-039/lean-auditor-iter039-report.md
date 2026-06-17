# Lean Audit Report

## Slug
iter039

## Iteration
039

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **New declaration `base_change_mate_reindex_conj_pullbackLeg` (~1625)**: single-delegation to Mathlib's `Adjunction.conjugateEquiv_leftAdjointCompIso_inv _ _ _ _`. Axiom-clean (propext/Classical.choice/Quot.sound only). No sorry, no suspect body. Clean.
  - **New declaration `base_change_mate_reindex_conj_crossLayer` (~1652)**: 60+-line proof. Axiom-clean. No sorry. Docstring correctly describes the strategy ("Ported verbatim from Seam 1 `base_change_mate_unit_value`"). Proof uses `erw [reassoc_of% huce]`, multiple `simp only [...]`, `rw`, and `simp [← Functor.map_comp]` — all computationally heavy but standard for this category-theoretic setting.
  - **`set_option maxHeartbeats 4000000 in` on `crossLayer` (~1637)**: No adjacent "why heartbeats needed" comment. Every other elevated-heartbeat declaration in this file carries an adjacent justification comment (e.g. lines 1749–1750 for `_legs_conj`, 1824–1825 for `_reindex_legs`, 1874–1875 for `base_change_mate_fstar_reindex`). The absence is an inconsistency with the file's own pattern (minor). The proof compiles and is axiom-clean, so this is not fragile — just underdocumented.
  - **`rfl` close at `hpullinv` (~1685)**: `have hpullinv : ((conjugateEquiv adjL adjR).symm β.hom).app N = (pullback_spec_tilde_iso ψ N).inv := by rw [hβ]; rfl`. This is the same pattern used in the already-proved Seam-1 `base_change_mate_unit_value`. The defeq holds because `pullback_spec_tilde_iso` is defined via `conjugateIsoEquiv.symm` applied to `gammaPushforwardNatIso`, and `conjugateIsoEquiv.symm` unfolds to `conjugateEquiv.symm` — definitionally identical at this constructor level. Not fragile.
  - **`sorry` at `base_change_mate_fstar_reindex_legs_conj` (~1822)**: Honest scaffold. Comment at 1808–1814 accurately states iter-039 status: all three legs (conj-2b `pullbackLeg`, conj-2c `pushforwardCollapse`, conj-2d `crossLayer`) are built and axiom-clean this iter. The `sorry` is the "heaviest node" — assembling those legs into a single `conjugateEquiv.injective` close. Not an excuse-comment.
  - **`sorry` at `base_change_mate_gstar_transpose` (~2289)**: Honest scaffold. Comment at 2209–2218 includes an explicit self-audit flag: "the existing Seam-2 lemma `base_change_mate_fstar_reindex` asserts exactly this but is currently sorry-backed… so this content must be REPROVEN INLINE here, not cited — otherwise the result is not axiom-clean." This is correct and responsible documentation.
  - **`sorry` at `affineBaseChange_pushforward_iso` (~2470)**: Honest scaffold. Detailed multi-hundred-LOC affine-reduction obligation described.
  - **`sorry` at `flatBaseChange_pushforward_isIso` (~2492)**: Honest scaffold. Deferred to Čech-cohomology/cover infrastructure.
  - **Stale iter-NNN references (~183–247)**: The historical "STATUS (iter-234)", "UPDATE (iter-236)", "UPDATE (iter-240)", "UPDATE (iter-241)", and "UPDATE (resolved)" block in the module-level docstring uses iteration numbers from the original Algebraic-Jacobian-Challenge project (where iter-234 ≈ current iter-039 in Quot-Foundations). The content is accurate — `pushforward_spec_tilde_iso` IS fully proved, route (a) IS dead, route (b) IS axiom-clean — but the numbers are confusing relative to the current Archon numbering. Minor stale-comment issue.
  - **`SCAFFOLD (iter-022)` comment at ~2225**: Describes a partial proof structure ("the conjugate-counit calculus, dual to Seam 1's unit calculus"), not an excuse-comment. Iter-022 is stale numbering (same origin).

---

### `AlgebraicJacobian/Picard/QuotScheme.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Protected scaffold stubs (`hilbertPolynomial` ~126, `QuotFunctor` ~165, `Grassmannian` ~201, `Grassmannian.representable` ~228)**: All four carry `:= sorry` or `sorry` proof with docstring phrases "For the iter-176 file-skeleton the body is a typed `sorry`." These are known blueprint-pinned stubs; "iter-176" refers to the original project's numbering (stale in the current context). The claim types are correct — signatures match the intended mathematical objects. These sorry'd stubs are expected pre-existing work, not new this iter.
  - **New declaration `isLocalizedModule_basicOpen_descent_of_basicOpen_cover` (~1665)**: Three-field `where`-clause construction of `IsLocalizedModule`. Axiom-clean. The `surj` field delegates to `descent_surj` via `fun U hbo hcov => by obtain ⟨s, rfl⟩ := hbo; exact Hfr s hcov` — correctly destructs the basic-open hypothesis `hbo : ∃ s, U = D(s)` to substitute `U = D(s)` before calling `Hfr s hcov`. The `exists_of_eq` field delegates to `descent_smul_eq_zero` via `fun r hr => Hfr r ⟨r, hr, le_refl _⟩` — correctly produces the `∃ r' ∈ t, D(r) ≤ D(r')` existential with `r' = r`. Both `rfl`s within (e.g., `⟨f ^ n, n, rfl⟩`) are `f ^ n = f ^ n` equalities, trivially correct.
  - **`descent_surj` signature change (new `(∃ s : R, U = PrimeSpectrum.basicOpen s)` argument)**: Change is coherent with the implementation. The `descent_surj` proof body only ever calls `Hfr` at basic opens (line 1483: `Hfr (PrimeSpectrum.basicOpen r)` for `r ∈ t`; line 1526: `Hfr (PrimeSpectrum.basicOpen (i:R) ⊓ ...)` with `⟨(i:R) * (j:R), ..., ...⟩`), so the new precondition is honest. Both call sites correctly updated:
    - `isLocalizedModule_basicOpen_descent_of_cover` (~1638): `fun U _ hcov => Hfr U hcov` (discards the basic-open witness via `_`). ✓
    - `isLocalizedModule_basicOpen_descent_of_basicOpen_cover` (~1678): `fun U hbo hcov => by obtain ⟨s, rfl⟩ := hbo; exact Hfr s hcov`. ✓
  - **New declaration `isLocalizedModule_powers_transport` (~1905)**: Chains bridge (I) (`isLocalizedModule_of_ringEquiv_semilinear`) and bridge (II) (`isLocalizedModule_restrictScalars_powers_algebraMap`). Axiom-clean. The key step `Submonoid.map_powers` + `congrArg Submonoid.powers hf` correctly identifies `(Submonoid.powers f').map σ = Submonoid.powers (algebraMap R A f)`. Clean.
  - **New declaration `isIso_fromTildeΓ_of_iso` (~1936)**: Two-line proof via Mathlib's `isIso_fromTildeΓ_iff` and `Functor.essImage.ofIso`. Axiom-clean. Correct use of the essential-image closure property. Clean.
  - **Stale iter-NNN references throughout**: `iter-177+`, `iter-176` (scaffold stubs) use the original project's numbering scheme; `iter-011` and other numbers in comments in the transitive import chain (`FlatBaseChange.lean`) have the same issue. Minor, same origin as FlatBaseChange.
  - **`stand-in` usage (~496)**: "`M.fromTildeΓ` is an isomorphism (equivalently, `M` lies in the essential image of `tilde` — the honest Spec-affine stand-in for quasi-coherence)". This is a mathematical description of a Mathlib gap, not an excuse-comment; it describes the hypothesis `[IsIso M.fromTildeΓ]` accurately.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `FlatBaseChange.lean:1637` — `set_option maxHeartbeats 4000000 in` on `base_change_mate_reindex_conj_crossLayer` has no adjacent justification comment explaining the heartbeat elevation. All other `set_option maxHeartbeats` decorators in the same file carry a dedicated justification comment (see lines 1749–1750, 1824–1825, 1874–1875). The proof is axiom-clean and compiles, but is underdocumented relative to the file's own pattern. Suggest adding a one-line "-- erw [reassoc_of% huce] + several simp passes run heavy whnf in the Modules category" comment.

- `FlatBaseChange.lean:183–247` — Stale iteration numbers ("STATUS (iter-234)", "UPDATE (iter-236)", "iter-240", "iter-241") in the module docstring refer to the original Algebraic-Jacobian-Challenge project's numbering, not Quot-Foundations' iter-039 scheme. Content is accurate but the numbers are confusing in the new project context.

- `QuotScheme.lean:119–228` — Scaffold-stub docstrings use "iter-176" / "iter-177+" (original project numbering), now stale relative to the current iter-039 scheme.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files are in good shape this iteration — the three new FlatBaseChange declarations are axiom-clean and honest, the three QuotScheme additions are axiom-clean, the `descent_surj` signature change is coherent with both call sites updated correctly, and no excuse-comments or weakened definitions were found; the only issues are a missing heartbeat-justification comment on `crossLayer` and stale iteration-number references inherited from the original project.

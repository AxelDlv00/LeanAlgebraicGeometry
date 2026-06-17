# Blueprint Review Report

## Slug
iter002

## Iteration
002

## Top-level summaries

### Proofs lacking detail

- `Cohomology_FlatBaseChange.tex` / `lem:base_change_map_affine_local` — proof sketch step 4 asserts that "pushforwardBaseChangeMap is built from the (pullback ⊣ pushforward) units and counits, all of which commute with restriction to an open," then proceeds "Granting this base-change-of-the-base-change-map compatibility" without deriving it. This step is identified in the chapter itself as "absent from the pinned Mathlib and recorded here as the named obligation," yet the proof sketch provides no mechanism: no naturality lemma cited, no derivation from the definition of `pushforwardBaseChangeMap` as the (g^*, g_*)-transpose of the unit/counit composite. A prover targeting `AlgebraicGeometry.TODO.base_change_map_affine_local` cannot construct this step without guidance. **This is the must-fix for the FBC-A lane.** Recommended addition: a paragraph showing that (a) `pushforwardBaseChangeMap` is the (g^*, g_*)-adjunction transpose of the composite `f_*F → g_* f'_* (g')^*F` obtained by applying `f_*` to the ((g')^*, (g')_*)-unit; (b) restricting the cartesian square to an affine open `U ⊆ S'` produces a new cartesian square with an identical `pushforwardBaseChangeMap`; (c) the naturality of the adjunction transpose in the base-change diagram means the restriction of the global map to `U` equals the affine-affine map on the restricted square. The argument cites no new Mathlib lemma beyond the definition of natural transformations and the functoriality of the adjunction transpose — but it needs to be spelled out so the prover knows the reduction is definitional/naturality rather than a non-trivial coherence result.

### Citation discipline

- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ` — `% SOURCE QUOTE PROOF:` is missing. The writer flagged it: "TODO retrieve from references/stacks-constructions.tex (proof of lemma-spec, L553–L600, ~50 lines…)." Since `thm:relative_spec_univ` already has `\leanok` and is not a current frontier prover target, this is **soon** severity only — but the verbatim proof text should be pulled on the next writer pass for this chapter.

### Dependency & isolation findings

From `leandag build --json`:

**Unmatched `\lean{}`** (5 entries):
- `lem:base_change_map_affine_local` → `AlgebraicGeometry.TODO.base_change_map_affine_local` — known intentional scaffold. **Not a defect.**
- `lem:pushforward_base_change_mate_cancelBaseChange` → `AlgebraicGeometry.TODO.pushforward_base_change_mate_cancelBaseChange` — known intentional scaffold. **Not a defect.**
- `thm:generic_flatness_algebraic` → `AlgebraicGeometry.TODO.genericFlatnessAlgebraic` — known intentional scaffold. **Not a defect.**
- `lem:flat_preserves_equalizer_mathlib` → `LinearMap.tensorEqLocusEquiv` — **`\mathlibok` node**. Verified against Mathlib: exists at `.lake/packages/mathlib/Mathlib/RingTheory/Flat/Equalizer.lean`. Signature `[Module.Flat R M] : M ⊗[R] eqLocus f g ≃ₗ[S] eqLocus (lTensor S M f) (lTensor S M g)` matches the stated form (base change along flat module commutes with formation of the equalizer). Supporting lemmas `Module.Flat.ker_lTensor_eq` and `Module.Flat.eqLocus_lTensor_eq` also confirmed present. **`\mathlibok` claim is faithful.**
- `lem:functor_is_representable_mathlib` → `CategoryTheory.Functor.IsRepresentable` — **`\mathlibok` node**. Verified against Mathlib: exists at `.lake/packages/mathlib/Mathlib/CategoryTheory/Yoneda.lean` as a class with field `has_representation : ∃ (Y : C), Nonempty (F.RepresentableBy Y)`. Accessors `F.reprX`, `F.representableBy`, `F.reprW` confirmed present (lines 569–592). **`\mathlibok` claim is faithful.**

**Unknown `\uses{}`**: none.

**Isolated nodes** (4, all `lean_aux`, 0 blueprint): these are uncovered Lean helper declarations with no blueprint entry. Not removal candidates; **informational** only — they are signals that 4 helper lemmas in the project files currently lack blueprint entries.

## Per-chapter

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `lem:base_change_map_affine_local` / proof sketch step 4 — the key naturality claim ("pushforwardBaseChangeMap is built from units and counits, all of which commute with restriction to an open") is asserted without derivation. The chapter explicitly frames this as "the named obligation absent from Mathlib" and then says "Granting this...the assertion reduces to the affine–affine case." A prover cannot close this step from the sketch alone: they need to know whether the reduction is definitional (unfold `pushforwardBaseChangeMap`, check naturality of the transpose) or requires an appeal to a specific coherence lemma. **Must-fix: dispatch blueprint-writer to add the derivation paragraph (see § Proofs lacking detail above).**
  - All other declarations (`def:pushforward_base_change_map`, locality infrastructure lemmas, tilde-dictionary lemmas, `lem:pullback_spec_tilde_iso`, `lem:pushforward_base_change_mate_cancelBaseChange`, `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`) have detailed, mathematically sound proof sketches. In particular the four-step generator-tracing proof of `lem:pushforward_base_change_mate_cancelBaseChange` (showing Γ(α) = cancelBaseChange⁻¹) and the Mayer–Vietoris induction of `thm:flat_base_change_pushforward` are prover-ready.
  - The `\mathlibok` anchor `lem:flat_preserves_equalizer_mathlib` (`LinearMap.tensorEqLocusEquiv`) is faithful (verified above).
  - The chapter's H⁰-as-equalizer route (Čech-free: sheaf-condition equalizer + flat base change commutes with finite equalizers via `lem:flat_preserves_equalizer_mathlib`) is mathematically sound.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:generic_flatness_algebraic` proof sketch correctly identifies two routes: (A) the A-finite primary route via Mathlib's `Module.FinitePresentation.exists_free_localizedModule_powers` (confirmed to exist at `.lake/packages/mathlib/Mathlib/RingTheory/Localization/Free.lean:79`; its signature `[Module.FinitePresentation R M] [Module.Free Rₛ M'] → ∃ r ∈ S, Module.Free (Localization (.powers r)) (LocalizedModule (.powers r) M)` matches exactly what the sketch uses); and (B) the Nitsure §4 dévissage fallback for the general B-finite case, reducing to (A) at the bottom of the induction via Noether normalization + prime filtration. The intended Lean signature comment (`∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`) is correctly typed. `Module.freeLocus` is confirmed open (`isOpen_freeLocus` exists at FreeLocus.lean:174).
  - `thm:generic_flatness` coherence-hypothesis correction is faithfully documented (the known re-sign task). The one-sentence proof sketch (restrict to affine open, apply thm:generic_flatness_algebraic, patch via noetherianity) is adequate for the GF-geo wrapper.
  - The Mathlib-status section accurately names the available and missing infrastructure.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:hilbert_polynomial`: intended signature discussion correctly identifies `SheafOfModules.IsQuasicoherent` + `SheafOfModules.IsFiniteType` as the coherence encoding (no single `IsCoherent` predicate at pin), and correctly flags the schematic-support predicate as a project-side gap. `AlgebraicGeometry.IsProper` is confirmed present at this pin.
  - `def:grassmannian_scheme` is correctly defined as `QuotFunctor (𝟙 S) V Φ_d` (the Quot functor for X=S, E=V, Φ=d). Design choice is sound.
  - `lem:functor_is_representable_mathlib`: `\mathlibok` claim is faithful (verified above). The description of `has_representation`, `reprX`, and `representableBy` matches the actual Mathlib interface.
  - `thm:grassmannian_representable` proof sketch is detailed (explicit Schubert cell construction, cocycle gluing, properness via valuative criterion, Plücker embedding). The NOTE documenting the proof as blocked on `thm:relative_spec_univ` strengthening (option a) or a RepresentableBy-free gluing argument (option b) is correctly placed. The proof sketch implicitly follows option (b) and is prover-adequate for when the QUOT-repr phase is dispatched.
  - `SheafOfModules.IsLocallyFree` correctly noted as absent at the pin. Rank-r local-freeness gap is explicitly identified.
  - The chapter does NOT contain any Lean syntax in the blueprint prose (only in `% NOTE` comments and `\lean{}` hints), so no blueprint-purity issue.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:relative_spec_univ` / `% SOURCE QUOTE PROOF:` missing — writer noted "TODO retrieve from references/stacks-constructions.tex." **Soon** finding only; theorem is `\leanok` and not an active frontier target this iter.
  - The `% NOTE` on `thm:relative_spec_univ` correctly documents the Lean-weaker-than-blueprint-prose gap (IsAffineHom vs. RepresentableBy witness). This is a known re-sign task, not a blueprint prose error.
  - The `% NOTE` on `thm:relative_spec_affine_base` similarly documents the weaker Lean type. Blueprint prose is correct.

## Cross-chapter notes

- `Picard_QuotScheme.tex` / `thm:grassmannian_representable` uses `thm:relative_spec_univ` from `Picard_RelativeSpec.tex`. The RelativeSpec chapter documents that `thm:relative_spec_univ` has a weaker Lean encoding (IsAffineHom only, not a RepresentableBy witness). The QuotScheme chapter's NOTE correctly flags this as a blocker for the QUOT-repr phase: either (a) `thm:relative_spec_univ` must be re-signed to deliver a RepresentableBy witness, or (b) the Grassmannian representability argument must be restructured to not require it. Both chapters correctly document this dependency. **No blueprint-writer action needed this iter** (the QUOT-repr phase is BLOCKED per STRATEGY.md); log in iter-002 plan.md as a live cross-chapter blocker for the QUOT-repr phase.

## Severity summary

**must-fix-this-iter**:
- `Cohomology_FlatBaseChange.tex` has `correct: partial` — `lem:base_change_map_affine_local` proof sketch step 4 (naturality of pushforwardBaseChangeMap w.r.t. restriction to affine opens) is asserted without derivation. Per the HARD GATE rule, this blocks FBC-A prover dispatch. **Dispatch blueprint-writer for `Cohomology_FlatBaseChange.tex` with directive: add derivation paragraph to the proof of `lem:base_change_map_affine_local` explaining why the (g^*, g_*)-adjunction transpose of the unit/counit composite is natural w.r.t. restriction to affine opens of S' (i.e., that (.app U) of the global pushforwardBaseChangeMap equals pushforwardBaseChangeMap on the restricted affine-affine square).**

**soon**:
- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ`: missing `% SOURCE QUOTE PROOF:` (verbatim from Stacks tag 01LQ proof, L553–L600). Pull on next writer pass.

**informational**:
- 4 isolated `lean_aux` nodes in the DAG (uncovered Lean helpers; no blueprint entry). Not removal candidates.
- `Picard_QuotScheme.tex` / `def:hilbert_polynomial`: visible `\textit{Source: ...}` cites [Hartshorne] III.5.2 as a secondary reference, but no corresponding `% SOURCE:` parenthetical for `references/hartshorne-algebraic-geometry.pdf` (setup note explains the text-layer issue; primary verbatim quote is correctly taken from Nitsure). No corrective action needed.

Overall verdict: Three of four chapters clear the HARD GATE; `Cohomology_FlatBaseChange.tex` has `correct: partial` due to an unspecified naturality step in the proof of `lem:base_change_map_affine_local` — dispatch a blueprint-writer for that chapter before FBC-A prover dispatch; all strategy phases have adequate blueprint coverage (including FBC-B, GF-geo, QUOT-repr), no unstarted-phase proposals.
